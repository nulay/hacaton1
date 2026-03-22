package com.hackaton.repository;

import com.hackaton.model.DoctorProfile;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Repository
public class DoctorProfileRepository {
    private final JdbcTemplate jdbcTemplate;

    public DoctorProfileRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public void upsertProfile(Long userId, String photoUrl, String specialization) {
        jdbcTemplate.update(
            "INSERT INTO doctor_profiles (user_id, photo_url, specialization, updated_at) " +
                "VALUES (?, ?, ?, NOW()) " +
                "ON CONFLICT (user_id) DO UPDATE SET photo_url = EXCLUDED.photo_url, " +
                "specialization = EXCLUDED.specialization, updated_at = NOW()",
            userId,
            photoUrl,
            specialization
        );
    }

    public void addDiploma(Long userId, String title) {
        jdbcTemplate.update(
            "INSERT INTO doctor_diplomas (doctor_user_id, title) VALUES (?, ?)",
            userId,
            title
        );
    }

    public List<DoctorProfile> findAllDoctors() {
        return jdbcTemplate.query(
            "SELECT u.id, u.last_name, u.first_name, u.middle_name, dp.photo_url, dp.specialization " +
                "FROM users u " +
                "LEFT JOIN doctor_profiles dp ON dp.user_id = u.id " +
                "WHERE u.role = 'DOCTOR' " +
                "ORDER BY u.last_name ASC, u.first_name ASC",
            (rs, rowNum) -> {
                DoctorProfile profile = new DoctorProfile();
                profile.setUserId(rs.getLong("id"));
                profile.setLastName(rs.getString("last_name"));
                profile.setFirstName(rs.getString("first_name"));
                profile.setMiddleName(rs.getString("middle_name"));
                profile.setPhotoUrl(rs.getString("photo_url"));
                profile.setSpecialization(rs.getString("specialization"));
                profile.setDiplomas(new ArrayList<>());
                return profile;
            }
        );
    }

    public Optional<DoctorProfile> findDoctorById(Long doctorUserId) {
        try {
            DoctorProfile profile = jdbcTemplate.queryForObject(
                "SELECT u.id, u.last_name, u.first_name, u.middle_name, dp.photo_url, dp.specialization " +
                    "FROM users u " +
                    "LEFT JOIN doctor_profiles dp ON dp.user_id = u.id " +
                    "WHERE u.id = ? AND u.role = 'DOCTOR'",
                (rs, rowNum) -> {
                    DoctorProfile p = new DoctorProfile();
                    p.setUserId(rs.getLong("id"));
                    p.setLastName(rs.getString("last_name"));
                    p.setFirstName(rs.getString("first_name"));
                    p.setMiddleName(rs.getString("middle_name"));
                    p.setPhotoUrl(rs.getString("photo_url"));
                    p.setSpecialization(rs.getString("specialization"));
                    return p;
                },
                doctorUserId
            );
            profile.setDiplomas(findDiplomasByDoctorId(doctorUserId));
            return Optional.of(profile);
        } catch (EmptyResultDataAccessException ex) {
            return Optional.empty();
        }
    }

    public List<String> findDiplomasByDoctorId(Long doctorUserId) {
        return jdbcTemplate.query(
            "SELECT title FROM doctor_diplomas WHERE doctor_user_id = ? ORDER BY created_at DESC",
            (rs, rowNum) -> rs.getString("title"),
            doctorUserId
        );
    }
}
