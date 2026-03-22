<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="${pageContext.response.locale.language}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key="cabinet.profile"/> - <fmt:message key="app.title"/></title>
    <%@ include file="fragments/common-styles.jsp" %>
</head>
<body>
    <%@ include file="fragments/header-auth.jsp" %>

    <main class="main-content">
        <div class="profile-card">
            <div class="profile-header">
                <div class="profile-photo">
                    <c:choose>
                        <c:when test="${not empty photoUrl}">
                            <img src="${photoUrl}" alt="<fmt:message key="reg.photo"/>" />
                        </c:when>
                        <c:otherwise>
                            <svg viewBox="0 0 24 24"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>
                        </c:otherwise>
                    </c:choose>
                </div>
                <h1 class="profile-name">${lastName} ${firstName} ${middleName}</h1>
                <p class="profile-subtitle">${email}</p>
                <c:forEach var="auth" items="${authorities}">
                    <c:if test="${auth.authority == 'ROLE_DOCTOR'}">
                        <span class="specialization-badge"><fmt:message key="doctor.title"/></span>
                    </c:if>
                    <c:if test="${auth.authority == 'ROLE_ADMIN'}">
                        <span class="specialization-badge"><fmt:message key="reg.role.admin"/></span>
                    </c:if>
                    <c:if test="${auth.authority == 'ROLE_USER'}">
                        <span class="specialization-badge"><fmt:message key="reg.role.patient"/></span>
                    </c:if>
                </c:forEach>
            </div>

            <div class="profile-body">
                <div class="info-section">
                    <h3 class="section-title">
                        <svg viewBox="0 0 24 24"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>
                        <fmt:message key="cabinet.personal_info"/>
                    </h3>

                    <div class="info-grid">
                        <div class="info-item">
                            <div class="info-label"><fmt:message key="reg.last_name"/></div>
                            <div class="info-value">${lastName}</div>
                        </div>
                        <div class="info-item">
                            <div class="info-label"><fmt:message key="reg.first_name"/></div>
                            <div class="info-value">${firstName}</div>
                        </div>
                        <div class="info-item">
                            <div class="info-label"><fmt:message key="reg.middle_name"/></div>
                            <div class="info-value">${middleName != '' ? middleName : '—'}</div>
                        </div>
                        <div class="info-item">
                            <div class="info-label"><fmt:message key="reg.birth_date"/></div>
                            <div class="info-value">${birthDate != '' ? birthDate : '—'}</div>
                        </div>
                    </div>
                </div>

                <div class="actions">
                    <a href="${pageContext.request.contextPath}/cabinet/profile/edit?lang=${pageContext.response.locale.language}" class="btn btn-primary">
                        <svg viewBox="0 0 24 24"><path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/></svg>
                        <fmt:message key="edit"/>
                    </a>
                </div>
            </div>
        </div>
    </main>
</body>
</html>
