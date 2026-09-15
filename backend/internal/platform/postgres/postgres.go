package postgres

import (
	"context"
	"fmt"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
)

type Client struct { PersonalPool *pgxpool.Pool; CorporatePool *pgxpool.Pool; CorePool *pgxpool.Pool }
type HealthInfo struct { TotalConns int32; IdleConns int32; Status string }
func New(ctx context.Context, personalDSN, corporateDSN, coreDSN string) (*Client,error) { personalPool,err:=createPool(ctx,personalDSN,"personal"); if err!=nil{return nil,err}; corporatePool,err:=createPool(ctx,corporateDSN,"corporate"); if err!=nil{return nil,err}; corePool,err:=createPool(ctx,coreDSN,"core"); if err!=nil{return nil,err}; return &Client{PersonalPool:personalPool,CorporatePool:corporatePool,CorePool:corePool},nil }
func createPool(ctx context.Context, connStr,name string)(*pgxpool.Pool,error){ config,err:=pgxpool.ParseConfig(connStr); if err!=nil{return nil,fmt.Errorf("failed to parse %s config: %w",name,err)}; config.MaxConns=50; config.MinConns=10; config.MaxConnIdleTime=15*time.Minute; config.MaxConnLifetime=2*time.Hour; config.HealthCheckPeriod=30*time.Second; pool,err:=pgxpool.NewWithConfig(ctx,config); if err!=nil{return nil,fmt.Errorf("failed to create %s pool: %w",name,err)}; if err:=pool.Ping(ctx);err!=nil{return nil,fmt.Errorf("failed to ping %s db: %w",name,err)}; return pool,nil }
func (c *Client) CheckHealth(ctx context.Context) map[string]HealthInfo { health:=make(map[string]HealthInfo); pools:=map[string]*pgxpool.Pool{"personal":c.PersonalPool,"corporate":c.CorporatePool,"core":c.CorePool}; for name,pool:=range pools{stat:=pool.Stat(); status:="healthy"; if err:=pool.Ping(ctx);err!=nil{status="degraded"}; health[name]=HealthInfo{TotalConns:stat.TotalConns(),IdleConns:stat.IdleConns(),Status:status} }; return health }
func (c *Client) Close(){if c.PersonalPool!=nil{c.PersonalPool.Close()};if c.CorporatePool!=nil{c.CorporatePool.Close()};if c.CorePool!=nil{c.CorePool.Close()}}
