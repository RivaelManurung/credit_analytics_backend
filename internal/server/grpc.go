package server

import (
	applicantV1 "credit-analytics-backend/api/applicant/v1"
	applicationV1 "credit-analytics-backend/api/application/v1"
	v1 "credit-analytics-backend/api/helloworld/v1"
	"credit-analytics-backend/internal/conf"
	"credit-analytics-backend/internal/service"

	"github.com/go-kratos/kratos/v2/log"
	"github.com/go-kratos/kratos/v2/middleware/recovery"
	"github.com/go-kratos/kratos/v2/transport/grpc"
)

// NewGRPCServer new a gRPC server.
func NewGRPCServer(c *conf.Server, greeter *service.GreeterService, application *service.ApplicationService, applicant *service.ApplicantService, logger log.Logger) *grpc.Server {
	var opts = []grpc.ServerOption{
		grpc.Middleware(
			recovery.Recovery(),
		),
	}
	if c.Grpc.Network != "" {
		opts = append(opts, grpc.Network(c.Grpc.Network))
	}
	if c.Grpc.Addr != "" {
		opts = append(opts, grpc.Address(c.Grpc.Addr))
	}
	if c.Grpc.Timeout != nil {
		opts = append(opts, grpc.Timeout(c.Grpc.Timeout.AsDuration()))
	}
	srv := grpc.NewServer(opts...)
	v1.RegisterGreeterServer(srv, greeter)
	applicationV1.RegisterApplicationServer(srv, application)
	applicantV1.RegisterApplicantServer(srv, applicant)
	return srv
}
