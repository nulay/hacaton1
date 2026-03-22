package com.hackaton.service;

import com.hackaton.model.DoctorProfile;
import com.hackaton.model.User;
import com.hackaton.repository.DoctorProfileRepository;
import com.hackaton.repository.UserRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class DoctorProfileService {
    private final DoctorProfileRepository doctorProfileRepository;
    private final UserRepository userRepository;

    public DoctorProfileService(DoctorProfileRepository doctorProfileRepository, UserRepository userRepository) {
        this.doctorProfileRepository = doctorProfileRepository;
        this.userRepository = userRepository;
    }

    public Optional<DoctorProfile> findCurrentDoctorProfile(String email) {
        Optional<User> user = userRepository.findByEmail(email);
        if (user.isEmpty()) {
            return Optional.empty();
        }
        return doctorProfileRepository.findDoctorById(user.get().getId());
    }

    public boolean updateCurrentDoctorProfile(String email, String photoUrl, String specialization) {
        Optional<User> user = userRepository.findByEmail(email);
        if (user.isEmpty()) {
            return false;
        }
        doctorProfileRepository.upsertProfile(user.get().getId(), photoUrl, specialization);
        return true;
    }

    public boolean addDiplomaToCurrentDoctor(String email, String diplomaTitle) {
        Optional<User> user = userRepository.findByEmail(email);
        if (user.isEmpty()) {
            return false;
        }
        doctorProfileRepository.addDiploma(user.get().getId(), diplomaTitle);
        return true;
    }

    public List<DoctorProfile> findAllDoctors() {
        return doctorProfileRepository.findAllDoctors();
    }

    public Optional<DoctorProfile> findDoctorById(Long id) {
        return doctorProfileRepository.findDoctorById(id);
    }
}
