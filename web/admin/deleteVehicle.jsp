<%-- 
    Document   : deleteVehicle
    Created on : Jun 3, 2025, 12:32:54 PM
    Author     : nadhi
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, Database.vehicleDAO, Vehicles.Vehicles" %>
<%
    // Get vehicle ID from request parameter
    String vehicleId = request.getParameter("id");

    // Initialize response message variables
    String message = "";
    String messageType = "";

    try {
        // Validate vehicle ID
        if (vehicleId == null || vehicleId.trim().isEmpty()) {
            message = "Invalid vehicle ID";
            messageType = "danger";
        } else {
            // Attempt to soft delete the vehicle
            boolean success = vehicleDAO.softDeleteVehicle(vehicleId);

            if (success) {
                message = "Vehicle deleted successfully";
                messageType = "success";
            } else {
                message = "Failed to delete vehicle";
                messageType = "danger";
            }
        }
    } catch (Exception e) {
        message = "An error occurred while deleting the vehicle";
        messageType = "danger";
        e.printStackTrace();
    }

    // Redirect back to vehicles page with appropriate message
    response.sendRedirect(request.getContextPath() + "/admin/admin-vehicles.jsp?message="
            + java.net.URLEncoder.encode(message, "UTF-8")
            + "&type=" + messageType);
%>