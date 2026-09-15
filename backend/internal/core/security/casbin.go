package security

import (
	"embed"
	"encoding/csv"
	"fmt"
	"io"
	"strings"

	"github.com/casbin/casbin/v2"
	"github.com/casbin/casbin/v2/model"
)

//go:embed rbac_model.conf rbac_policy.csv
var rbacFS embed.FS

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

func NewDefaultEnforcer() (*Enforcer, error) {
	modelBytes, err := rbacFS.ReadFile("rbac_model.conf")
	if err != nil {
		return nil, fmt.Errorf("read embedded RBAC model: %w", err)
	}
	m, err := model.NewModelFromString(string(modelBytes))
	if err != nil {
		return nil, fmt.Errorf("parse RBAC model: %w", err)
	}
	e, err := casbin.NewEnforcer(m)
	if err != nil {
		return nil, fmt.Errorf("create RBAC enforcer: %w", err)
	}

	policyFile, err := rbacFS.Open("rbac_policy.csv")
	if err != nil {
		return nil, fmt.Errorf("open embedded RBAC policy: %w", err)
	}
	defer policyFile.Close()

	reader := csv.NewReader(policyFile)
	reader.FieldsPerRecord = -1
	for {
		record, readErr := reader.Read()
		if readErr == io.EOF {
			break
		}
		if readErr != nil {
			return nil, fmt.Errorf("read RBAC policy: %w", readErr)
		}
		if len(record) != 4 || strings.TrimSpace(record[0]) != "p" {
			return nil, fmt.Errorf("invalid RBAC policy record")
		}
		if _, err := e.AddPolicy(strings.TrimSpace(record[1]), strings.TrimSpace(record[2]), strings.TrimSpace(record[3])); err != nil {
			return nil, fmt.Errorf("add RBAC policy: %w", err)
		}
	}
	return &Enforcer{Enforcer: e}, nil
}

func (e *Enforcer) CheckPermission(sub, obj, act string) (bool, error) {
	if e == nil || e.Enforcer == nil || strings.TrimSpace(sub) == "" || strings.TrimSpace(obj) == "" || strings.TrimSpace(act) == "" {
		return false, fmt.Errorf("invalid RBAC request")
	}
	return e.Enforcer.Enforce(sub, obj, act)
}
