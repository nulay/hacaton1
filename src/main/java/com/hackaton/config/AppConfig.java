package com.hackaton.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.flywaydb.core.Flyway;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.support.ResourceBundleMessageSource;
import org.springframework.core.env.Environment;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.multipart.support.StandardServletMultipartResolver;
import org.springframework.web.servlet.ViewResolver;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.view.InternalResourceViewResolver;

import javax.sql.DataSource;
import java.util.Locale;

@Configuration
@EnableWebMvc
@ComponentScan(basePackages = "com.hackaton")
@PropertySource("classpath:application.properties")
public class AppConfig implements WebMvcConfigurer {
    private static final Logger log = LoggerFactory.getLogger(AppConfig.class);

    private final Environment environment;

    public AppConfig(Environment environment) {
        this.environment = environment;
    }

    @Bean
    public ViewResolver viewResolver() {
        InternalResourceViewResolver resolver = new InternalResourceViewResolver();
        resolver.setPrefix("/WEB-INF/jsp/");
        resolver.setSuffix(".jsp");
        resolver.setContentType("text/html;charset=UTF-8");
        return resolver;
    }

    @Bean
    public ResourceBundleMessageSource messageSource() {
        ResourceBundleMessageSource messageSource = new ResourceBundleMessageSource();
        messageSource.setBasenames("messages");
        messageSource.setDefaultEncoding("UTF-8");
        messageSource.setDefaultLocale(Locale.of("en"));
        messageSource.setUseCodeAsDefaultMessage(false);
        return messageSource;
    }

    @Bean
    public SessionLocaleResolver localeResolver() {
        SessionLocaleResolver resolver = new SessionLocaleResolver();
        resolver.setDefaultLocale(Locale.of("en"));
        return resolver;
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        CustomLocaleInterceptor localeInterceptor = new CustomLocaleInterceptor();
        localeInterceptor.setParamName("lang");
        registry.addInterceptor(localeInterceptor)
            .addPathPatterns("/**")
            .excludePathPatterns("/static/**");
        registry.addInterceptor(new SessionCheckInterceptor())
            .addPathPatterns("/cabinet/**", "/doctor/**", "/payment/**", "/admin/**");
    }

    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        registry.addViewController("/").setViewName("index");
    }

    @Bean
    public DataSource dataSource() {
        String dbUrl = environment.getProperty("db.url", "jdbc:postgresql://localhost:5432/medical_archive");
        String dbUser = environment.getProperty("db.user", "postgres");
        String dbPassword = environment.getProperty("db.password", "postgres");

        HikariConfig config = new HikariConfig();
        config.setJdbcUrl(dbUrl + "?characterEncoding=utf8&useUnicode=true");
        config.setUsername(dbUser);
        config.setPassword(dbPassword);
        config.setDriverClassName("org.postgresql.Driver");
        config.addDataSourceProperty("cachePrepStmts", "true");
        config.addDataSourceProperty("prepStmtCacheSize", "250");
        config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");

        log.info("HikariCP DataSource configured. url={}, user={}", dbUrl, dbUser);
        return new HikariDataSource(config);
    }

    @Bean
    public JdbcTemplate jdbcTemplate(DataSource dataSource) {
        return new JdbcTemplate(dataSource);
    }

    @Bean(initMethod = "migrate")
    public Flyway flyway(DataSource dataSource) {
        log.info("Flyway bean initialized. Running migrations from classpath:db/migration");
        return Flyway.configure()
            .dataSource(dataSource)
            .locations("classpath:db/migration")
            .baselineOnMigrate(true)
            .outOfOrder(true)
            .load();
    }

    @Bean
    public StandardServletMultipartResolver multipartResolver() {
        return new StandardServletMultipartResolver();
    }
}
