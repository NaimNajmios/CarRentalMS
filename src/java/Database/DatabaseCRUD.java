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

    // Constructor to initialize the connection
    public DatabaseCRUD() {
        LOGGER.info("Initializing DatabaseCRUD");
        LOGGER.info("DatabaseCRUD initialized successfully");
    }

    private Connection getConnection() throws SQLException, ClassNotFoundException {
        return DatabaseConnection.getConnection();
    }

    // Method to add booking to the database, returning boolean for success
    public boolean addBooking(Booking booking) throws SQLException, ClassNotFoundException {
        LOGGER.info("Starting addBooking method");
        long newBookingId = -1;
        Connection connection = null;

        try {
            LOGGER.info("Attempting to add new booking to the database");
            connection = getConnection();
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
                                        paymentStatement.setString(6, null); // referenceNo (can be set by booking if needed)
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
                try {
                    LOGGER.info("Closing database connection");
                    connection.close();
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Error closing database connection", e);
                }
            }
        }
    }

    // Method to add booking to the database with payment type, returning boolean for success
    public boolean addBooking(Booking booking, String paymentType) throws SQLException, ClassNotFoundException {
        LOGGER.info("Starting addBooking method with payment type: " + paymentType);
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;

        try {
            conn = getConnection();
            conn.setAutoCommit(false); // Start transaction

            // Insert into BOOKING table
            String sql = "INSERT INTO BOOKING (clientID, bookingDate, startDate, endDate, totalCost, bookingStatus, createdBy) VALUES (?, ?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, booking.getClientId());
            pstmt.setString(2, booking.getBookingDate());
            pstmt.setString(3, booking.getBookingStartDate());
            pstmt.setString(4, booking.getBookingEndDate());
            pstmt.setString(5, booking.getTotalCost());
            pstmt.setString(6, booking.getBookingStatus());
            pstmt.setInt(7, Integer.parseInt(booking.getCreatedBy())); // Convert createdBy to integer

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                // Get the generated booking ID
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        String bookingId = generatedKeys.getString(1);
                        
                        // Insert into BOOKINGVEHICLE table
                        String bookingVehicleSql = "INSERT INTO BOOKINGVEHICLE (bookingID, vehicleID, assignedDate) VALUES (?, ?, ?)";
                        pstmt = conn.prepareStatement(bookingVehicleSql);
                        pstmt.setString(1, bookingId);
                        pstmt.setString(2, booking.getVehicleId());
                        pstmt.setString(3, booking.getAssignedDate());
                        
                        rowsAffected = pstmt.executeUpdate();
                        if (rowsAffected > 0) {
                            // Insert into PAYMENT table
                            String paymentSql = "INSERT INTO PAYMENT (bookingID, paymentDate, amount, paymentType, paymentStatus) VALUES (?, ?, ?, ?, ?)";
                            pstmt = conn.prepareStatement(paymentSql);
                            pstmt.setString(1, bookingId);
                            pstmt.setString(2, booking.getBookingDate()); // Use booking date as payment date
                            pstmt.setString(3, booking.getTotalCost());
                            pstmt.setString(4, paymentType);
                            pstmt.setString(5, "Completed"); // Set initial payment status as Completed

                            rowsAffected = pstmt.executeUpdate();
                            if (rowsAffected > 0) {
                                conn.commit(); // Commit transaction
                                success = true;
                                LOGGER.info("Successfully added booking with ID: " + bookingId);
                            } else {
                                conn.rollback(); // Rollback if payment insertion fails
                                LOGGER.warning("Failed to insert payment record");
                            }
                        } else {
                            conn.rollback(); // Rollback if booking vehicle insertion fails
                            LOGGER.warning("Failed to insert booking vehicle record");
                        }
                    } else {
                        conn.rollback(); // Rollback if no booking ID was generated
                        LOGGER.warning("Failed to get generated booking ID");
                    }
                }
            } else {
                conn.rollback(); // Rollback if booking insertion fails
                LOGGER.warning("Failed to insert booking record");
            }
        } catch (SQLException e) {
            LOGGER.severe("Error adding booking: " + e.getMessage());
            try {
                if (conn != null) {
                    conn.rollback(); // Rollback on error
                }
            } catch (SQLException ex) {
                LOGGER.severe("Error rolling back transaction: " + ex.getMessage());
            }
            throw e;
        } catch (NumberFormatException e) {
            LOGGER.severe("Error converting createdBy to integer: " + e.getMessage());
            try {
                if (conn != null) {
                    conn.rollback(); // Rollback on error
                }
            } catch (SQLException ex) {
                LOGGER.severe("Error rolling back transaction: " + ex.getMessage());
            }
            throw new SQLException("Invalid admin ID format: " + e.getMessage());
        } finally {
            try {
                if (pstmt != null) {
                    pstmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                LOGGER.severe("Error closing resources: " + e.getMessage());
            }
        }
        return success;
    }

    // Method for client to submit payment status in the database, returning boolean
    // for success,
    public boolean submitPayment(String paymentId, String paymentType, String paymentStatus, String paymentDate,
            String invoiceNumber, String proofOfPayment)
            throws SQLException, ClassNotFoundException {
        LOGGER.info("Starting submitPayment method");
        Connection connection = null;
        try {
            LOGGER.info("Attempting to submit payment for payment ID: " + paymentId);
            connection = getConnection();
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

    // Method to update payment status and booking status in the database, returning
    // boolean for success
    public boolean updatePaymentStatus(String paymentId, String paymentStatus, String adminid)
            throws SQLException, ClassNotFoundException {
        LOGGER.info("Starting updatePaymentStatus method");
        Connection connection = null;
        try {
            LOGGER.info("Attempting to update payment status for payment ID: " + paymentId);
            connection = getConnection();
            connection.setAutoCommit(false);
            LOGGER.info("Database connection established and auto-commit set to false");

            String paymentQuery = "UPDATE payment SET paymentStatus = ?, handledBy = ? WHERE paymentID = ?";
            String bookingQuery = "UPDATE booking SET bookingStatus = ? WHERE bookingID = (SELECT bookingID FROM payment WHERE paymentID = ?)";

            try (PreparedStatement paymentStatement = connection.prepareStatement(paymentQuery);
                    PreparedStatement bookingStatement = connection.prepareStatement(bookingQuery)) {

                LOGGER.info("Preparing PAYMENT table update query");
                paymentStatement.setString(1, paymentStatus);
                paymentStatement.setString(2, adminid);
                paymentStatement.setString(3, paymentId);

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

    /**
     * Cancels a booking based on the provided booking ID.
     * Updates both the booking and payment status to "Cancelled".
     *
     * @param bookingId The ID of the booking to cancel
     * @return true if the cancellation was successful, false otherwise
     * @throws SQLException if there is an error accessing the database
     */
    public boolean cancelBooking(String bookingId) throws SQLException, ClassNotFoundException {
        Connection connection = null;
        try {
            connection = getConnection();
            connection.setAutoCommit(false);

            // Prepare statements for updating both booking and payment tables
            String bookingUpdateQuery = "UPDATE booking SET bookingStatus = ? WHERE bookingID = ?";
            String paymentUpdateQuery = "UPDATE payment SET paymentStatus = ? WHERE bookingID = ?";

            try (PreparedStatement bookingStatement = connection.prepareStatement(bookingUpdateQuery);
                 PreparedStatement paymentStatement = connection.prepareStatement(paymentUpdateQuery)) {

                LOGGER.info("Preparing BOOKING table update query for cancellation");
                bookingStatement.setString(1, "Cancelled");
                bookingStatement.setString(2, bookingId);

                LOGGER.info("Preparing PAYMENT table update query for cancellation");
                paymentStatement.setString(1, "Pending");
                paymentStatement.setString(2, bookingId);

                LOGGER.info("Executing BOOKING table update query");
                int bookingRowsAffected = bookingStatement.executeUpdate();

                LOGGER.info("Executing PAYMENT table update query");
                int paymentRowsAffected = paymentStatement.executeUpdate();

                if (bookingRowsAffected > 0 && paymentRowsAffected > 0) {
                    LOGGER.info("Booking cancellation successful. Committing transaction");
                    connection.commit();
                    LOGGER.info("Transaction committed successfully");
                    return true;
                } else {
                    LOGGER.warning("Booking cancellation failed. Rolling back transaction");
                    connection.rollback();
                    return false;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error cancelling booking in the database", e);
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

    public String getLatestBookingId(String clientId) throws SQLException, ClassNotFoundException {
        LOGGER.info("Getting latest booking ID for client: " + clientId);
        String bookingId = null;
        Connection connection = null;

        try {
            connection = getConnection();
            String query = "SELECT bookingID FROM BOOKING WHERE clientID = ? ORDER BY bookingID DESC LIMIT 1";
            
            try (PreparedStatement statement = connection.prepareStatement(query)) {
                statement.setString(1, clientId);
                
                try (ResultSet resultSet = statement.executeQuery()) {
                    if (resultSet.next()) {
                        bookingId = resultSet.getString("bookingID");
                        LOGGER.info("Found latest booking ID: " + bookingId);
                    } else {
                        LOGGER.warning("No booking found for client: " + clientId);
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting latest booking ID", e);
            throw e;
        } finally {
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Error closing connection", e);
                }
            }
        }
        
        return bookingId;
    }
}
