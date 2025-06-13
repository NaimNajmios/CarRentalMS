<%-- 
    Document   : client-profile
    Created on : Jun 12, 2025, 3:00:00 PM
    Author     : Cursor
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="Database.DatabaseConnection" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="User.User" %>
<%@ page import="User.Client" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CarRent - My Profile</title>
        <%@ include file="include/client-css.html" %>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
        <style>
            body {
                font-family: 'Inter', sans-serif;
                background-color: #f0f2f5; /* Consistent with client-main */
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
                flex-grow: 1;
                padding: 3rem; /* Increased padding for overall spacing */
            }

            .dashboard-content {
                max-width: 1200px; /* Further increased width for better readability and spacing */
                margin: 0 auto; /* Center the content */
                padding: 0; /* Remove internal padding as wrapper has it */
                background-color: transparent; /* Remove background, cards will have their own */
            }

            .dashboard-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 2rem;
                padding: 1.5rem 0;
                border-bottom: 1px solid #e0e0e0;
            }

            .dashboard-header h2 {
                font-size: 2.2rem; /* Larger heading */
                color: #333;
                font-weight: 700;
                margin: 0;
            }

            /* Modern Card Styling */
            .profile-card {
                background-color: #fff;
                border-radius: 12px;
                box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1); /* Deeper shadow */
                padding: 2.5rem;
                margin-bottom: 2rem; 
            }

            .section-title {
                font-size: 1.8rem;
                font-weight: 600;
                color: #007bff; /* Primary color for section titles */
                margin-bottom: 1.5rem;
                border-bottom: 1px solid #e0e0e0;
                padding-bottom: 0.75rem;
            }

            .form-group {
                margin-bottom: 1.5rem; /* More spacing between form groups */
            }

            .form-label {
                color: #34495e;
                font-weight: 500;
                margin-bottom: 0.5rem;
                display: block; /* Ensure labels are block level */
            }

            .form-control[readonly] {
                background-color: #e9ecef; /* Lighter readonly background */
                opacity: 1;
                cursor: default; /* Indicate non-editable */
            }

            .form-control {
                border: 1px solid #ced4da;
                border-radius: 8px; /* Slightly more rounded */
                padding: 0.85rem 1rem; /* More vertical padding */
                transition: border-color 0.2s, box-shadow 0.2s;
                width: 100%; /* Ensure full width */
            }

            .form-control:focus {
                border-color: #80bdff;
                box-shadow: 0 0 0 0.25rem rgba(0, 123, 255, 0.25); /* Bootstrap-like focus */
                outline: none; 
            }

            .btn {
                padding: 0.75rem 1.75rem; /* Larger buttons */
                font-weight: 600; /* Bolder text */
                border-radius: 8px; /* More rounded */
                transition: all 0.2s ease;
                text-decoration: none; 
                display: inline-flex; 
                align-items: center;
                justify-content: center;
            }

            .btn i {
                margin-right: 0.75rem; /* More space for icons */
                font-size: 1.1rem;
            }

            .btn-primary {
                background-color: #007bff;
                border-color: #007bff;
                color: #fff;
            }

            .btn-primary:hover {
                background-color: #0056b3;
                border-color: #004085;
                transform: translateY(-2px);
            }

            .btn-secondary {
                background-color: #6c757d;
                border-color: #6c757d;
                color: #fff;
            }

            .btn-secondary:hover {
                background-color: #5a6268;
                border-color: #545b62;
                transform: translateY(-2px);
            }

            .btn-success {
                background-color: #28a745;
                border-color: #28a745;
                color: #fff;
            }

            .btn-success:hover {
                background-color: #218838;
                border-color: #1e7e34;
                transform: translateY(-2px);
            }

            /* Profile Image Styling */
            .profile-image-container {
                width: 180px;
                height: 180px;
                margin: 0 auto 25px auto;
                position: relative;
                border-radius: 50%;
                overflow: hidden;
                border: 5px solid #fff;
                box-shadow: 0 0.25rem 0.5rem rgba(0, 0, 0, 0.1);
                cursor: pointer;
            }

            .profile-preview {
                width: 100%;
                height: 100%;
                object-fit: cover;
                border-radius: 50%;
                cursor: pointer;
            }

            .image-upload-overlay {
                position: absolute;
                bottom: 0;
                right: 0;
                background-color: rgba(0, 123, 255, 0.9);
                border-radius: 50%;
                width: 50px;
                height: 50px;
                display: none;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
                transition: background-color 0.2s ease;
                z-index: 10;
            }

            .image-upload-overlay:hover {
                background-color: #0056b3;
            }

            .image-upload-overlay i {
                color: #fff;
                font-size: 1.5rem;
                margin-right: 0; /* Remove margin from icon */
            }

            .image-reset-btn {
                margin-top: 15px; /* Space below image */
            }

            .hidden-on-display {
                display: none !important;
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
        <%@ include file="include/header.jsp" %>
        
        <div class="wrapper">
            <%-- No sidebar for client profile --%>
            
            <div class="dashboard-content">
                <% 
                    // Import User and Client classes
                    User loggedInUser = (User) session.getAttribute("loggedInUser");
                    Client loggedInClient = (Client) session.getAttribute("loggedInClient");

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
                        if (loggedInUser == null || loggedInClient == null || loggedInUser.getUserID() == null || loggedInUser.getUserID().isEmpty()) {
                            response.sendRedirect(request.getContextPath() + "/login.jsp?message=Please+log+in+to+view+your+profile.&type=warning");
                            return; 
                        }

                        con = DatabaseConnection.getConnection();
                        ps = con.prepareStatement("SELECT u.username, c.* FROM user u JOIN client c ON u.userID = c.userID WHERE u.userID = ?");
                        ps.setString(1, loggedInUser.getUserID()); // Use userID from loggedInUser object
                        rs = ps.executeQuery();
                        
                        if (!rs.next()) {
                            response.sendRedirect(request.getContextPath() + "/client-main.jsp?message=Profile+not+found.&type=danger");
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
                    <h2>My Profile</h2>
                    <div class="action-buttons">
                        <button type="button" id="editProfileBtn" class="btn btn-primary">
                            <i class="fas fa-edit"></i> Edit Profile
                        </button>
                        <button type="button" id="cancelEditBtn" class="btn btn-secondary" style="display: none;">
                            <i class="fas fa-times"></i> Cancel Edit
                        </button>
                    </div>
                </div>

                <div class="profile-card">
                    <form action="${pageContext.request.contextPath}/UpdateClientServlet" method="post" enctype="multipart/form-data" id="profileForm">
                        <input type="hidden" name="userID" value="<%= loggedInUser.getUserID()%>">
                        <input type="hidden" name="currentImagePath" id="currentImagePath" value="<%= loggedInClient.getProfileImagePath() != null ? loggedInClient.getProfileImagePath() : "" %>"> <!-- Use Client object -->
                        
                        <!-- Profile Header Section - New Structure -->
                        <div class="text-center mb-4 pb-3 border-bottom">
                            <div class="profile-image-container">
                                <img src="<%= loggedInClient.getProfileImagePath() != null && !loggedInClient.getProfileImagePath().isEmpty() ? request.getContextPath() + "/" + loggedInClient.getProfileImagePath() : request.getContextPath() + "/images/profilepic/default_profile.jpg"%>"
                                     alt="Profile Picture" 
                                     class="profile-preview" 
                                     id="profilePreview">
                                <div class="image-upload-overlay" id="imageChangeButtons" style="display: none;">
                                    <input type="file" class="form-control-file" id="profileImage" 
                                           name="profileImage" accept="image/*" 
                                           onchange="previewProfileImage(this)" style="display: none;">
                                    <i class="fas fa-camera"></i>
                                </div>
                            </div>
                            <div class="mb-2 image-reset-btn" id="imageResetButton" style="display: none;">
                                <button type="button" class="btn btn-outline-secondary btn-sm" 
                                        onclick="resetProfileImage('<%= request.getContextPath() + "/images/profilepic/default_profile.jpg" %>')">
                                    <i class="fas fa-undo me-2"></i>Reset Image
                                </button>
                            </div>
                            <small class="text-muted d-block hidden-on-display" id="imageSizeInfo">Recommended size: 200x200 pixels. Max file size: 2MB</small>
                            
                            <h3 class="mt-3 mb-0"><%= loggedInClient.getName() %></h3>
                            <p class="text-muted"><%= loggedInUser.getUsername() %></p>
                        </div>

                        <!-- Personal Information Section -->
                        <h4 class="section-title mb-3 mt-4">Personal Information</h4>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="name" class="form-label">Full Name</label>
                                    <input type="text" class="form-control" id="name" name="name" value="<%= loggedInClient.getName()%>" required readonly>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="username" class="form-label">Username</label>
                                    <input type="text" class="form-control" id="username" name="username" value="<%= loggedInUser.getUsername()%>" required readonly>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Contact Information Section -->
                        <h4 class="section-title mb-3 mt-4">Contact Information</h4>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="email" class="form-label">Email</label>
                                    <input type="email" class="form-control" id="email" name="email" value="<%= loggedInClient.getEmail()%>" required readonly>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="phone" class="form-label">Phone Number</label>
                                    <input type="text" class="form-control" id="phone" name="phone" value="<%= loggedInClient.getPhoneNumber()%>" required readonly>
                                </div>
                            </div>
                        </div>

                        <!-- Address Information Section -->
                        <h4 class="section-title mb-3 mt-4">Address Information</h4>
                        <div class="row">
                            <div class="col-12">
                                <div class="form-group">
                                    <label for="address" class="form-label">Address</label>
                                    <textarea class="form-control" id="address" name="address" required readonly><%= loggedInClient.getAddress()%></textarea>
                                </div>
                            </div>
                        </div>

                        <div class="text-center mt-4">
                             <button type="submit" id="updateBtn" class="btn btn-success" style="display: none;"><i class="fas fa-save"></i> Update Profile</button>
                        </div>
                    </form>
                </div>

                <% 
                    } catch (SQLException e) {
                        e.printStackTrace();
                        // More user-friendly redirect in case of error
                        response.sendRedirect(request.getContextPath() + "/client-main.jsp?message=Database+error+loading+profile.&type=danger");
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException ignore) { /* ignore */ }
                        if (ps != null) try { ps.close(); } catch (SQLException ignore) { /* ignore */ }
                        if (con != null) try { con.close(); } catch (SQLException ignore) { /* ignore */ }
                    }
                %>
            </div>
        </div>

        <%@ include file="include/footer.jsp" %>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                const formInputs = document.querySelectorAll('#profileForm input[type="text"], #profileForm input[type="email"], #profileForm input[type="tel"], #profileForm textarea');
                const editProfileBtn = document.getElementById('editProfileBtn');
                const cancelEditBtn = document.getElementById('cancelEditBtn');
                const updateBtn = document.getElementById('updateBtn');
                const imageChangeButtons = document.getElementById('imageChangeButtons');
                const imageResetButton = document.getElementById('imageResetButton'); 
                const profilePreview = document.getElementById('profilePreview');
                const profileImageContainer = document.querySelector('.profile-image-container');
                const profileImageInput = document.getElementById('profileImage');
                const originalImagePath = document.getElementById('currentImagePath').value;
                const imageSizeInfo = document.getElementById('imageSizeInfo'); 

                // Add click event listener to profile image container
                profileImageContainer.addEventListener('click', function() {
                    if (imageChangeButtons.style.display === 'flex') {
                        profileImageInput.click();
                    }
                });

                function setEditMode(isEditMode) {
                    formInputs.forEach(input => {
                        if (input.id !== 'username') { 
                            input.readOnly = !isEditMode;
                        }
                    });

                    if (isEditMode) {
                        editProfileBtn.style.display = 'none';
                        cancelEditBtn.style.display = 'inline-flex';
                        updateBtn.style.display = 'inline-flex';
                        imageChangeButtons.style.display = 'flex';
                        imageResetButton.style.display = 'block';
                        profilePreview.style.cursor = 'pointer';
                        imageSizeInfo.classList.remove('hidden-on-display');
                    } else {
                        editProfileBtn.style.display = 'inline-flex';
                        cancelEditBtn.style.display = 'none';
                        updateBtn.style.display = 'none';
                        imageChangeButtons.style.display = 'none';
                        imageResetButton.style.display = 'none';
                        profilePreview.style.cursor = 'default';
                        imageSizeInfo.classList.add('hidden-on-display');
                        document.getElementById('profileImage').value = '';
                        document.getElementById('profilePreview').src = "<%= request.getContextPath() %>/" + (originalImagePath || "images/profilepic/default_profile.jpg");
                    }
                }

                editProfileBtn.addEventListener('click', function() {
                    setEditMode(true);
                });

                cancelEditBtn.addEventListener('click', function() {
                    location.reload(); 
                });

                setEditMode(false);
            });

            function previewProfileImage(input) {
                if (input.files && input.files[0]) {
                    var reader = new FileReader();
                    reader.onload = function(e) {
                        document.getElementById('profilePreview').src = e.target.result;
                    };
                    reader.readAsDataURL(input.files[0]);
                }
            }

            function resetProfileImage(defaultPath) {
                document.getElementById('profilePreview').src = defaultPath;
                document.getElementById('profileImage').value = ''; 
            }
        </script>
    </body>
</html> 