package com.hackaton.service;

import com.hackaton.model.DocumentFile;
import com.hackaton.model.MedicalDocument;
import com.hackaton.repository.MedicalDocumentRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class MedicalDocumentService {
    private static final Logger logger = LoggerFactory.getLogger(MedicalDocumentService.class);

    private final MedicalDocumentRepository documentRepository;
    private final OcrService ocrService;
    private static final String UPLOAD_DIR = "D:/raznoe/project/hackaton/uploads/documents/";

    public MedicalDocumentService(MedicalDocumentRepository documentRepository, OcrService ocrService) {
        this.documentRepository = documentRepository;
        this.ocrService = ocrService;
    }

    public List<MedicalDocument> getDocumentsByUserId(Long userId) {
        return documentRepository.findByUserId(userId);
    }

    public Optional<MedicalDocument> getDocumentById(Long id) {
        return documentRepository.findById(id);
    }

    public Optional<MedicalDocument> getDocumentByIdAndUserId(Long id, Long userId) {
        return documentRepository.findByIdAndUserId(id, userId);
    }

    public MedicalDocument createDocument(Long userId, String title, String description,
                                        LocalDate documentDate, String doctorName, List<MultipartFile> files) throws IOException {
        MedicalDocument doc = new MedicalDocument();
        doc.setUserId(userId);
        doc.setTitle(title);
        doc.setDescription(description);
        doc.setDocumentDate(documentDate);
        doc.setDoctorName(doctorName);

        long docId = documentRepository.create(doc);

        Path uploadPath = Paths.get(UPLOAD_DIR);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        StringBuilder extractedTextBuilder = new StringBuilder();

        for (MultipartFile file : files) {
            if (file != null && !file.isEmpty()) {
                String originalFilename = file.getOriginalFilename();
                logger.debug("Processing file: {}", originalFilename);
                
                String fileName = UUID.randomUUID().toString() + "_" + originalFilename;
                Path filePath = uploadPath.resolve(fileName);
                Files.copy(file.getInputStream(), filePath);
                logger.debug("File saved to: {}", filePath);

                DocumentFile docFile = new DocumentFile();
                docFile.setFileName(originalFilename);
                docFile.setFilePath(fileName);
                docFile.setFileSize(MedicalDocumentRepository.formatFileSize(file.getSize()));
                documentRepository.addFile(docId, docFile);

                if (isImageFile(originalFilename)) {
                    try {
                        logger.debug("File is image, calling OCR...");
                        String text = ocrService.extractTextFromImage(filePath);
                        if (text != null && !text.isEmpty()) {
                            if (extractedTextBuilder.length() > 0) {
                                extractedTextBuilder.append("\n\n---\n\n");
                            }
                            extractedTextBuilder.append("Файл: ").append(originalFilename).append("\n");
                            extractedTextBuilder.append(text);
                            logger.info("OCR extracted {} chars from {}", text.length(), originalFilename);
                        } else {
                            logger.debug("OCR returned empty text for {}", originalFilename);
                        }
                    } catch (Exception e) {
                        logger.warn("OCR failed for {}: {}", originalFilename, e.getMessage());
                    }
                }
            }
        }

        String extractedText = extractedTextBuilder.length() > 0 ? extractedTextBuilder.toString() : null;
        if (extractedText != null) {
            documentRepository.updateExtractedText(docId, extractedText);
            doc.setExtractedText(extractedText);
            
            if (description == null || description.trim().isEmpty()) {
                String shortText = extractedText.length() > 1000 ? extractedText.substring(0, 1000) + "..." : extractedText;
                documentRepository.updateDescription(docId, shortText);
            }
        }

        if (doc.getOcrStatus() != null) {
            if (doc.getOcrError() != null) {
                documentRepository.updateOcrError(docId, doc.getOcrError());
            } else {
                documentRepository.updateOcrStatus(docId, doc.getOcrStatus());
            }
        }

        return documentRepository.findById(docId).orElse(doc);
    }

    public MedicalDocument updateDocument(Long id, Long userId, String title, String description,
                                         LocalDate documentDate, String doctorName, List<MultipartFile> newFiles) throws IOException {
        Optional<MedicalDocument> existing = documentRepository.findByIdAndUserId(id, userId);
        if (existing.isEmpty()) {
            throw new RuntimeException("Document not found");
        }

        MedicalDocument doc = existing.get();
        doc.setTitle(title);
        doc.setDescription(description);
        doc.setDocumentDate(documentDate);
        doc.setDoctorName(doctorName);

        documentRepository.update(doc);

        if (newFiles != null && !newFiles.isEmpty()) {
            Path uploadPath = Paths.get(UPLOAD_DIR);
            StringBuilder newTextBuilder = new StringBuilder();
            String existingText = doc.getExtractedText();

            for (MultipartFile file : newFiles) {
                if (file != null && !file.isEmpty()) {
                    String originalFilename = file.getOriginalFilename();
                    String fileName = UUID.randomUUID().toString() + "_" + originalFilename;
                    Path filePath = uploadPath.resolve(fileName);
                    Files.copy(file.getInputStream(), filePath);

                    DocumentFile docFile = new DocumentFile();
                    docFile.setFileName(originalFilename);
                    docFile.setFilePath(fileName);
                    docFile.setFileSize(MedicalDocumentRepository.formatFileSize(file.getSize()));
                    documentRepository.addFile(id, docFile);

                    if (isImageFile(originalFilename) && ocrService.isConfigured()) {
                        try {
                            String text = ocrService.extractTextFromImage(filePath);
                            if (text != null && !text.isEmpty()) {
                                newTextBuilder.append("\n\n---\n\n");
                                newTextBuilder.append("Файл: ").append(originalFilename).append("\n");
                                newTextBuilder.append(text);
                            }
                        } catch (Throwable e) {
                            logger.warn("Failed to extract text from {}: {}", originalFilename, e.getMessage());
                        }
                    }
                }
            }

            String combinedText = existingText;
            if (newTextBuilder.length() > 0) {
                if (combinedText == null || combinedText.isEmpty()) {
                    combinedText = newTextBuilder.toString().trim();
                } else {
                    combinedText = combinedText + newTextBuilder.toString();
                }
                documentRepository.updateExtractedText(id, combinedText);
                doc.setExtractedText(combinedText);
            }
        }

        return documentRepository.findById(id).orElse(doc);
    }

    public void deleteDocumentFile(Long documentId, Long fileId, Long userId) throws IOException {
        Optional<MedicalDocument> doc = documentRepository.findByIdAndUserId(documentId, userId);
        if (doc.isEmpty()) return;

        Optional<DocumentFile> file = doc.get().getFiles().stream()
            .filter(f -> f.getId().equals(fileId))
            .findFirst();
        
        if (file.isPresent()) {
            Path filePath = Paths.get(UPLOAD_DIR + file.get().getFilePath());
            if (Files.exists(filePath)) {
                Files.delete(filePath);
            }
            documentRepository.deleteFile(fileId);
        }
    }

    public void deleteDocument(Long id, Long userId) {
        Optional<MedicalDocument> doc = documentRepository.findByIdAndUserId(id, userId);
        if (doc.isPresent()) {
            for (DocumentFile file : doc.get().getFiles()) {
                try {
                    Path filePath = Paths.get(UPLOAD_DIR + file.getFilePath());
                    if (Files.exists(filePath)) {
                        Files.delete(filePath);
                    }
                } catch (IOException e) {
                    // Log error but continue
                }
            }
            documentRepository.delete(id);
        }
    }

    public String getUploadDir() {
        return UPLOAD_DIR;
    }

    public void retryOcr(Long documentId, Long userId) {
        Optional<MedicalDocument> docOpt = documentRepository.findByIdAndUserId(documentId, userId);
        if (docOpt.isEmpty()) {
            return;
        }

        MedicalDocument doc = docOpt.get();
        documentRepository.updateOcrError(documentId, null);
        documentRepository.updateOcrStatus(documentId, null);
        
        StringBuilder extractedTextBuilder = new StringBuilder();

        for (DocumentFile file : doc.getFiles()) {
            Path filePath = Paths.get(UPLOAD_DIR + file.getFilePath());
            
            if (Files.exists(filePath) && isImageFile(file.getFileName())) {
                if (!ocrService.isConfigured()) {
                    documentRepository.updateOcrError(documentId, "OCR сервис не настроен. Обратитесь к администратору.");
                    return;
                }

                try {
                    String text = ocrService.extractTextFromImage(filePath);
                    if (text != null && !text.isEmpty()) {
                        if (extractedTextBuilder.length() > 0) {
                            extractedTextBuilder.append("\n\n---\n\n");
                        }
                        extractedTextBuilder.append("Файл: ").append(file.getFileName()).append("\n");
                        extractedTextBuilder.append(text);
                    }
                } catch (Throwable e) {
                    documentRepository.updateOcrError(documentId, parseOcrError(e.getMessage()));
                    return;
                }
            }
        }

        String extractedText = extractedTextBuilder.length() > 0 ? extractedTextBuilder.toString() : null;
        if (extractedText != null) {
            documentRepository.updateExtractedText(documentId, extractedText);
        }
    }

    private boolean isImageFile(String filename) {
        if (filename == null) return false;
        String lower = filename.toLowerCase();
        return lower.endsWith(".jpg") || lower.endsWith(".jpeg") || 
               lower.endsWith(".png") || lower.endsWith(".gif") || 
               lower.endsWith(".bmp") || lower.endsWith(".webp");
    }

    private String parseOcrError(String errorMsg) {
        if (errorMsg == null) {
            return "Произошла неизвестная ошибка при распознавании текста.";
        }
        
        if (errorMsg.contains("location is not supported") || errorMsg.contains("FAILED_PRECONDITION")) {
            return "Сервис распознавания недоступен в вашем регионе. Попробуйте использовать VPN.";
        }
        if (errorMsg.contains("not found") || errorMsg.contains("NOT_FOUND")) {
            return "Выбранная модель ИИ недоступна. Обратитесь к администратору.";
        }
        if (errorMsg.contains("image input") || errorMsg.contains("IMAGE_ERROR")) {
            return "Данный тип изображения не поддерживается. Попробуйте другой формат (JPG, PNG).";
        }
        if (errorMsg.contains("QUOTA_EXCEEDED") || errorMsg.contains("rate limit")) {
            return "Превышен лимит запросов. Попробуйте позже.";
        }
        if (errorMsg.contains("403") || errorMsg.contains("PERMISSION_DENIED") || errorMsg.contains("ACCESS_TOKEN_TYPE")) {
            return "Доступ к сервису запрещён. Проверьте API ключ.";
        }
        if (errorMsg.contains("400") || errorMsg.contains("INVALID_ARGUMENT")) {
            return "Неверный формат изображения. Убедитесь, что файл не повреждён.";
        }
        if (errorMsg.contains("500") || errorMsg.contains("INTERNAL_ERROR")) {
            return "Ошибка сервера ИИ. Попробуйте повторить позже.";
        }
        if (errorMsg.contains("socket") || errorMsg.contains("connection") || errorMsg.contains("timeout")) {
            return "Нет соединения с сервером. Проверьте интернет-соединение.";
        }
        
        return "Не удалось распознать текст из изображения. Попробуйте загрузить другое фото.";
    }
}
