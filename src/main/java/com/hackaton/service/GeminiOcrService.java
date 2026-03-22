package com.hackaton.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.*;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Base64;

@Service
public class GeminiOcrService {
    private static final Logger logger = LoggerFactory.getLogger(GeminiOcrService.class);

    @Value("${gemini.api.key:}")
    private String apiKey;

    @Value("${gemini.api.url:https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent}")
    private String apiUrl;

    private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper;

    public GeminiOcrService() {
        this.restTemplate = new RestTemplate();
        this.objectMapper = new ObjectMapper();
    }

    public String extractTextFromImage(Path imagePath) {
        logger.debug("API Key present: {}", apiKey != null && !apiKey.isEmpty());
        logger.debug("API URL: {}", apiUrl);
        
        if (apiKey == null || apiKey.isEmpty()) {
            logger.warn("Gemini API key not configured. Skipping OCR.");
            return null;
        }

        try {
            String base64Image = encodeImageToBase64(imagePath);
            String fileName = imagePath.getFileName().toString();
            logger.debug("Image encoded ({}), calling Gemini API...", fileName);
            String extractedText = callGeminiApi(base64Image, fileName);
            logger.info("Successfully extracted text from image: {}", fileName);
            return extractedText;
        } catch (Exception e) {
            logger.error("Failed to extract text from image: {}", imagePath, e);
            return null;
        }
    }

    private String encodeImageToBase64(Path imagePath) throws IOException {
        byte[] imageBytes = Files.readAllBytes(imagePath);
        return Base64.getEncoder().encodeToString(imageBytes);
    }

    private String callGeminiApi(String base64Image, String fileName) throws IOException {
        String fullUrl = apiUrl + "?key=" + apiKey;

        String mimeType = "image/jpeg";
        if (fileName != null) {
            String lower = fileName.toLowerCase();
            if (lower.endsWith(".png")) {
                mimeType = "image/png";
            } else if (lower.endsWith(".jpg") || lower.endsWith(".jpeg")) {
                mimeType = "image/jpeg";
            } else if (lower.endsWith(".webp")) {
                mimeType = "image/webp";
            } else if (lower.endsWith(".gif")) {
                mimeType = "image/gif";
            }
        }
        
        String prompt = """
            Извлеки весь текст из этого медицинского документа. Верни ТОЛЬКО текст без дополнительных пояснений и комментариев. Если на изображении нет текста, верни пустую строку.
            Документ может содержать: анализы крови, рецепты, справки, заключения врачей, результаты УЗИ, ЭКГ и другие медицинские документы.
            """;

        String jsonRequest = """
            {
                "contents": [{
                    "parts": [
                        {
                            "text": "%s"
                        },
                        {
                            "inline_data": {
                                "mime_type": "%s",
                                "data": "%s"
                            }
                        }
                    ]
                }],
                "generationConfig": {
                    "temperature": 0.1,
                    "maxOutputTokens": 8192
                }
            }
            """.formatted(prompt, mimeType, base64Image);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<String> entity = new HttpEntity<>(jsonRequest, headers);

        ResponseEntity<String> response = restTemplate.exchange(
            fullUrl,
            HttpMethod.POST,
            entity,
            String.class
        );

        if (response.getStatusCode().is2xxSuccessful()) {
            return parseGeminiResponse(response.getBody());
        } else {
            logger.error("Gemini API error: {}", response.getStatusCode());
            logger.error("Response body: {}", response.getBody());
            return null;
        }
    }

    private String parseGeminiResponse(String responseBody) {
        try {
            JsonNode root = objectMapper.readTree(responseBody);
            JsonNode candidates = root.path("candidates");
            
            if (candidates.isArray() && !candidates.isEmpty()) {
                JsonNode content = candidates.get(0).path("content");
                JsonNode parts = content.path("parts");
                
                if (parts.isArray() && !parts.isEmpty()) {
                    return parts.get(0).path("text").asText("");
                }
            }
            
            return "";
        } catch (Exception e) {
            logger.error("Failed to parse Gemini response", e);
            return null;
        }
    }

    public boolean isConfigured() {
        return apiKey != null && !apiKey.isEmpty();
    }
}
