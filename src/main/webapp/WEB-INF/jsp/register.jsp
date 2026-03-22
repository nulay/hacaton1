<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="${pageContext.response.locale.language}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key="auth.register"/> - <fmt:message key="app.title"/></title>
    <%@ include file="fragments/auth-styles.jsp" %>
</head>
<body>
    <div class="page-container">
        <div class="form-container wide">
            <div class="logo">
                <div class="logo-icon">
                    <svg viewBox="0 0 24 24"><path d="M15 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm-9-2V7H4v3H1v2h3v3h2v-3h3v-2H6zm9 4c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>
                </div>
                <h1><fmt:message key="reg.title"/></h1>
                <p><fmt:message key="auth.register_subtitle"/></p>
            </div>

            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error"><%= request.getAttribute("error") %></div>
            <% } %>

            <form method="post" action="${pageContext.request.contextPath}/auth/register?lang=${pageContext.response.locale.language}">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                
                <div class="form-group">
                    <label><fmt:message key="auth.email"/></label>
                    <input type="email" name="email" placeholder="example@mail.ru" required />
                </div>

                <div class="name-fields">
                    <div class="form-group">
                        <label><fmt:message key="reg.last_name"/> *</label>
                        <input type="text" name="lastName" placeholder="<fmt:message key="reg.last_name"/>" required />
                    </div>
                    <div class="form-group">
                        <label><fmt:message key="reg.first_name"/> *</label>
                        <input type="text" name="firstName" placeholder="<fmt:message key="reg.first_name"/>" required />
                    </div>
                    <div class="form-group">
                        <label><fmt:message key="reg.middle_name"/></label>
                        <input type="text" name="middleName" placeholder="<fmt:message key="reg.middle_name"/>" />
                    </div>
                </div>

                <div class="form-group">
                    <label><fmt:message key="auth.password"/> *</label>
                    <input type="password" name="password" placeholder="<fmt:message key="auth.password"/> (min 6)" required minlength="6" />
                </div>

                <div class="form-group">
                    <label><fmt:message key="reg.role"/></label>
                    <select name="role" required>
                        <option value="USER"><fmt:message key="reg.role.patient"/></option>
                        <option value="DOCTOR"><fmt:message key="reg.role.doctor"/></option>
                    </select>
                </div>

                <button type="submit" class="btn"><fmt:message key="reg.create_account"/></button>
            </form>

            <div class="footer-link">
                <fmt:message key="auth.has_account"/> <a href="${pageContext.request.contextPath}/auth/login?lang=${pageContext.response.locale.language}"><fmt:message key="auth.login"/></a>
            </div>
        </div>
    </div>
</body>
</html>
