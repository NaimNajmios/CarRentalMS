<%@ page import="Database.UIAccessObject"%>
<%@ page import="java.util.logging.Logger"%>
<%@ page import="java.util.logging.Level"%>
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%
    response.setContentType("application/json");
    response.setHeader("Cache-Control", "no-cache");
    
    Logger logger = Logger.getLogger("update-booking.jsp");
    logger.log(Level.INFO, "Starting booking update process");
    
    // Get and validate booking ID first
    String bookingId = request.getParameter("bookingId");
    String adminId = request.getParameter("adminId");
    
    if (bookingId == null || bookingId.trim().isEmpty()) {
        logger.log(Level.WARNING, "Booking ID is missing");
        out.print("{\"success\": false, \"message\": \"Booking ID is required\"}");
        return;
    }
    
    if (adminId == null || adminId.trim().isEmpty()) {
        logger.log(Level.WARNING, "Admin ID is missing");
        out.print("{\"success\": false, \"message\": \"Admin ID is required\"}");
        return;
    }
    
    // Get other parameters
    String startDate = request.getParameter("startDate");
    String endDate = request.getParameter("endDate");
    String totalCost = request.getParameter("totalCost");
    
    // Log all parameters received
    logger.log(Level.INFO, "Received parameters:");
    logger.log(Level.INFO, "Booking ID: {0}", bookingId);
    logger.log(Level.INFO, "Admin ID: {0}", adminId);
    logger.log(Level.INFO, "Start Date: {0}", startDate);
    logger.log(Level.INFO, "End Date: {0}", endDate);
    logger.log(Level.INFO, "Total Cost: {0}", totalCost);
    
    boolean success = false;
    String message = "";
    
    try {
        if (startDate == null || startDate.trim().isEmpty()) {
            message = "Start date is required";
            logger.log(Level.WARNING, "Start date is missing for booking {0}", bookingId);
        } else if (endDate == null || endDate.trim().isEmpty()) {
            message = "End date is required";
            logger.log(Level.WARNING, "End date is missing for booking {0}", bookingId);
        } else if (totalCost == null || totalCost.trim().isEmpty()) {
            message = "Total cost is required";
            logger.log(Level.WARNING, "Total cost is missing for booking {0}", bookingId);
        } else {
            UIAccessObject uiAccessObject = new UIAccessObject();
            
            // Verify booking exists before updating
            if (uiAccessObject.getBookingByBookingId(bookingId) == null) {
                message = "Booking not found";
                logger.log(Level.WARNING, "Booking {0} not found in database", bookingId);
            } else {
                // Update both booking and payment
                success = uiAccessObject.updateBooking(bookingId, startDate, endDate, totalCost, adminId);
                
                if (success) {
                    message = "Booking and payment updated successfully";
                    logger.log(Level.INFO, "Booking {0} and payment updated successfully", bookingId);
                    logger.log(Level.INFO, "New dates: {0} to {1}", new Object[]{startDate, endDate});
                    logger.log(Level.INFO, "New cost: {0}", totalCost);
                    logger.log(Level.INFO, "Updated by admin: {0}", adminId);
                } else {
                    message = "Failed to update booking and payment";
                    logger.log(Level.WARNING, "Failed to update booking {0} and payment", bookingId);
                }
            }
        }
    } catch (Exception e) {
        message = "Error updating booking and payment: " + e.getMessage();
        logger.log(Level.SEVERE, "Error updating booking {0} and payment: {1}", 
            new Object[]{bookingId, e.getMessage()});
    }
    
    logger.log(Level.INFO, "Booking update process completed");
    logger.log(Level.INFO, "Success: {0}", success);
    logger.log(Level.INFO, "Message: {0}", message);
    
    // Return JSON response
    out.print("{\"success\": " + success + ", \"message\": \"" + message + "\"}");
%>