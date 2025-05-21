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
        LOGGER.info("Initializing DatabaseCRUD");
        connection = DatabaseConnection.getConnection();
        LOGGER.info("DatabaseCRUD initialized successfully");
    }

    // Method to add booking to the database, returning boolean for success
    public boolean addBooking(Booking booking) throws SQLException, ClassNotFoundException {
        LOGGER.info("Starting addBooking method");
        long newBookingId = -1;

        try {
            LOGGER.info("Attempting to add new booking to the database");
            connection = DatabaseConnection.getConnection();
            connection.setAutoCommit(false);
            LOGGER.info("Database connection established and auto-commit set to false");

            // Step 1: Insert into BOOKING table and retrieve the generated key
            String bookingQuery = "INSERT INTO BOOKING (clientID, bookingDate, startDate, endDate, totalCost, bookingStatus) VALUES (?, ?, ?, ?, ?, ?)";
            try (PreparedStatement bookingStatement = connection.prepareStatement(bookingQuery,
                    Statement.RETURN_GENERATED_KEYS)) {

                LOGGER.info("Preparing BOOKING table insert query");
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
                                LOGGER.info("Preparing BOOKINGVEHICLE table insert query");
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
                                        LOGGER.info("Preparing PAYMENT table insert query");
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
                                            LOGGER.info("Transaction committed successfully");
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
                LOGGER.info("Closing database connection");
                connection.close();
            }
        }
    }

    // Method for client to submit payment status in the database, returning boolean
    // for success,
    public boolean submitPayment(String paymentId, String paymentType, String paymentStatus, String paymentDate,
            String invoiceNumber, String proofOfPayment)
            throws SQLException, ClassNotFoundException {
        LOGGER.info("Starting submitPayment method");
        try {
            LOGGER.info("Attempting to submit payment for payment ID: " + paymentId);
            connection = DatabaseConnection.getConnection();
            connection.setAutoCommit(false);
            LOGGER.info("Database connection established and auto-commit set to false");

            String paymentQuery = "UPDATE payment SET paymentType = ?, paymentStatus = ?, paymentDate = ?, invoiceNumber = ?, proofOfPayment = ? WHERE paymentID = ?";

            try (PreparedStatement paymentStatement = connection.prepareStatement(paymentQuery)) {
                LOGGER.info("Preparing PAYMENT table update query");
                paymentStatement.setString(1, paymentType);
                paymentStatement.setString(2, paymentStatus);
                paymentStatement.setString(3, paymentDate);
                paymentStatement.setString(4, invoiceNumber);
                paymentStatement.setString(5, proofOfPayment);
                paymentStatement.setString(6, paymentId);

                LOGGER.info("Executing PAYMENT table update query");
                int paymentRowsAffected = paymentStatement.executeUpdate();

                if (paymentRowsAffected > 0) {
                    LOGGER.info("PAYMENT table update successful. Committing transaction");
                    connection.commit();
                    LOGGER.info("Transaction committed successfully");
                    return true;
                } else {
                    LOGGER.warning("PAYMENT table update failed. Rolling back transaction");
                    connection.rollback();
                    return false;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error submitting payment to the database", e);
            throw e;
        } finally {
            if (connection != null) {
                LOGGER.info("Closing database connection");
                connection.close();
            }
        }
    }

    // Method to update payment status and booking status in the database, returning
    // boolean for success
    public boolean updatePaymentStatus(String paymentId, String paymentStatus)
            throws SQLException, ClassNotFoundException {
        LOGGER.info("Starting updatePaymentStatus method");
        try {
            LOGGER.info("Attempting to update payment status for payment ID: " + paymentId);
            connection = DatabaseConnection.getConnection();
            connection.setAutoCommit(false);
            LOGGER.info("Database connection established and auto-commit set to false");

            String paymentQuery = "UPDATE payment SET paymentStatus = ? WHERE paymentID = ?";
            String bookingQuery = "UPDATE booking SET bookingStatus = ? WHERE bookingID = (SELECT bookingID FROM payment WHERE paymentID = ?)";

            try (PreparedStatement paymentStatement = connection.prepareStatement(paymentQuery);
                    PreparedStatement bookingStatement = connection.prepareStatement(bookingQuery)) {

                LOGGER.info("Preparing PAYMENT table update query");
                paymentStatement.setString(1, paymentStatus);
                paymentStatement.setString(2, paymentId);

                LOGGER.info("Executing PAYMENT table update query");
                int paymentRowsAffected = paymentStatement.executeUpdate();

                LOGGER.info("Preparing BOOKING table update query");
                String bookingStatus = paymentStatus.equals("Completed") ? "Completed" : "Pending";
                bookingStatement.setString(1, bookingStatus);
                bookingStatement.setString(2, paymentId);

                LOGGER.info("Executing BOOKING table update query");
                int bookingRowsAffected = bookingStatement.executeUpdate();

                if (paymentRowsAffected > 0 && bookingRowsAffected > 0) {
                    LOGGER.info("PAYMENT and BOOKING tables update successful. Committing transaction");
                    connection.commit();
                    LOGGER.info("Transaction committed successfully");
                    return true;
                } else {
                    LOGGER.warning("PAYMENT or BOOKING table update failed. Rolling back transaction");
                    connection.rollback();
                    return false;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating payment and booking status in the database", e);
            if (connection != null) {
                try {
                    LOGGER.warning("Rolling back transaction due to error");
                    connection.rollback();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Error rolling back transaction", ex);
                }
            }
            throw e;
        } finally {
            if (connection != null) {
                try {
                    LOGGER.info("Closing database connection");
                    connection.close();
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Error closing database connection", e);
                }
            }
        }
    }
}
