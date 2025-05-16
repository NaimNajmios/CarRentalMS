/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Database;

import Booking.Booking;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
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

    // Method to add booking to the database, returning boolean for success
    public boolean addBooking(Booking booking) throws SQLException, ClassNotFoundException {
        long newBookingId = -1;

        try {
            LOGGER.info("Attempting to add new booking to the database");
            connection = DatabaseConnection.getConnection();
            connection.setAutoCommit(false);

            // Step 1: Insert into BOOKING table and retrieve the generated key
            String bookingQuery = "INSERT INTO BOOKING (clientID, bookingDate, startDate, endDate, totalCost, bookingStatus) VALUES (?, ?, ?, ?, ?, ?)";
            try (PreparedStatement bookingStatement = connection.prepareStatement(bookingQuery,
                    Statement.RETURN_GENERATED_KEYS)) {

                bookingStatement.setString(1, booking.getClientId());
                bookingStatement.setString(2, booking.getBookingDate());
                bookingStatement.setString(3, booking.getBookingStartDate());
                bookingStatement.setString(4, booking.getBookingEndDate());
                bookingStatement.setString(5, booking.getTotalCost());
                bookingStatement.setString(6, booking.getBookingStatus());

                LOGGER.info("Executing BOOKING table insert query");
                int rowsAffected = bookingStatement.executeUpdate();

                if (rowsAffected > 0) {
                    LOGGER.info("BOOKING table insert successful. Retrieving generated bookingID.");
                    try (ResultSet generatedKeys = bookingStatement.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            newBookingId = generatedKeys.getLong(1);
                            LOGGER.info("Generated bookingID: " + newBookingId);

                            // Step 2: Insert into BOOKINGVEHICLE table using the generated bookingID
                            String bookingVehicleQuery = "INSERT INTO BOOKINGVEHICLE (bookingID, vehicleID, assignedDate) VALUES (?, ?, ?)";
                            try (PreparedStatement bookingVehicleStatement = connection
                                    .prepareStatement(bookingVehicleQuery)) {
                                bookingVehicleStatement.setLong(1, newBookingId);
                                bookingVehicleStatement.setString(2, booking.getVehicleId());
                                bookingVehicleStatement.setString(3, booking.getAssignedDate());

                                LOGGER.info("Executing BOOKINGVEHICLE table insert query");
                                int bookingVehicleRowsAffected = bookingVehicleStatement.executeUpdate();

                                if (bookingVehicleRowsAffected > 0) {
                                    LOGGER.info("BOOKINGVEHICLE table insert successful.");

                                    // Step 3: Insert into PAYMENT table using the generated bookingID
                                    String paymentQuery = "INSERT INTO payment (bookingID, paymentType, amount, paymentStatus, paymentDate, referenceNo, invoiceNumber, handledBy, proofOfPayment) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                                    try (PreparedStatement paymentStatement = connection
                                            .prepareStatement(paymentQuery)) {
                                        paymentStatement.setLong(1, newBookingId);
                                        paymentStatement.setString(2, null); // Default payment type, null
                                        paymentStatement.setString(3, booking.getTotalCost());
                                        paymentStatement.setString(4, "Pending"); // Default payment status
                                        paymentStatement.setDate(5, null); // Null date
                                        paymentStatement.setString(6, null); // referenceNo (can be set by booking if
                                                                             // needed)
                                        paymentStatement.setString(7, null); // invoiceNumber (null)
                                        paymentStatement.setString(8, null); // handledBy (null)
                                        paymentStatement.setString(9, null); // proofOfPayment (null)

                                        LOGGER.info("Executing PAYMENT table insert query");
                                        int paymentRowsAffected = paymentStatement.executeUpdate();

                                        if (paymentRowsAffected > 0) {
                                            LOGGER.info("PAYMENT table insert successful. Committing transaction");
                                            connection.commit();
                                            return true; // Return true if all inserts are successful
                                        } else {
                                            LOGGER.warning("PAYMENT table insert failed. Rolling back transaction");
                                            connection.rollback();
                                            return false;
                                        }
                                    }
                                } else {
                                    LOGGER.warning("BOOKINGVEHICLE table insert failed. Rolling back transaction");
                                    connection.rollback();
                                    return false;
                                }
                            }
                        } else {
                            LOGGER.warning("Failed to retrieve generated bookingID. Rolling back transaction.");
                            connection.rollback();
                            return false;
                        }
                    }
                } else {
                    LOGGER.warning("BOOKING table insert failed. Rolling back transaction");
                    connection.rollback();
                    return false;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding booking to the database", e);
            if (connection != null) {
                try {
                    LOGGER.info("Rolling back transaction due to error");
                    connection.rollback();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Error rolling back transaction", ex);
                }
            }
            throw e; // Re-throw the SQLException to be handled by the caller
        } finally {
            if (connection != null) {
                connection.close();
            }
        }
    }

}
