package com.hackaton.controller;

import com.hackaton.model.Role;
import com.hackaton.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class AuthController {
    private final UserService userService;

    public AuthController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/auth/login")
    public String login() {
        return "login";
    }

    @GetMapping("/auth/register")
    public String registerPage() {
        return "register";
    }

    @GetMapping("/logout")
    public String logout() {
        return "logout";
    }

    @PostMapping("/auth/register")
    public String register(
        @RequestParam String email,
        @RequestParam String lastName,
        @RequestParam String firstName,
        @RequestParam(required = false, defaultValue = "") String middleName,
        @RequestParam String password,
        @RequestParam String role,
        Model model
    ) {
        Role selectedRole;
        try {
            selectedRole = Role.valueOf(role.toUpperCase());
        } catch (IllegalArgumentException ex) {
            model.addAttribute("error", "Unknown role");
            return "register";
        }

        boolean created = userService.register(email, lastName, firstName, middleName, password, selectedRole);
        if (!created) {
            model.addAttribute("error", "Email already exists");
            return "register";
        }

        return "redirect:/auth/login?registered=true";
    }
}
