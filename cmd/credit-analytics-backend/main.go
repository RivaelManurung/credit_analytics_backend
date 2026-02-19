package main

import (
	"flag"
	"os"

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
	flag.StringVar(&flagconf, "conf", "../../configs", "config path, eg: -conf config.yaml")
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
		bc.Server.Http.Addr = "0.0.0.0:" + port
	}

	// Handle Railway Database URL Override
	dbSource := os.Getenv("DATA_DATABASE_SOURCE")
	if dbSource == "" {
		dbSource = os.Getenv("DATABASE_URL")
	}

	isCloud := os.Getenv("PORT") != "" || os.Getenv("RAILWAY_ENVIRONMENT") != ""

	if dbSource != "" {
		bc.Data.Database.Source = dbSource
		log.NewHelper(logger).Infof("Database override detected. Using environment variable.")
	} else if isCloud {
		log.NewHelper(logger).Error("CRITICAL ERROR: No database environment variable found (DATA_DATABASE_SOURCE or DATABASE_URL).")
		log.NewHelper(logger).Error("Please set DATA_DATABASE_SOURCE in Railway Variables to ${{Postgres.DATABASE_URL}}")
		panic("missing database configuration in cloud environment")
	} else {
		log.NewHelper(logger).Warn("No database environment variable found. Falling back to local config (config.yaml).")
	}

	log.NewHelper(logger).Infof("DB Connection: %s", bc.Data.Database.Source)

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
