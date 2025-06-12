<%-- 
    Document   : Register
    Created on : 5 Jun 2025, 12:56:53?pm
    Author     : khair
--%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CarRent - Register</title>
    <%@ include file="include/admin-css.html" %>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f4f4f4;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }

        .form-container {
            background-color: #fff;
            padding: 2.5rem;
            border-radius: 0.5rem;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
            width: 100%;
            max-width: 800px;
            text-align: center;
        }

        .form-container form {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
        }

        .form-container .mb-3 {
            width: 48%;
        }

        .form-container h2 {
            font-size: 1.75rem;
            color: #333;
            font-weight: 700;
            margin-bottom: 2rem;
        }

        .form-container label {
            display: block;
            text-align: left;
            margin-bottom: 0.5rem;
            color: #555;
            font-weight: 500;
        }

        .form-container .form-control {
            width: 100%;
            padding: 0.75rem 1rem;
            margin-bottom: 1.5rem;
            border: 1px solid #ced4da;
            border-radius: 0.375rem;
            font-size: 1rem;
            transition: border-color 0.2s;
        }

        .form-container .form-control:focus {
            border-color: #007bff;
            outline: none;
        }

        .form-container .btn-primary {
            width: 100%;
            padding: 0.75rem;
            font-size: 1.1rem;
            font-weight: 600;
            border-radius: 0.375rem;
            background-color: #2563eb;
            border-color: #2563eb;
            transition: background-color 0.2s, border-color 0.2s;
            margin-top: 1.5rem;
        }

        .form-container .btn-primary:hover {
            background-color: #1d4ed8;
            border-color: #1d4ed8;
        }

        .forgot-password-container {
            margin-top: 1rem;
            margin-bottom: 1rem;
        }

        .forgot-password-link {
            color: #6c757d;
            text-decoration: none;
            font-size: 0.9rem;
        }

        .forgot-password-link:hover {
            color: #007bff;
            text-decoration: underline;
        }

        .register-link-container {
            margin-top: 1.5rem;
            font-size: 0.95rem;
        }

        .register-link-container a {
            color: #007bff;
            text-decoration: none;
            font-weight: 500;
        }

        .register-link-container a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>CarRent Register</h2>
        <p class="text-muted mb-4">Create your account to manage your vehicle rentals.</p>
        <% 
            String errorMessage = request.getParameter("message");
            if (errorMessage != null) {
        %>
                <div class="alert alert-danger" role="alert">
                    <%= errorMessage %>
                </div>
        <% 
            }
        %>
        <form action="RegisterServlet" method="post" onsubmit="return validateForm()">
            <div class="mb-3">
                <label for="username" class="form-label">Username:</label>
                <input type="text" class="form-control" id="username" name="username" required value="${param.username}">
            </div>

            <div class="mb-3">
                <label for="name" class="form-label">Name:</label>
                <input type="text" class="form-control" id="name" name="name" required value="${param.name}">
            </div>

            <div class="mb-3">
                <label for="address" class="form-label">Address:</label>
                <input type="text" class="form-control" id="address" name="address" required value="${param.address}">
            </div>

            <div class="mb-3">
                <label for="email" class="form-label">Email:</label>
                <input type="email" class="form-control" id="email" name="email" required value="${param.email}">
            </div>

            <div class="mb-3">
                <label for="contact" class="form-label">Contact:</label>
                <input type="tel" class="form-control" id="contact" name="contact" required value="${param.contact}" inputmode="numeric">
            </div>

            <div class="mb-3">
                <label for="password" class="form-label">Password:</label>
                <input type="password" class="form-control" id="password" name="password" required>
            </div>

            <div class="mb-3">
                <label for="confirmPassword" class="form-label">Repeat Password:</label>
                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                <span id="confirmPasswordError" class="text-danger"></span>
            </div>

            <button type="submit" class="btn btn-primary">Register</button>
        </form>
        <div class="register-link-container">
            <a href="login.jsp">Back to Login</a>
        </div>
    </div>

    <!-- Load JS from external file -->
    <script>
        function validateForm() {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const confirmPasswordError = document.getElementById('confirmPasswordError');

            confirmPasswordError.textContent = ''; // Clear previous error

            if (password !== confirmPassword) {
                confirmPasswordError.textContent = 'Passwords do not match.';
                return false;
            }
            return true;
        }
    </script>
</body>
</html>
