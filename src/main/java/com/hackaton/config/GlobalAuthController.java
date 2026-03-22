package com.hackaton.config;

import com.hackaton.model.User;
import com.hackaton.service.UserService;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

@ControllerAdvice
public class GlobalAuthController {

    private final UserService userService;

    public GlobalAuthController(UserService userService) {
        this.userService = userService;
    }

    @ModelAttribute("currentUser")
    public User getCurrentUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && !auth.getName().equals("anonymousUser")) {
            return userService.findByEmail(auth.getName()).orElse(null);
        }
        return null;
    }

    @ModelAttribute("isAuthenticated")
    public boolean isAuthenticated() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return auth != null && !auth.getName().equals("anonymousUser");
    }
}
