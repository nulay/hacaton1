<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    background: #0a0e17;
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 20px;
}

.page-container {
    width: 100%;
    max-width: 440px;
    animation: fadeIn 0.5s ease;
}

@keyframes fadeIn {
    from { opacity: 0; transform: translateY(20px); }
    to { opacity: 1; transform: translateY(0); }
}

.form-container {
    background: linear-gradient(135deg, rgba(255, 255, 255, 0.03) 0%, rgba(255, 255, 255, 0.01) 100%);
    border: 1px solid rgba(255, 255, 255, 0.08);
    border-radius: 24px;
    padding: 40px;
    backdrop-filter: blur(20px);
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.5);
}

.form-container.wide {
    max-width: 500px;
}

.logo {
    text-align: center;
    margin-bottom: 32px;
}

.logo-icon {
    width: 72px;
    height: 72px;
    background: linear-gradient(135deg, #00d4aa 0%, #00a3ff 100%);
    border-radius: 20px;
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto 16px;
    box-shadow: 0 8px 30px rgba(0, 212, 170, 0.4);
}

.logo-icon svg {
    width: 36px;
    height: 36px;
    fill: #0a0e17;
}

.logo h1 {
    color: #fff;
    font-size: 26px;
    font-weight: 700;
    margin-bottom: 8px;
}

.logo p {
    color: #6b7280;
    font-size: 14px;
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
.form-group select {
    width: 100%;
    padding: 14px 16px;
    background: rgba(255, 255, 255, 0.03);
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 12px;
    font-size: 15px;
    color: #fff;
    transition: all 0.3s ease;
    outline: none;
}

.form-group input:focus,
.form-group select:focus {
    border-color: #00d4aa;
    box-shadow: 0 0 0 3px rgba(0, 212, 170, 0.15);
}

.form-group input::placeholder {
    color: #4b5563;
}

.btn {
    width: 100%;
    padding: 16px;
    background: linear-gradient(135deg, #00d4aa 0%, #00a3ff 100%);
    color: #0a0e17;
    border: none;
    border-radius: 12px;
    font-size: 16px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    margin-top: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
}

.btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 30px rgba(0, 212, 170, 0.4);
}

.btn svg {
    width: 18px;
    height: 18px;
    fill: currentColor;
}

.alert {
    padding: 14px 16px;
    border-radius: 12px;
    margin-bottom: 20px;
    font-size: 14px;
}

.alert-error {
    background: rgba(239, 68, 68, 0.15);
    color: #f87171;
    border: 1px solid rgba(239, 68, 68, 0.3);
}

.alert-success {
    background: rgba(16, 185, 129, 0.15);
    color: #34d399;
    border: 1px solid rgba(16, 185, 129, 0.3);
}

.footer-link {
    text-align: center;
    margin-top: 24px;
    color: #6b7280;
    font-size: 14px;
}

.footer-link a {
    color: #00d4aa;
    text-decoration: none;
    font-weight: 500;
    transition: color 0.3s;
}

.footer-link a:hover {
    color: #00a3ff;
}

.name-fields {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 12px;
}

.name-fields .form-group:first-child {
    grid-column: 1 / -1;
}

.features {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
    gap: 16px;
    margin: 40px 0;
}

.feature {
    background: rgba(255, 255, 255, 0.03);
    border: 1px solid rgba(255, 255, 255, 0.05);
    border-radius: 16px;
    padding: 24px 16px;
    text-align: center;
    transition: all 0.3s ease;
}

.feature:hover {
    background: rgba(0, 212, 170, 0.05);
    border-color: rgba(0, 212, 170, 0.2);
    transform: translateY(-4px);
}

.feature-icon {
    width: 48px;
    height: 48px;
    background: linear-gradient(135deg, rgba(0, 212, 170, 0.2) 0%, rgba(0, 163, 255, 0.2) 100%);
    border-radius: 14px;
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto 14px;
}

.feature-icon svg {
    width: 24px;
    height: 24px;
    fill: #00d4aa;
}

.feature h3 {
    color: #fff;
    font-size: 14px;
    font-weight: 600;
    margin-bottom: 6px;
}

.feature p {
    color: #6b7280;
    font-size: 12px;
}

.buttons {
    display: flex;
    gap: 12px;
    justify-content: center;
    flex-wrap: wrap;
}

.btn-outline {
    background: transparent;
    color: #00d4aa;
    border: 1px solid #00d4aa;
}

.btn-outline:hover {
    background: rgba(0, 212, 170, 0.1);
}

@media (max-width: 480px) {
    .form-container {
        padding: 28px 24px;
    }
    .name-fields {
        grid-template-columns: 1fr;
    }
    .name-fields .form-group:first-child {
        grid-column: auto;
    }
    .features {
        grid-template-columns: 1fr;
    }
    .buttons {
        flex-direction: column;
    }
    .btn {
        width: 100%;
    }
}
</style>
