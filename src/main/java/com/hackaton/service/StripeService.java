package com.hackaton.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class StripeService {
    private static final Logger logger = LoggerFactory.getLogger(StripeService.class);

    @Value("${stripe.api.key:}")
    private String stripeApiKey;

    @Value("${stripe.success.url:}")
    private String successUrl;

    @Value("${stripe.cancel.url:}")
    private String cancelUrl;

    private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper;

    public StripeService() {
        this.restTemplate = new RestTemplate();
        this.objectMapper = new ObjectMapper();
    }

    public String createCheckoutSession(Long userId, String userEmail) {
        if (stripeApiKey == null || stripeApiKey.isEmpty() || stripeApiKey.equals("sk_test_your_test_key_here")) {
            logger.warn("Stripe API key not configured");
            return null;
        }

        try {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.set("Authorization", "Bearer " + stripeApiKey);

            Map<String, Object> sessionRequest = new HashMap<>();
            sessionRequest.put("mode", "payment");
            sessionRequest.put("success_url", successUrl + "?session_id={CHECKOUT_SESSION_ID}&user_id=" + userId);
            sessionRequest.put("cancel_url", cancelUrl + "?user_id=" + userId);
            sessionRequest.put("customer_email", userEmail);
            sessionRequest.put("payment_method_types", new String[]{"card"});
            sessionRequest.put("billing_address_collection", "required");

            Map<String, Object> lineItem = new HashMap<>();
            Map<String, Object> priceData = new HashMap<>();
            priceData.put("currency", "usd");
            priceData.put("unit_amount", 999L);
            
            Map<String, Object> productData = new HashMap<>();
            productData.put("name", "Medical Archive Premium");
            productData.put("description", "Unlimited document storage with OCR");
            priceData.put("product_data", productData);
            
            lineItem.put("price_data", priceData);
            lineItem.put("quantity", 1);
            
            List<Map<String, Object>> lineItems = new ArrayList<>();
            lineItems.add(lineItem);
            sessionRequest.put("line_items", lineItems);

            Map<String, String> metadata = new HashMap<>();
            metadata.put("user_id", String.valueOf(userId));
            metadata.put("type", "premium_subscription");
            sessionRequest.put("metadata", metadata);

            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(sessionRequest, headers);
            
            ResponseEntity<String> response = restTemplate.exchange(
                "https://api.stripe.com/v1/checkout/sessions",
                HttpMethod.POST,
                entity,
                String.class
            );

            if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
                JsonNode json = objectMapper.readTree(response.getBody());
                String sessionId = json.get("id").asText();
                String url = json.get("url").asText();
                logger.info("Created Stripe checkout session: {} for user: {}", sessionId, userId);
                return url;
            }
        } catch (Exception e) {
            logger.error("Failed to create Stripe checkout session: {}", e.getMessage());
        }
        return null;
    }

    public boolean isConfigured() {
        return stripeApiKey != null && !stripeApiKey.isEmpty() && !stripeApiKey.equals("sk_test_your_test_key_here");
    }
}
