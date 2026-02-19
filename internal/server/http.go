package server

import (
	applicantV1 "credit-analytics-backend/api/applicant/v1"
	applicationV1 "credit-analytics-backend/api/application/v1"
	v1 "credit-analytics-backend/api/helloworld/v1"
	"credit-analytics-backend/internal/conf"
	"credit-analytics-backend/internal/service"
	"net/http"

	"embed"

	"github.com/go-kratos/kratos/v2/log"
	"github.com/go-kratos/kratos/v2/middleware/recovery"
	khttp "github.com/go-kratos/kratos/v2/transport/http"
	"github.com/go-openapi/runtime/middleware"
	"github.com/gorilla/handlers"
)

//go:embed openapi.yaml
var OpenApiFile embed.FS

// NewHTTPServer new an HTTP server.
func NewHTTPServer(c *conf.Server, greeter *service.GreeterService, application *service.ApplicationService, applicant *service.ApplicantService, logger log.Logger) *khttp.Server {
	var opts = []khttp.ServerOption{
		khttp.Middleware(
			recovery.Recovery(),
		),
		khttp.Filter(handlers.CORS(
			handlers.AllowedOrigins([]string{"*"}),
			handlers.AllowedMethods([]string{"GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"}),
			handlers.AllowedHeaders([]string{"Content-Type", "Authorization", "X-Requested-With", "Accept", "Origin"}),
			handlers.AllowCredentials(),
		)),
	}
	if c.Http.Network != "" {
		opts = append(opts, khttp.Network(c.Http.Network))
	}
	if c.Http.Addr != "" {
		opts = append(opts, khttp.Address(c.Http.Addr))
	}
	if c.Http.Timeout != nil {
		opts = append(opts, khttp.Timeout(c.Http.Timeout.AsDuration()))
	}
	srv := khttp.NewServer(opts...)

	// Swagger UI
	srv.HandleFunc("/openapi.yaml", func(w http.ResponseWriter, r *http.Request) {
		data, err := OpenApiFile.ReadFile("openapi.yaml")
		if err != nil {
			http.Error(w, err.Error(), 500)
			return
		}
		w.Header().Set("Content-Type", "application/x-yaml")
		w.Write(data)
	})
	opts_ui := middleware.SwaggerUIOpts{SpecURL: "/openapi.yaml", Path: "docs"}
	sh := middleware.SwaggerUI(opts_ui, nil)
	srv.HandlePrefix("/docs", sh)

	v1.RegisterGreeterHTTPServer(srv, greeter)
	applicationV1.RegisterApplicationHTTPServer(srv, application)
	applicantV1.RegisterApplicantHTTPServer(srv, applicant)
	return srv
}
