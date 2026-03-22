<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Кабинет врача - Medical Archive</title>
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
            <h2>Кабинет врача</h2>
            <p>Управление профилем и профессиональной информацией</p>
        </div>

        <div class="card">
            <div class="card-header">
                <div class="card-icon">
                    <svg viewBox="0 0 24 24"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>
                </div>
                <div>
                    <h3 class="card-title">Информация о враче</h3>
                    <p class="card-subtitle">Ваши персональные данные</p>
                </div>
            </div>

            <div class="info-grid">
                <div class="info-item">
                    <div class="info-label">Фамилия</div>
                    <div class="info-value">${profile.lastName}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Имя</div>
                    <div class="info-value">${profile.firstName}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Отчество</div>
                    <div class="info-value">${profile.middleName != '' ? profile.middleName : '—'}</div>
                </div>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/doctor/profile">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                
                <div class="form-group">
                    <label>URL фотографии</label>
                    <input type="text" name="photoUrl" value="${profile.photoUrl}" placeholder="https://example.com/photo.jpg" />
                </div>

                <div class="form-group">
                    <label>Специализация</label>
                    <textarea name="specialization" rows="3" placeholder="Кардиология, неврология, терапия...">${profile.specialization}</textarea>
                </div>

                <button type="submit" class="btn btn-primary">
                    <svg viewBox="0 0 24 24"><path d="M17 3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V7l-4-4zm-5 16c-1.66 0-3-1.34-3-3s1.34-3 3-3 3 1.34 3 3-1.34 3-3 3zm3-10H5V5h10v4z"/></svg>
                    Сохранить профиль
                </button>
            </form>
        </div>

        <div class="card">
            <div class="card-header">
                <div class="card-icon">
                    <svg viewBox="0 0 24 24"><path d="M14 2H6c-1.1 0-1.99.9-1.99 2L4 20c0 1.1.89 2 1.99 2H18c1.1 0 2-.9 2-2V8l-6-6zm2 16H8v-2h8v2zm0-4H8v-2h8v2zm-3-5V3.5L18.5 9H13z"/></svg>
                </div>
                <div>
                    <h3 class="card-title">Дипломы и сертификаты</h3>
                    <p class="card-subtitle">Добавьте ваши профессиональные документы</p>
                </div>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/doctor/profile/diplomas" class="diploma-form">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <input type="text" name="title" placeholder="Название диплома или сертификата" required />
                <button type="submit" class="btn btn-success">
                    <svg viewBox="0 0 24 24"><path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/></svg>
                    Добавить
                </button>
            </form>

            <c:choose>
                <c:when test="${empty profile.diplomas}">
                    <div class="empty-state">
                        <svg viewBox="0 0 24 24"><path d="M14 2H6c-1.1 0-1.99.9-1.99 2L4 20c0 1.1.89 2 1.99 2H18c1.1 0 2-.9 2-2V8l-6-6zm2 16H8v-2h8v2zm0-4H8v-2h8v2zm-3-5V3.5L18.5 9H13z"/></svg>
                        <p>Дипломы не добавлены</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="diplomas-list">
                        <c:forEach var="diploma" items="${profile.diplomas}">
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
    </main>
</body>
</html>
