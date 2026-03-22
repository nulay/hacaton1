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
        String dbUrl;
        String dbUser = environment.getProperty("db.user", "postgres");
        String dbPassword = environment.getProperty("db.password", "postgres");

        String databaseUrl = environment.getProperty("DB_URL");
        if (databaseUrl != null && !databaseUrl.isEmpty()) {
            java.net.URI uri;
            try {
                uri = new java.net.URI(databaseUrl);
            } catch (Exception e) {
                log.error("Failed to parse DATABASE_URL: {}", databaseUrl);
                throw new RuntimeException("Invalid DATABASE_URL format", e);
            }
            
            dbUser = uri.getUserInfo() != null ? uri.getUserInfo().split(":")[0] : dbUser;
            dbPassword = uri.getUserInfo() != null && uri.getUserInfo().split(":").length > 1 
                ? uri.getUserInfo().split(":")[1] : dbPassword;
            
            String host = uri.getHost();
            int port = uri.getPort() > 0 ? uri.getPort() : 5432;
            String dbName = uri.getPath() != null ? uri.getPath().substring(1) : "medical_archive";
            
            StringBuilder jdbcUrl = new StringBuilder("jdbc:postgresql://");
            jdbcUrl.append(host).append(":").append(port).append("/").append(dbName);
            jdbcUrl.append("?characterEncoding=utf8&useUnicode=true");
            if (uri.getQuery() != null) {
                jdbcUrl.append("&").append(uri.getQuery());
            }
            
            dbUrl = jdbcUrl.toString();
            log.info("Using DATABASE_URL: host={}, port={}, db={}", host, port, dbName);
        } else {
            dbUrl = environment.getProperty("db.url", "jdbc:postgresql://localhost:5432/medical_archive");
            log.info("Using default db properties. url={}", dbUrl);
        }

        HikariConfig config = new HikariConfig();
        config.setJdbcUrl(dbUrl);
        config.setUsername(dbUser);
        config.setPassword(dbPassword);
        config.setDriverClassName("org.postgresql.Driver");
        config.addDataSourceProperty("cachePrepStmts", "true");
        config.addDataSourceProperty("prepStmtCacheSize", "250");
        config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");

        log.info("HikariCP DataSource configured for user: {}", dbUser);
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
