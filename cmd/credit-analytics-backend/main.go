package main

import (
	"flag"
	"os"
	"strings"

	"credit-analytics-backend/internal/conf"

	"github.com/go-kratos/kratos/v2"
	"github.com/go-kratos/kratos/v2/config"
	"github.com/go-kratos/kratos/v2/config/env"
	"github.com/go-kratos/kratos/v2/config/file"
	"github.com/go-kratos/kratos/v2/log"
	"github.com/go-kratos/kratos/v2/middleware/tracing"
	"github.com/go-kratos/kratos/v2/transport/grpc"
	"github.com/go-kratos/kratos/v2/transport/http"

	_ "go.uber.org/automaxprocs"
)

// go build -ldflags "-X main.Version=x.y.z"
var (
	// Name is the name of the compiled software.
	Name string
	// Version is the version of the compiled software.
	Version string
	// flagconf is the config flag.
	flagconf string

	id, _ = os.Hostname()
)

func init() {
	flag.StringVar(&flagconf, "conf", "configs", "config path, eg: -conf config.yaml")
}

func newApp(logger log.Logger, gs *grpc.Server, hs *http.Server) *kratos.App {
	return kratos.New(
		kratos.ID(id),
		kratos.Name(Name),
		kratos.Version(Version),
		kratos.Metadata(map[string]string{}),
		kratos.Logger(logger),
		kratos.Server(
			gs,
			hs,
		),
	)
}

func main() {
	flag.Parse()
	logger := log.With(log.NewStdLogger(os.Stdout),
		"ts", log.DefaultTimestamp,
		"caller", log.DefaultCaller,
		"service.id", id,
		"service.name", Name,
		"service.version", Version,
		"trace.id", tracing.TraceID(),
		"span.id", tracing.SpanID(),
	)

	// Check if config directory exists, if not, try fallback
	if _, err := os.Stat(flagconf); os.IsNotExist(err) {
		fallback := "../../configs"
		if _, err := os.Stat(fallback); err == nil {
			flagconf = fallback
		}
	}

	c := config.New(
		config.WithSource(
			file.NewSource(flagconf),
			env.NewSource(),
		),
	)
	defer c.Close()

	if err := c.Load(); err != nil {
		panic(err)
	}

	var bc conf.Bootstrap
	if err := c.Scan(&bc); err != nil {
		panic(err)
	}

	// Handle Railway dynamic port
	if port := os.Getenv("PORT"); port != "" {
		log.NewHelper(logger).Infof("Railway PORT detected: %s", port)
		bc.Server.Http.Addr = "0.0.0.0:" + port
	}

	// Handle Railway Database URL Override
	dbSource := strings.TrimSpace(os.Getenv("DATA_DATABASE_SOURCE"))
	if dbSource == "" {
		dbSource = strings.TrimSpace(os.Getenv("DATABASE_URL"))
	}

	isCloud := os.Getenv("PORT") != "" || os.Getenv("RAILWAY_ENVIRONMENT") != ""

	if dbSource != "" {
		// Ensure it uses postgresql:// if needed for lib/pq
		if strings.HasPrefix(dbSource, "postgres://") {
			// some drivers prefer postgresql
		}
		bc.Data.Database.Source = dbSource
		log.NewHelper(logger).Infof("Database override detected. Using environment variable.")
	} else if isCloud {
		log.NewHelper(logger).Error("CRITICAL ERROR: No database environment variable found (DATA_DATABASE_SOURCE or DATABASE_URL).")
		panic("missing database configuration in cloud environment")
	} else {
		log.NewHelper(logger).Warn("No database environment variable found. Falling back to local config (config.yaml).")
	}

	// Double check for trailing spaces or hidden characters
	bc.Data.Database.Source = strings.TrimSpace(bc.Data.Database.Source)
	log.NewHelper(logger).Infof("DB Connection: [%s]", bc.Data.Database.Source)

	app, cleanup, err := wireApp(bc.Server, bc.Data, logger)
	if err != nil {
		panic(err)
	}
	defer cleanup()

	// start and wait for stop signal
	if err := app.Run(); err != nil {
		panic(err)
	}
}
