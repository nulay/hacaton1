package com.hackaton.controller;

import com.hackaton.model.DoctorProfile;
import com.hackaton.service.DoctorProfileService;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class DoctorController {
    private final DoctorProfileService doctorProfileService;

    public DoctorController(DoctorProfileService doctorProfileService) {
        this.doctorProfileService = doctorProfileService;
    }

    @GetMapping("/doctor/dashboard")
    public String dashboard(Authentication authentication, Model model) {
        DoctorProfile profile = doctorProfileService
            .findCurrentDoctorProfile(authentication.getName())
            .orElseGet(DoctorProfile::new);
        model.addAttribute("profile", profile);
        return "doctor-dashboard";
    }

    @PostMapping("/doctor/profile")
    public String updateProfile(
        Authentication authentication,
        @RequestParam(required = false, defaultValue = "") String photoUrl,
        @RequestParam(required = false, defaultValue = "") String specialization
    ) {
        doctorProfileService.updateCurrentDoctorProfile(authentication.getName(), photoUrl, specialization);
        return "redirect:/doctor/dashboard";
    }

    @PostMapping("/doctor/profile/diplomas")
    public String addDiploma(
        Authentication authentication,
        @RequestParam String title
    ) {
        String normalized = title == null ? "" : title.trim();
        if (!normalized.isEmpty()) {
            doctorProfileService.addDiplomaToCurrentDoctor(authentication.getName(), normalized);
        }
        return "redirect:/doctor/dashboard";
    }
}
