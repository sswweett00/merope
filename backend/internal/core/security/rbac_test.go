package security

import "testing"

func TestDefaultRBACPolicy(t *testing.T) {
	enforcer, err := NewDefaultEnforcer()
	if err != nil {
		t.Fatalf("create default RBAC enforcer: %v", err)
	}

	allowed, err := enforcer.CheckPermission("user", "/api/v10/content/posts/123", "DELETE")
	if err != nil {
		t.Fatalf("check content delete policy: %v", err)
	}
	if !allowed {
		t.Fatal("expected authenticated users to reach content mutations; object ownership is enforced by the service layer")
	}

	allowed, err = enforcer.CheckPermission("user", "/api/v10/social/follow/123", "DELETE")
	if err != nil {
		t.Fatalf("check social delete policy: %v", err)
	}
	if allowed {
		t.Fatal("expected unlisted social DELETE route to be denied")
	}

	allowed, err = enforcer.CheckPermission("admin", "/api/v10/social/profile/123", "PATCH")
	if err != nil {
		t.Fatalf("check admin policy: %v", err)
	}
	if !allowed {
		t.Fatal("expected admin policy to allow API mutations")
	}
}
