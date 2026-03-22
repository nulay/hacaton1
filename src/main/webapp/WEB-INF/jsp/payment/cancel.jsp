<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="${pageContext.response.locale.language}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key="payment.cancel.title"/> - <fmt:message key="app.title"/></title>
    <%@ include file="../fragments/common-styles.jsp" %>
    <style>
        .result-container {
            max-width: 600px;
            margin: 0 auto;
            padding: 80px 20px;
            text-align: center;
        }
        .cancel-icon {
            width: 100px;
            height: 100px;
            background: rgba(251, 191, 36, 0.2);
            border: 2px solid #fbbf24;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 32px;
        }
        .cancel-icon svg {
            width: 50px;
            height: 50px;
            fill: #fbbf24;
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
        .btn-secondary {
            background: transparent;
            color: #00d4aa;
            border: 1px solid #00d4aa;
            margin-left: 12px;
        }
        .btn-secondary:hover {
            background: rgba(0, 212, 170, 0.1);
            box-shadow: none;
        }
    </style>
</head>
<body>
    <main class="main-content">
        <div class="result-container">
            <div class="cancel-icon">
                <svg viewBox="0 0 24 24"><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/></svg>
            </div>
            <h1><fmt:message key="payment.cancel.headline"/></h1>
            <p><fmt:message key="payment.cancel.message"/></p>
            <div>
                <a href="${pageContext.request.contextPath}/payment/upgrade?lang=${pageContext.response.locale.language}" class="btn">
                    <svg viewBox="0 0 24 24"><path d="M20 4H4c-1.11 0-1.99.89-1.99 2L2 18c0 1.11.89 2 2 2h16c1.11 0 2-.89 2-2V6c0-1.11-.89-2-2-2zm0 14H4v-6h16v6zm0-10H4V6h16v2z"/></svg>
                    <fmt:message key="payment.cancel.try_again"/>
                </a>
                <a href="${pageContext.request.contextPath}/cabinet?lang=${pageContext.response.locale.language}" class="btn btn-secondary">
                    <svg viewBox="0 0 24 24"><path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/></svg>
                    <fmt:message key="payment.cancel.back_cabinet"/>
                </a>
            </div>
        </div>
    </main>
</body>
</html>
