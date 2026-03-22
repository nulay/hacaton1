CREATE TABLE IF NOT EXISTS doctor_profiles (
    user_id BIGINT PRIMARY KEY REFERENCES users (id) ON DELETE CASCADE,
    photo_url TEXT,
    specialization TEXT,
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS doctor_diplomas (
    id BIGSERIAL PRIMARY KEY,
    doctor_user_id BIGINT NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_doctor_diplomas_doctor_user_id
    ON doctor_diplomas (doctor_user_id);
