<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="${pageContext.response.locale.language}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key="logout.title"/> - <fmt:message key="app.title"/></title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #0a0e17 0%, #1a1f2e 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
        }
        .logout-card {
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.03) 0%, rgba(255, 255, 255, 0.01) 100%);
            border: 1px solid rgba(255, 255, 255, 0.05);
            border-radius: 24px;
            padding: 48px;
            text-align: center;
            max-width: 400px;
            width: 90%;
        }
        .icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #00d4aa 0%, #00a3ff 100%);
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 24px;
        }
        .icon svg {
            width: 40px;
            height: 40px;
            fill: #0a0e17;
        }
        h1 {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 12px;
        }
        p {
            color: #6b7280;
            font-size: 15px;
            margin-bottom: 32px;
            line-height: 1.6;
        }
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 14px 28px;
            border-radius: 12px;
            font-size: 15px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            cursor: pointer;
            border: none;
        }
        .btn-primary {
            background: linear-gradient(135deg, #00d4aa 0%, #00a3ff 100%);
            color: #0a0e17;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 30px rgba(0, 212, 170, 0.3);
        }
        .btn svg {
            width: 18px;
            height: 18px;
            fill: currentColor;
        }
    </style>
</head>
<body>
    <div class="logout-card">
        <div class="icon">
            <svg viewBox="0 0 24 24"><path d="M17 7l-1.41 1.41L18.17 11H8v2h10.17l-2.58 2.58L17 17l5-5zM4 5h8V3H4c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h8v-2H4V5z"/></svg>
        </div>
        <h1><fmt:message key="logout.title"/></h1>
        <p><fmt:message key="logout.message"/></p>
        <a href="${pageContext.request.contextPath}/auth/login?lang=${pageContext.response.locale.language}" class="btn btn-primary">
            <svg viewBox="0 0 24 24"><path d="M17 7l-1.41 1.41L18.17 11H8v2h10.17l-2.58 2.58L17 17l5-5zM4 5h8V3H4c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h8v-2H4V5z"/></svg>
            <fmt:message key="logout.login_again"/>
        </a>
    </div>
</body>
</html>
