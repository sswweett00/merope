-- Backend/frontend messaging contract support.
-- Public keys are stored server-side; private keys never leave the client.
CREATE TABLE IF NOT EXISTS user_e2ee_public_keys (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    public_key TEXT NOT NULL,
    algorithm TEXT NOT NULL DEFAULT 'x25519',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS e2ee_key_rotations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    room_id UUID NOT NULL REFERENCES chat_rooms(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    public_key_id TEXT NOT NULL,
    device_id TEXT NOT NULL,
    rotated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_e2ee_key_rotations_room
    ON e2ee_key_rotations(room_id, rotated_at DESC);
