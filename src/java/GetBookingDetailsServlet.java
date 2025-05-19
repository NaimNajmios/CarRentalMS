import Booking.Booking;
import Database.UIAccessObject;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.google.gson.Gson;
import java.io.IOException;

@WebServlet("/getBookingDetails")
public class GetBookingDetailsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {

        String bookingId = request.getParameter("bookingId");
        UIAccessObject uiAccessObject = new UIAccessObject();
        Booking booking = uiAccessObject.getBookingById(bookingId);

        response.setContentType("application/json");
        if (booking != null) {
            response.getWriter().write(new Gson().toJson(booking));
        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("{\"error\": \"Booking not found\"}");
        }
    }
}