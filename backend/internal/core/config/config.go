package config

import (
	"context"
	"github.com/sethvargo/go-envconfig"
	"log"
)

type Config struct {
	Env               string `env:"ENV,default=development"`
	Port              int    `env:"PORT,default=8080"`
	DatabaseURL       string `env:"DATABASE_URL,required"`
	JWTSecret         string `env:"JWT_SECRET,required"`
	CORSAllowedOrigins string `env:"CORS_ALLOWED_ORIGINS,default="`

	Redis struct {
		Addr     string `env:"REDIS_ADDR,default=localhost:6379"`
		Password string `env:"REDIS_PASSWORD"`
	}

	Scylla struct {
		Hosts       []string `env:"SCYLLA_HOSTS,default=localhost:9042"`
		Keyspace    string   `env:"SCYLLA_KEYSPACE,default=merope"`
		Username    string   `env:"SCYLLA_USERNAME,default="`
		Password    string   `env:"SCYLLA_PASSWORD,default="`
		Consistency string   `env:"SCYLLA_CONSISTENCY,default=LOCAL_QUORUM"`
		Timeout     string   `env:"SCYLLA_TIMEOUT,default=10s"`
	}

	NATS struct {
		URL string `env:"NATS_URL,default=nats://localhost:4222"`
	}

	Storage struct {
		Endpoint        string `env:"STORAGE_ENDPOINT,required"`
		Region          string `env:"STORAGE_REGION,required"`
		AccessKey       string `env:"STORAGE_ACCESS_KEY,required"`
		SecretKey       string `env:"STORAGE_SECRET_KEY,required"`
		Bucket          string `env:"STORAGE_BUCKET,required"`
		PublicURLPrefix string `env:"STORAGE_PUBLIC_URL_PREFIX,required"`
	}

	ClickHouse struct {
		Addr     string `env:"CLICKHOUSE_ADDR,default=localhost:9000"`
		Database string `env:"CLICKHOUSE_DB,default=merope_audit"`
	}
}

func Load(ctx context.Context) *Config {
	var c Config
	if err := envconfig.Process(ctx, &c); err != nil {
		log.Fatalf("Failed to load config: %v", err)
	}
	return &c
}
