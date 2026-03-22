package com.hackaton.repository;

import com.hackaton.model.DocumentFile;
import com.hackaton.model.MedicalDocument;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.Date;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public class MedicalDocumentRepository {
    private final JdbcTemplate jdbcTemplate;

    private final RowMapper<MedicalDocument> mapper = (rs, rowNum) -> {
        MedicalDocument doc = new MedicalDocument();
        doc.setId(rs.getLong("id"));
        doc.setUserId(rs.getLong("user_id"));
        doc.setTitle(rs.getString("title"));
        doc.setDescription(rs.getString("description"));
        Date docDate = rs.getDate("document_date");
        doc.setDocumentDate(docDate != null ? docDate.toLocalDate() : null);
        doc.setDoctorName(rs.getString("doctor_name"));
        doc.setExtractedText(rs.getString("extracted_text"));
        doc.setOcrStatus(rs.getString("ocr_status"));
        doc.setOcrError(rs.getString("ocr_error"));
        Date createdAt = rs.getDate("created_at");
        doc.setCreatedAt(createdAt != null ? createdAt.toLocalDate() : null);
        return doc;
    };

    private final RowMapper<DocumentFile> fileMapper = (rs, rowNum) -> {
        DocumentFile file = new DocumentFile();
        file.setId(rs.getLong("id"));
        file.setDocumentId(rs.getLong("document_id"));
        file.setFileName(rs.getString("file_name"));
        file.setFilePath(rs.getString("file_path"));
        file.setFileSize(rs.getString("file_size"));
        java.sql.Timestamp ts = rs.getTimestamp("created_at");
        file.setCreatedAt(ts != null ? ts.toLocalDateTime() : null);
        return file;
    };

    public MedicalDocumentRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<MedicalDocument> findByUserId(Long userId) {
        List<MedicalDocument> docs = jdbcTemplate.query(
            "SELECT * FROM medical_documents WHERE user_id = ? ORDER BY created_at DESC",
            mapper,
            userId
        );
        for (MedicalDocument doc : docs) {
            doc.setFiles(findFilesByDocumentId(doc.getId()));
        }
        return docs;
    }

    public Optional<MedicalDocument> findById(Long id) {
        try {
            MedicalDocument doc = jdbcTemplate.queryForObject(
                "SELECT * FROM medical_documents WHERE id = ?",
                mapper,
                id
            );
            if (doc != null) {
                doc.setFiles(findFilesByDocumentId(doc.getId()));
            }
            return Optional.of(doc);
        } catch (EmptyResultDataAccessException ex) {
            return Optional.empty();
        }
    }

    public Optional<MedicalDocument> findByIdAndUserId(Long id, Long userId) {
        try {
            MedicalDocument doc = jdbcTemplate.queryForObject(
                "SELECT * FROM medical_documents WHERE id = ? AND user_id = ?",
                mapper,
                id,
                userId
            );
            if (doc != null) {
                doc.setFiles(findFilesByDocumentId(doc.getId()));
            }
            return Optional.of(doc);
        } catch (EmptyResultDataAccessException ex) {
            return Optional.empty();
        }
    }

    private List<DocumentFile> findFilesByDocumentId(Long documentId) {
        return jdbcTemplate.query(
            "SELECT * FROM document_files WHERE document_id = ? ORDER BY created_at",
            fileMapper,
            documentId
        );
    }

    public long create(MedicalDocument doc) {
        jdbcTemplate.update(
            "INSERT INTO medical_documents (user_id, title, description, document_date, doctor_name, created_at) VALUES (?, ?, ?, ?, ?, ?)",
            doc.getUserId(),
            doc.getTitle(),
            doc.getDescription(),
            doc.getDocumentDate() != null ? Date.valueOf(doc.getDocumentDate()) : null,
            doc.getDoctorName(),
            Date.valueOf(java.time.LocalDate.now())
        );
        
        Long id = jdbcTemplate.queryForObject("SELECT lastval()", Long.class);
        return id != null ? id : 0;
    }

    public void addFile(Long documentId, DocumentFile file) {
        jdbcTemplate.update(
            "INSERT INTO document_files (document_id, file_name, file_path, file_size, created_at) VALUES (?, ?, ?, ?, ?)",
            documentId,
            file.getFileName(),
            file.getFilePath(),
            file.getFileSize(),
            LocalDateTime.now()
        );
    }

    public void update(MedicalDocument doc) {
        jdbcTemplate.update(
            "UPDATE medical_documents SET title = ?, description = ?, document_date = ?, doctor_name = ? WHERE id = ?",
            doc.getTitle(),
            doc.getDescription(),
            doc.getDocumentDate() != null ? Date.valueOf(doc.getDocumentDate()) : null,
            doc.getDoctorName(),
            doc.getId()
        );
    }

    public void updateExtractedText(Long id, String extractedText) {
        jdbcTemplate.update(
            "UPDATE medical_documents SET extracted_text = ? WHERE id = ?",
            extractedText,
            id
        );
    }

    public void updateOcrStatus(Long id, String status) {
        jdbcTemplate.update(
            "UPDATE medical_documents SET ocr_status = ? WHERE id = ?",
            status,
            id
        );
    }

    public void updateOcrError(Long id, String error) {
        jdbcTemplate.update(
            "UPDATE medical_documents SET ocr_status = 'failed', ocr_error = ? WHERE id = ?",
            error,
            id
        );
    }

    public void deleteFile(Long fileId) {
        jdbcTemplate.update("DELETE FROM document_files WHERE id = ?", fileId);
    }

    public void delete(Long id) {
        jdbcTemplate.update("DELETE FROM medical_documents WHERE id = ?", id);
    }

    public void updateDescription(Long docId, String description) {
        jdbcTemplate.update("UPDATE medical_documents SET description = ? WHERE id = ?", description, docId);
    }

    public static String formatFileSize(long bytes) {
        if (bytes < 1024) return bytes + " B";
        if (bytes < 1024 * 1024) return String.format("%.1f KB", bytes / 1024.0);
        return String.format("%.1f MB", bytes / (1024.0 * 1024.0));
    }
}
