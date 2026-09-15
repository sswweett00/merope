package service

import (
	"context"
	"crypto/hmac"
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"sync"
	"time"

	"local/merope/internal/core/events"
)

type AetherStreamShield interface { AuthorizeStreamAccess(context.Context,string,string,string)(string,error); IssueStreamDRMToken(context.Context,string,string,time.Duration)(string,error); TrackViewerSession(context.Context,string,string)error; RevokeViewerSession(context.Context,string,string)error }
type aetherStreamShield struct { bus events.Publisher; secretKey []byte; activeViewers map[string]map[string]time.Time; mu sync.RWMutex }
func NewAetherStreamShield(bus events.Publisher,secretKey string)AetherStreamShield{if secretKey==""{secretKey="aether_default_stream_secret_key_merope"};return &aetherStreamShield{bus:bus,secretKey:[]byte(secretKey),activeViewers:make(map[string]map[string]time.Time)}}
func (s *aetherStreamShield) AuthorizeStreamAccess(ctx context.Context,streamID,viewerID,tokenHex string)(string,error){if streamID==""||viewerID==""{return "",fmt.Errorf("aether_shield: invalid stream or viewer ID")};if tokenHex==""{return "",fmt.Errorf("aether_shield: missing stream authorization token")};watermarkCode:=s.generateWatermarkCode(streamID,viewerID);_ = s.TrackViewerSession(ctx,streamID,viewerID);if s.bus!=nil{_ = s.bus.Publish(ctx,"aether.stream.authorized",events.Event{Type:"AETHER_STREAM_AUTHORIZED",Payload:map[string]interface{}{"stream_id":streamID,"viewer_id":viewerID,"watermark_code":watermarkCode,"authorized_at":time.Now()}})};return watermarkCode,nil}
func (s *aetherStreamShield) IssueStreamDRMToken(ctx context.Context,streamID,viewerID string,ttl time.Duration)(string,error){expiresAt:=time.Now().Add(ttl).Unix();payload:=fmt.Sprintf("%s:%s:%d",streamID,viewerID,expiresAt);h:=hmac.New(sha256.New,s.secretKey);_,_=h.Write([]byte(payload));return fmt.Sprintf("%s.%s",payload,hex.EncodeToString(h.Sum(nil))),nil}
func (s *aetherStreamShield) TrackViewerSession(ctx context.Context,streamID,viewerID string)error{s.mu.Lock();defer s.mu.Unlock();if _,exists:=s.activeViewers[streamID];!exists{s.activeViewers[streamID]=make(map[string]time.Time)};s.activeViewers[streamID][viewerID]=time.Now();return nil}
func (s *aetherStreamShield) RevokeViewerSession(ctx context.Context,streamID,viewerID string)error{s.mu.Lock();defer s.mu.Unlock();if viewers,exists:=s.activeViewers[streamID];exists{delete(viewers,viewerID)};if s.bus!=nil{_ = s.bus.Publish(ctx,"aether.stream.revoked",events.Event{Type:"AETHER_STREAM_REVOKED",Payload:map[string]interface{}{"stream_id":streamID,"viewer_id":viewerID}})};return nil}
func (s *aetherStreamShield) generateWatermarkCode(streamID,viewerID string)string{day:=time.Now().Unix()/86400;raw:=fmt.Sprintf("%s#%s#%d",streamID,viewerID,day);hash:=sha256.Sum256([]byte(raw));return hex.EncodeToString(hash[:])[:10]}
