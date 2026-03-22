package com.hackaton.config;

import org.springframework.web.servlet.i18n.LocaleChangeInterceptor;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.support.RequestContextUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Locale;

public class CustomLocaleInterceptor extends LocaleChangeInterceptor {
    
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        String lang = request.getParameter("lang");
        if (lang != null && !lang.isEmpty()) {
            LocaleResolver localeResolver = RequestContextUtils.getLocaleResolver(request);
            if (localeResolver != null) {
                Locale locale = Locale.forLanguageTag(lang);
                localeResolver.setLocale(request, response, locale);
            }
        }
        return true;
    }
}
