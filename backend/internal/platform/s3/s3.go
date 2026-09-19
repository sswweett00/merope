package s3

import (
	"context"
	"fmt"
	"io"
	"time"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/credentials"
	"github.com/aws/aws-sdk-go-v2/service/s3"
)

type Client struct {
	S3     *s3.Client
	Bucket string
}

type Options struct {
	Region       string
	Endpoint     string
	AccessKey    string
	SecretKey    string
	UsePathStyle bool
	Bucket       string
}

func New(ctx context.Context, opts Options) (*Client, error) {
	var cfg aws.Config
	var err error

	if opts.Endpoint != "" {
		// MinIO or custom S3 provider
		customResolver := aws.EndpointResolverWithOptionsFunc(func(service, region string, options ...interface{}) (aws.Endpoint, error) {
			return aws.Endpoint{
				URL:               opts.Endpoint,
				SigningRegion:     opts.Region,
				HostnameImmutable: true,
			}, nil
		})

		cfg, err = config.LoadDefaultConfig(ctx,
			config.WithRegion(opts.Region),
			config.WithEndpointResolverWithOptions(customResolver),
			config.WithCredentialsProvider(credentials.NewStaticCredentialsProvider(opts.AccessKey, opts.SecretKey, "")),
		)
	} else {
		// Standard AWS S3
		cfg, err = config.LoadDefaultConfig(ctx, config.WithRegion(opts.Region))
	}

	if err != nil {
		return nil, fmt.Errorf("failed to load s3 config: %w", err)
	}

	s3Client := s3.NewFromConfig(cfg, func(o *s3.Options) {
		o.UsePathStyle = opts.UsePathStyle
	})

	return &Client{S3: s3Client, Bucket: opts.Bucket}, nil
}

func (c *Client) Upload(ctx context.Context, key string, body io.Reader, contentType string) (string, error) {
	_, err := c.S3.PutObject(ctx, &s3.PutObjectInput{
		Bucket:      aws.String(c.Bucket),
		Key:         aws.String(key),
		Body:        body,
		ContentType: aws.String(contentType),
	})
	if err != nil {
		return "", err
	}

	return key, nil // Return the key instead of a hardcoded URL prefix
}

func (c *Client) GetPresignedURL(ctx context.Context, key string, expiration time.Duration) (string, error) {
	presignClient := s3.NewPresignClient(c.S3)
	req, err := presignClient.PresignGetObject(ctx, &s3.GetObjectInput{
		Bucket: aws.String(c.Bucket),
		Key:    aws.String(key),
	}, s3.WithPresignExpires(expiration))

	if err != nil {
		return "", err
	}

	return req.URL, nil
}

func (c *Client) Download(ctx context.Context, key string) (io.ReadCloser, error) {
	result, err := c.S3.GetObject(ctx, &s3.GetObjectInput{
		Bucket: aws.String(c.Bucket),
		Key:    aws.String(key),
	})
	if err != nil {
		return nil, err
	}
	return result.Body, nil
}

func (c *Client) Delete(ctx context.Context, key string) error {
	_, err := c.S3.DeleteObject(ctx, &s3.DeleteObjectInput{
		Bucket: aws.String(c.Bucket),
		Key:    aws.String(key),
	})
	return err
}
