package com.hackaton.service;

import com.hackaton.model.Role;
import com.hackaton.model.User;
import com.hackaton.repository.UserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.Optional;

@Service
public class UserService {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public UserService(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    public boolean createUser(String email, String lastName, String firstName, String middleName, String photoUrl, Role role) {
        if (userRepository.findByEmail(email).isPresent()) {
            return false;
        }

        User user = new User();
        user.setEmail(email);
        user.setLastName(lastName);
        user.setFirstName(firstName);
        user.setMiddleName(middleName);
        user.setPhotoUrl(photoUrl);
        user.setRole(role);
        user.setPasswordHash("");
        userRepository.create(user);
        return true;
    }

    public boolean register(String email, String lastName, String firstName, String middleName, String rawPassword, Role role) {
        if (userRepository.findByEmail(email).isPresent()) {
            return false;
        }

        User user = new User();
        user.setEmail(email);
        user.setLastName(lastName);
        user.setFirstName(firstName);
        user.setMiddleName(middleName);
        user.setPasswordHash(passwordEncoder.encode(rawPassword));
        user.setRole(role);
        userRepository.create(user);
        return true;
    }

    public void updateProfile(String email, String lastName, String firstName, String middleName, String photoUrl, LocalDate birthDate) {
        User user = userRepository.findByEmail(email).orElseThrow(() -> new RuntimeException("User not found"));
        user.setLastName(lastName);
        user.setFirstName(firstName);
        user.setMiddleName(middleName);
        user.setPhotoUrl(photoUrl);
        user.setBirthDate(birthDate);
        userRepository.update(user);
    }
}
