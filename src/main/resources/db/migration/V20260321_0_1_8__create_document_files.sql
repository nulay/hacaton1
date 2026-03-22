CREATE TABLE document_files (
    id BIGSERIAL PRIMARY KEY,
    document_id BIGINT NOT NULL REFERENCES medical_documents(id) ON DELETE CASCADE,
    file_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    file_size VARCHAR(50),
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_document_files_document_id ON document_files(document_id);
