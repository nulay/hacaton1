<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="${pageContext.response.locale.language}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title><fmt:message key="docs.title"/> - <fmt:message key="app.title"/></title>
    <script src="https://telegram.org/js/telegram-web-app.js"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #0a0e17 0%, #1a1f2e 100%);
            min-height: 100vh;
            color: #fff;
        }
        .header {
            background: rgba(255, 255, 255, 0.03);
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            padding: 16px 32px;
        }
        .header-content {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .logo { display: flex; align-items: center; gap: 12px; }
        .logo-icon {
            width: 40px; height: 40px;
            background: linear-gradient(135deg, #00d4aa, #00a3ff);
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
        }
        .logo-icon svg { width: 22px; height: 22px; fill: #0a0e17; }
        .logo h1 { font-size: 18px; font-weight: 600; }
        .main-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 32px;
        }
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
            flex-wrap: wrap;
            gap: 16px;
        }
        .page-header h2 { font-size: 24px; margin-bottom: 4px; }
        .page-header p { color: #6b7280; font-size: 14px; }
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 20px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
        }
        .btn-primary {
            background: linear-gradient(135deg, #00d4aa, #00a3ff);
            color: #0a0e17;
        }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 8px 30px rgba(0, 212, 170, 0.3); }
        .btn svg { width: 18px; height: 18px; fill: currentColor; }
        .back-link { display: inline-flex; align-items: center; gap: 8px; color: #00d4aa; text-decoration: none; margin-bottom: 20px; font-size: 14px; transition: all 0.2s; }
        .back-link:hover { color: #00a3ff; }
        .back-link svg { fill: currentColor; }
        .docs-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }
        .doc-card {
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid rgba(255, 255, 255, 0.06);
            border-radius: 16px;
            overflow: hidden;
            transition: all 0.3s ease;
        }
        .doc-card:hover {
            border-color: rgba(0, 212, 170, 0.3);
            transform: translateY(-2px);
        }
        .doc-card-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 16px;
            background: rgba(0, 212, 170, 0.05);
            border-bottom: 1px solid rgba(255, 255, 255, 0.03);
        }
        .doc-icon {
            width: 36px; height: 36px;
            background: linear-gradient(135deg, #00d4aa, #00a3ff);
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
        }
        .doc-icon svg { width: 18px; height: 18px; fill: #0a0e17; }
        .doc-actions { display: flex; gap: 8px; }
        .btn-sm {
            width: 40px; height: 40px;
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.15);
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            text-decoration: none;
            transition: all 0.2s ease;
            cursor: pointer;
        }
        .btn-sm svg { width: 20px; height: 20px; fill: #9ca3af; }
        .btn-sm:hover { background: rgba(0, 212, 170, 0.2); border-color: #00d4aa; transform: scale(1.05); }
        .btn-sm:hover svg { fill: #00d4aa; }
        .btn-sm.del { background: rgba(239, 68, 68, 0.15); border-color: rgba(239, 68, 68, 0.3); }
        .btn-sm.del svg { fill: #f87171; }
        .btn-sm.del:hover { background: rgba(239, 68, 68, 0.3); border-color: #ef4444; }
        .btn-sm.del:hover svg { fill: #ef4444; }
        .btn-sm.error-btn { background: rgba(251, 191, 36, 0.15); border-color: rgba(251, 191, 36, 0.3); }
        .btn-sm.error-btn svg { fill: #fbbf24; }
        .btn-sm.error-btn:hover { background: rgba(251, 191, 36, 0.25); border-color: #fbbf24; }
        .btn-sm.error-btn:hover svg { fill: #fbbf24; }
        .doc-body { padding: 16px; }
        .doc-title {
            font-size: 15px;
            font-weight: 600;
            margin-bottom: 8px;
            color: #fff;
            text-decoration: none;
            display: block;
        }
        .doc-title:hover { color: #00d4aa; }
        .doc-desc {
            font-size: 13px;
            color: #6b7280;
            margin-bottom: 12px;
            line-height: 1.5;
        }
        .doc-tags { display: flex; flex-wrap: wrap; gap: 6px; }
        .tag {
            padding: 4px 10px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 6px;
            font-size: 11px;
            color: #6b7280;
        }
        .tag.green { background: rgba(0, 212, 170, 0.1); color: #00d4aa; }
        .tag.yellow { background: rgba(251, 191, 36, 0.1); color: #fbbf24; }
        .tag.yellow[title] { cursor: help; }
        .empty-state {
            text-align: center;
            padding: 80px 20px;
        }
        .empty-state svg { width: 80px; height: 80px; fill: #6b7280; margin-bottom: 20px; }
        .empty-state h3 { font-size: 18px; margin-bottom: 8px; }
        .empty-state p { color: #6b7280; }
        @media (max-width: 600px) {
            .main-content { padding: 20px; }
            .docs-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <header class="header">
        <div class="header-content">
            <div class="logo">
                <div class="logo-icon">
                    <svg viewBox="0 0 24 24"><path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 3c1.93 0 3.5 1.57 3.5 3.5S13.93 13 12 13s-3.5-1.57-3.5-3.5S10.07 6 12 6zm7 13H5v-.23c0-.62.28-1.2.76-1.58C7.47 15.82 9.64 15 12 15s4.53.82 6.24 2.19c.48.38.76.97.76 1.58V19z"/></svg>
                </div>
                <h1><fmt:message key="app.title"/></h1>
            </div>
            <c:if test="${not empty email}">
                <form method="post" action="${pageContext.request.contextPath}/auth/logout">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <button type="submit" class="btn btn-primary" style="padding: 8px 16px; font-size: 13px;"><fmt:message key="nav.logout"/></button>
                </form>
            </c:if>
        </div>
    </header>

    <main class="main-content">
        <a href="${pageContext.request.contextPath}/cabinet?lang=${pageContext.response.locale.language}" class="back-link">
            <svg viewBox="0 0 24 24" width="20" height="20"><path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z"/></svg>
            <fmt:message key="nav.cabinet"/>
        </a>
        <div class="page-header">
            <div>
                <h2><fmt:message key="docs.title"/></h2>
                <p><fmt:message key="cabinet.your_documents"/></p>
            </div>
            <a href="${pageContext.request.contextPath}/cabinet/documents/new?lang=${pageContext.response.locale.language}" class="btn btn-primary">
                <svg viewBox="0 0 24 24"><path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/></svg>
                <fmt:message key="docs.new"/>
            </a>
        </div>

        <c:if test="${not isPremium}">
            <div style="background: linear-gradient(135deg, rgba(0,212,170,0.08), rgba(0,163,255,0.08)); border: 1px solid rgba(0,212,170,0.2); border-radius: 12px; padding: 12px 16px; margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 12px;">
                <div style="display: flex; align-items: center; gap: 12px;">
                    <svg viewBox="0 0 24 24" width="20" height="20" style="fill:#00d4aa;"><path d="M20 4H4c-1.11 0-1.99.89-1.99 2L2 18c0 1.11.89 2 2 2h16c1.11 0 2-.89 2-2V6c0-1.11-.89-2-2-2zm0 14H4v-6h16v6zm0-10H4V6h16v2z"/></svg>
                    <span style="color: #e5e5e5; font-size: 13px;">
                        <fmt:message key="docs.used"/>: <strong>${documentCount}</strong> / ${freemiumLimit} <fmt:message key="docs.count"/>
                    </span>
                </div>
                <a href="${pageContext.request.contextPath}/payment/upgrade?lang=${pageContext.response.locale.language}" class="btn" style="background: linear-gradient(135deg, #00d4aa, #00a3ff); color: #0a0e17; font-size: 12px; padding: 8px 16px;">
                    <fmt:message key="payment.upgrade.button"/>
                </a>
            </div>
        </c:if>

        <!-- DEBUG: documents count = ${documents.size()} -->
        
        <c:forEach var="doc" items="${documents}" varStatus="loop">
            <div style="background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); border-radius: 12px; padding: 16px; margin-bottom: 12px;">
                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <div>
                        <a href="${pageContext.request.contextPath}/cabinet/documents/${doc.id}/view" style="color: #fff; font-weight: 600; text-decoration: none; font-size: 16px;">${doc.title}</a>
                        <div style="color: #6b7280; font-size: 12px; margin-top: 4px;">${doc.fileCount} files</div>
                    </div>
                    <div style="display: flex; gap: 8px; align-items: center;">
                        <a href="${pageContext.request.contextPath}/cabinet/documents/${doc.id}/view" style="background: linear-gradient(135deg, #00d4aa, #00a3ff); color: #0a0e17; padding: 8px 16px; border-radius: 8px; text-decoration: none; font-size: 13px; font-weight: 600;">
                            View
                        </a>
                        <a href="${pageContext.request.contextPath}/cabinet/documents/${doc.id}/edit" style="background: rgba(255,255,255,0.1); color: #00d4aa; border: 1px solid rgba(0,212,170,0.3); padding: 8px 16px; border-radius: 8px; text-decoration: none; font-size: 13px; font-weight: 600;">
                            Edit
                        </a>
                        <form method="post" action="${pageContext.request.contextPath}/cabinet/documents/${doc.id}/delete">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <button type="submit" style="background: rgba(239,68,68,0.2); color: #f87171; border: 1px solid rgba(239,68,68,0.4); padding: 8px 12px; border-radius: 8px; cursor: pointer;" onclick="return confirm('Delete document?')">X</button>
                        </form>
                    </div>
                </div>
            </div>
        </c:forEach>
        
        <c:if test="${documents.size() == 0}">
            <div class="empty-state">
                <svg viewBox="0 0 24 24"><path d="M14 2H6c-1.1 0-1.99.9-1.99 2L4 20c0 1.1.89 2 1.99 2H18c1.1 0 2-.9 2-2V8l-6-6zm2 16H8v-2h8v2zm0-4H8v-2h8v2zm-3-5V3.5L18.5 9H13z"/></svg>
                <h3><fmt:message key="docs.empty"/></h3>
                <p><fmt:message key="docs.empty_hint"/></p>
            </div>
        </c:if>
    </main>
    
    <script>
        if (window.Telegram && Telegram.WebApp) {
            Telegram.WebApp.ready();
            Telegram.WebApp.expand();
            Telegram.WebApp.setHeaderColor('#0a0e17');
            Telegram.WebApp.setBackgroundColor('#0a0e17');
            
            const user = Telegram.WebApp.initDataUnsafe.user;
            if (user) {
                document.body.dataset.telegramId = user.id;
                document.body.dataset.telegramUser = JSON.stringify(user);
            }
            
            Telegram.WebApp.MainButton.setText('Open Menu').show();
        }
    </script>
</body>
</html>
