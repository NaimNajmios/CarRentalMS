<%@ page import="Database.UIAccessObject"%>
<%@ page import="java.util.logging.Logger"%>
<%@ page import="java.util.logging.Level"%>
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%
    response.setContentType("application/json");
    response.setHeader("Cache-Control", "no-cache");
    
    Logger logger = Logger.getLogger("update-booking.jsp");
    
    // Get and validate booking ID first
    String bookingId = request.getParameter("bookingId");
    if (bookingId == null || bookingId.trim().isEmpty()) {
        out.print("{\"success\": false, \"message\": \"Booking ID is required\"}");
        return;
    }
    
    // Get other parameters
    String startDate = request.getParameter("startDate");
    String endDate = request.getParameter("endDate");
    String totalCost = request.getParameter("totalCost");
    
    boolean success = false;
    String message = "";
    
    try {
        if (startDate == null || startDate.trim().isEmpty()) {
            message = "Start date is required";
        } else if (endDate == null || endDate.trim().isEmpty()) {
            message = "End date is required";
        } else if (totalCost == null || totalCost.trim().isEmpty()) {
            message = "Total cost is required";
        } else {
            UIAccessObject uiAccessObject = new UIAccessObject();
            
            // Verify booking exists before updating
            if (uiAccessObject.getBookingByBookingId(bookingId) == null) {
                message = "Booking not found";
            } else {
                success = uiAccessObject.updateBooking(bookingId, startDate, endDate, totalCost);
                
                if (success) {
                    message = "Booking updated successfully";
                    logger.log(Level.INFO, "Booking {0} updated successfully", bookingId);
                } else {
                    message = "Failed to update booking";
                    logger.log(Level.WARNING, "Failed to update booking {0}", bookingId);
                }
            }
        }
    } catch (Exception e) {
        message = "Error updating booking: " + e.getMessage();
        logger.log(Level.SEVERE, "Error updating booking", e);
    }
    
    // Return JSON response
    out.print("{\"success\": " + success + ", \"message\": \"" + message + "\"}");
%> 