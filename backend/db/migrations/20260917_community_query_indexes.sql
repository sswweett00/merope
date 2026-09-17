-- Community hot paths: membership listing, aggregate counts, and slug lookup.
CREATE INDEX IF NOT EXISTS idx_community_members_community_role_joined
    ON community_members(community_id, role, joined_at ASC, user_id);

CREATE INDEX IF NOT EXISTS idx_communities_normalized_name
    ON communities ((LOWER(REPLACE(name, ' ', '-'))));
