package com.hackaton.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

@Service
public class OcrService {
    private static final Logger logger = LoggerFactory.getLogger(OcrService.class);

    @Value("${ocr.provider:ocrspace}")
    private String provider;

    @Value("${ocr.api.key:helloworld}")
    private String ocrSpaceApiKey;

    @Value("${gemini.api.key:}")
    private String geminiApiKey;

    @Value("${gemini.api.url:}")
    private String geminiApiUrl;

    private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper;

    public OcrService() {
        this.restTemplate = new RestTemplate();
        this.objectMapper = new ObjectMapper();
    }

    public String extractTextFromImage(Path imagePath) {
        try {
            byte[] imageBytes = Files.readAllBytes(imagePath);
            String base64Image = Base64.getEncoder().encodeToString(imageBytes);
            String fileName = imagePath.getFileName().toString();
            
            logger.info("Starting OCR for: {} using provider: {}", fileName, provider);
            
            String result = switch (provider) {
                case "gemini" -> callGeminiApi(base64Image, fileName);
                default -> callOcrSpaceApi(base64Image, fileName);
            };
            
            if (result != null && !result.isEmpty()) {
                logger.info("OCR completed for: {} - extracted {} chars", fileName, result.length());
            } else {
                logger.warn("OCR returned empty text for: {}", fileName);
            }
            
            return result;
        } catch (Exception e) {
            logger.error("OCR failed: {}", e.getMessage());
            return null;
        }
    }

    private String callOcrSpaceApi(String base64Image, String fileName) throws IOException {
        String url = "https://api.ocr.space/parse/image";
        
        String mimeType = "image/jpeg";
        if (fileName != null) {
            String lower = fileName.toLowerCase();
            if (lower.endsWith(".png")) mimeType = "image/png";
            else if (lower.endsWith(".gif")) mimeType = "image/gif";
            else if (lower.endsWith(".pdf")) mimeType = "application/pdf";
        }

        String body = "base64Image=data:" + mimeType + ";base64," + base64Image +
                "&language=eng%2Crus&isOverlayRequired=false&detectOrientation=true&scale=true&OCREngine=2&filetype=" + 
                getFileType(fileName);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        headers.set("apikey", ocrSpaceApiKey);

        HttpEntity<String> entity = new HttpEntity<>(body, headers);

        try {
            ResponseEntity<String> response = restTemplate.exchange(
                url, HttpMethod.POST, entity, String.class
            );

            if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
                return parseOcrSpaceResponse(response.getBody());
            }
        } catch (Exception e) {
            logger.error("OCR.space API call failed: {}", e.getMessage());
        }

        return null;
    }

    private String parseOcrSpaceResponse(String responseBody) {
        try {
            JsonNode root = objectMapper.readTree(responseBody);
            
            JsonNode errorNode = root.path("ErrorMessage");
            if (!errorNode.isMissingNode() && !errorNode.asText().isEmpty()) {
                logger.error("OCR.space error: {}", errorNode.asText());
                return null;
            }

            JsonNode parsedResults = root.path("ParsedResults");
            if (parsedResults.isArray() && !parsedResults.isEmpty()) {
                StringBuilder text = new StringBuilder();
                for (JsonNode result : parsedResults) {
                    JsonNode textNode = result.path("ParsedText");
                    if (!textNode.isMissingNode()) {
                        text.append(textNode.asText()).append("\n\n");
                    }
                }
                return text.toString().trim();
            }
            return "";
        } catch (Exception e) {
            logger.error("Failed to parse OCR.space response: {}", e.getMessage());
            return null;
        }
    }

    private String callGeminiApi(String base64Image, String fileName) throws IOException {
        if (geminiApiKey == null || geminiApiKey.isEmpty() || geminiApiUrl == null || geminiApiUrl.isEmpty()) {
            logger.warn("Gemini API not configured");
            return null;
        }

        String mimeType = "image/jpeg";
        if (fileName != null) {
            String lower = fileName.toLowerCase();
            if (lower.endsWith(".png")) mimeType = "image/png";
            else if (lower.endsWith(".webp")) mimeType = "image/webp";
        }

        String fullUrl = geminiApiUrl + "?key=" + geminiApiKey;

        String prompt = """
            Извлеки весь текст из этого медицинского документа. Верни ТОЛЬКО текст без дополнительных пояснений.
            """;

        String jsonRequest = """
            {
                "contents": [{
                    "parts": [
                        {"text": "%s"},
                        {"inline_data": {"mime_type": "%s", "data": "%s"}}
                    ]
                }],
                "generationConfig": {"temperature": 0.1, "maxOutputTokens": 8192}
            }
            """.formatted(prompt, mimeType, base64Image);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<String> entity = new HttpEntity<>(jsonRequest, headers);

        try {
            ResponseEntity<String> response = restTemplate.exchange(
                fullUrl, HttpMethod.POST, entity, String.class
            );

            if (response.getStatusCode().is2xxSuccessful()) {
                return parseGeminiResponse(response.getBody());
            }
        } catch (Exception e) {
            logger.error("Gemini API call failed: {}", e.getMessage());
        }
        return null;
    }

    private String parseGeminiResponse(String responseBody) {
        try {
            JsonNode root = objectMapper.readTree(responseBody);
            JsonNode candidates = root.path("candidates");
            if (candidates.isArray() && !candidates.isEmpty()) {
                JsonNode parts = candidates.get(0).path("content").path("parts");
                if (parts.isArray() && !parts.isEmpty()) {
                    return parts.get(0).path("text").asText("");
                }
            }
            return "";
        } catch (Exception e) {
            logger.error("Failed to parse Gemini response: {}", e.getMessage());
            return null;
        }
    }

    private String getFileType(String fileName) {
        if (fileName == null) return "JPG";
        String lower = fileName.toLowerCase();
        if (lower.endsWith(".png")) return "PNG";
        if (lower.endsWith(".gif")) return "GIF";
        if (lower.endsWith(".pdf")) return "PDF";
        return "JPG";
    }

    public boolean isConfigured() {
        return true;
    }

    public String getProvider() {
        return provider;
    }
}
