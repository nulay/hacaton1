CREATE TABLE medical_documents (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    document_date DATE,
    doctor_name VARCHAR(255),
    file_name VARCHAR(255),
    file_path VARCHAR(500) NOT NULL,
    file_size VARCHAR(50),
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_medical_documents_user_id ON medical_documents(user_id);
