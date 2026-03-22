package com.hackaton.config;

import com.hackaton.security.CustomUserDetailsService;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.web.filter.CharacterEncodingFilter;

@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    private final CustomUserDetailsService userDetailsService;

    public SecurityConfig(CustomUserDetailsService userDetailsService) {
        this.userDetailsService = userDetailsService;
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public CharacterEncodingFilter characterEncodingFilter() {
        CharacterEncodingFilter filter = new CharacterEncodingFilter();
        filter.setEncoding("UTF-8");
        filter.setForceEncoding(true);
        return filter;
    }

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(userDetailsService).passwordEncoder(passwordEncoder());
    }

    @Override
    public void configure(WebSecurity web) {
        web.ignoring().antMatchers("/static/**");
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .addFilterBefore(characterEncodingFilter(), UsernamePasswordAuthenticationFilter.class)
            .authorizeRequests()
                .antMatchers("/", "/auth/register", "/auth/login").permitAll()
                .antMatchers("/webhook/stripe/**").permitAll()
                .antMatchers("/api/**").hasAnyRole("USER", "DOCTOR", "ADMIN")
                .antMatchers("/doctor/**").hasRole("DOCTOR")
                .antMatchers("/admin/**").hasRole("ADMIN")
                .antMatchers("/payment/**").hasAnyRole("USER", "DOCTOR", "ADMIN")
                .antMatchers("/cabinet/**").hasAnyRole("USER", "DOCTOR", "ADMIN")
                .anyRequest().authenticated()
            .and()
                .formLogin()
                .loginPage("/auth/login")
                .successHandler((request, response, authentication) -> {
                    String contextPath = request.getContextPath();
                    if (authentication.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
                        response.sendRedirect(contextPath + "/admin");
                    } else {
                        response.sendRedirect(contextPath + "/cabinet");
                    }
                })
                .failureUrl("/auth/login?error=true")
                .permitAll()
            .and()
                .logout()
                .logoutUrl("/auth/logout")
                .logoutSuccessUrl("/logout")
                .permitAll()
            .and()
                .sessionManagement()
                    .maximumSessions(1)
                    .maxSessionsPreventsLogin(false);
    }
}
