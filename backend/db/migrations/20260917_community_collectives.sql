CREATE TABLE IF NOT EXISTS collectives (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE,
    description TEXT NOT NULL DEFAULT '',
    icon TEXT NOT NULL DEFAULT '',
    banner_url TEXT NOT NULL DEFAULT '',
    is_official BOOLEAN NOT NULL DEFAULT FALSE,
    category TEXT NOT NULL DEFAULT 'general',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_collectives_category_created
    ON collectives(category, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_collectives_official
    ON collectives(is_official, created_at DESC);

CREATE TABLE IF NOT EXISTS collective_members (
    collective_id UUID NOT NULL REFERENCES collectives(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role TEXT NOT NULL DEFAULT 'member',
    joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (collective_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_collective_members_user
    ON collective_members(user_id, joined_at DESC);
