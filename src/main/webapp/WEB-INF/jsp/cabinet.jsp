<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="${pageContext.response.locale.language}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key="cabinet.title"/> - <fmt:message key="app.title"/></title>
    <%@ include file="fragments/common-styles.jsp" %>
</head>
<body>
    <%@ include file="fragments/header-auth.jsp" %>

    <main class="main-content">
        <div class="profile-header-card">
            <div class="profile-avatar">
                <c:choose>
                    <c:when test="${not empty photoUrl}">
                        <img src="${photoUrl}" alt="<fmt:message key="reg.photo"/>" />
                    </c:when>
                    <c:otherwise>
                        <svg viewBox="0 0 24 24"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="profile-header-info">
                <h2 class="profile-title">${lastName} ${firstName} ${middleName}</h2>
                <p class="profile-subtitle">${email}</p>
                <c:forEach var="auth" items="${authorities}">
                    <c:if test="${auth.authority == 'ROLE_DOCTOR'}">
                        <span class="role-badge doctor"><fmt:message key="doctor.title"/></span>
                    </c:if>
                    <c:if test="${auth.authority == 'ROLE_ADMIN'}">
                        <span class="role-badge admin"><fmt:message key="reg.role.admin"/></span>
                    </c:if>
                    <c:if test="${auth.authority == 'ROLE_USER'}">
                        <span class="role-badge user"><fmt:message key="reg.role.patient"/></span>
                    </c:if>
                </c:forEach>
            </div>
            <a href="${pageContext.request.contextPath}/cabinet/profile/edit?lang=${pageContext.response.locale.language}" class="btn btn-outline edit-btn">
                <svg viewBox="0 0 24 24"><path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/></svg>
                <fmt:message key="edit"/>
            </a>
        </div>

        <div class="card">
            <div class="card-header">
                <div class="card-icon">
                    <svg viewBox="0 0 24 24"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>
                </div>
                <div>
                    <h3 class="card-title"><fmt:message key="cabinet.personal_info"/></h3>
                    <p class="card-subtitle"><fmt:message key="cabinet.personal_info.desc"/></p>
                </div>
            </div>

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

        <div class="nav-grid">
            <a href="${pageContext.request.contextPath}/cabinet/doctors?lang=${pageContext.response.locale.language}" class="nav-card">
                <div class="nav-icon blue">
                    <svg viewBox="0 0 24 24"><path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 3c1.93 0 3.5 1.57 3.5 3.5S13.93 13 12 13s-3.5-1.57-3.5-3.5S10.07 6 12 6zm7 13H5v-.23c0-.62.28-1.2.76-1.58C7.47 15.82 9.64 15 12 15s4.53.82 6.24 2.19c.48.38.76.97.76 1.58V19z"/></svg>
                </div>
                <div class="nav-text">
                    <h3><fmt:message key="cabinet.doctors_catalog"/></h3>
                    <p><fmt:message key="cabinet.doctors_catalog.desc"/></p>
                </div>
            </a>

            <c:if test="${authorities.toString().contains('ROLE_DOCTOR')}">
                <a href="${pageContext.request.contextPath}/doctor/dashboard?lang=${pageContext.response.locale.language}" class="nav-card">
                    <div class="nav-icon green">
                        <svg viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/></svg>
                    </div>
                    <div class="nav-text">
                        <h3><fmt:message key="cabinet.doctor_cabinet"/></h3>
                        <p><fmt:message key="cabinet.doctor_cabinet.desc"/></p>
                    </div>
                </a>
            </c:if>

            <a href="${pageContext.request.contextPath}/cabinet/documents?lang=${pageContext.response.locale.language}" class="nav-card">
                <div class="nav-icon purple">
                    <svg viewBox="0 0 24 24"><path d="M14 2H6c-1.1 0-1.99.9-1.99 2L4 20c0 1.1.89 2 1.99 2H18c1.1 0 2-.9 2-2V8l-6-6zm2 16H8v-2h8v2zm0-4H8v-2h8v2zm-3-5V3.5L18.5 9H13z"/></svg>
                </div>
                <div class="nav-text">
                    <h3><fmt:message key="nav.documents"/></h3>
                    <p><fmt:message key="cabinet.documents.desc"/></p>
                </div>
            </a>
        </div>
    </main>
</body>
</html>
