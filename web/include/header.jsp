<%@ page import="User.User"%>
<%@ page import="User.Client"%>

<%
    // Check if user is logged in
    if (session.getAttribute("loggedInUser") == null || session.getAttribute("loggedInClient") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?message=Please+log+in+to+access+client+area.&type=warning");
        return;
    }
    
    // Get logged in user and client
    User loggedUser = (User) session.getAttribute("loggedInUser");
    Client loggedClient = (Client) session.getAttribute("loggedInClient");
%>

<%-- header.jsp --%>
<header>
    <nav class="navbar navbar-expand-lg bg-white shadow-sm fixed-top">
        <div class="container">
            <a class="navbar-brand" href="#"><i class="fas fa-car"></i> CarRent</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link ${pageContext.request.requestURI.contains('main') ? 'active' : ''}" href="client-main.jsp">
                            <i class="fas fa-home"></i> Main
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${pageContext.request.requestURI.contains('cars') || pageContext.request.requestURI.contains('vehicle-details') ? 'active' : ''}" href="cars.jsp">
                            <i class="fas fa-car-side"></i> Cars
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${pageContext.request.requestURI.contains('booking') || pageContext.request.requestURI.contains('booking-form') ? 'active' : ''}" href="mybooking.jsp">
                            <i class="fas fa-calendar-check"></i> Booking
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-primary ${pageContext.request.requestURI.contains('profile') || pageContext.request.requestURI.contains('edit-profile') ? 'active' : ''}" href="client-profile.jsp">
                            <i class="fas fa-user-circle"></i> <%= loggedClient.getName() %>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${pageContext.request.requestURI.contains('logout') ? 'active' : ''}" href="Logout">
                            <i class="fas fa-sign-out-alt"></i> Logout
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
</header>