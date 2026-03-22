<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Профиль врача - Medical Archive</title>
    <%@ include file="fragments/common-styles.jsp" %>
</head>
<body>
    <%@ include file="fragments/header-auth.jsp" %>

    <main class="main-content">
        <a href="${pageContext.request.contextPath}/cabinet/doctors" class="back-link">
            <svg viewBox="0 0 24 24"><path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z"/></svg>
            Назад к списку врачей
        </a>

        <div class="profile-card">
            <div class="profile-header">
                <div class="profile-photo">
                    <c:choose>
                        <c:when test="${not empty doctor.photoUrl}">
                            <img src="${doctor.photoUrl}" alt="Фото врача" />
                        </c:when>
                        <c:otherwise>
                            <svg viewBox="0 0 24 24"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>
                        </c:otherwise>
                    </c:choose>
                </div>
                <h2 class="profile-name">${doctor.lastName} ${doctor.firstName} ${doctor.middleName}</h2>
                <c:if test="${not empty doctor.specialization}">
                    <span class="specialization-badge">${doctor.specialization}</span>
                </c:if>
            </div>

            <div class="profile-body">
                <div class="info-section">
                    <h3 class="section-title">
                        <svg viewBox="0 0 24 24"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>
                        Информация о враче
                    </h3>
                    <div class="info-grid">
                        <div class="info-item">
                            <div class="info-label">Фамилия</div>
                            <div class="info-value">${doctor.lastName}</div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Имя</div>
                            <div class="info-value">${doctor.firstName}</div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Отчество</div>
                            <div class="info-value">${doctor.middleName != '' ? doctor.middleName : '—'}</div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Специализация</div>
                            <div class="info-value">${doctor.specialization != '' ? doctor.specialization : 'Не указана'}</div>
                        </div>
                    </div>
                </div>

                <div class="info-section">
                    <h3 class="section-title">
                        <svg viewBox="0 0 24 24"><path d="M14 2H6c-1.1 0-1.99.9-1.99 2L4 20c0 1.1.89 2 1.99 2H18c1.1 0 2-.9 2-2V8l-6-6zm2 16H8v-2h8v2zm0-4H8v-2h8v2zm-3-5V3.5L18.5 9H13z"/></svg>
                        Дипломы и сертификаты
                    </h3>
                    <c:choose>
                        <c:when test="${empty doctor.diplomas}">
                            <div class="empty-state">
                                <svg viewBox="0 0 24 24"><path d="M14 2H6c-1.1 0-1.99.9-1.99 2L4 20c0 1.1.89 2 1.99 2H18c1.1 0 2-.9 2-2V8l-6-6zm2 16H8v-2h8v2zm0-4H8v-2h8v2zm-3-5V3.5L18.5 9H13z"/></svg>
                                <p>Дипломы не добавлены</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="diplomas-list">
                                <c:forEach var="diploma" items="${doctor.diplomas}">
                                    <div class="diploma-item">
                                        <div class="diploma-icon">
                                            <svg viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/></svg>
                                        </div>
                                        <span class="diploma-title">${diploma}</span>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="actions">
                    <a href="${pageContext.request.contextPath}/cabinet/doctors" class="btn btn-primary">
                        <svg viewBox="0 0 24 24" style="width:18px;height:18px;fill:currentColor"><path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z"/></svg>
                        Назад к списку
                    </a>
                </div>
            </div>
        </div>
    </main>
</body>
</html>
