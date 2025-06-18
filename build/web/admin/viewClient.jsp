<%-- 
    Document   : viewClient
    Created on : Jun 12, 2025, 10:30:00 AM
    Author     : Gemini
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="Database.DatabaseConnection" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CarRent - View Client Details</title>
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

            .detail-card {
                background-color: #fff;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                margin-bottom: 2rem;
                padding: 2rem;
            }

            .detail-title {
                color: #34495e;
                font-size: 1.5rem;
                margin-bottom: 1.5rem;
                padding-bottom: 0.5rem;
                border-bottom: 2px solid #f0f0f0;
            }

            .details-grid {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 1.5rem;
            }

            .detail-item {
                display: flex;
                flex-direction: column;
                gap: 0.5rem;
            }

            .detail-label {
                color: #666;
                font-weight: 500;
                font-size: 0.9rem;
            }

            .detail-value {
                color: #333;
                font-size: 1rem;
            }

            .profile-image-container {
                width: 150px;
                height: 150px;
                border-radius: 50%;
                overflow: hidden;
                margin: 0 auto 1.5rem auto;
                border: 3px solid #eee;
                box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
            }

            .profile-image {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .action-buttons {
                margin-top: 2rem;
                display: flex;
                gap: 1rem;
            }

            .action-buttons .btn {
                padding: 0.5rem 1rem;
                font-weight: 500;
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
                .dashboard-content {
                    padding: 1.5rem;
                }
                .dashboard-header {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 1rem;
                }
                .details-grid {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>
    <body>
        <%@ include file="../include/admin-header.jsp" %>
        
        <div class="wrapper">
            <%@ include file="../include/admin-sidebar.jsp" %>
            
            <div class="dashboard-content">
                <%
                    String message = request.getParameter("message");
                    String messageType = request.getParameter("type");
                    if (message != null && messageType != null) {
                %>
                <div class="alert alert-<%= messageType%> alert-dismissible fade show" role="alert">
                    <% if (messageType.equals("danger")) { %>
                        <i class="fas fa-exclamation-triangle me-2"></i>
                    <% } else if (messageType.equals("success")) { %>
                        <i class="fas fa-check-circle me-2"></i>
                    <% } else { %>
                        <i class="fas fa-info-circle me-2"></i>
                    <% } %>
                    <%= message%>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <%
                    }
                %>
                <% 
                    String userId = request.getParameter("userID");
                    Connection con = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;
                    try {
                        if (userId == null || userId.isEmpty()) {
                            response.sendRedirect("admin-users.jsp?message=Client ID not provided&type=danger");
                            return;
                        }

                        con = DatabaseConnection.getConnection();
                        ps = con.prepareStatement("SELECT * FROM client WHERE userID = ?");
                        ps.setString(1, userId);
                        rs = ps.executeQuery();
                        
                        if (!rs.next()) {
                            response.sendRedirect("admin-users.jsp?message=Client not found&type=danger");
                            return; 
                        }
                %>

                <div class="dashboard-header">
                    <h2><i class="fas fa-user"></i> Client Details</h2>
                    <a href="admin-users.jsp" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Users
                    </a>
                </div>

                <div class="detail-card">
                    <div class="profile-image-container">
                        <% 
                            String profilePicPath = rs.getString("profileImagePath");
                            if (profilePicPath != null && !profilePicPath.isEmpty()) {
                        %>
                                <img src="<%= request.getContextPath() %>/<%= profilePicPath %>" alt="Profile Picture" class="profile-image">
                        <% 
                            } else {
                        %>
                                <img src="<%= request.getContextPath() %>/images/profilepic/default_profile.jpg" alt="Default Profile Picture" class="profile-image">
                        <% 
                            }
                        %>
                    </div>
                    <h3 class="detail-title"><i class="fas fa-user-circle"></i> <%= rs.getString("name") %></h3>
                    
                    <div class="details-grid">
                        <div class="detail-item">
                            <span class="detail-label"><i class="fas fa-hashtag text-muted"></i> Client ID</span>
                            <span class="detail-value"><%= rs.getString("clientID") %></span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label"><i class="fas fa-user text-muted"></i> User ID</span>
                            <span class="detail-value"><%= rs.getString("userID") %></span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label"><i class="fas fa-map-marker-alt text-muted"></i> Address</span>
                            <span class="detail-value"><%= rs.getString("address") %></span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label"><i class="fas fa-phone text-muted"></i> Phone Number</span>
                            <span class="detail-value"><%= rs.getString("phoneNumber") %></span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label"><i class="fas fa-envelope text-muted"></i> Email</span>
                            <span class="detail-value"><%= rs.getString("email") %></span>
                        </div>
                    </div>

                    <div class="action-buttons">
                        <a href="editClient.jsp?userID=<%= rs.getString("userID")%>" class="btn btn-warning me-2">
                            <i class="fas fa-edit"></i> Edit Client
                        </a>
                        <a href="${pageContext.request.contextPath}/DeleteClientServlet?userID=<%= rs.getString("userID")%>" 
                           class="btn btn-danger" 
                           onclick="return confirm('Are you sure you want to delete this client?');">
                            <i class="fas fa-trash"></i> Delete Client
                        </a>
                    </div>
                </div>

                <% 
                    } catch (SQLException e) {
                        e.printStackTrace();
                        response.sendRedirect("admin-users.jsp?message=Database error&type=danger");
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException ignore) { /* ignore */ }
                        if (ps != null) try { ps.close(); } catch (SQLException ignore) { /* ignore */ }
                        if (con != null) try { con.close(); } catch (SQLException ignore) { /* ignore */ }
                    }
                %>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html> 