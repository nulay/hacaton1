package com.hackaton.controller;

import com.hackaton.model.DoctorProfile;
import com.hackaton.model.User;
import com.hackaton.service.DoctorProfileService;
import com.hackaton.service.UserService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@Controller
public class CabinetController {
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    private final DoctorProfileService doctorProfileService;
    private final UserService userService;

    @Value("${freemium.document.limit:5}")
    private int freemiumLimit;

    public CabinetController(DoctorProfileService doctorProfileService, UserService userService) {
        this.doctorProfileService = doctorProfileService;
        this.userService = userService;
    }

    @GetMapping("/cabinet")
    public String cabinet(Authentication authentication, Model model) {
        String email = authentication.getName();
        User user = userService.findByEmail(email).orElse(null);
        model.addAttribute("email", email);
        model.addAttribute("lastName", user != null ? user.getLastName() : "");
        model.addAttribute("firstName", user != null ? user.getFirstName() : "");
        model.addAttribute("middleName", user != null ? user.getMiddleName() : "");
        model.addAttribute("photoUrl", user != null ? user.getPhotoUrl() : "");
        model.addAttribute("birthDate", user != null && user.getBirthDate() != null ? user.getBirthDate().format(DATE_FORMATTER) : "");
        model.addAttribute("authorities", authentication.getAuthorities());
        model.addAttribute("isPremium", user != null && user.isPremiumActive());
        model.addAttribute("freemiumLimit", freemiumLimit);
        return "cabinet";
    }

    @GetMapping("/cabinet/profile")
    public String profile(Authentication authentication, Model model) {
        String email = authentication.getName();
        User user = userService.findByEmail(email).orElse(null);
        model.addAttribute("email", email);
        model.addAttribute("lastName", user != null ? user.getLastName() : "");
        model.addAttribute("firstName", user != null ? user.getFirstName() : "");
        model.addAttribute("middleName", user != null ? user.getMiddleName() : "");
        model.addAttribute("photoUrl", user != null ? user.getPhotoUrl() : "");
        model.addAttribute("birthDate", user != null && user.getBirthDate() != null ? user.getBirthDate().format(DATE_FORMATTER) : "");
        model.addAttribute("authorities", authentication.getAuthorities());
        model.addAttribute("isPremium", user != null && user.isPremiumActive());
        model.addAttribute("freemiumLimit", freemiumLimit);
        return "profile";
    }

    @GetMapping("/cabinet/profile/edit")
    public String editProfile(Authentication authentication, Model model) {
        String email = authentication.getName();
        User user = userService.findByEmail(email).orElse(null);
        model.addAttribute("email", email);
        model.addAttribute("lastName", user != null ? user.getLastName() : "");
        model.addAttribute("firstName", user != null ? user.getFirstName() : "");
        model.addAttribute("middleName", user != null ? user.getMiddleName() : "");
        model.addAttribute("photoUrl", user != null ? user.getPhotoUrl() : "");
        model.addAttribute("birthDate", user != null && user.getBirthDate() != null ? user.getBirthDate().format(DATE_FORMATTER) : "");
        return "profile-edit";
    }

    @PostMapping("/cabinet/profile/edit")
    public String updateProfile(
            Authentication authentication,
            @RequestParam String lastName,
            @RequestParam String firstName,
            @RequestParam(required = false, defaultValue = "") String middleName,
            @RequestParam(required = false, defaultValue = "") String photoUrl,
            @RequestParam(required = false, defaultValue = "") String birthDate
    ) {
        String email = authentication.getName();
        LocalDate birthDateLocal = birthDate.isEmpty() ? null : LocalDate.parse(birthDate, DATE_FORMATTER);
        userService.updateProfile(email, lastName, firstName, middleName, photoUrl, birthDateLocal);
        return "redirect:/cabinet?updated=true";
    }

    @GetMapping("/cabinet/doctors")
    public String doctors(Model model) {
        model.addAttribute("doctors", doctorProfileService.findAllDoctors());
        return "doctors";
    }

    @GetMapping("/cabinet/doctors/{id}")
    public String doctorDetails(@PathVariable Long id, Model model) {
        DoctorProfile doctor = doctorProfileService.findDoctorById(id).orElse(null);
        if (doctor == null) {
            return "redirect:/cabinet/doctors";
        }
        model.addAttribute("doctor", doctor);
        return "doctor-view";
    }
}
