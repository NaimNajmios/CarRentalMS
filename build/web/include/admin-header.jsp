<%@ page import="User.User" %>
<%@ page import="User.Admin" %>
<%
    // Check if session attributes exist
    if (session.getAttribute("loggedInUser") == null || session.getAttribute("loggedInAdmin") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?message=Please+log+in+to+access+admin+area.&type=warning");
        return;
    }
%>

<%-- admin-header.jsp --%>
<header>
    <nav class="navbar navbar-expand-lg bg-white shadow-sm fixed-top">
        <div class="container">
            <a class="navbar-brand" href="admin-dashboard.jsp"><i class="fas fa-car-side"></i> CarRent</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <span class="nav-link"><i class="fas fa-user-shield"></i> <%= ((Admin)session.getAttribute("loggedInAdmin")).getName() %></span>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${pageContext.request.requestURI.contains('logout') ? 'active' : ''}" href="${pageContext.request.contextPath}/Logout"><i class="fas fa-power-off"></i> Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
</header>