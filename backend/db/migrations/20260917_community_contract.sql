-- Community API contract
-- Aligns PostgreSQL community records with the Flutter Community model and
-- keeps older installations forward-compatible via idempotent ALTERs.

ALTER TABLE communities ADD COLUMN IF NOT EXISTS slug TEXT;
ALTER TABLE communities ADD COLUMN IF NOT EXISTS banner_url TEXT NOT NULL DEFAULT '';
ALTER TABLE communities ADD COLUMN IF NOT EXISTS is_verified BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE communities ADD COLUMN IF NOT EXISTS category TEXT NOT NULL DEFAULT 'general';
ALTER TABLE communities ADD COLUMN IF NOT EXISTS tags TEXT[] NOT NULL DEFAULT '{}';
ALTER TABLE communities ADD COLUMN IF NOT EXISTS rules TEXT[] NOT NULL DEFAULT '{}';
ALTER TABLE communities ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW();

-- Existing rows need deterministic, URL-safe, collision-resistant slugs.
UPDATE communities
SET slug = CONCAT(
    NULLIF(BTRIM(REGEXP_REPLACE(LOWER(name), '[^a-z0-9]+', '-', 'g'), '-'), ''),
    '-',
    SUBSTRING(id::text, 1, 8)
)
WHERE slug IS NULL OR BTRIM(slug) = '';

CREATE INDEX IF NOT EXISTS idx_communities_slug_lower
    ON communities(LOWER(slug));
CREATE INDEX IF NOT EXISTS idx_communities_category_created
    ON communities(category, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_community_members_user_joined
    ON community_members(user_id, joined_at DESC);
CREATE INDEX IF NOT EXISTS idx_community_members_community_role_joined
    ON community_members(community_id, role, joined_at DESC);
