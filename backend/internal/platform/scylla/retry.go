package scylla

import "github.com/gocql/gocql"

type noRetry struct{}

func (n *noRetry) Attempt(q gocql.RetryableQuery) bool {
	return false
}

func (n *noRetry) GetRetryType(err error) gocql.RetryType {
	return gocql.Rethrow
}
