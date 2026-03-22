<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="${pageContext.response.locale.language}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Panel - <fmt:message key="app.title"/></title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; background: linear-gradient(135deg, #0a0e17 0%, #1a1f2e 100%); min-height: 100vh; color: #fff; }
        .header { background: rgba(255,255,255,0.03); border-bottom: 1px solid rgba(255,255,255,0.05); padding: 16px 32px; }
        .header-content { max-width: 1400px; margin: 0 auto; display: flex; justify-content: space-between; align-items: center; }
        .logo { display: flex; align-items: center; gap: 12px; }
        .logo-icon { width: 40px; height: 40px; background: linear-gradient(135deg, #00d4aa, #00a3ff); border-radius: 10px; display: flex; align-items: center; justify-content: center; }
        .logo-icon svg { width: 22px; height: 22px; fill: #0a0e17; }
        .logo h1 { font-size: 18px; font-weight: 600; }
        .main-content { max-width: 1400px; margin: 0 auto; padding: 32px; }
        .page-header { margin-bottom: 32px; }
        .page-header h2 { font-size: 28px; margin-bottom: 8px; background: linear-gradient(135deg, #00d4aa, #00a3ff); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 32px; }
        .stat-card { background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.08); border-radius: 16px; padding: 24px; text-align: center; }
        .stat-value { font-size: 36px; font-weight: 700; background: linear-gradient(135deg, #00d4aa, #00a3ff); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        .stat-label { color: #6b7280; font-size: 14px; margin-top: 8px; }
        .stat-card.premium { border-color: rgba(251,191,36,0.3); }
        .stat-card.premium .stat-value { background: linear-gradient(135deg, #fbbf24, #f59e0b); -webkit-background-clip: text; }
        .card { background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.08); border-radius: 16px; padding: 24px; margin-bottom: 24px; }
        .card-title { font-size: 18px; font-weight: 600; margin-bottom: 20px; color: #fff; }
        table { width: 100%; border-collapse: collapse; }
        th, td { text-align: left; padding: 12px 16px; border-bottom: 1px solid rgba(255,255,255,0.05); }
        th { color: #6b7280; font-size: 12px; text-transform: uppercase; letter-spacing: 0.05em; }
        td { font-size: 14px; color: #e5e5e5; }
        tr:hover { background: rgba(255,255,255,0.02); }
        .badge { display: inline-block; padding: 4px 10px; border-radius: 20px; font-size: 11px; font-weight: 600; text-transform: uppercase; }
        .badge-premium { background: rgba(251,191,36,0.2); color: #fbbf24; }
        .badge-free { background: rgba(0,212,170,0.2); color: #00d4aa; }
        .badge-admin { background: rgba(239,68,68,0.2); color: #f87171; }
        .badge-doctor { background: rgba(59,130,246,0.2); color: #60a5fa; }
        .badge-user { background: rgba(107,114,128,0.2); color: #9ca3af; }
        .btn { display: inline-flex; align-items: center; gap: 6px; padding: 8px 16px; border-radius: 8px; font-size: 13px; font-weight: 600; cursor: pointer; text-decoration: none; transition: all 0.2s; border: none; }
        .btn-sm { padding: 6px 12px; font-size: 12px; }
        .btn-primary { background: linear-gradient(135deg, #00d4aa, #00a3ff); color: #0a0e17; }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 8px 30px rgba(0,212,170,0.3); }
        .btn-outline { background: transparent; border: 1px solid rgba(255,255,255,0.1); color: #e5e5e5; }
        .btn-outline:hover { border-color: #00d4aa; color: #00d4aa; }
        .btn-warning { background: rgba(251,191,36,0.2); color: #fbbf24; border: 1px solid rgba(251,191,36,0.3); }
        .search-box { width: 100%; padding: 12px 16px; background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); border-radius: 10px; color: #fff; font-size: 14px; margin-bottom: 20px; }
        .search-box::placeholder { color: #6b7280; }
        .search-box:focus { outline: none; border-color: #00d4aa; }
        .user-info { display: flex; align-items: center; gap: 12px; }
        .user-avatar { width: 36px; height: 36px; border-radius: 50%; background: linear-gradient(135deg, #00d4aa, #00a3ff); display: flex; align-items: center; justify-content: center; font-weight: 600; font-size: 14px; color: #0a0e17; }
        .nav-links { display: flex; gap: 16px; }
        .nav-link { color: #6b7280; text-decoration: none; font-size: 14px; transition: color 0.2s; }
        .nav-link:hover { color: #00d4aa; }
        .nav-link.active { color: #00d4aa; }
        @media (max-width: 768px) { .stats-grid { grid-template-columns: repeat(2, 1fr); } }
    </style>
</head>
<body>
    <header class="header">
        <div class="header-content">
            <div class="logo">
                <div class="logo-icon">
                    <svg viewBox="0 0 24 24"><path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 3c1.93 0 3.5 1.57 3.5 3.5S13.93 13 12 13s-3.5-1.57-3.5-3.5S10.07 6 12 6zm7 13H5v-.23c0-.62.28-1.2.76-1.58C7.47 15.82 9.64 15 12 15s4.53.82 6.24 2.19c.48.38.76.97.76 1.58V19z"/></svg>
                </div>
                <h1>Medical Archive <span style="color:#00d4aa;">Admin</span></h1>
            </div>
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/cabinet" class="nav-link active">Dashboard</a>
                <a href="${pageContext.request.contextPath}/cabinet/documents" class="nav-link">Documents</a>
                <form method="post" action="${pageContext.request.contextPath}/auth/logout" style="display:inline;">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <button type="submit" class="btn btn-outline btn-sm">Logout</button>
                </form>
            </div>
        </div>
    </header>

    <main class="main-content">
        <div class="page-header">
            <h2>Admin Dashboard</h2>
            <p style="color:#6b7280;">System overview and user management</p>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-value">${totalUsers}</div>
                <div class="stat-label">Total Users</div>
            </div>
            <div class="stat-card premium">
                <div class="stat-value">${premiumUsers}</div>
                <div class="stat-label">Premium Users</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">${freeUsers}</div>
                <div class="stat-label">Free Users</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">$${String.format("%.2f", revenue)}</div>
                <div class="stat-label">Est. Revenue</div>
            </div>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-value">${patients}</div>
                <div class="stat-label">Patients</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">${doctors}</div>
                <div class="stat-label">Doctors</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">${admins}</div>
                <div class="stat-label">Admins</div>
            </div>
            <div class="stat-card premium">
                <div class="stat-value">${conversionRate}%</div>
                <div class="stat-label">Conversion Rate</div>
            </div>
        </div>

        <div class="card">
            <h3 class="card-title">Users (${totalUsers})</h3>
            <input type="text" class="search-box" placeholder="Search users..." onkeyup="filterTable(this.value)">
            <table id="usersTable">
                <thead>
                    <tr>
                        <th>User</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Subscription</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="user" items="${users}">
                        <tr data-name="${user.lastName} ${user.firstName} ${user.email}">
                            <td>
                                <div class="user-info">
                                    <div class="user-avatar">${user.lastName != null ? user.lastName.charAt(0) : 'U'}</div>
                                    <div>
                                        <div style="font-weight:500;">${user.lastName} ${user.firstName}</div>
                                        <div style="color:#6b7280; font-size:12px;">${user.middleName}</div>
                                    </div>
                                </div>
                            </td>
                            <td>${user.email}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${user.role == 'ADMIN'}"><span class="badge badge-admin">Admin</span></c:when>
                                    <c:when test="${user.role == 'DOCTOR'}"><span class="badge badge-doctor">Doctor</span></c:when>
                                    <c:otherwise><span class="badge badge-user">User</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${user.premium}"><span class="badge badge-premium">Premium</span></c:when>
                                    <c:otherwise><span class="badge badge-free">Free</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${user.premium && user.premiumUntil != null}">Until: ${user.premiumUntil}</c:when>
                                    <c:when test="${user.premium}">Unlimited</c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <form method="post" action="${pageContext.request.contextPath}/admin/user/toggle-premium" style="display:inline;">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                    <input type="hidden" name="userId" value="${user.id}" />
                                    <button type="submit" class="btn btn-sm ${user.premium ? 'btn-warning' : 'btn-primary'}">
                                        ${user.premium ? 'Remove Premium' : 'Give Premium'}
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </main>

    <script>
        function filterTable(search) {
            const rows = document.querySelectorAll('#usersTable tbody tr');
            search = search.toLowerCase();
            rows.forEach(row => {
                const name = row.getAttribute('data-name').toLowerCase();
                row.style.display = name.includes(search) ? '' : 'none';
            });
        }
    </script>
</body>
</html>
