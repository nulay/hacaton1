package com.hackaton.model;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

public class User {
    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    
    private Long id;
    private String email;
    private String lastName;
    private String firstName;
    private String middleName;
    private String photoUrl;
    private LocalDate birthDate;
    private String passwordHash;
    private Role role;
    private boolean premium;
    private String stripeCustomerId;
    private LocalDate premiumUntil;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getMiddleName() {
        return middleName;
    }

    public void setMiddleName(String middleName) {
        this.middleName = middleName;
    }

    public String getPhotoUrl() {
        return photoUrl;
    }

    public void setPhotoUrl(String photoUrl) {
        this.photoUrl = photoUrl;
    }

    public LocalDate getBirthDate() {
        return birthDate;
    }

    public void setBirthDate(LocalDate birthDate) {
        this.birthDate = birthDate;
    }

    public String getBirthDateFormatted() {
        return birthDate != null ? birthDate.format(FORMATTER) : "";
    }

    public String getFullName() {
        StringBuilder sb = new StringBuilder();
        if (lastName != null && !lastName.isEmpty()) sb.append(lastName);
        if (firstName != null && !firstName.isEmpty()) {
            if (sb.length() > 0) sb.append(" ");
            sb.append(firstName);
        }
        if (middleName != null && !middleName.isEmpty()) {
            if (sb.length() > 0) sb.append(" ");
            sb.append(middleName);
        }
        return sb.toString();
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public boolean isPremium() {
        return premium;
    }

    public void setPremium(boolean premium) {
        this.premium = premium;
    }

    public String getStripeCustomerId() {
        return stripeCustomerId;
    }

    public void setStripeCustomerId(String stripeCustomerId) {
        this.stripeCustomerId = stripeCustomerId;
    }

    public LocalDate getPremiumUntil() {
        return premiumUntil;
    }

    public void setPremiumUntil(LocalDate premiumUntil) {
        this.premiumUntil = premiumUntil;
    }

    public boolean isPremiumActive() {
        if (!premium) return false;
        if (premiumUntil == null) return true;
        return premiumUntil.isAfter(LocalDate.now());
    }
}
