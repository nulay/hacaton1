<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Редактирование профиля - Medical Archive</title>
    <%@ include file="fragments/common-styles.jsp" %>
    <style>
        .edit-container {
            max-width: 600px;
            margin: 0 auto;
        }
        
        .avatar-preview {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 25px;
        }
        
        .avatar-preview .profile-avatar {
            width: 80px;
            height: 80px;
        }
        
        .avatar-preview .avatar-info {
            flex: 1;
        }
        
        .avatar-preview .avatar-info p {
            color: #888;
            font-size: 13px;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <%@ include file="fragments/header-auth.jsp" %>

    <main class="main-content">
        <a href="${pageContext.request.contextPath}/cabinet" class="back-link">
            <svg viewBox="0 0 24 24"><path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z"/></svg>
            Назад в кабинет
        </a>

        <div class="edit-container">
            <div class="page-header">
                <h2>Редактирование профиля</h2>
                <p>Обновите вашу личную информацию</p>
            </div>

            <div class="card">
                <form method="post" action="${pageContext.request.contextPath}/cabinet/profile/edit">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    
                    <div class="avatar-preview">
                        <div class="profile-avatar">
                            <c:choose>
                                <c:when test="${not empty photoUrl}">
                                    <img src="${photoUrl}" alt="Фото профиля" />
                                </c:when>
                                <c:otherwise>
                                    <svg viewBox="0 0 24 24"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="avatar-info">
                            <h3>Фото профиля</h3>
                            <p>Укажите URL изображения для вашего аватара</p>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>URL фотографии</label>
                        <input type="text" name="photoUrl" value="${photoUrl}" placeholder="https://example.com/photo.jpg" />
                    </div>

                    <div class="info-grid" style="margin-bottom: 25px;">
                        <div class="form-group">
                            <label>Фамилия *</label>
                            <input type="text" name="lastName" value="${lastName}" required />
                        </div>
                        <div class="form-group">
                            <label>Имя *</label>
                            <input type="text" name="firstName" value="${firstName}" required />
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Отчество</label>
                        <input type="text" name="middleName" value="${middleName}" placeholder="Иванович" />
                    </div>

                    <div class="form-group">
                        <label>Дата рождения</label>
                        <input type="date" name="birthDate" value="${birthDate}" />
                    </div>

                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" value="${email}" readonly />
                        <small style="color: #888; font-size: 12px; margin-top: 5px; display: block;">Email нельзя изменить</small>
                    </div>

                    <button type="submit" class="btn btn-primary" style="margin-top: 20px;">
                        <svg viewBox="0 0 24 24"><path d="M17 3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V7l-4-4zm-5 16c-1.66 0-3-1.34-3-3s1.34-3 3-3 3 1.34 3 3-1.34 3-3 3zm3-10H5V5h10v4z"/></svg>
                        Сохранить изменения
                    </button>
                </form>
            </div>
        </div>
    </main>
</body>
</html>
