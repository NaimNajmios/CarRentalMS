<%@ page import="Booking.Booking"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="Database.UIAccessObject"%>
<%@ page import="Payment.Payment"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.logging.Logger"%>
<%@ page import="java.util.logging.Level"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CarRent - Admin Vehicle Management</title>
        <%@ include file="../include/admin-css.html" %>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
        <style>
            body {
                font-family: 'Inter', sans-serif;
                background-color: #f4f4f4;
                display: flex;
                flex-direction: column;
                min-height: 100vh;
                margin: 0;
                padding-top: 56px;
            }

            header {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                z-index: 1000;
            }

            .wrapper {
                display: flex;
                flex-grow: 1;
            }

            .sidebar {
                width: 250px;
                background-color: #f8f9fa;
                padding: 20px;
                flex-shrink: 0;
            }

            .sidebar .nav-link {
                color: #4b5563;
                padding: 0.75rem 1rem;
                transition: color 0.2s;
                display: block;
                text-decoration: none;
            }

            .sidebar .nav-link:hover {
                color: #2563eb;
                background-color: #e9ecef;
            }

            .sidebar .nav-link i {
                margin-right: 0.75rem;
            }

            .sidebar .nav-item {
                margin-bottom: 0.5rem;
            }

            @media (max-width: 768px) {
                body {
                    padding-top: 69px;
                }
                .wrapper {
                    flex-direction: column;
                }
                .sidebar {
                    width: 100%;
                    margin-bottom: 1rem;
                    padding: 15px;
                }
            }
        </style>    </head>
    <body>
        <header>
            <%@ include file="../include/admin-header.jsp" %>
        </header>

        <div class="wrapper">
            <%@ include file="../include/admin-sidebar.jsp" %>

            <main class="dashboard-content">
                <!-- Main content removed as per instructions -->
            </main>
        </div>

        <%@ include file="../include/scripts.html" %>
    </body>
</html>