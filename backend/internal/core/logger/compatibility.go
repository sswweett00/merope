package logger

import "go.uber.org/zap"

func current() *zap.Logger {
	if Log != nil {
		return Log
	}
	return zap.NewNop()
}

func Info(msg string, args ...interface{}) {
	current().Sugar().Infow(msg, args...)
}

func Warn(msg string, args ...interface{}) {
	current().Sugar().Warnw(msg, args...)
}
