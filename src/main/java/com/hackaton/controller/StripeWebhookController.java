package com.hackaton.controller;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.hackaton.model.User;
import com.hackaton.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/webhook/stripe")
public class StripeWebhookController {
    private static final Logger logger = LoggerFactory.getLogger(StripeWebhookController.class);

    private final UserRepository userRepository;
    private final ObjectMapper objectMapper;

    @Value("${stripe.webhook.secret:}")
    private String webhookSecret;

    public StripeWebhookController(UserRepository userRepository) {
        this.userRepository = userRepository;
        this.objectMapper = new ObjectMapper();
    }

    @PostMapping
    public ResponseEntity<String> handleStripeWebhook(@RequestBody String payload) {
        if (webhookSecret == null || webhookSecret.isEmpty() || webhookSecret.equals("whsec_your_webhook_secret_here")) {
            logger.warn("Stripe webhook secret not configured");
            return ResponseEntity.ok("Webhook secret not configured");
        }

        try {
            JsonNode event = objectMapper.readTree(payload);
            String eventType = event.get("type").asText();
            JsonNode data = event.get("data").get("object");

            logger.info("Received Stripe webhook: {}", eventType);

            switch (eventType) {
                case "checkout.session.completed":
                    handleCheckoutSessionCompleted(data);
                    break;
                case "customer.subscription.deleted":
                    handleSubscriptionDeleted(data);
                    break;
                case "customer.subscription.updated":
                    handleSubscriptionUpdated(data);
                    break;
                default:
                    logger.info("Unhandled event type: {}", eventType);
            }
        } catch (Exception e) {
            logger.error("Error processing webhook: {}", e.getMessage());
            return ResponseEntity.badRequest().body("Error processing webhook");
        }

        return ResponseEntity.ok("Received");
    }

    private void handleCheckoutSessionCompleted(JsonNode data) {
        try {
            String customerId = data.has("customer") ? data.get("customer").asText() : null;
            JsonNode metadata = data.get("metadata");
            String userIdStr = metadata != null && metadata.has("user_id") ? metadata.get("user_id").asText() : null;
            
            if (customerId != null && userIdStr != null) {
                Long userId = Long.parseLong(userIdStr);
                userRepository.updatePremiumStatus(userId, true, null, customerId);
                logger.info("Activated premium for user: {}", userId);
            }
        } catch (Exception e) {
            logger.error("Error handling checkout.session.completed: {}", e.getMessage());
        }
    }

    private void handleSubscriptionDeleted(JsonNode data) {
        try {
            String customerId = data.has("customer") ? data.get("customer").asText() : null;
            
            if (customerId != null) {
                List<User> users = userRepository.findAll();
                for (User user : users) {
                    if (customerId.equals(user.getStripeCustomerId())) {
                        userRepository.setPremium(user.getId(), false);
                        logger.info("Deactivated premium for user: {}", user.getId());
                        break;
                    }
                }
            }
        } catch (Exception e) {
            logger.error("Error handling customer.subscription.deleted: {}", e.getMessage());
        }
    }

    private void handleSubscriptionUpdated(JsonNode data) {
        try {
            String customerId = data.has("customer") ? data.get("customer").asText() : null;
            String status = data.has("status") ? data.get("status").asText() : null;
            
            if (customerId != null) {
                List<User> users = userRepository.findAll();
                for (User user : users) {
                    if (customerId.equals(user.getStripeCustomerId())) {
                        if ("canceled".equals(status)) {
                            userRepository.setPremium(user.getId(), false);
                            logger.info("Deactivated premium for user: {} (subscription canceled)", user.getId());
                        } else if ("active".equals(status)) {
                            LocalDate periodEnd = LocalDate.now().plusMonths(1);
                            userRepository.updatePremiumStatus(user.getId(), true, periodEnd, customerId);
                            logger.info("Updated premium for user: {} (period until {})", user.getId(), periodEnd);
                        }
                        break;
                    }
                }
            }
        } catch (Exception e) {
            logger.error("Error handling customer.subscription.updated: {}", e.getMessage());
        }
    }
}
