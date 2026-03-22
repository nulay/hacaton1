<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Medical Archive - Electronic Medical Document Management</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --primary: #00d4aa;
            --primary-dark: #00b894;
            --secondary: #00a3ff;
            --bg-dark: #0a0e17;
            --bg-card: rgba(255, 255, 255, 0.03);
            --text-primary: #ffffff;
            --text-secondary: #9ca3af;
            --text-muted: #6b7280;
            --border: rgba(255, 255, 255, 0.08);
            --border-hover: rgba(255, 255, 255, 0.15);
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: var(--bg-dark);
            color: var(--text-primary);
            line-height: 1.6;
            overflow-x: hidden;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 24px;
        }

        /* Navigation */
        nav {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1000;
            padding: 20px 0;
            background: rgba(10, 14, 23, 0.8);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid var(--border);
        }

        nav .container {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
            color: var(--text-primary);
        }

        .logo-icon {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .logo-icon svg {
            width: 22px;
            height: 22px;
            fill: var(--bg-dark);
        }

        .logo-text {
            font-size: 20px;
            font-weight: 700;
        }

        .nav-links {
            display: flex;
            gap: 32px;
            list-style: none;
        }

        .nav-links a {
            color: var(--text-secondary);
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: color 0.3s;
        }

        .nav-links a:hover {
            color: var(--primary);
        }

        .nav-buttons {
            display: flex;
            gap: 12px;
        }

        .btn {
            padding: 10px 20px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s;
            cursor: pointer;
            border: none;
        }

        .btn-outline {
            background: transparent;
            color: var(--primary);
            border: 1px solid var(--primary);
        }

        .btn-outline:hover {
            background: rgba(0, 212, 170, 0.1);
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: var(--bg-dark);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(0, 212, 170, 0.4);
        }

        /* Hero Section */
        .hero {
            min-height: 100vh;
            display: flex;
            align-items: center;
            padding: 120px 0 80px;
            position: relative;
            overflow: hidden;
        }

        .hero::before {
            content: '';
            position: absolute;
            top: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 800px;
            height: 800px;
            background: radial-gradient(circle, rgba(0, 212, 170, 0.15) 0%, transparent 70%);
            pointer-events: none;
        }

        .hero-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 60px;
            align-items: center;
        }

        .hero-content h1 {
            font-size: 56px;
            font-weight: 800;
            line-height: 1.1;
            margin-bottom: 24px;
        }

        .hero-content h1 span {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .hero-content p {
            font-size: 18px;
            color: var(--text-secondary);
            margin-bottom: 32px;
            max-width: 500px;
        }

        .hero-buttons {
            display: flex;
            gap: 16px;
            flex-wrap: wrap;
        }

        .hero-buttons .btn {
            padding: 14px 28px;
            font-size: 16px;
        }

        .hero-image {
            position: relative;
        }

        .hero-card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 24px;
            padding: 32px;
            backdrop-filter: blur(20px);
        }

        .hero-card-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 24px;
            padding-bottom: 16px;
            border-bottom: 1px solid var(--border);
        }

        .hero-card-header .icon {
            width: 48px;
            height: 48px;
            background: linear-gradient(135deg, rgba(0, 212, 170, 0.2), rgba(0, 163, 255, 0.2));
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .hero-card-header .icon svg {
            width: 24px;
            height: 24px;
            fill: var(--primary);
        }

        .hero-card-header h3 {
            font-size: 16px;
            font-weight: 600;
        }

        .hero-card-header p {
            font-size: 12px;
            color: var(--text-muted);
            margin: 0;
        }

        .hero-stats {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
        }

        .stat {
            text-align: center;
            padding: 16px;
            background: rgba(255, 255, 255, 0.02);
            border-radius: 12px;
        }

        .stat-value {
            font-size: 28px;
            font-weight: 700;
            color: var(--primary);
        }

        .stat-label {
            font-size: 12px;
            color: var(--text-muted);
            margin-top: 4px;
        }

        /* Features Section */
        .features {
            padding: 100px 0;
        }

        .section-header {
            text-align: center;
            margin-bottom: 60px;
        }

        .section-header h2 {
            font-size: 40px;
            font-weight: 700;
            margin-bottom: 16px;
        }

        .section-header p {
            font-size: 18px;
            color: var(--text-secondary);
            max-width: 600px;
            margin: 0 auto;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 24px;
        }

        .feature-card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 20px;
            padding: 32px;
            transition: all 0.3s;
        }

        .feature-card:hover {
            border-color: var(--primary);
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
        }

        .feature-icon {
            width: 56px;
            height: 56px;
            background: linear-gradient(135deg, rgba(0, 212, 170, 0.2), rgba(0, 163, 255, 0.2));
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
        }

        .feature-icon svg {
            width: 28px;
            height: 28px;
            fill: var(--primary);
        }

        .feature-card h3 {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 12px;
        }

        .feature-card p {
            font-size: 14px;
            color: var(--text-secondary);
            line-height: 1.7;
        }

        /* How It Works */
        .how-it-works {
            padding: 100px 0;
            background: rgba(255, 255, 255, 0.01);
        }

        .steps {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 32px;
            position: relative;
        }

        .step {
            text-align: center;
            position: relative;
        }

        .step-number {
            width: 64px;
            height: 64px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            font-weight: 700;
            color: var(--bg-dark);
            margin: 0 auto 20px;
        }

        .step h3 {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 8px;
        }

        .step p {
            font-size: 14px;
            color: var(--text-secondary);
        }

        /* Pricing */
        .pricing {
            padding: 100px 0;
        }

        .pricing-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 32px;
            max-width: 800px;
            margin: 0 auto;
        }

        .pricing-card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 24px;
            padding: 40px;
            position: relative;
        }

        .pricing-card.featured {
            border-color: var(--primary);
            background: linear-gradient(135deg, rgba(0, 212, 170, 0.05), rgba(0, 163, 255, 0.05));
        }

        .pricing-card.featured::before {
            content: 'Popular';
            position: absolute;
            top: -12px;
            left: 50%;
            transform: translateX(-50%);
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: var(--bg-dark);
            padding: 4px 16px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .pricing-card h3 {
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 8px;
        }

        .pricing-card .price {
            font-size: 48px;
            font-weight: 800;
            margin-bottom: 24px;
        }

        .pricing-card .price span {
            font-size: 16px;
            font-weight: 400;
            color: var(--text-muted);
        }

        .pricing-features {
            list-style: none;
            margin-bottom: 32px;
        }

        .pricing-features li {
            padding: 12px 0;
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 14px;
            color: var(--text-secondary);
        }

        .pricing-features li:last-child {
            border-bottom: none;
        }

        .pricing-features li svg {
            width: 20px;
            height: 20px;
            fill: var(--primary);
            flex-shrink: 0;
        }

        .pricing-card .btn {
            width: 100%;
            padding: 16px;
        }

        /* CTA */
        .cta {
            padding: 100px 0;
            text-align: center;
        }

        .cta h2 {
            font-size: 40px;
            font-weight: 700;
            margin-bottom: 16px;
        }

        .cta p {
            font-size: 18px;
            color: var(--text-secondary);
            margin-bottom: 32px;
        }

        /* Footer */
        footer {
            padding: 40px 0;
            border-top: 1px solid var(--border);
        }

        footer .container {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        footer p {
            font-size: 14px;
            color: var(--text-muted);
        }

        .footer-links {
            display: flex;
            gap: 24px;
        }

        .footer-links a {
            color: var(--text-secondary);
            text-decoration: none;
            font-size: 14px;
            transition: color 0.3s;
        }

        .footer-links a:hover {
            color: var(--primary);
        }

        /* Mobile Menu */
        .mobile-menu-btn {
            display: none;
            background: none;
            border: none;
            cursor: pointer;
            padding: 8px;
        }

        .mobile-menu-btn span {
            display: block;
            width: 24px;
            height: 2px;
            background: var(--text-primary);
            margin: 6px 0;
            transition: all 0.3s;
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .hero-grid {
                grid-template-columns: 1fr;
                text-align: center;
            }

            .hero-content p {
                margin: 0 auto 32px;
            }

            .hero-buttons {
                justify-content: center;
            }

            .features-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .steps {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 768px) {
            .nav-links, .nav-buttons {
                display: none;
            }

            .mobile-menu-btn {
                display: block;
            }

            .hero-content h1 {
                font-size: 36px;
            }

            .features-grid {
                grid-template-columns: 1fr;
            }

            .steps {
                grid-template-columns: 1fr;
            }

            .pricing-grid {
                grid-template-columns: 1fr;
            }

            footer .container {
                flex-direction: column;
                gap: 16px;
                text-align: center;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav>
        <div class="container">
            <a href="#" class="logo">
                <div class="logo-icon">
                    <svg viewBox="0 0 24 24"><path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 3c1.93 0 3.5 1.57 3.5 3.5S13.93 13 12 13s-3.5-1.57-3.5-3.5S10.07 6 12 6zm7 13H5v-.23c0-.62.28-1.2.76-1.58C7.47 15.82 9.64 15 12 15s4.53.82 6.24 2.19c.48.38.76.97.76 1.58V19z"/></svg>
                </div>
                <span class="logo-text">Medical Archive</span>
            </a>
            <ul class="nav-links">
                <li><a href="#features">Features</a></li>
                <li><a href="#how-it-works">How It Works</a></li>
                <li><a href="#pricing">Pricing</a></li>
            </ul>
            <div class="nav-buttons">
                <a href="/medical-archive/auth/login" class="btn btn-outline">Login</a>
                <a href="/medical-archive/auth/register" class="btn btn-primary">Get Started</a>
            </div>
            <button class="mobile-menu-btn">
                <span></span>
                <span></span>
                <span></span>
            </button>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero">
        <div class="container">
            <div class="hero-grid">
                <div class="hero-content">
                    <h1>Your Medical Documents,<br><span>Securely Stored</span></h1>
                    <p>A modern electronic medical document management system. Store, organize, and access your health records anytime, anywhere with bank-level security.</p>
                    <div class="hero-buttons">
                        <a href="/medical-archive/auth/register" class="btn btn-primary">Start Free Trial</a>
                        <a href="#features" class="btn btn-outline">Learn More</a>
                    </div>
                </div>
                <div class="hero-image">
                    <div class="hero-card">
                        <div class="hero-card-header">
                            <div class="icon">
                                <svg viewBox="0 0 24 24"><path d="M14 2H6c-1.1 0-1.99.9-1.99 2L4 20c0 1.1.89 2 1.99 2H18c1.1 0 2-.9 2-2V8l-6-6zm2 16H8v-2h8v2zm0-4H8v-2h8v2zm-3-5V3.5L18.5 9H13z"/></svg>
                            </div>
                            <div>
                                <h3>Medical Archive</h3>
                                <p>Electronic Document Management</p>
                            </div>
                        </div>
                        <div class="hero-stats">
                            <div class="stat">
                                <div class="stat-value">100%</div>
                                <div class="stat-label">Secure</div>
                            </div>
                            <div class="stat">
                                <div class="stat-value">24/7</div>
                                <div class="stat-label">Access</div>
                            </div>
                            <div class="stat">
                                <div class="stat-value">OCR</div>
                                <div class="stat-label">Included</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section class="features" id="features">
        <div class="container">
            <div class="section-header">
                <h2>Everything You Need</h2>
                <p>Powerful features to manage your medical documents efficiently and securely</p>
            </div>
            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon">
                        <svg viewBox="0 0 24 24"><path d="M14 2H6c-1.1 0-1.99.9-1.99 2L4 20c0 1.1.89 2 1.99 2H18c1.1 0 2-.9 2-2V8l-6-6zm2 16H8v-2h8v2zm0-4H8v-2h8v2zm-3-5V3.5L18.5 9H13z"/></svg>
                    </div>
                    <h3>Document Storage</h3>
                    <p>Upload and store all your medical documents including certificates, lab results, prescriptions, and medical reports in one secure place.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <svg viewBox="0 0 24 24"><path d="M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4zm0 10.99h7c-.53 4.12-3.28 7.79-7 8.94V12H5V6.3l7-3.11v8.8z"/></svg>
                    </div>
                    <h3>Bank-Level Security</h3>
                    <p>Your sensitive health data is protected with industry-standard encryption and secure authentication protocols.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <svg viewBox="0 0 24 24"><path d="M9.4 16.6L4.8 12l4.6-4.6L8 6l-6 6 6 6 1.4-1.4zm5.2 0l4.6-4.6-4.6-4.6L16 6l6 6-6 6-1.4-1.4z"/></svg>
                    </div>
                    <h3>OCR Recognition</h3>
                    <p>Automatically extract text from your documents using advanced OCR technology. Search and organize your records effortlessly.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <svg viewBox="0 0 24 24"><path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 3c1.93 0 3.5 1.57 3.5 3.5S13.93 13 12 13s-3.5-1.57-3.5-3.5S10.07 6 12 6zm7 13H5v-.23c0-.62.28-1.2.76-1.58C7.47 15.82 9.64 15 12 15s4.53.82 6.24 2.19c.48.38.76.97.76 1.58V19z"/></svg>
                    </div>
                    <h3>Doctor Directory</h3>
                    <p>Browse through our directory of verified healthcare professionals. View their specializations, experience, and credentials.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <svg viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/></svg>
                    </div>
                    <h3>Easy Access</h3>
                    <p>Access your documents from any device, anytime. Share specific documents with your healthcare providers when needed.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <svg viewBox="0 0 24 24"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>
                    </div>
                    <h3>Multi-User Support</h3>
                    <p>Secure role-based access for patients, doctors, and administrators. Each user sees only what they need.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- How It Works -->
    <section class="how-it-works" id="how-it-works">
        <div class="container">
            <div class="section-header">
                <h2>How It Works</h2>
                <p>Get started with Medical Archive in just a few simple steps</p>
            </div>
            <div class="steps">
                <div class="step">
                    <div class="step-number">1</div>
                    <h3>Create Account</h3>
                    <p>Sign up for free and verify your email address</p>
                </div>
                <div class="step">
                    <div class="step-number">2</div>
                    <h3>Upload Documents</h3>
                    <p>Upload your medical documents from your device</p>
                </div>
                <div class="step">
                    <div class="step-number">3</div>
                    <h3>Automatic OCR</h3>
                    <p>Our system extracts and indexes text automatically</p>
                </div>
                <div class="step">
                    <div class="step-number">4</div>
                    <h3>Access Anywhere</h3>
                    <p>View and manage your records from any device</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Pricing -->
    <section class="pricing" id="pricing">
        <div class="container">
            <div class="section-header">
                <h2>Simple Pricing</h2>
                <p>Choose the plan that fits your needs</p>
            </div>
            <div class="pricing-grid">
                <div class="pricing-card">
                    <h3>Free</h3>
                    <div class="price">$0 <span>/ forever</span></div>
                    <ul class="pricing-features">
                        <li>
                            <svg viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg>
                            20 documents included
                        </li>
                        <li>
                            <svg viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg>
                            Basic OCR recognition
                        </li>
                        <li>
                            <svg viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg>
                            Doctor directory access
                        </li>
                        <li>
                            <svg viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg>
                            Mobile access
                        </li>
                    </ul>
                    <a href="/medical-archive/auth/register" class="btn btn-outline">Get Started</a>
                </div>
                <div class="pricing-card featured">
                    <h3>Premium</h3>
                    <div class="price">$29 <span>/ once</span></div>
                    <ul class="pricing-features">
                        <li>
                            <svg viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg>
                            Unlimited documents
                        </li>
                        <li>
                            <svg viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg>
                            Advanced OCR processing
                        </li>
                        <li>
                            <svg viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg>
                            Priority support
                        </li>
                        <li>
                            <svg viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg>
                            Secure cloud backup
                        </li>
                        <li>
                            <svg viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg>
                            Lifetime access
                        </li>
                    </ul>
                    <a href="/medical-archive/auth/register" class="btn btn-primary">Upgrade Now</a>
                </div>
            </div>
        </div>
    </section>

    <!-- CTA -->
    <section class="cta">
        <div class="container">
            <h2>Ready to Get Started?</h2>
            <p>Join thousands of users who trust Medical Archive with their health records</p>
            <a href="/medical-archive/auth/register" class="btn btn-primary">Create Free Account</a>
        </div>
    </section>

    <!-- Footer -->
    <footer>
        <div class="container">
            <p>2026 Medical Archive. All rights reserved.</p>
            <div class="footer-links">
                <a href="#">Privacy Policy</a>
                <a href="#">Terms of Service</a>
                <a href="#">Contact</a>
            </div>
        </div>
    </footer>
</body>
</html>
