package service

import "testing"

func TestLevelForXP(t *testing.T) {
	tests := []struct {
		xp    int64
		level int
	}{
		{0, 1},
		{99, 1},
		{100, 2},
		{399, 2},
		{400, 3},
		{2500, 6},
	}
	for _, tt := range tests {
		if got := LevelForXP(tt.xp); got != tt.level {
			t.Fatalf("LevelForXP(%d)=%d, want %d", tt.xp, got, tt.level)
		}
	}
}

func TestNextLevelXP(t *testing.T) {
	if got := NextLevelXP(1); got != 100 {
		t.Fatalf("NextLevelXP(1)=%d, want 100", got)
	}
	if got := NextLevelXP(10); got != 10000 {
		t.Fatalf("NextLevelXP(10)=%d, want 10000", got)
	}
}

func TestTierForLevel(t *testing.T) {
	tests := []struct {
		level int
		tier  string
	}{
		{1, "Seed"},
		{5, "Spark"},
		{10, "Pulse"},
		{15, "Orbit"},
		{25, "Nova"},
		{50, "Apex"},
	}
	for _, tt := range tests {
		if got := TierForLevel(tt.level); got != tt.tier {
			t.Fatalf("TierForLevel(%d)=%s, want %s", tt.level, got, tt.tier)
		}
	}
}
