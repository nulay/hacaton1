package com.hackaton.controller;

import com.hackaton.service.OcrService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.support.StandardMultipartHttpServletRequest;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;

@RestController
@RequestMapping("/api/ocr")
public class OcrController {
    private static final Logger logger = LoggerFactory.getLogger(OcrController.class);
    private static final String TEMP_DIR = "D:/raznoe/project/hackaton/uploads/temp/";

    private final OcrService ocrService;

    public OcrController(OcrService ocrService) {
        this.ocrService = ocrService;
        
        try {
            Path uploadPath = Paths.get(TEMP_DIR).toAbsolutePath();
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
                logger.info("Created temp directory: {}", uploadPath);
            }
        } catch (Exception e) {
            logger.error("Failed to create temp directory", e);
        }
    }

    @PostMapping("/upload-and-recognize")
    public Map<String, Object> uploadAndRecognize(HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();
        List<Map<String, Object>> files = new ArrayList<>();
        String sessionId = UUID.randomUUID().toString();
        
        try {
            if (request instanceof StandardMultipartHttpServletRequest) {
                StandardMultipartHttpServletRequest multipartRequest = (StandardMultipartHttpServletRequest) request;
                Map<String, MultipartFile> fileMap = multipartRequest.getFileMap();
                
                for (Map.Entry<String, MultipartFile> entry : fileMap.entrySet()) {
                    MultipartFile file = entry.getValue();
                    if (file != null && !file.isEmpty()) {
                        String originalFilename = file.getOriginalFilename();
                        
                        String tempFileName = sessionId + "_" + UUID.randomUUID() + "_" + originalFilename;
                        Path filePath = Paths.get(TEMP_DIR + tempFileName);
                        Files.copy(file.getInputStream(), filePath);
                        
                        Map<String, Object> fileInfo = new HashMap<>();
                        fileInfo.put("tempPath", tempFileName);
                        fileInfo.put("originalName", originalFilename);
                        fileInfo.put("size", file.getSize());
                        fileInfo.put("index", files.size());
                        
                        String text = ocrService.extractTextFromImage(filePath);
                        fileInfo.put("recognizedText", text != null ? text : "");
                        fileInfo.put("textLength", text != null ? text.length() : 0);
                        
                        files.add(fileInfo);
                        logger.info("OCR processed: {} - {} chars", originalFilename, text != null ? text.length() : 0);
                    }
                }
            }
            
            result.put("success", true);
            result.put("sessionId", sessionId);
            result.put("files", files);
            
        } catch (Exception e) {
            logger.error("OCR upload failed", e);
            result.put("success", false);
            result.put("error", e.getMessage());
        }
        
        return result;
    }

    @PostMapping("/cancel")
    public Map<String, Object> cancel(@RequestBody Map<String, String> request) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            String sessionId = request.get("sessionId");
            if (sessionId != null) {
                File tempDir = new File(TEMP_DIR);
                File[] tempFiles = tempDir.listFiles((dir, name) -> name.startsWith(sessionId));
                
                if (tempFiles != null) {
                    for (File file : tempFiles) {
                        Files.deleteIfExists(file.toPath());
                        logger.info("Deleted temp file: {}", file.getName());
                    }
                }
            }
            
            result.put("success", true);
        } catch (Exception e) {
            logger.error("Cancel failed", e);
            result.put("success", false);
            result.put("error", e.getMessage());
        }
        
        return result;
    }

    @PostMapping("/save")
    public Map<String, Object> save(@RequestBody Map<String, Object> request) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            String sessionId = (String) request.get("sessionId");
            if (sessionId != null) {
                File tempDir = new File(TEMP_DIR);
                File[] tempFiles = tempDir.listFiles((dir, name) -> name.startsWith(sessionId));
                
                if (tempFiles != null) {
                    for (File file : tempFiles) {
                        logger.info("Keeping file for save: {}", file.getName());
                    }
                }
            }
            
            result.put("success", true);
            result.put("message", "Files saved successfully");
            
        } catch (Exception e) {
            logger.error("Save failed", e);
            result.put("success", false);
            result.put("error", e.getMessage());
        }
        
        return result;
    }

    @GetMapping("/get-temp-file/{tempPath}")
    public byte[] getTempFile(@PathVariable String tempPath) {
        try {
            Path filePath = Paths.get(TEMP_DIR + tempPath);
            if (Files.exists(filePath)) {
                return Files.readAllBytes(filePath);
            }
        } catch (Exception e) {
            logger.error("Failed to read temp file", e);
        }
        return null;
    }
}
