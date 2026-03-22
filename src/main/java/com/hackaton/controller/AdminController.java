package com.hackaton.controller;

import com.hackaton.model.Role;
import com.hackaton.model.User;
import com.hackaton.repository.UserRepository;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Map;

@Controller
public class AdminController {

    private final UserRepository userRepository;

    public AdminController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @GetMapping("/admin")
    public String adminPanel(Authentication authentication, Model model) {
        List<User> users = userRepository.findAll();
        
        long totalUsers = userRepository.countAll();
        long premiumUsers = userRepository.countPremium();
        long freeUsers = totalUsers - premiumUsers;
        long doctors = userRepository.countByRole(Role.DOCTOR);
        long patients = userRepository.countByRole(Role.USER);
        long admins = userRepository.countByRole(Role.ADMIN);

        model.addAttribute("users", users);
        model.addAttribute("totalUsers", totalUsers);
        model.addAttribute("premiumUsers", premiumUsers);
        model.addAttribute("freeUsers", freeUsers);
        model.addAttribute("doctors", doctors);
        model.addAttribute("patients", patients);
        model.addAttribute("admins", admins);
        model.addAttribute("revenue", premiumUsers * 9.99);
        double conversionRate = totalUsers > 0 ? (premiumUsers * 100.0 / totalUsers) : 0;
        model.addAttribute("conversionRate", String.format("%.1f", conversionRate));

        return "admin";
    }

    @PostMapping("/admin/user/toggle-premium")
    public String togglePremium(@RequestParam Long userId, Authentication authentication) {
        User user = userRepository.findById(userId).orElse(null);
        if (user != null) {
            userRepository.setPremium(userId, !user.isPremium());
        }
        return "redirect:/admin";
    }

    @PostMapping("/admin/user/change-role")
    public String changeRole(@RequestParam Long userId, @RequestParam String role, Authentication authentication) {
        try {
            Role newRole = Role.valueOf(role.toUpperCase());
            User user = userRepository.findById(userId).orElse(null);
            if (user != null) {
                user.setRole(newRole);
                userRepository.update(user);
            }
        } catch (IllegalArgumentException e) {
            // Invalid role
        }
        return "redirect:/admin";
    }
}
