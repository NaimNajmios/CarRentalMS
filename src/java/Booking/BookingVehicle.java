package Booking;

// Class to represent a booking in the database
public class BookingVehicle {

    // Attributes
    private String bookingID;
    private String vehicleID;
    private String assignedDate;

    // Empty constructor
    public BookingVehicle() {

    }

    // Constructor
    public BookingVehicle(String bookingID, String vehicleID, String assignedDate) {
        this.bookingID = bookingID;
        this.vehicleID = vehicleID;
        this.assignedDate = assignedDate;
    }

    // Getters and Setters
    public String getBookingID() {
        return this.bookingID;
    }

    public void setBookingID(String bookingID) {
        this.bookingID = bookingID;
    }

    public String getVehicleID() {
        return this.vehicleID;
    }

    public void setVehicleID(String vehicleID) {
        this.vehicleID = vehicleID;
    }

    public String getAssignedDate() {
        return this.assignedDate;
    }

    public void setAssignedDate(String assignedDate) {
        this.assignedDate = assignedDate;
    }

    @Override
    public String toString() {
        return "Booking{"
                + "bookingID=" + bookingID
                + ", vehicleID='" + vehicleID + '\''
                + ", assignedDate='" + assignedDate + '\''
                + '}';
    }

}
