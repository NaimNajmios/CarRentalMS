/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Booking;

/**
 *
 * @author Naim Najmi
 */
// Class to represent a booking in the database
public class Booking {

    // Attributes
    private String bookingId;
    private String clientId;
    private String vehicleId;
    private String assignedDate;
    private String bookingDate;
    private String bookingStartDate;
    private String bookingEndDate;
    private String actualReturnDate;
    private String totalCost;
    private String bookingStatus;
    private String createdBy;

    // Empty constructor
    public Booking() {
    }

    // Constructor
    public Booking(String clientId, String vehicleId, String assignedDate, String bookingDate,
            String bookingStartDate, String bookingEndDate, String totalCost,
            String bookingStatus, String createdBy) {
        this.clientId = clientId;
        this.vehicleId = vehicleId;
        this.assignedDate = assignedDate;
        this.bookingDate = bookingDate;
        this.bookingStartDate = bookingStartDate;
        this.bookingEndDate = bookingEndDate;
        this.totalCost = totalCost;
        this.bookingStatus = bookingStatus;
        this.createdBy = createdBy;
    }

    public String getBookingId() {  
        return this.bookingId;
    }

    public void setBookingId(String bookingId) {
        this.bookingId = bookingId;
    }

    public String getClientId() {
        return this.clientId;
    }

    public void setClientId(String clientId) {
        this.clientId = clientId;
    }

    public String getVehicleId() {
        return this.vehicleId;
    }

    public void setVehicleId(String vehicleId) {
        this.vehicleId = vehicleId;
    }

    public String getAssignedDate() {
        return this.assignedDate;
    }

    public void setAssignedDate(String assignedDate) {
        this.assignedDate = assignedDate;
    }

    public String getBookingDate() {
        return this.bookingDate;
    }

    public void setBookingDate(String bookingDate) {
        this.bookingDate = bookingDate;
    }

    public String getBookingStartDate() {
        return this.bookingStartDate;
    }

    public void setBookingStartDate(String bookingStartDate) {
        this.bookingStartDate = bookingStartDate;
    }

    public String getBookingEndDate() {
        return this.bookingEndDate;
    }

    public void setBookingEndDate(String bookingEndDate) {
        this.bookingEndDate = bookingEndDate;
    }

    public String getActualReturnDate() {
        return this.actualReturnDate;
    }

    public void setActualReturnDate(String actualReturnDate) {
        this.actualReturnDate = actualReturnDate;
    }

    public String getTotalCost() {
        return this.totalCost;
    }

    public void setTotalCost(String totalCost) {
        this.totalCost = totalCost;
    }

    public String getBookingStatus() {
        return this.bookingStatus;
    }

    public void setBookingStatus(String bookingStatus) {
        this.bookingStatus = bookingStatus;
    }

    public String getCreatedBy() {
        return this.createdBy;
    }

    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }

    // toString method
    @Override
    public String toString() {
        return "Booking{" + "bookingId=" + bookingId + ", clientId=" + clientId + ", bookingDate=" + bookingDate
                + ", bookingStartDate=" + bookingStartDate + ", bookingEndDate=" + bookingEndDate
                + ", actualReturnDate=" + actualReturnDate + ", totalCost=" + totalCost + ", bookingStatus="
                + bookingStatus + ", createdBy=" + createdBy + '}';
    }

}
