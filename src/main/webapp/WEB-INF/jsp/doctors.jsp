<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Врачи - Medical Archive</title>
    <%@ include file="fragments/common-styles.jsp" %>
</head>
<body>
    <%@ include file="fragments/header-auth.jsp" %>

    <main class="main-content">
        <a href="${pageContext.request.contextPath}/cabinet" class="back-link">
            <svg viewBox="0 0 24 24"><path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z"/></svg>
            Назад в кабинет
        </a>

        <div class="page-header">
            <h2>Справочник врачей</h2>
            <p>Найдите нужного специалиста и запишитесь на приём</p>
        </div>

        <c:choose>
            <c:when test="${empty doctors}">
                <div class="empty-state">
                    <svg viewBox="0 0 24 24"><path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 3c1.93 0 3.5 1.57 3.5 3.5S13.93 13 12 13s-3.5-1.57-3.5-3.5S10.07 6 12 6zm7 13H5v-.23c0-.62.28-1.2.76-1.58C7.47 15.82 9.64 15 12 15s4.53.82 6.24 2.19c.48.38.76.97.76 1.58V19z"/></svg>
                    <h3>Врачи не найдены</h3>
                    <p>Список врачей пуст</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="doctors-grid">
                    <c:forEach var="doctor" items="${doctors}">
                        <div class="doctor-card">
                            <div class="doctor-card-content">
                                <div class="doctor-header">
                                    <div class="doctor-photo">
                                        <c:choose>
                                            <c:when test="${not empty doctor.photoUrl}">
                                                <img src="${doctor.photoUrl}" alt="Фото врача" />
                                            </c:when>
                                            <c:otherwise>
                                                <svg viewBox="0 0 24 24"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="doctor-info">
                                        <h3>${doctor.lastName} ${doctor.firstName} ${doctor.middleName}</h3>
                                        <c:if test="${not empty doctor.specialization}">
                                            <span class="specialization">${doctor.specialization}</span>
                                        </c:if>
                                    </div>
                                </div>
                                <div class="doctor-details">
                                    <a href="${pageContext.request.contextPath}/cabinet/doctors/${doctor.userId}" class="btn btn-primary btn-block">
                                        Открыть профиль
                                        <svg viewBox="0 0 24 24"><path d="M10 6L8.59 7.41 13.17 12l-4.58 4.59L10 18l6-6z"/></svg>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </main>
</body>
</html>
