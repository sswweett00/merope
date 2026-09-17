-- Feed retrieval has two dominant branches: followed authors and public posts.
-- Separate partial indexes let PostgreSQL prune rows before the published_at sort.
CREATE INDEX IF NOT EXISTS idx_posts_feed_author_published
    ON posts(author_id, published_at DESC, id DESC)
    WHERE published_at IS NOT NULL AND is_archived = FALSE AND is_draft = FALSE AND deleted_at IS NULL;

CREATE INDEX IF NOT EXISTS idx_posts_feed_public_published
    ON posts(published_at DESC, id DESC)
    WHERE visibility = 'public' AND published_at IS NOT NULL AND is_archived = FALSE AND is_draft = FALSE AND deleted_at IS NULL;
