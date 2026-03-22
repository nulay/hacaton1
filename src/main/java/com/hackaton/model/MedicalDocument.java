package com.hackaton.model;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class MedicalDocument {
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    
    private Long id;
    private Long userId;
    private String title;
    private String description;
    private LocalDate documentDate;
    private String doctorName;
    private List<DocumentFile> files = new ArrayList<>();
    private String extractedText;
    private String ocrStatus;
    private String ocrError;
    private LocalDate createdAt;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public LocalDate getDocumentDate() {
        return documentDate;
    }

    public void setDocumentDate(LocalDate documentDate) {
        this.documentDate = documentDate;
    }

    public String getDocumentDateFormatted() {
        return documentDate != null ? documentDate.format(DATE_FORMATTER) : "";
    }

    public String getDoctorName() {
        return doctorName;
    }

    public void setDoctorName(String doctorName) {
        this.doctorName = doctorName;
    }

    public List<DocumentFile> getFiles() {
        return files;
    }

    public void setFiles(List<DocumentFile> files) {
        this.files = files;
    }

    public void addFile(DocumentFile file) {
        this.files.add(file);
    }

    public int getFileCount() {
        return files != null ? files.size() : 0;
    }

    public LocalDate getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDate createdAt) {
        this.createdAt = createdAt;
    }

    public String getExtractedText() {
        return extractedText;
    }

    public void setExtractedText(String extractedText) {
        this.extractedText = extractedText;
    }

    public boolean isHasExtractedText() {
        return extractedText != null && !extractedText.isEmpty();
    }

    public boolean hasExtractedText() {
        return extractedText != null && !extractedText.isEmpty();
    }

    public String getOcrStatus() {
        return ocrStatus;
    }

    public void setOcrStatus(String ocrStatus) {
        this.ocrStatus = ocrStatus;
    }

    public boolean isOcrFailed() {
        return "failed".equals(ocrStatus);
    }

    public String getOcrError() {
        return ocrError;
    }

    public void setOcrError(String ocrError) {
        this.ocrError = ocrError;
    }

    public boolean isHasOcrError() {
        return ocrError != null && !ocrError.isEmpty();
    }

    public boolean hasOcrError() {
        return ocrError != null && !ocrError.isEmpty();
    }
}
