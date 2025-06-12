<%@ page import="Database.UIAccessObject"%>
<%@ page import="java.util.logging.Logger"%>
<%@ page import="java.util.logging.Level"%>
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%
    response.setContentType("application/json");
    response.setHeader("Cache-Control", "no-cache");
    
    Logger logger = Logger.getLogger("update-booking-status.jsp");
    String bookingId = request.getParameter("bookingId");
    String newStatus = request.getParameter("status");
    
    boolean success = false;
    String message = "";
    
    if (bookingId != null && !bookingId.trim().isEmpty() && 
        newStatus != null && !newStatus.trim().isEmpty()) {
        
        try {
            UIAccessObject uiAccessObject = new UIAccessObject();
            
            // Validate the status
            if (isValidStatus(newStatus)) {
                // Update the booking status
                success = uiAccessObject.updateBookingStatus(bookingId, newStatus);
                
                if (success) {
                    message = "Booking status updated successfully";
                    logger.log(Level.INFO, "Booking " + bookingId + " status updated to " + newStatus);
                } else {
                    message = "Failed to update booking status";
                    logger.log(Level.WARNING, "Failed to update booking " + bookingId + " status to " + newStatus);
                }
            } else {
                message = "Invalid status value";
                logger.log(Level.WARNING, "Invalid status value: " + newStatus);
            }
        } catch (Exception e) {
            message = "Error updating booking status: " + e.getMessage();
            logger.log(Level.SEVERE, "Error updating booking status", e);
        }
    } else {
        message = "Missing required parameters";
        logger.log(Level.WARNING, "Missing parameters - bookingId: " + bookingId + ", status: " + newStatus);
    }
    
    // Return JSON response
    out.print("{\"success\": " + success + ", \"message\": \"" + message + "\"}");
%>

<%!
    private boolean isValidStatus(String status) {
        if (status == null) return false;
        
        switch (status.trim()) {
            case "Pending":
            case "Confirmed":
            case "Cancelled":
            case "Completed":
                return true;
            default:
                return false;
        }
    }
%> 