CREATE TABLE IF NOT EXISTS thread_replies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    thread_id UUID NOT NULL,
    author_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    parent_id UUID,
    content TEXT NOT NULL,
    resonance INTEGER NOT NULL DEFAULT 0,
    is_edited BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_thread_replies_thread_created
    ON thread_replies(thread_id, created_at ASC);
CREATE INDEX IF NOT EXISTS idx_thread_replies_author_created
    ON thread_replies(author_id, created_at DESC);
