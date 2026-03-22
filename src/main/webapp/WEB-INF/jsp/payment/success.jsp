<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="${pageContext.response.locale.language}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key="payment.success.title"/> - <fmt:message key="app.title"/></title>
    <%@ include file="../fragments/common-styles.jsp" %>
    <style>
        .result-container {
            max-width: 600px;
            margin: 0 auto;
            padding: 80px 20px;
            text-align: center;
        }
        .success-icon {
            width: 100px;
            height: 100px;
            background: linear-gradient(135deg, #00d4aa 0%, #00a3ff 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 32px;
            box-shadow: 0 20px 60px rgba(0, 212, 170, 0.3);
        }
        .success-icon svg {
            width: 50px;
            height: 50px;
            fill: #0a0e17;
        }
        h1 {
            font-size: 32px;
            font-weight: 700;
            color: #fff;
            margin-bottom: 16px;
        }
        p {
            color: #6b7280;
            font-size: 18px;
            margin-bottom: 32px;
        }
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 14px 28px;
            background: linear-gradient(135deg, #00d4aa 0%, #00a3ff 100%);
            color: #0a0e17;
            font-size: 16px;
            font-weight: 600;
            border: none;
            border-radius: 12px;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 15px 40px rgba(0, 212, 170, 0.4);
        }
        .btn svg {
            width: 18px;
            height: 18px;
            fill: currentColor;
        }
    </style>
</head>
<body>
    <main class="main-content">
        <div class="result-container">
            <div class="success-icon">
                <svg viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg>
            </div>
            <h1><fmt:message key="payment.success.headline"/></h1>
            <p><fmt:message key="payment.success.message"/></p>
            <a href="${pageContext.request.contextPath}/cabinet?lang=${pageContext.response.locale.language}" class="btn">
                <svg viewBox="0 0 24 24"><path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/></svg>
                <fmt:message key="payment.success.go_cabinet"/>
            </a>
        </div>
    </main>
</body>
</html>
