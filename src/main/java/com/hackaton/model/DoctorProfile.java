package com.hackaton.model;

import java.util.ArrayList;
import java.util.List;

public class DoctorProfile {
    private Long userId;
    private String lastName;
    private String firstName;
    private String middleName;
    private String photoUrl;
    private String specialization;
    private List<String> diplomas = new ArrayList<>();

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
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

    public String getPhotoUrl() {
        return photoUrl;
    }

    public void setPhotoUrl(String photoUrl) {
        this.photoUrl = photoUrl;
    }

    public String getSpecialization() {
        return specialization;
    }

    public void setSpecialization(String specialization) {
        this.specialization = specialization;
    }

    public List<String> getDiplomas() {
        return diplomas;
    }

    public void setDiplomas(List<String> diplomas) {
        this.diplomas = diplomas;
    }
}
