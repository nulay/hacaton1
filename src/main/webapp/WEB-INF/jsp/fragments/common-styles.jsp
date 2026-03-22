<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    background: #0a0e17;
    color: #e5e5e5;
    min-height: 100vh;
    line-height: 1.6;
}

a {
    color: inherit;
    text-decoration: none;
}

.header {
    background: rgba(13, 17, 28, 0.95);
    border-bottom: 1px solid rgba(255, 255, 255, 0.05);
    padding: 16px 0;
    position: sticky;
    top: 0;
    z-index: 100;
    backdrop-filter: blur(20px);
}

.header-content {
    max-width: 1400px;
    margin: 0 auto;
    padding: 0 24px;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.logo {
    display: flex;
    align-items: center;
    gap: 12px;
}

.logo-icon {
    width: 42px;
    height: 42px;
    background: linear-gradient(135deg, #00d4aa 0%, #00a3ff 100%);
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 4px 20px rgba(0, 212, 170, 0.3);
}

.logo-icon svg {
    width: 24px;
    height: 24px;
    fill: #0a0e17;
}

.logo h1 {
    font-size: 20px;
    font-weight: 700;
    background: linear-gradient(135deg, #00d4aa, #00a3ff);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
}

.user-menu {
    display: flex;
    align-items: center;
    gap: 16px;
}

.user-info {
    display: flex;
    align-items: center;
    gap: 12px;
}

.user-avatar {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background: linear-gradient(135deg, #00d4aa 0%, #00a3ff 100%);
    display: flex;
    align-items: center;
    justify-content: center;
}

.user-avatar svg {
    width: 20px;
    height: 20px;
    fill: #0a0e17;
}

.user-name {
    font-weight: 600;
    font-size: 14px;
    color: #fff;
}

.user-email {
    font-size: 12px;
    color: #6b7280;
}

.logout-btn {
    background: rgba(255, 255, 255, 0.05);
    color: #e5e5e5;
    border: 1px solid rgba(255, 255, 255, 0.1);
    padding: 10px 20px;
    border-radius: 10px;
    cursor: pointer;
    font-size: 14px;
    font-weight: 500;
    transition: all 0.3s ease;
    display: flex;
    align-items: center;
    gap: 8px;
}

.logout-btn:hover {
    background: rgba(255, 255, 255, 0.1);
    border-color: #00d4aa;
}

.logout-btn svg {
    width: 16px;
    height: 16px;
    fill: currentColor;
}

.main-content {
    max-width: 1400px;
    margin: 0 auto;
    padding: 32px 24px;
}

.back-link {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    color: #00d4aa;
    text-decoration: none;
    font-weight: 500;
    margin-bottom: 24px;
    transition: all 0.3s;
}

.back-link:hover {
    gap: 12px;
    color: #00a3ff;
}

.back-link svg {
    width: 20px;
    height: 20px;
    fill: currentColor;
}

.page-header {
    margin-bottom: 32px;
}

.page-header h2 {
    color: #fff;
    font-size: 32px;
    font-weight: 700;
    margin-bottom: 8px;
}

.page-header p {
    color: #6b7280;
    font-size: 16px;
}

.card {
    background: linear-gradient(135deg, rgba(255, 255, 255, 0.03) 0%, rgba(255, 255, 255, 0.01) 100%);
    border: 1px solid rgba(255, 255, 255, 0.05);
    border-radius: 20px;
    padding: 28px;
    margin-bottom: 24px;
    backdrop-filter: blur(10px);
}

.card-header {
    display: flex;
    align-items: center;
    gap: 16px;
    margin-bottom: 24px;
    padding-bottom: 20px;
    border-bottom: 1px solid rgba(255, 255, 255, 0.05);
}

.card-icon {
    width: 48px;
    height: 48px;
    background: linear-gradient(135deg, #00d4aa 0%, #00a3ff 100%);
    border-radius: 14px;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 4px 20px rgba(0, 212, 170, 0.3);
}

.card-icon svg {
    width: 24px;
    height: 24px;
    fill: #0a0e17;
}

.card-title {
    color: #fff;
    font-size: 18px;
    font-weight: 600;
}

.card-subtitle {
    color: #6b7280;
    font-size: 13px;
    margin-top: 2px;
}

.info-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 16px;
    margin-bottom: 24px;
}

.info-item {
    background: rgba(255, 255, 255, 0.03);
    border: 1px solid rgba(255, 255, 255, 0.05);
    padding: 16px;
    border-radius: 14px;
}

.info-label {
    color: #6b7280;
    font-size: 12px;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    margin-bottom: 6px;
}

.info-value {
    color: #fff;
    font-size: 16px;
    font-weight: 600;
}

.form-group {
    margin-bottom: 20px;
}

.form-group label {
    display: block;
    color: #9ca3af;
    font-size: 14px;
    font-weight: 500;
    margin-bottom: 8px;
}

.form-group input,
.form-group textarea,
.form-group select {
    width: 100%;
    padding: 14px 16px;
    background: rgba(255, 255, 255, 0.03);
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 12px;
    font-size: 15px;
    font-family: inherit;
    color: #fff;
    transition: all 0.3s ease;
    outline: none;
}

.form-group input:focus,
.form-group textarea:focus,
.form-group select:focus {
    border-color: #00d4aa;
    box-shadow: 0 0 0 3px rgba(0, 212, 170, 0.1);
}

.form-group input[readonly] {
    opacity: 0.6;
    cursor: not-allowed;
}

.btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    padding: 14px 28px;
    border-radius: 12px;
    font-size: 15px;
    font-weight: 600;
    text-decoration: none;
    transition: all 0.3s ease;
    cursor: pointer;
    border: none;
}

.btn svg {
    width: 18px;
    height: 18px;
    fill: currentColor;
}

.btn-primary {
    background: linear-gradient(135deg, #00d4aa 0%, #00a3ff 100%);
    color: #0a0e17;
    box-shadow: 0 4px 20px rgba(0, 212, 170, 0.3);
}

.btn-primary:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 30px rgba(0, 212, 170, 0.4);
}

.btn-success {
    background: linear-gradient(135deg, #10b981 0%, #059669 100%);
    color: #fff;
}

.btn-success:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 30px rgba(16, 185, 129, 0.4);
}

.btn-outline {
    background: transparent;
    color: #00d4aa;
    border: 1px solid #00d4aa;
}

.btn-outline:hover {
    background: rgba(0, 212, 170, 0.1);
}

.btn-block {
    width: 100%;
}

.nav-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 20px;
}

.nav-card {
    background: linear-gradient(135deg, rgba(255, 255, 255, 0.03) 0%, rgba(255, 255, 255, 0.01) 100%);
    border: 1px solid rgba(255, 255, 255, 0.05);
    border-radius: 20px;
    padding: 28px;
    transition: all 0.3s ease;
    display: flex;
    align-items: flex-start;
    gap: 20px;
}

.nav-card:hover {
    transform: translateY(-5px);
    border-color: rgba(0, 212, 170, 0.3);
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
}

.nav-icon {
    width: 56px;
    height: 56px;
    border-radius: 16px;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
}

.nav-icon svg {
    width: 28px;
    height: 28px;
    fill: #fff;
}

.nav-icon.blue {
    background: linear-gradient(135deg, #00d4aa 0%, #00a3ff 100%);
    box-shadow: 0 4px 20px rgba(0, 212, 170, 0.3);
}

.nav-icon.green {
    background: linear-gradient(135deg, #10b981 0%, #059669 100%);
    box-shadow: 0 4px 20px rgba(16, 185, 129, 0.3);
}

.nav-icon.purple {
    background: linear-gradient(135deg, #8b5cf6 0%, #6366f1 100%);
    box-shadow: 0 4px 20px rgba(139, 92, 246, 0.3);
}

.nav-text h3 {
    color: #fff;
    font-size: 18px;
    font-weight: 600;
    margin-bottom: 8px;
}

.nav-text p {
    color: #6b7280;
    font-size: 14px;
    line-height: 1.5;
}

.role-badge {
    display: inline-block;
    padding: 6px 14px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 600;
    margin-top: 12px;
}

.role-badge.admin {
    background: rgba(59, 130, 246, 0.2);
    color: #60a5fa;
    border: 1px solid rgba(59, 130, 246, 0.3);
}

.role-badge.user {
    background: rgba(16, 185, 129, 0.2);
    color: #34d399;
    border: 1px solid rgba(16, 185, 129, 0.3);
}

.role-badge.doctor {
    background: rgba(139, 92, 246, 0.2);
    color: #a78bfa;
    border: 1px solid rgba(139, 92, 246, 0.3);
}

.profile-header-card {
    background: linear-gradient(135deg, rgba(0, 212, 170, 0.1) 0%, rgba(0, 163, 255, 0.1) 100%);
    border: 1px solid rgba(0, 212, 170, 0.2);
    border-radius: 24px;
    padding: 32px;
    margin-bottom: 24px;
    display: flex;
    align-items: center;
    gap: 28px;
    flex-wrap: wrap;
}

.profile-avatar {
    width: 100px;
    height: 100px;
    border-radius: 50%;
    background: linear-gradient(135deg, #00d4aa 0%, #00a3ff 100%);
    display: flex;
    align-items: center;
    justify-content: center;
    overflow: hidden;
    flex-shrink: 0;
    border: 3px solid rgba(0, 212, 170, 0.3);
    box-shadow: 0 8px 30px rgba(0, 212, 170, 0.3);
}

.profile-avatar img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.profile-avatar svg {
    width: 50px;
    height: 50px;
    fill: #0a0e17;
}

.profile-header-info {
    flex: 1;
    min-width: 200px;
}

.profile-title {
    color: #fff;
    font-size: 28px;
    font-weight: 700;
    margin-bottom: 6px;
}

.profile-subtitle {
    color: #6b7280;
    font-size: 14px;
    margin-bottom: 10px;
}

.edit-btn {
    margin-left: auto;
}

.doctors-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
    gap: 24px;
}

.doctor-card {
    background: linear-gradient(135deg, rgba(255, 255, 255, 0.03) 0%, rgba(255, 255, 255, 0.01) 100%);
    border: 1px solid rgba(255, 255, 255, 0.05);
    border-radius: 20px;
    overflow: hidden;
    transition: all 0.3s ease;
}

.doctor-card:hover {
    transform: translateY(-5px);
    border-color: rgba(0, 212, 170, 0.3);
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
}

.doctor-card-content {
    padding: 24px;
}

.doctor-header {
    display: flex;
    gap: 16px;
    margin-bottom: 20px;
}

.doctor-photo {
    width: 70px;
    height: 70px;
    border-radius: 16px;
    background: linear-gradient(135deg, #00d4aa 0%, #00a3ff 100%);
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
    overflow: hidden;
    box-shadow: 0 4px 20px rgba(0, 212, 170, 0.3);
}

.doctor-photo img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.doctor-photo svg {
    width: 32px;
    height: 32px;
    fill: #0a0e17;
}

.doctor-info h3 {
    color: #fff;
    font-size: 18px;
    font-weight: 600;
    margin-bottom: 8px;
}

.specialization {
    display: inline-block;
    background: rgba(0, 212, 170, 0.15);
    color: #00d4aa;
    padding: 5px 12px;
    border-radius: 20px;
    font-size: 13px;
    font-weight: 500;
    border: 1px solid rgba(0, 212, 170, 0.2);
}

.profile-card {
    background: linear-gradient(135deg, rgba(255, 255, 255, 0.03) 0%, rgba(255, 255, 255, 0.01) 100%);
    border: 1px solid rgba(255, 255, 255, 0.05);
    border-radius: 24px;
    overflow: hidden;
}

.profile-header {
    background: linear-gradient(135deg, rgba(0, 212, 170, 0.15) 0%, rgba(0, 163, 255, 0.15) 100%);
    padding: 48px 32px;
    text-align: center;
    border-bottom: 1px solid rgba(255, 255, 255, 0.05);
}

.profile-photo {
    width: 120px;
    height: 120px;
    border-radius: 50%;
    background: linear-gradient(135deg, #00d4aa 0%, #00a3ff 100%);
    margin: 0 auto 20px;
    display: flex;
    align-items: center;
    justify-content: center;
    overflow: hidden;
    border: 4px solid rgba(255, 255, 255, 0.1);
    box-shadow: 0 8px 30px rgba(0, 212, 170, 0.3);
}

.profile-photo img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.profile-photo svg {
    width: 50px;
    height: 50px;
    fill: #0a0e17;
}

.profile-name {
    font-size: 28px;
    font-weight: 700;
    color: #fff;
    margin-bottom: 12px;
}

.specialization-badge {
    display: inline-block;
    background: rgba(0, 212, 170, 0.2);
    color: #00d4aa;
    padding: 8px 20px;
    border-radius: 25px;
    font-size: 14px;
    font-weight: 500;
    border: 1px solid rgba(0, 212, 170, 0.3);
}

.profile-body {
    padding: 32px;
}

.info-section {
    margin-bottom: 32px;
}

.section-title {
    display: flex;
    align-items: center;
    gap: 12px;
    color: #fff;
    font-size: 18px;
    font-weight: 600;
    margin-bottom: 16px;
}

.section-title svg {
    width: 22px;
    height: 22px;
    fill: #00d4aa;
}

.diplomas-list {
    display: flex;
    flex-direction: column;
    gap: 12px;
}

.diploma-item {
    display: flex;
    align-items: center;
    gap: 16px;
    background: rgba(255, 255, 255, 0.03);
    border: 1px solid rgba(255, 255, 255, 0.05);
    padding: 16px 20px;
    border-radius: 14px;
    transition: all 0.3s;
}

.diploma-item:hover {
    background: rgba(0, 212, 170, 0.05);
    border-color: rgba(0, 212, 170, 0.2);
}

.diploma-icon {
    width: 40px;
    height: 40px;
    background: linear-gradient(135deg, #00d4aa 0%, #00a3ff 100%);
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
}

.diploma-icon svg {
    width: 20px;
    height: 20px;
    fill: #0a0e17;
}

.diploma-title {
    color: #e5e5e5;
    font-size: 15px;
    font-weight: 500;
}

.diploma-form {
    display: flex;
    gap: 12px;
    margin-bottom: 20px;
    flex-wrap: wrap;
}

.diploma-form input {
    flex: 1;
    min-width: 200px;
    padding: 14px 16px;
    background: rgba(255, 255, 255, 0.03);
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 12px;
    font-size: 15px;
    color: #fff;
    outline: none;
    transition: all 0.3s ease;
}

.diploma-form input:focus {
    border-color: #00d4aa;
    box-shadow: 0 0 0 3px rgba(0, 212, 170, 0.1);
}

.empty-state {
    text-align: center;
    padding: 48px 20px;
    color: #6b7280;
}

.empty-state svg {
    width: 50px;
    height: 50px;
    fill: #374151;
    margin-bottom: 16px;
}

.actions {
    display: flex;
    gap: 16px;
    flex-wrap: wrap;
    margin-top: 32px;
}

@media (max-width: 768px) {
    .header-content {
        flex-direction: column;
        gap: 16px;
    }
    .main-content {
        padding: 20px 16px;
    }
    .page-header h2 {
        font-size: 24px;
    }
    .info-grid {
        grid-template-columns: 1fr;
    }
    .doctors-grid {
        grid-template-columns: 1fr;
    }
    .profile-header-card {
        flex-direction: column;
        text-align: center;
    }
    .edit-btn {
        margin-left: 0;
        width: 100%;
    }
    .nav-grid {
        grid-template-columns: 1fr;
    }
}
</style>
