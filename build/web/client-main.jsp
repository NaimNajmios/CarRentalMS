<%-- 
    Document   : client-main
    Created on : 5 Jun 2025, 1:30:00 PM
    Author     : Cursor
--%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CarRent - Client Dashboard</title>
    <%@ include file="include/client-css.html" %>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <%@ include file="include/header.jsp" %>

    <main class="container mt-5 pt-5">
        <% 
            String loggedInUsername = (String) session.getAttribute("loggedInUsername");
            if (loggedInUsername == null) {
                // Redirect to login if not logged in
                response.sendRedirect("login.jsp");
                return;
            }
        %>
        <h2 class="display-4 mb-4">Welcome, <%= loggedInUsername %>!</h2>
        <p class="lead mb-5">Explore our wide range of vehicles and book your perfect car today.</p>
        <div class="d-grid gap-3 col-md-6 mx-auto">
            <a href="cars.jsp" class="btn btn-primary btn-lg">Browse Available Cars</a>
            <a href="mybooking.jsp" class="btn btn-outline-secondary btn-lg">View My Bookings</a>
            <a href="profile.jsp" class="btn btn-outline-info btn-lg">Manage Profile</a>
        </div>
    </main>

    <%@ include file="include/footer.jsp" %>
</body>
</html> 