<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="User.User" %>
<%@ page import="User.Client" %>

<%-- 
    Document   : client-main
    Created on : 5 Jun 2025, 1:30:00 PM
    Author     : Cursor
--%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CarRent - Client Dashboard</title>
    <%@ include file="include/client-css.html" %>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f0f2f5;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            margin: 0;
            padding-top: 56px; /* Adjust for fixed header */
        }

        header {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            z-index: 1000;
        }

        .hero-section {
            background: linear-gradient(135deg, #007bff, #0056b3); /* Modern gradient */
            color: #fff;
            padding: 60px 0;
            text-align: center;
            margin-bottom: 3rem;
            border-radius: 12px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
            position: relative;
            overflow: hidden;
        }

        .hero-section::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, rgba(255,255,255,0) 70%);
            transform: rotate(45deg);
        }

        .hero-section h1 {
            font-size: 3.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }

        .hero-section p {
            font-size: 1.25rem;
            margin-bottom: 2rem;
            max-width: 700px;
            margin-left: auto;
            margin-right: auto;
            line-height: 1.6;
        }

        .card-feature {
            text-align: center;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            height: 100%;
            background-color: #fff;
        }

        .card-feature:hover {
            transform: translateY(-10px);
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.2);
        }

        .card-feature .icon {
            font-size: 3rem;
            color: #007bff;
            margin-bottom: 15px;
        }

        .card-feature h5 {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 15px;
            color: #333;
        }

        .card-feature p {
            color: #666;
            margin-bottom: 20px;
        }

        .section-title {
            font-size: 2.2rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 2.5rem;
            text-align: center;
        }

        .dashboard-card {
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 2.5rem;
            height: 100%;
        }

        .dashboard-card .card-title {
            font-size: 1.8rem;
            font-weight: 600;
            color: #007bff;
            margin-bottom: 1.5rem;
        }

        .dashboard-card .list-unstyled li a {
            font-size: 1.1rem;
            color: #555;
            padding: 0.75rem 0;
            display: flex;
            align-items: center;
            transition: color 0.2s;
        }

        .dashboard-card .list-unstyled li a:hover {
            color: #007bff;
        }

        .dashboard-card .list-unstyled li i {
            margin-right: 12px;
            color: #007bff;
        }

        .dashboard-card .btn {
            margin-top: 1.5rem;
        }

        .quick-access-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }

        .quick-access-grid li a {
            background-color: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 15px 20px;
            display: flex;
            align-items: center;
            text-decoration: none;
            color: #333;
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .quick-access-grid li a:hover {
            background-color: #e2e6ea;
            border-color: #dae0e5;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.05);
        }

        .quick-access-grid li a i {
            font-size: 1.5rem;
            color: #007bff;
            margin-right: 15px;
        }

        @media (max-width: 768px) {
            .hero-section {
                padding: 40px 0;
            }
            .hero-section h1 {
                font-size: 2.5rem;
            }
            .hero-section p {
                font-size: 1rem;
            }
            .section-title {
                font-size: 1.8rem;
            }
            .dashboard-card {
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <%@ include file="include/header.jsp" %>

    <main class="container mt-5 pt-5">
        <% 
            User loggedInUser = (User) session.getAttribute("loggedInUser");
            Client loggedInClient = (Client) session.getAttribute("loggedInClient");

            if (loggedInUser == null || loggedInClient == null) {
                // Redirect to login if not logged in or client object not found
                response.sendRedirect("login.jsp?message=Please+log+in+to+view+your+dashboard.&type=warning");
                return;
            }
        %>

        <section class="hero-section">
            <div class="container">
                <h1>Welcome, <%= loggedInClient.getName() %>!</h1>
                <p>Your journey to the perfect car starts here. Explore our fleet, manage your bookings, and keep your profile updated.</p>
                <a href="cars.jsp" class="btn btn-light btn-lg rounded-pill px-4">Browse Cars <i class="fas fa-arrow-right ms-2"></i></a>
            </div>
        </section>

        <section class="mb-5">
            <h2 class="section-title">Key Features</h2>
            <div class="row row-cols-1 row-cols-md-3 g-4">
                <div class="col">
                    <div class="card-feature">
                        <div class="icon"><i class="fas fa-car"></i></div>
                        <h5>Vast Car Selection</h5>
                        <p>Browse a wide range of vehicles, from economy to luxury, and find the perfect one for your needs.</p>
                        <a href="cars.jsp" class="btn btn-outline-primary btn-sm rounded-pill">View Cars</a>
                    </div>
                </div>
                <div class="col">
                    <div class="card-feature">
                        <div class="icon"><i class="fas fa-calendar-alt"></i></div>
                        <h5>Easy Booking Management</h5>
                        <p>Track your current and past bookings, modify details, or cancel with ease.</p>
                        <a href="mybooking.jsp" class="btn btn-outline-primary btn-sm rounded-pill">My Bookings</a>
                    </div>
                </div>
                <div class="col">
                    <div class="card-feature">
                        <div class="icon"><i class="fas fa-user-circle"></i></div>
                        <h5>Personalized Profile</h5>
                        <p>Keep your profile up-to-date, manage your details, and ensure a smooth experience.</p>
                        <a href="client-profile.jsp" class="btn btn-outline-primary btn-sm rounded-pill">Edit Profile</a>
                    </div>
                </div>
            </div>
        </section>

        <section class="dashboard-sections mb-5">
            <h2 class="section-title">Your Dashboard</h2>
            <div class="row">
                <div class="col-md-6 mb-4">
                    <div class="dashboard-card">
                        <h5 class="card-title">Your Recent Activity</h5>
                        <p class="card-text text-muted">No recent activity to display. Start by browsing cars!</p>
                        <a href="cars.jsp" class="btn btn-outline-primary rounded-pill">Explore Cars <i class="fas fa-arrow-right ms-2"></i></a>
                    </div>
                </div>
                <div class="col-md-6 mb-4">
                    <div class="dashboard-card">
                        <h5 class="card-title">Quick Access</h5>
                        <ul class="list-unstyled quick-access-grid">
                            <li><a href="cars.jsp"><i class="fas fa-car"></i>View All Cars</a></li>
                            <li><a href="mybooking.jsp"><i class="fas fa-calendar-alt"></i>Check Your Bookings</a></li>
                            <li><a href="client-profile.jsp"><i class="fas fa-user-circle"></i>Update Your Profile</a></li>
                            <li><a href="LogoutServlet"><i class="fas fa-sign-out-alt"></i>Logout</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </section>

    </main>

    <%@ include file="include/footer.jsp" %>
</body>
</html> 