<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="${pageContext.response.locale.language}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key="payment.upgrade.title"/> - <fmt:message key="app.title"/></title>
    <%@ include file="../fragments/common-styles.jsp" %>
    <style>
        .upgrade-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 40px 20px;
        }
        .upgrade-header {
            text-align: center;
            margin-bottom: 40px;
        }
        .upgrade-header h1 {
            font-size: 36px;
            font-weight: 700;
            background: linear-gradient(135deg, #00d4aa, #00a3ff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 16px;
        }
        .upgrade-header p {
            color: #6b7280;
            font-size: 18px;
        }
        .pricing-card {
            background: linear-gradient(135deg, rgba(0, 212, 170, 0.1) 0%, rgba(0, 163, 255, 0.1) 100%);
            border: 2px solid rgba(0, 212, 170, 0.3);
            border-radius: 24px;
            padding: 40px;
            text-align: center;
        }
        .pricing-card.premium {
            border-color: #00d4aa;
            box-shadow: 0 20px 60px rgba(0, 212, 170, 0.2);
        }
        .plan-name {
            font-size: 24px;
            font-weight: 700;
            color: #fff;
            margin-bottom: 8px;
        }
        .plan-price {
            font-size: 48px;
            font-weight: 700;
            color: #fff;
            margin-bottom: 8px;
        }
        .plan-price span {
            font-size: 18px;
            color: #6b7280;
        }
        .plan-period {
            color: #6b7280;
            margin-bottom: 32px;
        }
        .features-list {
            list-style: none;
            padding: 0;
            margin: 0 0 32px 0;
            text-align: left;
        }
        .features-list li {
            padding: 12px 0;
            color: #e5e5e5;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .features-list li svg {
            width: 20px;
            height: 20px;
            fill: #00d4aa;
            flex-shrink: 0;
        }
        .features-list li.disabled {
            color: #6b7280;
        }
        .features-list li.disabled svg {
            fill: #6b7280;
        }
        .upgrade-btn {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 16px 40px;
            background: linear-gradient(135deg, #00d4aa 0%, #00a3ff 100%);
            color: #0a0e17;
            font-size: 18px;
            font-weight: 700;
            border: none;
            border-radius: 14px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
        }
        .upgrade-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 40px rgba(0, 212, 170, 0.4);
        }
        .upgrade-btn svg {
            width: 20px;
            height: 20px;
            fill: currentColor;
        }
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #00d4aa;
            text-decoration: none;
            margin-bottom: 24px;
            transition: all 0.3s;
        }
        .back-link:hover {
            color: #00a3ff;
        }
        .back-link svg {
            width: 20px;
            height: 20px;
            fill: currentColor;
        }
        .alert {
            padding: 16px 20px;
            border-radius: 12px;
            margin-bottom: 24px;
            text-align: center;
        }
        .alert-warning {
            background: rgba(251, 191, 36, 0.1);
            border: 1px solid rgba(251, 191, 36, 0.3);
            color: #fbbf24;
        }
    </style>
</head>
<body>
    <%@ include file="../fragments/header-auth.jsp" %>

    <main class="main-content">
        <a href="${pageContext.request.contextPath}/cabinet?lang=${pageContext.response.locale.language}" class="back-link">
            <svg viewBox="0 0 24 24"><path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z"/></svg>
            <fmt:message key="back"/>
        </a>

        <div class="upgrade-container">
            <div class="upgrade-header">
                <h1><fmt:message key="payment.upgrade.header"/></h1>
                <p><fmt:message key="payment.upgrade.subheader"/></p>
            </div>

            <div class="pricing-card premium">
                <div class="plan-name"><fmt:message key="payment.plan.premium"/></div>
                <div class="plan-price">$9.99<span>/</span></div>
                <div class="plan-period"><fmt:message key="payment.plan.period"/></div>

                <ul class="features-list">
                    <li>
                        <svg viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg>
                        <fmt:message key="payment.feature.unlimited"/>
                    </li>
                    <li>
                        <svg viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg>
                        <fmt:message key="payment.feature.ocr"/>
                    </li>
                    <li>
                        <svg viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg>
                        <fmt:message key="payment.feature.storage"/>
                    </li>
                    <li>
                        <svg viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg>
                        <fmt:message key="payment.feature.share"/>
                    </li>
                    <li>
                        <svg viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg>
                        <fmt:message key="payment.feature.priority"/>
                    </li>
                </ul>

                <c:choose>
                    <c:when test="${isStripeConfigured}">
                        <form method="post" action="${pageContext.request.contextPath}/payment/create-checkout-session">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <button type="submit" class="upgrade-btn">
                                <svg viewBox="0 0 24 24"><path d="M20 4H4c-1.11 0-1.99.89-1.99 2L2 18c0 1.11.89 2 2 2h16c1.11 0 2-.89 2-2V6c0-1.11-.89-2-2-2zm0 14H4v-6h16v6zm0-10H4V6h16v2z"/></svg>
                                <fmt:message key="payment.upgrade.button"/>
                            </button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-warning">
                            <fmt:message key="payment.not_configured"/>
                        </div>
                        <form method="post" action="${pageContext.request.contextPath}/payment/create-checkout-session">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <button type="submit" class="upgrade-btn">
                                <svg viewBox="0 0 24 24"><path d="M20 4H4c-1.11 0-1.99.89-1.99 2L2 18c0 1.11.89 2 2 2h16c1.11 0 2-.89 2-2V6c0-1.11-.89-2-2-2zm0 14H4v-6h16v6zm0-10H4V6h16v2z"/></svg>
                                <fmt:message key="payment.activate.demo"/>
                            </button>
                        </form>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>
</body>
</html>
