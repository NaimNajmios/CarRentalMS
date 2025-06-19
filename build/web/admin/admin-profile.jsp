<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="Database.DatabaseConnection"%>
<%@ page import="User.User"%>
<%@ page import="User.Admin"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CarRent - Admin Profile</title>
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
                font-size: 2rem;
                color: #333;
                font-weight: bold;
                margin: 0;
            }

            .profile-card {
                background-color: #fff;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
                padding: 2rem;
            }

            .profile-image-container {
                position: relative;
                width: 150px;
                height: 150px;
                margin: 0 auto;
            }

            .profile-preview {
                width: 100%;
                height: 100%;
                object-fit: cover;
                border-radius: 50%;
                border: 3px solid #fff;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .image-upload-overlay {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0,0,0,0.5);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                opacity: 0;
                transition: opacity 0.3s;
            }

            .profile-image-container:hover .image-upload-overlay {
                opacity: 1;
            }

            .image-upload-overlay i {
                color: #fff;
                font-size: 2rem;
            }

            .section-title {
                font-size: 1.5rem;
                color: #333;
                margin-bottom: 1.5rem;
                padding-bottom: 0.5rem;
                border-bottom: 2px solid #f0f0f0;
            }

            .form-group {
                margin-bottom: 1.5rem;
            }

            .form-label {
                font-weight: 500;
                color: #555;
                margin-bottom: 0.5rem;
            }

            .form-control {
                border: 1px solid #ddd;
                border-radius: 4px;
                padding: 0.75rem;
                transition: border-color 0.2s;
            }

            .form-control:focus {
                border-color: #007bff;
                box-shadow: 0 0 0 0.2rem rgba(0,123,255,0.25);
            }

            .form-control[readonly] {
                background-color: #f8f9fa;
            }

            .btn {
                padding: 0.75rem 1.5rem;
                font-weight: 500;
                border-radius: 4px;
                transition: all 0.2s;
            }

            .btn-primary {
                background-color: #007bff;
                border-color: #007bff;
                color: #fff;
            }

            .btn-primary:hover {
                background-color: #0056b3;
                border-color: #0056b3;
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

            .btn-success {
                background-color: #28a745;
                border-color: #28a745;
                color: #fff;
            }

            .btn-success:hover {
                background-color: #218838;
                border-color: #1e7e34;
            }

            .alert {
                padding: 1rem;
                margin-bottom: 1.5rem;
                border: 1px solid transparent;
                border-radius: 4px;
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

            @media (max-width: 768px) {
                body {
                    padding-top: 69px;
                }
                .wrapper {
                    padding: 1rem;
                }
                .dashboard-content {
                    padding: 0;
                }
                .dashboard-header {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 1rem;
                    margin-bottom: 1.5rem;
                    padding: 1rem 0;
                }
                .dashboard-header h2 {
                    font-size: 1.8rem;
                }
                .profile-card {
                    padding: 1.5rem;
                }
                .section-title {
                    font-size: 1.5rem;
                    margin-bottom: 1rem;
                    padding-bottom: 0.5rem;
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
                    // Import User and Admin classes
                    User loggedInUser = (User) session.getAttribute("loggedInUser");
                    Admin loggedInAdmin = (Admin) session.getAttribute("loggedInAdmin");

                    // Get message attributes from session
                    String successMessage = (String) session.getAttribute("successMessage");
                    String errorMessage = (String) session.getAttribute("errorMessage");
                    
                    // Clear the messages after retrieving them
                    session.removeAttribute("successMessage");
                    session.removeAttribute("errorMessage");

                    Connection con = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;
                    try {
                        if (loggedInUser == null || loggedInAdmin == null || loggedInUser.getUserID() == null || loggedInUser.getUserID().isEmpty()) {
                            response.sendRedirect(request.getContextPath() + "/login.jsp?message=Please+log+in+to+view+your+profile.&type=warning");
                            return; 
                        }

                        con = DatabaseConnection.getConnection();
                        ps = con.prepareStatement("SELECT u.username, a.* FROM user u JOIN administrator a ON u.userID = a.userID WHERE u.userID = ?");
                        ps.setString(1, loggedInUser.getUserID());
                        rs = ps.executeQuery();
                        
                        if (!rs.next()) {
                            response.sendRedirect(request.getContextPath() + "/admin-dashboard.jsp?message=Profile+not+found.&type=danger");
                            return; 
                        }
                %>

                <% if (errorMessage != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    <%= errorMessage %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% } %>

                <% if (successMessage != null) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>
                    <%= successMessage %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% } %>

                <div class="dashboard-header">
                    <h2><i class="fas fa-user-shield"></i> My Profile</h2>
                </div>

                <div class="profile-card">
                    <form action="${pageContext.request.contextPath}/UpdateAdminServlet" method="post" enctype="multipart/form-data" id="profileForm">
                        <input type="hidden" name="userID" value="<%= loggedInUser.getUserID()%>">
                        <input type="hidden" name="currentImagePath" id="currentImagePath" value="<%= loggedInAdmin.getProfileImagePath() != null ? loggedInAdmin.getProfileImagePath() : "" %>">
                        
                        <!-- Profile Header Section -->
                        <div class="text-center mb-4 pb-3 border-bottom">
                            <div class="profile-image-container">
                                <img src="<%= loggedInAdmin.getProfileImagePath() != null && !loggedInAdmin.getProfileImagePath().isEmpty() ? request.getContextPath() + "/" + loggedInAdmin.getProfileImagePath() : request.getContextPath() + "/images/profilepic/default_profile.jpg"%>"
                                     alt="Profile Picture" 
                                     class="profile-preview" 
                                     id="profilePreview">
                                <label for="profileImage" class="image-upload-overlay" id="imageChangeButtons" style="display: none;">
                                    <input type="file" class="form-control-file" id="profileImage" 
                                           name="profileImage" accept="image/*" 
                                           onchange="previewProfileImage(this)" style="display: none;">
                                    <i class="fas fa-camera"></i>
                                </label>
                            </div>
                            <div class="mb-2 image-reset-btn" id="imageResetButton" style="display: none;">
                                <button type="button" class="btn btn-outline-secondary btn-sm" 
                                        onclick="resetProfileImage('<%= request.getContextPath() + "/images/profilepic/default_profile.jpg" %>')">
                                    <i class="fas fa-undo me-2"></i>Reset Image
                                </button>
                            </div>
                            <small class="text-muted d-block hidden-on-display" id="imageSizeInfo">Recommended size: 200x200 pixels. Max file size: 2MB</small>
                            
                            <h3 class="mt-3 mb-0"><%= loggedInAdmin.getName() %></h3>
                            <p class="text-muted"><%= loggedInUser.getUsername() %></p>
                        </div>

                        <!-- Personal Information Section -->
                        <h4 class="section-title mb-3 mt-4"><i class="fas fa-id-card"></i> Personal Information</h4>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="name" class="form-label"><i class="fas fa-user"></i> Full Name</label>
                                    <input type="text" class="form-control" id="name" name="name" value="<%= loggedInAdmin.getName()%>" required readonly>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="username" class="form-label"><i class="fas fa-at"></i> Username</label>
                                    <input type="text" class="form-control" id="username" name="username" value="<%= loggedInUser.getUsername()%>" required readonly>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Contact Information Section -->
                        <h4 class="section-title mb-3 mt-4"><i class="fas fa-address-book"></i> Contact Information</h4>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="email" class="form-label"><i class="fas fa-envelope"></i> Email</label>
                                    <input type="email" class="form-control" id="email" name="email" value="<%= loggedInAdmin.getEmail()%>" required readonly>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="phone" class="form-label"><i class="fas fa-phone"></i> Phone Number</label>
                                    <input type="text" class="form-control" id="phone" name="phone" value="<%= loggedInAdmin.getPhoneNumber()%>" required readonly>
                                </div>
                            </div>
                        </div>

                        <div class="text-center mt-4">
                            <button type="button" id="editProfileBtn" class="btn btn-primary">
                                <i class="fas fa-edit"></i> Edit Profile
                            </button>
                            <button type="button" id="cancelEditBtn" class="btn btn-secondary" style="display: none;">
                                <i class="fas fa-times"></i> Cancel Edit
                            </button>
                            <button type="submit" id="updateBtn" class="btn btn-success" style="display: none;">
                                <i class="fas fa-save"></i> Update Profile
                            </button>
                            <button type="button" class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#changePasswordModal">
                                <i class="fas fa-key"></i> Change Password
                            </button>
                        </div>
                    </form>
                </div>

                <% 
                    } catch (SQLException e) {
                        e.printStackTrace();
                        response.sendRedirect(request.getContextPath() + "/admin-dashboard.jsp?message=Database+error+loading+profile.&type=danger");
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException ignore) { /* ignore */ }
                        if (ps != null) try { ps.close(); } catch (SQLException ignore) { /* ignore */ }
                        if (con != null) try { con.close(); } catch (SQLException ignore) { /* ignore */ }
                    }
                %>
            </div>
        </div>

        <!-- Change Password Modal -->
        <div class="modal fade" id="changePasswordModal" tabindex="-1" aria-labelledby="changePasswordModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="changePasswordModalLabel"><i class="fas fa-key"></i> Change Password</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="changePasswordForm" action="${pageContext.request.contextPath}/ChangePasswordServlet" method="post">
                            <input type="hidden" name="userID" value="<%= loggedInUser.getUserID()%>">
                            <div class="mb-3">
                                <label for="oldPassword" class="form-label"><i class="fas fa-lock"></i> Current Password</label>
                                <input type="password" class="form-control" id="oldPassword" name="oldPassword" required>
                            </div>
                            <div class="mb-3">
                                <label for="newPassword" class="form-label"><i class="fas fa-lock-open"></i> New Password</label>
                                <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                            </div>
                            <div class="mb-3">
                                <label for="confirmPassword" class="form-label"><i class="fas fa-check-circle"></i> Confirm New Password</label>
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                            </div>
                            <div class="alert alert-danger" id="passwordError" style="display: none;"></div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"><i class="fas fa-times"></i> Cancel</button>
                        <button type="button" class="btn btn-primary" id="submitPasswordChange"><i class="fas fa-save"></i> Change Password</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                const editProfileBtn = document.getElementById('editProfileBtn');
                const cancelEditBtn = document.getElementById('cancelEditBtn');
                const updateBtn = document.getElementById('updateBtn');
                const imageChangeButtons = document.getElementById('imageChangeButtons');
                const imageResetButton = document.getElementById('imageResetButton');
                const imageSizeInfo = document.getElementById('imageSizeInfo');
                const formInputs = document.querySelectorAll('#profileForm input:not([type="hidden"]), #profileForm textarea');

                editProfileBtn.addEventListener('click', function() {
                    formInputs.forEach(input => {
                        // Keep username field readonly even in edit mode
                        if (input.id !== 'username') {
                            input.removeAttribute('readonly');
                        }
                    });
                    editProfileBtn.style.display = 'none';
                    cancelEditBtn.style.display = 'inline-block';
                    updateBtn.style.display = 'inline-block';
                    imageChangeButtons.style.display = 'flex';
                    imageResetButton.style.display = 'block';
                    imageSizeInfo.classList.remove('hidden-on-display');
                });

                cancelEditBtn.addEventListener('click', function() {
                    formInputs.forEach(input => {
                        // Set all fields back to readonly, including username
                        input.setAttribute('readonly', '');
                    });
                    editProfileBtn.style.display = 'inline-block';
                    cancelEditBtn.style.display = 'none';
                    updateBtn.style.display = 'none';
                    imageChangeButtons.style.display = 'none';
                    imageResetButton.style.display = 'none';
                    imageSizeInfo.classList.add('hidden-on-display');
                    document.getElementById('profileForm').reset();
                    
                    // Restore original profile image
                    const currentImagePath = document.getElementById('currentImagePath').value;
                    const profilePreview = document.getElementById('profilePreview');
                    if (currentImagePath && currentImagePath.trim() !== '') {
                        profilePreview.src = '<%= request.getContextPath() %>/' + currentImagePath;
                    } else {
                        profilePreview.src = '<%= request.getContextPath() + "/images/profilepic/default_profile.jpg" %>';
                    }
                });

                // Password change form validation
                const changePasswordForm = document.getElementById('changePasswordForm');
                const submitPasswordChange = document.getElementById('submitPasswordChange');
                const passwordError = document.getElementById('passwordError');

                submitPasswordChange.addEventListener('click', function() {
                    const newPassword = document.getElementById('newPassword').value;
                    const confirmPassword = document.getElementById('confirmPassword').value;
                    
                    // Reset error message
                    passwordError.style.display = 'none';
                    passwordError.textContent = '';

                    // Validate password match
                    if (newPassword !== confirmPassword) {
                        passwordError.textContent = 'New passwords do not match!';
                        passwordError.style.display = 'block';
                        return;
                    }

                    // Submit the form if validation passes
                    changePasswordForm.submit();
                });

                // Clear form and error message when modal is closed
                const changePasswordModal = document.getElementById('changePasswordModal');
                changePasswordModal.addEventListener('hidden.bs.modal', function () {
                    changePasswordForm.reset();
                    passwordError.style.display = 'none';
                    passwordError.textContent = '';
                });
            });

            function previewProfileImage(input) {
                if (input.files && input.files[0]) {
                    const file = input.files[0];
                    // Check file size (2MB limit)
                    if (file.size > 2 * 1024 * 1024) {
                        alert('File size exceeds 2MB limit. Please choose a smaller image.');
                        input.value = '';
                        return;
                    }
                    // Check file type
                    if (!file.type.startsWith('image/')) {
                        alert('Please select an image file.');
                        input.value = '';
                        return;
                    }
                    var reader = new FileReader();
                    reader.onload = function(e) {
                        document.getElementById('profilePreview').src = e.target.result;
                    };
                    reader.readAsDataURL(file);
                }
            }

            function resetProfileImage(defaultPath) {
                document.getElementById('profilePreview').src = defaultPath;
                document.getElementById('profileImage').value = '';
            }
        </script>
    </body>
</html> 