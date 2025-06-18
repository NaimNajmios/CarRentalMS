<%-- 
    Document   : login
    Created on : 5 Jun 2025, 12:56:44?pm
    Author     : khair
--%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CarRent - Login</title>
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
            max-width: 400px;
            text-align: center;
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
        <h2><i class="fas fa-car"></i> CarRent Login</h2>
        <p class="text-muted mb-4"><i class="fas fa-cog"></i> Manage your vehicle rentals efficiently.</p>
        <% 
            String message = request.getParameter("message");
            if (message != null) {
        %>
                <div class="alert alert-info" role="alert">
                    <i class="fas fa-info-circle"></i> <%= message %>
                </div>
        <% 
            }
        %>
        <form action="LoginServlet" method="post" onsubmit="return validateLoginForm();">
            <div class="mb-3">
                <label for="username" class="form-label"><i class="fas fa-user"></i> Username:</label>
                <input type="text" class="form-control" id="username" name="username" required>
                <span id="usernameError" class="text-danger"></span>
            </div>
            <div class="mb-3">
                <label for="password" class="form-label"><i class="fas fa-lock"></i> Password:</label>
                <input type="password" class="form-control" id="password" name="password" required>
                <span id="passwordError" class="text-danger"></span>
            </div>
            <button type="submit" class="btn btn-primary"><i class="fas fa-sign-in-alt"></i> Login</button>
        </form>
        <div class="register-link-container">
            <a href="register.jsp"><i class="fas fa-user-plus"></i> Register here</a>
        </div>
    </div>
    <script>
        function validateLoginForm() {
            const usernameInput = document.getElementById('username');
            const passwordInput = document.getElementById('password');
            const usernameError = document.getElementById('usernameError');
            const passwordError = document.getElementById('passwordError');

            let isValid = true;

            // Clear previous errors
            usernameError.textContent = '';
            passwordError.textContent = '';

            if (usernameInput.value.trim() === '') {
                usernameError.textContent = 'Username cannot be empty.';
                isValid = false;
            }

            if (passwordInput.value.trim() === '') {
                passwordError.textContent = 'Password cannot be empty.';
                isValid = false;
            }

            return isValid;
        }
    </script>
</body>
</html>
