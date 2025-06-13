package Servlet;

import Database.UIAccessObject;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.time.LocalDate;
import java.util.ArrayList;

@WebServlet(name = "GetVehicleBookedDates", urlPatterns = {"/GetVehicleBookedDates"})
public class GetVehicleBookedDates extends HttpServlet {
    private static final Logger logger = Logger.getLogger(GetVehicleBookedDates.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            String vehicleIdStr = request.getParameter("vehicleId");
            if (vehicleIdStr == null || vehicleIdStr.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Vehicle ID is required");
                return;
            }

            int vehicleId = Integer.parseInt(vehicleIdStr);
            UIAccessObject uiAccessObject = new UIAccessObject();
            List<LocalDate> bookedDates = uiAccessObject.getBookedDatesForVehicle(vehicleId);

            // Convert booked dates to JSON manually
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < bookedDates.size(); i++) {
                json.append("\"").append(bookedDates.get(i).toString()).append("\"");
                if (i < bookedDates.size() - 1) {
                    json.append(",");
                }
            }
            json.append("]");

            out.print(json.toString());
            logger.log(Level.INFO, "Retrieved booked dates for vehicle ID: {0}", vehicleId);

        } catch (NumberFormatException e) {
            logger.log(Level.WARNING, "Invalid vehicle ID format", e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid vehicle ID format");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error retrieving booked dates", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving booked dates");
        } finally {
            out.flush();
        }
    }
} 