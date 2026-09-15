package security

import (
	"fmt"
	"github.com/casbin/casbin/v2"
)

type Enforcer struct {
	Enforcer *casbin.Enforcer
}

func NewEnforcer(modelPath, policyPath string) (*Enforcer, error) {
	e, err := casbin.NewEnforcer(modelPath, policyPath)
	if err != nil {
		return nil, fmt.Errorf("failed to create casbin enforcer: %w", err)
	}
	return &Enforcer{Enforcer: e}, nil
}

func (e *Enforcer) CheckPermission(sub, obj, act string) (bool, error) {
	return e.Enforcer.Enforce(sub, obj, act)
}
