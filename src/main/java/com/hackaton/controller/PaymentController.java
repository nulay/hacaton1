package com.hackaton.controller;

import com.hackaton.model.User;
import com.hackaton.repository.UserRepository;
import com.hackaton.service.StripeService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.Optional;

@Controller
@RequestMapping("/payment")
public class PaymentController {

    private final StripeService stripeService;
    private final UserRepository userRepository;

    @Value("${stripe.publishable.key:}")
    private String stripePublishableKey;

    public PaymentController(StripeService stripeService, UserRepository userRepository) {
        this.stripeService = stripeService;
        this.userRepository = userRepository;
    }

    @GetMapping("/upgrade")
    public String upgradePage(Authentication authentication, HttpSession session, Model model) {
        String email = authentication.getName();
        
        Optional<User> userOpt = userRepository.findByEmail(email);
        if (userOpt.isEmpty()) {
            return "redirect:/auth/login";
        }

        User user = userOpt.get();
        if (user.isPremiumActive()) {
            return "redirect:/cabinet";
        }

        model.addAttribute("stripePublishableKey", stripePublishableKey);
        model.addAttribute("isStripeConfigured", stripeService.isConfigured());
        model.addAttribute("user", user);
        return "payment/upgrade";
    }

    @PostMapping("/create-checkout-session")
    public String createCheckoutSession(Authentication authentication, HttpSession session) {
        String email = authentication.getName();
        
        Optional<User> userOpt = userRepository.findByEmail(email);
        if (userOpt.isEmpty()) {
            return "redirect:/auth/login";
        }

        if (!stripeService.isConfigured()) {
            userRepository.setPremium(userOpt.get().getId(), true);
            return "redirect:/cabinet";
        }

        String checkoutUrl = stripeService.createCheckoutSession(userOpt.get().getId(), email);
        if (checkoutUrl != null) {
            return "redirect:" + checkoutUrl;
        }
        userRepository.setPremium(userOpt.get().getId(), true);
        return "redirect:/cabinet";
    }

    @GetMapping("/success")
    public String paymentSuccess(@RequestParam(required = false) Long user_id, Model model) {
        if (user_id != null) {
            userRepository.setPremium(user_id, true);
        }

        model.addAttribute("success", true);
        return "payment/success";
    }

    @GetMapping("/cancel")
    public String paymentCancel(Model model) {
        model.addAttribute("cancelled", true);
        return "payment/cancel";
    }
}
