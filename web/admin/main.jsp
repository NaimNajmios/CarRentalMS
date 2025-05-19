<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CarRent - Admin Dashboard</title>
        <%@ include file="../include/client-css.html" %>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            body {
                background-color: #f4f4f4;
                font-family: 'Arial', sans-serif;
                display: flex;
                flex-direction: column;
                min-height: 100vh;
                margin: 0;
            }
            .container-fluid {
                flex-grow: 1;
                display: flex;
                padding: 0;
            }
            .sidebar {
                width: 250px;
                background-color: #ffffff;
                border-right: 1px solid #e0e0e0;
                padding: 1rem 0;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
                height: calc(100vh - 56px); /* Adjust for header height */
                position: sticky;
                top: 56px;
            }
            .sidebar .nav-link {
                color: #333;
                padding: 0.75rem 1.5rem;
                font-size: 1rem;
                font-weight: 500;
                display: flex;
                align-items: center;
                transition: background-color 0.2s;
            }
            .sidebar .nav-link:hover,
            .sidebar .nav-link.active {
                background-color: #f9f9f9;
                color: #007bff;
            }
            .sidebar .nav-link i {
                margin-right: 0.5rem;
            }
            .main-content {
                flex-grow: 1;
                padding: 2rem;
                background-color: #f4f4f4;
            }
            .dashboard-header {
                margin-bottom: 2rem;
            }
            .dashboard-header h2 {
                font-size: 2rem;
                color: #333;
                font-weight: bold;
            }
            .card {
                border: 0;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
                transition: transform 0.2s;
            }
            .card:hover {
                transform: translateY(-5px);
            }
            .card-body {
                text-align: center;
            }
            .card-title {
                font-size: 1.4rem;
                color: #333;
                margin-bottom: 1rem;
            }
            .card-text {
                font-size: 2rem;
                font-weight: bold;
                color: #007bff;
            }
            .card-footer-btn a {
                width: 100%;
                font-size: 1rem;
            }
            .row-cols-1 .col {
                margin-bottom: 1.5rem;
            }
            @media (max-width: 768px) {
                .sidebar {
                    width: 200px;
                }
                .main-content {
                    padding: 1rem;
                }
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <%@ include file="../include/admin-header.jsp" %>

        <!-- Admin Sidebar -->
        <%@ include file="../include/admin-sidebar.jsp" %>


        <!-- JavaScript Imports -->
        <%@ include file="../include/scripts.html" %>
    </body>
</html>