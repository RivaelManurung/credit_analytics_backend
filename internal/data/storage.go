package data

import (
	"context"
	"credit-analytics-backend/internal/biz"
	"credit-analytics-backend/internal/conf"
	"fmt"
	"time"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/credentials"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/go-kratos/kratos/v2/log"
)

type storageService struct {
	client        *s3.Client
	presignClient *s3.PresignClient
	bucket        string
	endpoint      string
	log           *log.Helper
}

func NewStorageService(c *conf.Data, logger log.Logger) biz.StorageService {
	l := log.NewHelper(logger)
	if c.Storage == nil {
		l.Warn("Storage configuration is missing, using fallback")
		return &storageService{log: l}
	}

	// Supabase S3 compatible config
	customResolver := aws.EndpointResolverWithOptionsFunc(func(service, region string, options ...interface{}) (aws.Endpoint, error) {
		return aws.Endpoint{
			URL:               c.Storage.Endpoint,
			SigningRegion:     c.Storage.Region,
			HostnameImmutable: true,
		}, nil
	})

	cfg, err := config.LoadDefaultConfig(context.TODO(),
		config.WithRegion(c.Storage.Region),
		config.WithCredentialsProvider(credentials.NewStaticCredentialsProvider(c.Storage.AccessKey, c.Storage.SecretKey, "")),
		config.WithEndpointResolverWithOptions(customResolver),
	)
	if err != nil {
		l.Errorf("failed to load storage config: %v", err)
		return &storageService{log: l}
	}

	client := s3.NewFromConfig(cfg)
	return &storageService{
		client:        client,
		presignClient: s3.NewPresignClient(client),
		bucket:        c.Storage.Bucket,
		endpoint:      c.Storage.Endpoint, // e.g. https://[project-id].supabase.co/storage/v1/s3
		log:           l,
	}
}

func (s *storageService) GeneratePresignedPutURL(ctx context.Context, fileName string, contentType string) (string, string, error) {
	if s.presignClient == nil {
		return "", "", fmt.Errorf("storage service not initialized")
	}

	req, err := s.presignClient.PresignPutObject(ctx, &s3.PutObjectInput{
		Bucket:      aws.String(s.bucket),
		Key:         aws.String(fileName),
		ContentType: aws.String(contentType),
	}, s3.WithPresignExpires(time.Hour))

	if err != nil {
		return "", "", fmt.Errorf("failed to presign put object: %w", err)
	}

	// Final URL Construction (Public access or public bucket URL)
	// For Supabase, final URL depends on bucket visibility.
	// Standard S3 URL pattern or Supabase public URL pattern:
	// https://[project-id].supabase.co/storage/v1/object/public/[bucket]/[key]

	// We'll return the standard S3 URL and the user can adjust if needed
	fileURL := fmt.Sprintf("%s/%s/%s", s.endpoint, s.bucket, fileName)

	return req.URL, fileURL, nil
}
