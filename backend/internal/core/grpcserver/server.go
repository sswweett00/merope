package grpcserver

import (
	"fmt"
	"log"
	"net"
	"sync"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/grpc/connectivity"
	"google.golang.org/grpc/keepalive"
)

type Server struct { server *grpc.Server; listener net.Listener; mu sync.RWMutex; stopped bool }
type Config struct { Addr string; MaxConnAge time.Duration; Timeout time.Duration }
func NewServer(cfg Config) *Server { kaep := keepalive.EnforcementPolicy{MinTime: time.Minute, PermitWithoutStream: true}; kasp := keepalive.ServerParameters{MaxConnectionAge: cfg.MaxConnAge, MaxConnectionAgeGrace: 5*time.Minute, Time: 2*time.Hour, Timeout: 20*time.Second}; server := grpc.NewServer(grpc.KeepaliveEnforcementPolicy(kaep), grpc.KeepaliveParams(kasp), grpc.MaxRecvMsgSize(50*1024*1024), grpc.MaxSendMsgSize(50*1024*1024)); return &Server{server: server} }
func (s *Server) RegisterService(sd *grpc.ServiceDesc, impl interface{}) { s.server.RegisterService(sd, impl) }
func (s *Server) Start(cfg Config) error { s.mu.Lock(); if s.stopped { s.mu.Unlock(); return fmt.Errorf("server is stopped") }; s.mu.Unlock(); listener, err := net.Listen("tcp", cfg.Addr); if err != nil { return fmt.Errorf("listen %s: %w", cfg.Addr, err) }; s.listener = listener; log.Printf("[grpc] starting on %s", cfg.Addr); go func() { if err := s.server.Serve(listener); err != nil && err != grpc.ErrServerStopped { log.Printf("[grpc] serving error: %v", err) } }(); return nil }
func (s *Server) GracefulStop() { s.mu.Lock(); defer s.mu.Unlock(); if !s.stopped { s.stopped = true; s.server.GracefulStop(); if s.listener != nil { _ = s.listener.Close() } } }
func (s *Server) Stop() { s.mu.Lock(); defer s.mu.Unlock(); if !s.stopped { s.stopped = true; s.server.Stop(); if s.listener != nil { _ = s.listener.Close() } } }
type GRPCClient interface { GetConnectionState() connectivity.State }
