package com.hackaton.controller;

import com.hackaton.model.Role;
import com.hackaton.model.User;
import com.hackaton.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.Optional;

@Controller
@RequestMapping("/telegram")
public class TelegramController {
    
    private final UserService userService;

    public TelegramController(UserService userService) {
        this.userService = userService;
    }

    @PostMapping("/login")
    public String telegramLogin(
            @RequestParam String id,
            @RequestParam String first_name,
            @RequestParam(required = false) String last_name,
            @RequestParam(required = false) String username,
            @RequestParam(required = false) String photo_url,
            HttpSession session
    ) {
        String email = id + "@telegram.user";
        Optional<User> existingUser = userService.findByEmail(email);
        
        if (existingUser.isEmpty()) {
            String fullName = (last_name != null ? last_name + " " : "") + first_name;
            String[] names = fullName.trim().split(" ", 2);
            String lastName = names.length > 1 ? names[0] : "";
            String firstName = names.length > 1 ? names[1] : names[0];
            
            userService.createUser(email, "telegram", lastName, firstName, "", Role.USER);
        }
        
        session.setAttribute("userEmail", email);
        session.setAttribute("telegramUserId", id);
        
        return "redirect:/cabinet";
    }

    @GetMapping("/tma")
    public String telegramMiniApp(Model model) {
        model.addAttribute("isTelegram", true);
        return "telegram/tma";
    }
}
