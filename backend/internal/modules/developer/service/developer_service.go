package service

import (
	"context"
	"crypto/rand"
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"strings"
	"time"

	"local/merope/internal/modules/developer/domain"
)

type developerService struct{ repo domain.RuntimeDeveloperRepository }
func NewDeveloperService(repo domain.RuntimeDeveloperRepository) domain.RuntimeDeveloperService{return &developerService{repo:repo}}
func(s *developerService)RegisterApp(ctx context.Context,ownerID,name,description string)(*domain.App,error){name=strings.TrimSpace(name);if name==""{return nil,fmt.Errorf("app name is required")};app:=&domain.App{OwnerID:ownerID,Name:name,Description:description,ClientID:generateID(16),ClientSecret:generateID(32),IsActive:true,CreatedAt:time.Now(),UpdatedAt:time.Now(),Settings:domain.AppSettings{EnableWebhooks:true,EnableRealtime:true,RateLimitPerMinute:100,RateLimitPerHour:1000,MaxConcurrentCalls:10,AutoApproveTokens:true,TokenExpiry:3600,RefreshTokenExpiry:86400}};if err:=s.repo.CreateApp(ctx,app);err!=nil{return nil,err};return app,nil}
func(s *developerService)GetApp(ctx context.Context,id string)(*domain.App,error){return s.repo.GetApp(ctx,id)}
func(s *developerService)GetApps(ctx context.Context,ownerID string)([]*domain.App,error){return s.repo.GetAppsByOwner(ctx,ownerID,100,0)}
func(s *developerService)UpdateApp(ctx context.Context,app *domain.App)error{return s.repo.UpdateApp(ctx,app)}
func(s *developerService)DeleteApp(ctx context.Context,id string)error{return s.repo.DeleteApp(ctx,id)}
func(s *developerService)VerifyApp(ctx context.Context,id string)error{return s.repo.VerifyApp(ctx,id)}
func(s *developerService)CreateAPIKey(ctx context.Context,appID,name,description string,scopes []string,ttlDays int)(*domain.APIKey,error){raw:=generateID(40);key:=&domain.APIKey{AppID:appID,KeyHash:hashKey(raw),KeyPrefix:raw[:8],Name:strings.TrimSpace(name),Description:description,Scopes:scopes,RateLimitRPM:100,RateLimitRPH:1000,IsActive:true,CreatedAt:time.Now(),RawKey:raw};if ttlDays>0{expires:=time.Now().AddDate(0,0,ttlDays);key.ExpiresAt=&expires};if err:=s.repo.CreateAPIKey(ctx,key);err!=nil{return nil,err};stored,err:=s.repo.GetAPIKeyByHash(ctx,key.KeyHash);if err!=nil{return nil,err};stored.RawKey=raw;return stored,nil}
func(s *developerService)GetAPIKey(ctx context.Context,id string)(*domain.APIKey,error){key,err:=s.repo.GetAPIKey(ctx,id);if err!=nil{return nil,err};if key!=nil{key.RawKey=""};return key,nil}
func(s *developerService)ListAPIKeys(ctx context.Context,appID string)([]*domain.APIKey,error){keys,err:=s.repo.GetAPIKeysByAppID(ctx,appID);if err!=nil{return nil,err};for _,k:=range keys{k.RawKey=""};return keys,nil}
func(s *developerService)UpdateAPIKey(ctx context.Context,key *domain.APIKey)error{return s.repo.UpdateAPIKey(ctx,key)}
func(s *developerService)RevokeAPIKey(ctx context.Context,id string)error{return s.repo.RevokeAPIKey(ctx,id)}
func(s *developerService)CreateWebhook(ctx context.Context,appID,name,url string,events []string)(*domain.Webhook,error){if strings.TrimSpace(url)==""{return nil,fmt.Errorf("webhook url is required")};w:=&domain.Webhook{AppID:appID,Name:name,TargetURL:url,Secret:generateID(24),Events:events,IsActive:true,CreatedAt:time.Now(),UpdatedAt:time.Now(),RetryPolicy:domain.WebhookRetryPolicy{MaxRetries:3,RetryInterval:60,BackoffStrategy:"exponential",Timeout:30}};if err:=s.repo.CreateWebhook(ctx,w);err!=nil{return nil,err};return w,nil}
func(s *developerService)GetWebhook(ctx context.Context,id string)(*domain.Webhook,error){return s.repo.GetWebhook(ctx,id)}
func(s *developerService)ListWebhooks(ctx context.Context,id string)([]*domain.Webhook,error){return s.repo.GetWebhooksByAppID(ctx,id)}
func(s *developerService)UpdateWebhook(ctx context.Context,w *domain.Webhook)error{return s.repo.UpdateWebhook(ctx,w)}
func(s *developerService)DeleteWebhook(ctx context.Context,id string)error{return s.repo.DeleteWebhook(ctx,id)}
func(s *developerService)TestWebhook(ctx context.Context,id string)error{return s.repo.RecordWebhookDelivery(ctx,id,true,200,"developer test")}
func(s *developerService)CreateBot(ctx context.Context,appID,name,description string)(*domain.Bot,error){name=strings.TrimSpace(name);if name==""{return nil,fmt.Errorf("bot name is required")};b:=&domain.Bot{AppID:appID,Name:name,Description:description,IsActive:true,CreatedAt:time.Now(),UpdatedAt:time.Now(),Settings:domain.BotSettings{AllowDirectMessages:true,AllowGroupMessages:true,EnableCommands:true,PrivacyMode:"private",RateLimitPerUser:30,MaxCommandQueue:100}};if err:=s.repo.CreateBot(ctx,b);err!=nil{return nil,err};return b,nil}
func(s *developerService)GetBot(ctx context.Context,id string)(*domain.Bot,error){return s.repo.GetBot(ctx,id)}
func(s *developerService)ListBots(ctx context.Context,id string)([]*domain.Bot,error){return s.repo.GetBotsByAppID(ctx,id)}
func(s *developerService)UpdateBot(ctx context.Context,b *domain.Bot)error{return s.repo.UpdateBot(ctx,b)}
func(s *developerService)DeleteBot(ctx context.Context,id string)error{return s.repo.DeleteBot(ctx,id)}
func(s *developerService)GetMetrics(ctx context.Context,id,period string)(*domain.DeveloperMetrics,error){return s.repo.GetMetrics(ctx,id,period)}
func(s *developerService)RunTestSuite(ctx context.Context,id string)(*domain.TestSuiteResult,error){started:=time.Now();results:=[]domain.TestResult{{TestName:"application_exists",Status:"passed"},{TestName:"metrics_readable",Status:"passed"}};if _,err:=s.repo.GetApp(ctx,id);err!=nil{msg:="application lookup failed";results[0].Status="failed";results[0].Error=&msg};if _,err:=s.repo.GetMetrics(ctx,id,"24h");err!=nil{msg:="metrics lookup failed";results[1].Status="failed";results[1].Error=&msg};var passed,failed int32;for _,r:=range results{if r.Status=="passed"{passed++}else if r.Status=="failed"{failed++}};return &domain.TestSuiteResult{AppID:id,TotalTests:int32(len(results)),PassedTests:passed,FailedTests:failed,Duration:time.Since(started),Results:results,ExecutedAt:time.Now()},nil}
func generateID(length int)string{b:=make([]byte,length);if _,err:=rand.Read(b);err!=nil{panic(fmt.Errorf("crypto/rand unavailable: %w",err))};return strings.ToUpper(hex.EncodeToString(b))[:length]}
func hashKey(key string)string{h:=sha256.Sum256([]byte(key));return hex.EncodeToString(h[:])}
