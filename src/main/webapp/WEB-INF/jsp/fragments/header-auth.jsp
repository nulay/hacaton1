<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${pageContext.response.locale}" scope="session"/>
<header class="header">
    <div class="header-content">
        <div class="logo">
            <div class="logo-icon">
                <svg viewBox="0 0 24 24"><path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 3c1.93 0 3.5 1.57 3.5 3.5S13.93 13 12 13s-3.5-1.57-3.5-3.5S10.07 6 12 6zm7 13H5v-.23c0-.62.28-1.2.76-1.58C7.47 15.82 9.64 15 12 15s4.53.82 6.24 2.19c.48.38.76.97.76 1.58V19z"/></svg>
            </div>
            <h1><fmt:message key="app.title"/></h1>
        </div>
        <c:if test="${not empty email}">
            <div class="header-nav">
                <a href="${pageContext.request.contextPath}/cabinet/documents" class="nav-link">
                    <svg viewBox="0 0 24 24"><path d="M14 2H6c-1.1 0-1.99.9-1.99 2L4 20c0 1.1.89 2 1.99 2H18c1.1 0 2-.9 2-2V8l-6-6zm2 16H8v-2h8v2zm0-4H8v-2h8v2zm-3-5V3.5L18.5 9H13z"/></svg>
                    <fmt:message key="nav.documents"/>
                </a>
                <a href="${pageContext.request.contextPath}/cabinet/profile?lang=${pageContext.response.locale.language}" class="nav-link">
                    <svg viewBox="0 0 24 24"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>
                    <fmt:message key="nav.profile"/>
                </a>
            </div>
            <div class="user-menu">
                <div class="lang-switcher">
                    <a href="?lang=en" class="${pageContext.response.locale.language == 'en' ? 'active' : ''}">EN</a>
                    <span>|</span>
                    <a href="?lang=ru" class="${pageContext.response.locale.language == 'ru' ? 'active' : ''}">RU</a>
                </div>
                <div class="user-info">
                    <div class="user-avatar">
                        <svg viewBox="0 0 24 24"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>
                    </div>
                    <div>
                        <div class="user-name">${lastName} ${firstName}</div>
                        <div class="user-email">${email}</div>
                    </div>
                </div>
                <form method="post" action="${pageContext.request.contextPath}/auth/logout" style="display: inline;">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <button type="submit" class="logout-btn">
                        <svg viewBox="0 0 24 24"><path d="M17 7l-1.41 1.41L18.17 11H8v2h10.17l-2.58 2.58L17 17l5-5zM4 5h8V3H4c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h8v-2H4V5z"/></svg>
                        <fmt:message key="nav.logout"/>
                    </button>
                </form>
            </div>
        </c:if>
    </div>
</header>

<style>
    .header-nav {
        display: flex;
        gap: 8px;
        margin-right: 20px;
    }
    .nav-link {
        display: flex;
        align-items: center;
        gap: 6px;
        padding: 8px 14px;
        color: #a0a0a0;
        text-decoration: none;
        border-radius: 8px;
        font-size: 14px;
        transition: all 0.3s ease;
    }
    .nav-link svg {
        width: 18px;
        height: 18px;
        fill: currentColor;
    }
    .nav-link:hover {
        color: #fff;
        background: rgba(255, 255, 255, 0.05);
    }
    .lang-switcher {
        display: flex;
        align-items: center;
        gap: 6px;
        margin-right: 16px;
        padding-right: 16px;
        border-right: 1px solid rgba(255, 255, 255, 0.1);
    }
    .lang-switcher a {
        color: #6b7280;
        text-decoration: none;
        font-size: 13px;
        font-weight: 600;
        transition: color 0.3s ease;
    }
    .lang-switcher a:hover,
    .lang-switcher a.active {
        color: #00d4aa;
    }
    .lang-switcher span {
        color: #3f3f3f;
    }
</style>
