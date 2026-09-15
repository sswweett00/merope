package scheduler

import (
	"context"
	"log"
	"sync"
	"time"
)

type TaskFunc func(ctx context.Context) error
type ScheduledTask struct { Name string; Interval time.Duration; RunNow bool; Task TaskFunc }
type Scheduler struct { tasks []*ScheduledTask; mtx sync.Mutex; running bool }
func New() *Scheduler { return &Scheduler{} }
func (s *Scheduler) Register(name string, interval time.Duration, task TaskFunc) { s.mtx.Lock(); defer s.mtx.Unlock(); s.tasks = append(s.tasks, &ScheduledTask{Name:name, Interval:interval, Task:task}) }
func (s *Scheduler) Start(ctx context.Context) { s.mtx.Lock(); if s.running { s.mtx.Unlock(); return }; s.running = true; for _, task := range s.tasks { go func(t *ScheduledTask) { if t.RunNow { if err:=t.Task(ctx); err!=nil { log.Printf("[scheduler] task %s failed on initial run: %v", t.Name, err) } }; ticker:=time.NewTicker(t.Interval); defer ticker.Stop(); for { select { case <-ticker.C: runCtx,cancel:=context.WithTimeout(ctx,t.Interval); if err:=t.Task(runCtx); err!=nil { log.Printf("[scheduler] task %s failed: %v",t.Name,err) }; cancel(); case <-ctx.Done(): return } } }(task) }; s.mtx.Unlock() }
type CronRunner struct { jobs []*CronJob }
type CronJob struct { Name string; CronExpr string; Task TaskFunc }
func NewCronRunner() *CronRunner { return &CronRunner{} }
func (c *CronRunner) Register(name, cronExpr string, task TaskFunc) { c.jobs=append(c.jobs,&CronJob{Name:name,CronExpr:cronExpr,Task:task}) }
func (c *CronRunner) Start(ctx context.Context) { for _,job:=range c.jobs { go func(j *CronJob) { ticker:=time.NewTicker(time.Minute); defer ticker.Stop(); for { select { case <-ticker.C: if shouldRun(j.CronExpr) { if err:=j.Task(ctx); err!=nil { log.Printf("[cron] job %s failed: %v",j.Name,err) } }; case <-ctx.Done(): return } } }(job) } }
func shouldRun(expr string) bool { return expr != "" }
