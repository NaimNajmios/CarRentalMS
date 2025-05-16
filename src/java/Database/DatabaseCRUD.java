/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Database;

import Booking.Booking;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Naim Najmi
 */
// CRUD operations for the database primarily for vehicle management, booking
// management, and user management
public class DatabaseCRUD {

    // Logger to log the messages
    private static final Logger LOGGER = Logger.getLogger(DatabaseCRUD.class.getName());

    // Connection to the database
    private Connection connection;

    // Constructor to initialize the connection
    public DatabaseCRUD() throws SQLException, ClassNotFoundException {
        connection = DatabaseConnection.getConnection();
    }

    // Method to add booking to the database, boolean is used to check if the
    // booking is added successfully
    public boolean addBooking(Booking booking) throws SQLException, ClassNotFoundException {

        try {
            connection = DatabaseConnection.getConnection();
            connection.setAutoCommit(false);

            // Step 1: Insert into BOOKING table
            String bookingQuery = "INSERT INTO BOOKING (clientID, startDate, endDate, actualReturnDate, totalCost, bookingStatus, createdBy) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement bookingStatement = connection.prepareStatement(bookingQuery);

            bookingStatement.setString(1, booking.getClientId());
            bookingStatement.setString(2, booking.getBookingStartDate());
            bookingStatement.setString(3, booking.getBookingEndDate());
            bookingStatement.setString(4, booking.getActualReturnDate());
            bookingStatement.setString(5, booking.getTotalCost());
            bookingStatement.setString(6, booking.getBookingStatus());
            bookingStatement.setString(7, booking.getCreatedBy());

            int rowsAffected = bookingStatement.executeUpdate();

            if (rowsAffected > 0) {
                // Step 2: Insert into BOOKINGVEHICLE table
                String bookingVehicleQuery = "INSERT INTO BOOKINGVEHICLE (bookingID, vehicleID, assignedDate) VALUES (?, ?, ?)";
                PreparedStatement bookingVehicleStatement = connection.prepareStatement(bookingVehicleQuery);

                bookingVehicleStatement.setString(1, booking.getBookingId());
                bookingVehicleStatement.setString(2, booking.getVehicleId());
                bookingVehicleStatement.setString(3, booking.getAssignedDate());

                rowsAffected = bookingVehicleStatement.executeUpdate();

                if (rowsAffected > 0) {
                    connection.commit();
                    return true;
                }
            }

            connection.rollback();
            return false;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding booking to the database", e);
        } finally {
            connection.close();
        }
        return false;
    }

}
