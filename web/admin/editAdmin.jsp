<%-- 
    Document   : editAdmin
    Created on : 11 Jun 2025, 11:58:44?am
    Author     : khair
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="Database.DatabaseConnection" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CarRent - Edit Administrator Information</title>
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

            .edit-form-card {
                background-color: #fff;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                padding: 2rem;
                margin-bottom: 2rem;
            }

            .form-label {
                color: #34495e;
                font-weight: 500;
                margin-bottom: 0.5rem;
            }

            .form-control {
                border: 1px solid #e0e0e0;
                border-radius: 6px;
                padding: 0.75rem;
                transition: border-color 0.2s, box-shadow 0.2s;
            }

            .form-control:focus {
                border-color: #4a90e2;
                box-shadow: 0 0 0 0.2rem rgba(74, 144, 226, 0.25);
                outline: none;
            }

            .btn {
                padding: 0.75rem 1.5rem;
                font-weight: 500;
                border-radius: 6px;
                transition: all 0.2s;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                justify-content: center;
            }

            .btn i {
                margin-right: 0.5rem;
            }

            .btn-primary {
                background-color: #007bff;
                border-color: #007bff;
                color: #fff;
            }

            .btn-primary:hover {
                background-color: #0056b3;
                border-color: #004085;
            }

            .btn-secondary {
                background-color: #6c757d;
                border-color: #6c757d;
                color: #fff;
            }

            .btn-secondary:hover {
                background-color: #5a6268;
                border-color: #545b62;
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
                .edit-form-card {
                    padding: 1.5rem;
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
                    String userId = request.getParameter("userID");
                    Connection con = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;
                    try {
                        con = DatabaseConnection.getConnection();
                        ps = con.prepareStatement("SELECT * FROM administrator WHERE userID = ?");
                        ps.setString(1, userId);
                        rs = ps.executeQuery();
                        
                        if (!rs.next()) {
                            response.sendRedirect("admin-users.jsp?message=Administrator not found&type=danger");
                            return; 
                        }
                %>

                <div class="dashboard-header">
                    <h2>Edit Administrator Information</h2>
                    <a href="admin-users.jsp" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Users
                    </a>
                </div>

                <div class="edit-form-card">
                    <form action="UpdateAdminServlet" method="post">
                        <input type="hidden" name="userID" value="<%= userId%>">
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="name" class="form-label">Name</label>
                                    <input type="text" class="form-control" id="name" name="name" value="<%= rs.getString("name")%>" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="email" class="form-label">Email</label>
                                    <input type="email" class="form-control" id="email" name="email" value="<%= rs.getString("email")%>" required>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="phone" class="form-label">Phone</label>
                                    <input type="text" class="form-control" id="phone" name="phone" value="<%= rs.getString("phoneNumber")%>" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <!-- Empty column for spacing or future expansion -->
                            </div>
                        </div>
                        
                        <div class="text-center">
                            <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Update Information</button>
                        </div>
                    </form>
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