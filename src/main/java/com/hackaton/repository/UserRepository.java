package com.hackaton.repository;

import com.hackaton.model.Role;
import com.hackaton.model.User;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.Date;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public class UserRepository {
    private final JdbcTemplate jdbcTemplate;

    private final RowMapper<User> mapper = (rs, rowNum) -> {
        User user = new User();
        user.setId(rs.getLong("id"));
        user.setEmail(rs.getString("email"));
        user.setLastName(rs.getString("last_name"));
        user.setFirstName(rs.getString("first_name"));
        user.setMiddleName(rs.getString("middle_name"));
        user.setPhotoUrl(rs.getString("photo_url"));
        Date birthDate = rs.getDate("birth_date");
        user.setBirthDate(birthDate != null ? birthDate.toLocalDate() : null);
        user.setPasswordHash(rs.getString("password_hash"));
        user.setRole(Role.valueOf(rs.getString("role")));
        user.setPremium(rs.getBoolean("premium"));
        user.setStripeCustomerId(rs.getString("stripe_customer_id"));
        Date premiumUntil = rs.getDate("premium_until");
        user.setPremiumUntil(premiumUntil != null ? premiumUntil.toLocalDate() : null);
        return user;
    };

    public UserRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public Optional<User> findByEmail(String email) {
        try {
            User user = jdbcTemplate.queryForObject(
                "SELECT id, email, last_name, first_name, middle_name, photo_url, birth_date, password_hash, role, premium, stripe_customer_id, premium_until FROM users WHERE email = ?",
                mapper,
                email
            );
            return Optional.ofNullable(user);
        } catch (EmptyResultDataAccessException ex) {
            return Optional.empty();
        }
    }

    public Optional<User> findById(Long id) {
        try {
            User user = jdbcTemplate.queryForObject(
                "SELECT id, email, last_name, first_name, middle_name, photo_url, birth_date, password_hash, role, premium, stripe_customer_id, premium_until FROM users WHERE id = ?",
                mapper,
                id
            );
            return Optional.ofNullable(user);
        } catch (EmptyResultDataAccessException ex) {
            return Optional.empty();
        }
    }

    public void create(User user) {
        jdbcTemplate.update(
            "INSERT INTO users (email, last_name, first_name, middle_name, photo_url, birth_date, password_hash, role) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
            user.getEmail(),
            user.getLastName(),
            user.getFirstName(),
            user.getMiddleName(),
            user.getPhotoUrl(),
            user.getBirthDate() != null ? Date.valueOf(user.getBirthDate()) : null,
            user.getPasswordHash(),
            user.getRole().name()
        );
    }

    public void update(User user) {
        jdbcTemplate.update(
            "UPDATE users SET last_name = ?, first_name = ?, middle_name = ?, photo_url = ?, birth_date = ? WHERE email = ?",
            user.getLastName(),
            user.getFirstName(),
            user.getMiddleName(),
            user.getPhotoUrl(),
            user.getBirthDate() != null ? Date.valueOf(user.getBirthDate()) : null,
            user.getEmail()
        );
    }

    public void updateById(User user) {
        jdbcTemplate.update(
            "UPDATE users SET last_name = ?, first_name = ?, middle_name = ?, photo_url = ?, birth_date = ?, role = ? WHERE id = ?",
            user.getLastName(),
            user.getFirstName(),
            user.getMiddleName(),
            user.getPhotoUrl(),
            user.getBirthDate() != null ? Date.valueOf(user.getBirthDate()) : null,
            user.getRole().name(),
            user.getId()
        );
    }

    public void updatePremiumStatus(Long userId, boolean premium, LocalDate premiumUntil, String stripeCustomerId) {
        jdbcTemplate.update(
            "UPDATE users SET premium = ?, premium_until = ?, stripe_customer_id = ? WHERE id = ?",
            premium,
            premiumUntil != null ? Date.valueOf(premiumUntil) : null,
            stripeCustomerId,
            userId
        );
    }

    public void setPremium(Long userId, boolean premium) {
        jdbcTemplate.update(
            "UPDATE users SET premium = ? WHERE id = ?",
            premium,
            userId
        );
    }

    public List<User> findAll() {
        return jdbcTemplate.query(
            "SELECT id, email, last_name, first_name, middle_name, photo_url, birth_date, password_hash, role, premium, stripe_customer_id, premium_until FROM users ORDER BY id DESC",
            mapper
        );
    }

    public long countAll() {
        Long count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM users", Long.class);
        return count != null ? count : 0;
    }

    public long countPremium() {
        Long count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM users WHERE premium = true", Long.class);
        return count != null ? count : 0;
    }

    public long countByRole(Role role) {
        Long count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM users WHERE role = ?", Long.class, role.name());
        return count != null ? count : 0;
    }
}
