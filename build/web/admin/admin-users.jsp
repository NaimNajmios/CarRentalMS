<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="Database.UIAccessObject"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.sql.*"%>
<%@ page import="Database.DatabaseConnection"%>

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
            .search-box {
                position: relative;
                max-width: 300px;
            }
            .search-box input {
                padding: 0.6rem 1rem 0.6rem 2.2rem;
                border: 1px solid #ced4da;
                border-radius: 0.375rem;
                width: 100%;
                font-size: 0.9rem;
                transition: border-color 0.2s;
            }
            .search-box input:focus {
                border-color: #007bff;
                outline: none;
            }
            .search-box i {
                position: absolute;
                left: 0.75rem;
                top: 50%;
                transform: translateY(-50%);
                color: #6c757d;
            }
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
                padding-top: 1rem;
            }
            .tab-content .tab-pane.active {
                display: block;
            }
            .data-table {
                width: 100%;
                border-collapse: collapse;
                background-color: #fff;
                border: 1px solid #dee2e6;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                margin-top: 1rem;
            }
            .data-table th, .data-table td {
                padding: 1rem;
                text-align: left;
                font-size: 0.95rem;
                color: #555;
            }
            .data-table th {
                background-color: #f8f9fa;
                color: #34495e;
                font-weight: 600;
                border-bottom: 2px solid #dee2e6;
            }
            .data-table td {
                border-bottom: 1px solid #dee2e6;
            }
            .data-table tr:hover {
                background-color: #f1f3f5;
            }
            .btn-sm {
                padding: 0.25rem 0.5rem;
                font-size: 0.875rem;
                margin: 0 0.2rem;
            }
            .btn-info {
                background-color: #17a2b8;
                color: #fff;
                border: 1px solid #17a2b8;
            }
            .btn-info:hover {
                background-color: #138496;
                border-color: #117a8b;
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
            .alert {
                padding: 1rem;
                margin-bottom: 1.5rem;
                border: 1px solid transparent;
                border-radius: 0.375rem;
            }
            .alert-success {
                color: #155724;
                background-color: #d4edda;
                border-color: #c3e6cb;
            }
            .alert-danger {
                color: #721c24;
                background-color: #f8d7da;
                border-color: #f5c6cb;
            }
            .timestamp {
                font-size: 0.9rem;
                color: #7f8c8d;
                text-align: right;
                margin-top: 1rem;
            }
            .form-group {
                margin-bottom: 1rem;
            }
            .form-label {
                font-weight: 500;
                color: #333;
                margin-bottom: 0.5rem;
            }
            .form-control:disabled {
                background-color: #e9ecef;
                opacity: 1;
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
                .search-box {
                    max-width: 100%;
                }
                .data-table {
                    display: block;
                    overflow-x: auto;
                    white-space: nowrap;
                }
                .data-table thead, .data-table tbody, .data-table tr {
                    display: block;
                }
                .data-table th, .data-table td {
                    display: inline-block;
                    width: 100%;
                    box-sizing: border-box;
                }
                .data-table th {
                    position: sticky;
                    top: 0;
                    background-color: #f8f9fa;
                }
            }
        </style>
    </head>
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
                <div class="alert alert-<%= messageType %> alert-dismissible fade show" role="alert">
                    <i class="fas fa-<%= messageType.equals("success") ? "check-circle" : "exclamation-triangle" %> me-2"></i>
                    <%= message %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <%
                    }
                %>
                <div class="dashboard-header">
                    <h2><i class="fas fa-users"></i> User Management</h2>
                    <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addUserModal">
                        <i class="fas fa-plus"></i> Add New User
                    </button>
                </div>
                <ul class="nav nav-tabs" id="userTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <a class="nav-link active" id="client-tab" data-bs-toggle="tab" data-bs-target="#client" role="tab" aria-controls="client" aria-selected="true"><i class="fas fa-user"></i> Clients</a>
                    </li>
                    <li class="nav-item" role="presentation">
                        <a class="nav-link" id="admin-tab" data-bs-toggle="tab" data-bs-target="#admin" role="tab" aria-controls="admin" aria-selected="false"><i class="fas fa-user-shield"></i> Administrators</a>
                    </li>
                </ul>
                <div class="tab-content" id="userTabsContent">
                    <div class="tab-pane fade show active" id="client" role="tabpanel" aria-labelledby="client-tab">
                        <div class="search-box mb-3">
                            <i class="fas fa-search"></i>
                            <input type="text" id="clientSearchInput" placeholder="Search by ID, name, phone, email..." onkeyup="filterTable('clientTable')">
                        </div>
                        <div class="table-responsive">
                            <table class="data-table" id="clientTable">
                                <thead>
                                    <tr>
                                        <th><i class="fas fa-id-badge"></i> Client ID</th>
                                        <th><i class="fas fa-user"></i> User ID</th>
                                        <th><i class="fas fa-user-circle"></i> Name</th>
                                        <th><i class="fas fa-phone"></i> Phone</th>
                                        <th><i class="fas fa-envelope"></i> Email</th>
                                        <th class="text-center"><i class="fas fa-cogs"></i> Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
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
                                        <td><%= rsClient.getString("clientID") %></td>
                                        <td><%= rsClient.getString("userID") %></td>
                                        <td><%= rsClient.getString("name") %></td>
                                        <td><%= rsClient.getString("phoneNumber") %></td>
                                        <td><%= rsClient.getString("email") %></td>
                                        <td class="text-center">
                                            <a href="viewClient.jsp?userID=<%= rsClient.getString("userID") %>" class="btn btn-info btn-sm" title="View Details">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                            <a href="editClient.jsp?userID=<%= rsClient.getString("userID") %>" class="btn btn-warning btn-sm" title="Edit">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/DeleteClientServlet?userID=<%= rsClient.getString("userID") %>" 
                                               class="btn btn-danger btn-sm" 
                                               onclick="return confirm('Are you sure you want to delete this client?');" title="Delete">
                                                <i class="fas fa-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                    <%
                                            }
                                        } catch (SQLException e) {
                                            e.printStackTrace();
                                        } finally {
                                            if (rsClient != null) try { rsClient.close(); } catch (SQLException ignore) {}
                                            if (psClient != null) try { psClient.close(); } catch (SQLException ignore) {}
                                            if (conClient != null) try { conClient.close(); } catch (SQLException ignore) {}
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                        <div class="timestamp">
                            <i class="fas fa-clock"></i> Last updated: <%= new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new Date()) %>
                        </div>
                    </div>
                    <div class="tab-pane fade" id="admin" role="tabpanel" aria-labelledby="admin-tab">
                        <div class="search-box mb-3">
                            <i class="fas fa-search"></i>
                            <input type="text" id="adminSearchInput" placeholder="Search by ID, name, phone, email..." onkeyup="filterTable('adminTable')">
                        </div>
                        <div class="table-responsive">
                            <table class="data-table" id="adminTable">
                                <thead>
                                    <tr>
                                        <th><i class="fas fa-id-badge"></i> Admin Id</th>
                                        <th><i class="fas fa-user"></i> User Id</th>
                                        <th><i class="fas fa-user-circle"></i> Name</th>
                                        <th><i class="fas fa-envelope"></i> Email</th>
                                        <th><i class="fas fa-phone"></i> Phone</th>
                                        <th class="text-center"><i class="fas fa-cogs"></i> Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
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
                                            <a href="viewAdmin.jsp?userID=<%= rs.getString("userID") %>" class="btn btn-info btn-sm" title="View Details">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                            <a href="editAdmin.jsp?userID=<%= rs.getString("userID") %>" class="btn btn-warning btn-sm" title="Edit">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/DeleteAdminServlet?userID=<%= rs.getString("userID") %>" 
                                               class="btn btn-danger btn-sm" 
                                               onclick="return confirm('Are you sure you want to delete this administrator?');" title="Delete">
                                                <i class="fas fa-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                    <%
                                            }
                                        } catch (SQLException e) {
                                            e.printStackTrace();
                                        } finally {
                                            if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
                                            if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
                                            if (con != null) try { con.close(); } catch (SQLException ignore) {}
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                        <div class="timestamp">
                            <i class="fas fa-clock"></i> Last updated: <%= new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new Date()) %>
                        </div>
                    </div>
                </div>
                <!-- Modal for Adding New User -->
                <div class="modal fade" id="addUserModal" tabindex="-1" aria-labelledby="addUserModalLabel" aria-hidden="true">
                    <div class="modal-dialog modal-lg modal-dialog-centered">
                        <div class="modal-content">
                            <div class="modal-header bg-light">
                                <h5 class="modal-title" id="addUserModalLabel">
                                    <i class="fa-solid fa-user-plus me-2"></i>Add New User
                                </h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <form action="<%= request.getContextPath() %>/RegisterWalkIn" method="post" id="addUserForm">
                                    <div class="row g-4">
                                        <!-- Username -->
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="userName" class="form-label">Username</label>
                                                <div class="input-group">
                                                    <span class="input-group-text"><i class="fa-solid fa-user"></i></span>
                                                    <input type="text" class="form-control" id="userName" name="username" placeholder="Enter username" required>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- Role -->
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="userRole" class="form-label">Role</label>
                                                <div class="input-group">
                                                    <span class="input-group-text"><i class="fa-solid fa-user-tag"></i></span>
                                                    <select class="form-select" id="userRole" name="role" required>
                                                        <option value="Client" selected>Client</option>
                                                        <option value="Administrator">Admin</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- Password -->
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="userPassword" class="form-label">Password</label>
                                                <div class="input-group">
                                                    <span class="input-group-text"><i class="fa-solid fa-lock"></i></span>
                                                    <input type="text" class="form-control" id="userPassword" name="password" value="Temp123!" readonly>
                                                    <button class="btn btn-outline-secondary" type="button" id="copyPassword" title="Copy password">
                                                        <i class="fa-solid fa-copy"></i>
                                                    </button>
                                                </div>
                                                <small class="text-muted">Temporary password for first login</small>
                                            </div>
                                        </div>
                                        <!-- Email -->
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="userEmail" class="form-label">Email</label>
                                                <div class="input-group">
                                                    <span class="input-group-text"><i class="fa-solid fa-envelope"></i></span>
                                                    <input type="email" class="form-control" id="userEmail" name="email" placeholder="Enter email" required>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- Full Name -->
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="fullName" class="form-label">Full Name</label>
                                                <div class="input-group">
                                                    <span class="input-group-text"><i class="fa-solid fa-id-card"></i></span>
                                                    <input type="text" class="form-control" id="fullName" name="full-name" placeholder="Enter full name" required>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- Address -->
                                        <div class="col-12">
                                            <div class="form-group">
                                                <label for="address" class="form-label">Address</label>
                                                <div class="input-group">
                                                    <span class="input-group-text"><i class="fa-solid fa-location-dot"></i></span>
                                                    <textarea class="form-control" id="address" name="address" rows="3" placeholder="Enter address" required></textarea>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- Phone Number -->
                                        <div class="col-12">
                                            <div class="form-group">
                                                <label for="phoneNumber" class="form-label">Phone Number</label>
                                                <div class="input-group">
                                                    <span class="input-group-text"><i class="fa-solid fa-phone"></i></span>
                                                    <input type="tel" class="form-control" id="phoneNumber" name="phone-number" placeholder="Enter phone number" required>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer bg-light mt-4">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                            <i class="fa-solid fa-times me-2"></i>Cancel
                                        </button>
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fa-solid fa-user-plus me-2"></i>Add User
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            function filterTable(tableId) {
                var input = document.getElementById(tableId === 'clientTable' ? 'clientSearchInput' : 'adminSearchInput');
                var filter = input.value.toUpperCase();
                var table = document.getElementById(tableId);
                var tr = table.getElementsByTagName("tr");
                for (var i = 1; i < tr.length; i++) {
                    var td = tr[i].getElementsByTagName("td");
                    var found = false;
                    for (var j = 0; j < td.length - 1; j++) {
                        if (td[j]) {
                            var txtValue = td[j].textContent || td[j].innerText;
                            if (txtValue.toUpperCase().indexOf(filter) > -1) {
                                found = true;
                                break;
                            }
                        }
                    }
                    tr[i].style.display = found ? "" : "none";
                }
            }

            // Handle role change for address field
            function toggleAddressField() {
                var roleSelect = document.getElementById('userRole');
                var addressField = document.getElementById('address');
                if (roleSelect.value === 'Administrator') {
                    addressField.value = '';
                    addressField.disabled = true;
                    addressField.removeAttribute('required');
                } else {
                    addressField.disabled = false;
                    addressField.setAttribute('required', 'required');
                }
            }

            // Initialize address field state on page load
            document.addEventListener('DOMContentLoaded', function() {
                toggleAddressField();
                document.getElementById('userRole').addEventListener('change', toggleAddressField);
            });

            // Copy password functionality
            document.getElementById('copyPassword').addEventListener('click', function() {
                var passwordInput = document.getElementById('userPassword');
                passwordInput.select();
                try {
                    document.execCommand('copy');
                    this.innerHTML = '<i class="fa-solid fa-check"></i>';
                    setTimeout(() => {
                        this.innerHTML = '<i class="fa-solid fa-copy"></i>';
                    }, 2000);
                } catch (err) {
                    console.error('Failed to copy password:', err);
                }
            });
        </script>
    </body>
</html>