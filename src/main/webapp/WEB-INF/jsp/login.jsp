<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="${pageContext.response.locale.language}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key="auth.login"/> - <fmt:message key="app.title"/></title>
    <%@ include file="fragments/auth-styles.jsp" %>
</head>
<body>
    <div class="page-container">
        <div class="form-container">
            <div class="logo">
                <div class="logo-icon">
                    <svg viewBox="0 0 24 24"><path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 3c1.93 0 3.5 1.57 3.5 3.5S13.93 13 12 13s-3.5-1.57-3.5-3.5S10.07 6 12 6zm7 13H5v-.23c0-.62.28-1.2.76-1.58C7.47 15.82 9.64 15 12 15s4.53.82 6.24 2.19c.48.38.76.97.76 1.58V19z"/></svg>
                </div>
                <h1><fmt:message key="app.title"/></h1>
                <p><fmt:message key="auth.login_subtitle"/></p>
            </div>

            <% if ("true".equals(request.getParameter("error"))) { %>
            <div class="alert alert-error"><fmt:message key="auth.error.invalid"/></div>
            <% } %>
            <% if ("true".equals(request.getParameter("registered"))) { %>
            <div class="alert alert-success"><fmt:message key="auth.success.registered"/></div>
            <% } %>
            <% if ("true".equals(request.getParameter("logout"))) { %>
            <div class="alert alert-success"><fmt:message key="auth.success.logout"/></div>
            <% } %>
            <% if ("true".equals(request.getParameter("expired"))) { %>
            <div class="alert alert-error"><fmt:message key="error.session_expired"/></div>
            <% } %>

            <form method="post" action="${pageContext.request.contextPath}/auth/login?lang=${pageContext.response.locale.language}">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <div class="form-group">
                    <label><fmt:message key="auth.email"/></label>
                    <input type="email" name="username" placeholder="example@mail.ru" required />
                </div>
                <div class="form-group">
                    <label><fmt:message key="auth.password"/></label>
                    <input type="password" name="password" placeholder="<fmt:message key="auth.password"/>" required />
                </div>
                <button type="submit" class="btn"><fmt:message key="auth.login"/></button>
            </form>

            <div class="footer-link">
                <fmt:message key="auth.no_account"/> <a href="${pageContext.request.contextPath}/auth/register?lang=${pageContext.response.locale.language}"><fmt:message key="auth.register"/></a>
            </div>
        </div>
    </div>
</body>
</html>
