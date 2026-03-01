package server

import (
	applicantV1 "credit-analytics-backend/api/applicant/v1"
	applicationV1 "credit-analytics-backend/api/application/v1"
	decisionV1 "credit-analytics-backend/api/decision/v1"
	financialV1 "credit-analytics-backend/api/financial/v1"
	v1 "credit-analytics-backend/api/helloworld/v1"
	referenceV1 "credit-analytics-backend/api/reference/v1"
	surveyV1 "credit-analytics-backend/api/survey/v1"
	"credit-analytics-backend/internal/conf"
	"credit-analytics-backend/internal/service"
	"net/http"

	"embed"

	"github.com/go-kratos/kratos/v2/log"
	"github.com/go-kratos/kratos/v2/middleware/recovery"
	"github.com/go-kratos/kratos/v2/transport/grpc"
	khttp "github.com/go-kratos/kratos/v2/transport/http"
	"github.com/go-openapi/runtime/middleware"
	"github.com/improbable-eng/grpc-web/go/grpcweb"
)

//go:embed openapi.yaml
var OpenApiFile embed.FS

// NewHTTPServer new an HTTP server.
func NewHTTPServer(c *conf.Server, greeter *service.GreeterService, application *service.ApplicationService,
	party *service.PartyService, applicant *service.ApplicantService, reference *service.ReferenceService,
	survey *service.SurveyService, financial *service.FinancialService,
	decision *service.DecisionService, committee *service.CommitteeService,
	grpcServer *grpc.Server, logger log.Logger) *khttp.Server {
	var opts = []khttp.ServerOption{
		khttp.Middleware(
			recovery.Recovery(),
		),
		khttp.Filter(func(next http.Handler) http.Handler {
			wrappedGrpc := grpcweb.WrapServer(grpcServer.Server,
				grpcweb.WithOriginFunc(func(origin string) bool { return true }),
			)
			h := log.NewHelper(logger)
			return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
				// 1. Manual CORS Headers
				origin := r.Header.Get("Origin")
				if origin == "" {
					origin = "*"
				}
				w.Header().Set("Access-Control-Allow-Origin", origin)
				w.Header().Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, DELETE, PATCH")
				w.Header().Set("Access-Control-Allow-Headers", "Content-Type, X-User-Agent, X-Grpc-Web, Custom-Header-1")
				w.Header().Set("Access-Control-Expose-Headers", "Grpc-Status, Grpc-Message, Grpc-Status-Details-Bin")
				w.Header().Set("Access-Control-Allow-Credentials", "true")
				w.Header().Set("Access-Control-Max-Age", "86400")

				// 2. Handle Preflight OPTIONS
				if r.Method == "OPTIONS" {
					w.WriteHeader(http.StatusOK)
					return
				}

				h.Infof("HTTP Request: %s %s (ContentType: %s, UserAgent: %s)", r.Method, r.URL.Path, r.Header.Get("Content-Type"), r.Header.Get("User-Agent"))

				// 3. Handle gRPC-Web
				if wrappedGrpc.IsGrpcWebRequest(r) || r.Header.Get("X-Grpc-Web") == "1" {
					h.Infof("Detected gRPC-Web Request: %s %s", r.Method, r.URL.Path)
					wrappedGrpc.ServeHTTP(w, r)
					return
				}

				next.ServeHTTP(w, r)
			})
		}),
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
	applicationV1.RegisterApplicationServiceHTTPServer(srv, application)
	applicationV1.RegisterPartyServiceHTTPServer(srv, party)
	applicantV1.RegisterApplicantServiceHTTPServer(srv, applicant)
	referenceV1.RegisterReferenceServiceHTTPServer(srv, reference)
	surveyV1.RegisterSurveyServiceHTTPServer(srv, survey)
	financialV1.RegisterFinancialServiceHTTPServer(srv, financial)
	decisionV1.RegisterDecisionServiceHTTPServer(srv, decision)
	decisionV1.RegisterCommitteeServiceHTTPServer(srv, committee)
	return srv
}
