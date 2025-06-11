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
<%@ page import="java.sql.*" %>
<%@ page import="Database.DatabaseConnection" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CarRent - Admin User Management</title>
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

            .dashboard-content {
                flex-grow: 1;
                padding: 2rem;
                background-color: #f4f4f4;
            }

            .dashboard-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 2rem;
            }

            .dashboard-header h2 {
                font-size: 1.75rem;
                color: #333;
                font-weight: 700;
                margin: 0;
            }

            /* Tabs Styling */
            .nav-tabs {
                border-bottom: 1px solid #dee2e6;
                margin-bottom: 1.5rem;
            }

            .nav-tabs .nav-link {
                border: 1px solid transparent;
                border-top-left-radius: 0.25rem;
                border-top-right-radius: 0.25rem;
                color: #495057;
                padding: 0.75rem 1.25rem;
                margin-bottom: -1px;
                background-color: transparent;
                transition: all 0.3s ease-in-out;
                cursor: pointer;
                text-decoration: none;
            }

            .nav-tabs .nav-link:hover {
                border-color: #e9ecef #e9ecef #dee2e6;
                background-color: #e9ecef;
            }

            .nav-tabs .nav-link.active {
                color: #495057;
                background-color: #fff;
                border-color: #dee2e6 #dee2e6 #fff;
                font-weight: 600;
            }

            .tab-content .tab-pane {
                display: none;
                padding-top: 1rem; /* Space between tabs and content */
            }

            .tab-content .tab-pane.active {
                display: block;
            }

            .data-table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 0;
                background-color: #fff;
                border: 1px solid #dee2e6;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            }

            .data-table th,
            .data-table td {
                padding: 1rem;
                text-align: left;
                font-size: 0.95rem;
                color: #555;
            }

            .data-table th {
                background-color: #f8f9fa;
                color: #34495e;
                font-weight: 600;
                text-transform: capitalize;
                border-bottom: 2px solid #dee2e6;
            }

            .data-table td {
                 border-bottom: 1px solid #dee2e6;
            }

            .data-table tbody tr:hover {
                background-color: #f1f3f5;
            }

            .action-buttons .btn {
                padding: 0.4rem 0.8rem;
                font-size: 0.85rem;
                font-weight: 500;
                border-radius: 5px;
                text-decoration: none;
                display: inline-block;
                margin-right: 0.5rem;
            }

            .btn-warning {
                background-color: #ffc107;
                color: #212529;
                border: 1px solid #ffc107;
            }

            .btn-warning:hover {
                background-color: #e0a800;
                border-color: #d39e00;
            }

            .btn-danger {
                background-color: #dc3545;
                color: #fff;
                border: 1px solid #dc3545;
            }

            .btn-danger:hover {
                background-color: #c82333;
                border-color: #bd2130;
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
                <%
                    String message = request.getParameter("message");
                    String messageType = request.getParameter("type");
                    if (message != null && messageType != null) {
                %>
                <div class="alert alert-<%= messageType%> alert-dismissible fade show" role="alert">
                    <%= message%>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <%
                    }
                %>
                <%-- 
                    Document   : adminPage
                    Created on : 11 Jun 2025, 11:57:08?am
                    Author     : khair
                --%>

                <%
                    String userRole = (String) session.getAttribute("loggedInRole");
                %>

                <div class="dashboard-header">
                    <h2>User Management</h2>
                </div>

                <ul class="nav nav-tabs" id="userTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <a class="nav-link active" id="client-tab" data-bs-toggle="tab" data-bs-target="#client" type="button" role="tab" aria-controls="client" aria-selected="true">Clients</a>
                    </li>
                    <li class="nav-item" role="presentation">
                        <a class="nav-link" id="admin-tab" data-bs-toggle="tab" data-bs-target="#admin" type="button" role="tab" aria-controls="admin" aria-selected="false">Administrators</a>
                    </li>
                </ul>

                <div class="tab-content" id="userTabsContent">
                    <div class="tab-pane fade show active" id="client" role="tabpanel" aria-labelledby="client-tab">
                        <div class="dashboard-header d-flex justify-content-end mb-3">
                             
                        </div>

                        <div class="table-responsive">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>Client Id</th>
                                        <th>User Id</th>
                                        <th>Name</th>
                                        <th>Phone</th>
                                        <th>Email</th>
                                        <th class="text-center">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%-- This scriptlet retrieves and displays client data from the database. --%>
                                    <% 
                                        Connection conClient = null;
                                        PreparedStatement psClient = null;
                                        ResultSet rsClient = null;
                                        try {
                                            conClient = DatabaseConnection.getConnection();
                                            psClient = conClient.prepareStatement("SELECT * FROM client WHERE isDeleted = 0");
                                            rsClient = psClient.executeQuery();
                                            while (rsClient.next()) {
                                    %>
                                    <tr>
                                        <td><%= rsClient.getString("clientID")%></td>
                                        <td><%= rsClient.getString("userID")%></td>
                                        <td><%= rsClient.getString("name")%></td>
                                        <td><%= rsClient.getString("phoneNumber")%></td>
                                        <td><%= rsClient.getString("email")%></td>
                                        <td class="text-center">
                                            <a href="viewClient.jsp?userID=<%= rsClient.getString("userID")%>" class="btn btn-info me-2" title="View Details">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                            <a href="editClient.jsp?userID=<%= rsClient.getString("userID")%>" class="btn btn-warning me-2" title="Edit">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/DeleteClientServlet?userID=<%= rsClient.getString("userID")%>" 
                                               class="btn btn-danger" 
                                               onclick="return confirm('Are you sure you want to delete this client?');" title="Delete">
                                                <i class="fas fa-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                    <% 
                                            }
                                        } catch (SQLException e) {
                                            e.printStackTrace(); // Log the exception for debugging
                                        } finally {
                                            // Close resources in a finally block to ensure they are closed even if an exception occurs
                                            if (rsClient != null) try { rsClient.close(); } catch (SQLException ignore) { /* ignore */ }
                                            if (psClient != null) try { psClient.close(); } catch (SQLException ignore) { /* ignore */ }
                                            if (conClient != null) try { conClient.close(); } catch (SQLException ignore) { /* ignore */ }
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="tab-pane fade" id="admin" role="tabpanel" aria-labelledby="admin-tab">
                        <div class="dashboard-header d-flex justify-content-end mb-3">
                             
                        </div>

                        <div class="table-responsive">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>Admin Id</th>
                                        <th>User Id</th>
                                        <th>Name</th>
                                        <th>Email</th>
                                        <th>Phone</th>
                                        <th class="text-center">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%-- This scriptlet retrieves and displays administrator data from the database. --%>
                                    <% 
                                        Connection con = null;
                                        Statement stmt = null;
                                        ResultSet rs = null;
                                        try {
                                            con = DatabaseConnection.getConnection();
                                            stmt = con.createStatement();
                                            rs = stmt.executeQuery("SELECT * FROM administrator WHERE isDeleted = 0");
                                            while (rs.next()) {
                                    %>
                                    <tr>
                                        <td><%= rs.getInt("adminID") %></td>
                                        <td><%= rs.getInt("userID") %></td>
                                        <td><%= rs.getString("name") %></td>
                                        <td><%= rs.getString("email") %></td>
                                        <td><%= rs.getString("phoneNumber") %></td>
                                        <td class="text-center">
                                            <a href="viewAdmin.jsp?userID=<%= rs.getString("userID")%>" class="btn btn-info me-2" title="View Details">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                            <a href="editAdmin.jsp?userID=<%= rs.getString("userID") %>" class="btn btn-warning me-2" title="Edit">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/DeleteAdminServlet?userID=<%= rs.getString("userID") %>" 
                                               class="btn btn-danger" 
                                               onclick="return confirm('Are you sure you want to delete this administrator?');" title="Delete">
                                                <i class="fas fa-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                    <% 
                                            }
                                        } catch (SQLException e) {
                                            e.printStackTrace(); // Log the exception for debugging
                                        } finally {
                                            // Close resources in a finally block to ensure they are closed even if an exception occurs
                                            if (rs != null) try { rs.close(); } catch (SQLException ignore) { /* ignore */ }
                                            if (stmt != null) try { stmt.close(); } catch (SQLException ignore) { /* ignore */ }
                                            if (con != null) try { con.close(); } catch (SQLException ignore) { /* ignore */ }
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </main>
        </div>

        <%@ include file="../include/scripts.html" %>
    </body>
</html>