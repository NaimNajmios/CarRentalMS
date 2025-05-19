/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Database;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import Vehicle.Vehicle;
import java.util.logging.Level;
import java.util.logging.Logger;

import Booking.Booking;
import Booking.BookingVehicle;
import Payment.Payment;
import User.Client;
import User.User;
import java.time.LocalDate;

/**
 *
 * @author Naim Najmi
 */
public class UIAccessObject {

    // Logger for debugging
    private static final Logger LOGGER = Logger.getLogger(UIAccessObject.class.getName());

    // Object classes
    private Vehicle vehicle = new Vehicle();
    private Booking booking = new Booking();

    // Instance of DatabaseConnection to manage database connections
    Connection connection = null;
    PreparedStatement preparedStatement = null;
    ResultSet resultSet = null;

    public UIAccessObject() {
        LOGGER.log(Level.INFO, "UIAccessObject instance created");
    }

    // Fetch list of vehicles from the database in ArrayList, return ArrayList
    public ArrayList<Vehicle> getVehicleList() throws ClassNotFoundException, SQLException {
        ArrayList<Vehicle> vehicleList = new ArrayList<>();
        try {
            connection = DatabaseConnection.getConnection();
            preparedStatement = connection.prepareStatement("SELECT * FROM vehicles");
            LOGGER.log(Level.INFO, "Executing SQL query: {0}", preparedStatement.toString());
            resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                Vehicle vehicle = new Vehicle(); // Create a new Vehicle object for each row
                vehicle.setVehicleId(resultSet.getInt("vehicleID"));
                vehicle.setVehicleModel(resultSet.getString("model"));
                vehicle.setVehicleBrand(resultSet.getString("brand"));
                vehicle.setVehicleYear(resultSet.getInt("manufacturingYear"));
                vehicle.setVehicleAvailablity(resultSet.getBoolean("availability"));
                vehicle.setVehicleCategory(resultSet.getString("category"));
                vehicle.setVehicleFuelType(resultSet.getString("fuelType"));
                vehicle.setTransmissionType(resultSet.getString("transmissionType"));
                vehicle.setVehicleMileage(resultSet.getInt("mileage"));
                vehicle.setVehicleRatePerDay(resultSet.getString("ratePerDay"));
                vehicle.setVehicleRegistrationNo(resultSet.getString("registrationNo"));
                vehicle.setVehicleImagePath(resultSet.getString("vehicleImagePath"));
                vehicleList.add(vehicle);
                LOGGER.log(Level.FINE, "Retrieved vehicle: {0}", vehicle.getVehicleId());
            }
            LOGGER.log(Level.INFO, "Successfully retrieved {0} vehicles.", vehicleList.size());
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching vehicle list from the database", e);
        } finally {
            // Close resources in a finally block to ensure they are always closed
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
                LOGGER.log(Level.FINE, "Database resources closed.");
            } catch (SQLException ex) {
                LOGGER.log(Level.WARNING, "Error closing database resources", ex);
            }
        }
        return vehicleList;
    }

    public Vehicle getVehicleById(int vehicleId) throws ClassNotFoundException, SQLException {
        Vehicle vehicle = null;
        try {
            connection = DatabaseConnection.getConnection();
            preparedStatement = connection.prepareStatement("SELECT * FROM vehicles WHERE vehicleID = ?");
            preparedStatement.setInt(1, vehicleId);
            LOGGER.log(Level.INFO, "Executing SQL query: {0}", preparedStatement.toString());
            resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                vehicle = new Vehicle();
                vehicle.setVehicleId(resultSet.getInt("vehicleID"));
                vehicle.setVehicleModel(resultSet.getString("model"));
                vehicle.setVehicleBrand(resultSet.getString("brand"));
                vehicle.setVehicleYear(resultSet.getInt("manufacturingYear"));
                vehicle.setVehicleAvailablity(resultSet.getBoolean("availability"));
                vehicle.setVehicleCategory(resultSet.getString("category"));
                vehicle.setVehicleFuelType(resultSet.getString("fuelType"));
                vehicle.setTransmissionType(resultSet.getString("transmissionType"));
                vehicle.setVehicleMileage(resultSet.getInt("mileage"));
                vehicle.setVehicleRatePerDay(resultSet.getString("ratePerDay"));
                vehicle.setVehicleRegistrationNo(resultSet.getString("registrationNo"));
                vehicle.setVehicleImagePath(resultSet.getString("vehicleImagePath"));
                LOGGER.log(Level.INFO, "Retrieved vehicle with ID: {0}", vehicleId);
            } else {
                LOGGER.log(Level.WARNING, "No vehicle found with ID: {0}", vehicleId);
            }
        } finally {
            // Close resources in a finally block to ensure they are always closed
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
                LOGGER.log(Level.FINE, "Database resources closed.");
            } catch (SQLException ex) {
                LOGGER.log(Level.WARNING, "Error closing database resources", ex);
            }
        }
        return vehicle;
    }

    // Get all individual booked dates for a specific vehicle
    public List<LocalDate> getBookedDatesForVehicle(int vehicleId) throws ClassNotFoundException, SQLException {
        List<LocalDate> bookedDates = new ArrayList<>();
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

        try {
            connection = DatabaseConnection.getConnection();
            preparedStatement = connection.prepareStatement(
                    "SELECT b.startDate, b.endDate FROM Booking b "
                            + "JOIN bookingvehicle vb ON b.bookingID = vb.bookingID "
                            + "WHERE vb.vehicleID = ? AND b.bookingStatus != 'Cancelled'");
            preparedStatement.setInt(1, vehicleId);
            LOGGER.log(Level.INFO, "Executing SQL query: {0}", preparedStatement.toString());
            resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                String startDateStr = resultSet.getString("startDate");
                String endDateStr = resultSet.getString("endDate");

                if (startDateStr != null && endDateStr != null) {
                    LocalDate startDate = LocalDate.parse(startDateStr, dateFormatter);
                    LocalDate endDate = LocalDate.parse(endDateStr, dateFormatter);
                    LocalDate currentDate = startDate;

                    while (!currentDate.isAfter(endDate)) {
                        bookedDates.add(currentDate);
                        currentDate = currentDate.plusDays(1);
                    }
                }
            }
            LOGGER.log(Level.INFO, "Retrieved {0} booked dates for vehicle ID: {1}",
                    new Object[] { bookedDates.size(), vehicleId });
        } finally {
            // Close resources
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
                LOGGER.log(Level.FINE, "Database resources closed.");
            } catch (SQLException ex) {
                LOGGER.log(Level.WARNING, "Error closing database resources", ex);
            }
        }
        return bookedDates;
    }

    // Method to get the details of the booking, from booking table and
    // bookingvehicle table, joined by bookingID
    public Booking getBookingDetails(int bookingId) throws ClassNotFoundException, SQLException {
        Booking booking = null;
        try {
            connection = DatabaseConnection.getConnection();
            preparedStatement = connection.prepareStatement(
                    "SELECT b.*, vb.vehicleID FROM Booking b "
                            + "JOIN bookingvehicle vb ON b.bookingID = vb.bookingID "
                            + "WHERE b.bookingID = ?");
            preparedStatement.setInt(1, bookingId);
            LOGGER.log(Level.INFO, "Executing SQL query: {0}", preparedStatement.toString());
            resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                booking = new Booking();
                booking.setBookingId(resultSet.getString("bookingID"));
                booking.setVehicleId(resultSet.getString("vehicleID"));
                LOGGER.log(Level.INFO, "Retrieved booking details for booking ID: {0}", bookingId);
            } else {
                LOGGER.log(Level.WARNING, "No booking found with ID: {0}", bookingId);
            }
        } finally {
            // Close resources
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
                LOGGER.log(Level.FINE, "Database resources closed.");
            } catch (SQLException ex) {
                LOGGER.log(Level.WARNING, "Error closing database resources", ex);
            }
        }
        return booking;
    }

    // Method to get the details of the booking, from booking table and
    // bookingvehicle table, joined by bookingID
    public Booking getBookingDetails(String bookingId) throws ClassNotFoundException, SQLException {
        Booking booking = null;
        try {
            connection = DatabaseConnection.getConnection();
            preparedStatement = connection.prepareStatement(
                    "SELECT b.*, vb.vehicleID FROM Booking b "
                            + "JOIN bookingvehicle vb ON b.bookingID = vb.bookingID "
                            + "WHERE b.bookingID = ?");
            preparedStatement.setString(1, bookingId);
            LOGGER.log(Level.INFO, "Executing SQL query: {0}", preparedStatement.toString());
            resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                booking = new Booking();
                booking.setBookingId(resultSet.getString("bookingID"));
                booking.setVehicleId(resultSet.getString("vehicleID"));
                LOGGER.log(Level.INFO, "Retrieved booking details for booking ID: {0}", bookingId);
            } else {
                LOGGER.log(Level.WARNING, "No booking found with ID: {0}", bookingId);
            }
        } finally {
            // Close resources
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
                LOGGER.log(Level.FINE, "Database resources closed.");
            } catch (SQLException ex) {
                LOGGER.log(Level.WARNING, "Error closing database resources", ex);
            }
        }
        return booking;
    }

    // Fetch user data by userID
    public User getUserDataByID(String userID) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        User user = null;

        try {
            // Get database connection
            connection = DatabaseConnection.getConnection();

            // SQL query to retrieve user information by userID
            String sql = "SELECT * FROM user WHERE userID = ?";
            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, userID);
            LOGGER.log(Level.INFO, "Executing SQL query: {0}", preparedStatement.toString());

            // Execute the query
            resultSet = preparedStatement.executeQuery();

            // If a record is found, create a User object and return it
            if (resultSet.next()) {
                user = new User();
                user.setUserID(resultSet.getString("userID"));
                user.setUsername(resultSet.getString("username"));
                user.setRole(resultSet.getString("role"));
                LOGGER.log(Level.INFO, "Retrieved user data for user ID: {0}", userID);
            } else {
                LOGGER.log(Level.WARNING, "No user found with userID: {0}", userID);
            }

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Database error while retrieving user: {0}", e.getMessage());
            throw new RuntimeException("Database error while retrieving user: " + e.getMessage());
        } finally {
            // Close resources
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    DatabaseConnection.closeConnection(connection);
                }
                LOGGER.log(Level.FINE, "Database resources closed.");
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error closing database resources: {0}", e.getMessage());
                throw new RuntimeException("Error closing database resources: " + e.getMessage());
            }
        }
        return user;
    }

    // Fetch user data by userID
    public Client getClientDataByID(String userID) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        Client client = null;

        try {
            // Get database connection
            connection = DatabaseConnection.getConnection();

            // SQL query to retrieve user information by userID
            String sql = "SELECT * FROM client WHERE userID = ?";
            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, userID);
            LOGGER.log(Level.INFO, "Executing SQL query: {0}", preparedStatement.toString());

            // Execute the query
            resultSet = preparedStatement.executeQuery();

            // If a record is found, create a Client object and populate it
            if (resultSet.next()) {
                client = new Client(); // Instantiate the Client object
                client.setUserID(resultSet.getString("userID"));
                client.setClientID(resultSet.getString("clientID"));
                client.setName(resultSet.getString("name"));
                client.setAddress(resultSet.getString("address"));
                client.setPhoneNumber(resultSet.getString("phoneNumber"));
                client.setEmail(resultSet.getString("email"));
                LOGGER.log(Level.INFO, "Retrieved client data for user ID: {0}", userID);
            } else {
                LOGGER.log(Level.WARNING, "No user found with userID: {0}", userID);
            }

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Database error while retrieving user: {0}", e.getMessage());
            throw new RuntimeException("Database error while retrieving user: " + e.getMessage());
        } finally {
            // Close resources
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    DatabaseConnection.closeConnection(connection);
                }
                LOGGER.log(Level.FINE, "Database resources closed.");
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error closing database resources: {0}", e.getMessage());
                throw new RuntimeException("Error closing database resources: " + e.getMessage());
            }
        }

        return client; // Returns populated Client object or null if not found
    }

    // Get client data by clientID
    public Client getClientDataByClientID(String clientID) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        Client client = null;

        try {
            // Get database connection
            connection = DatabaseConnection.getConnection();

            // SQL query to retrieve client information by clientID
            String sql = "SELECT * FROM client WHERE clientID = ?";
            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, clientID);
            LOGGER.log(Level.INFO, "Executing SQL query: {0}", preparedStatement.toString());

            // Execute the query
            resultSet = preparedStatement.executeQuery();

            // If a record is found, create a Client object and populate it
            if (resultSet.next()) {
                client = new Client(); // Instantiate the Client object
                client.setUserID(resultSet.getString("userID"));
                client.setClientID(resultSet.getString("clientID"));
                client.setName(resultSet.getString("name"));
                client.setAddress(resultSet.getString("address"));
                client.setPhoneNumber(resultSet.getString("phoneNumber"));
                client.setEmail(resultSet.getString("email"));
                LOGGER.log(Level.INFO, "Retrieved client data for client ID: {0}", clientID);
            } else {
                LOGGER.log(Level.WARNING, "No client found with clientID: {0}", clientID);
            }

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Database error while retrieving client: {0}", e.getMessage());
            throw new RuntimeException("Database error while retrieving client: " + e.getMessage());
        } finally {
            // Close resources
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    DatabaseConnection.closeConnection(connection);
                }
                LOGGER.log(Level.FINE, "Database resources closed.");
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error closing database resources: {0}", e.getMessage());
                throw new RuntimeException("Error closing database resources: " + e.getMessage());
            }
        }

        return client; // Returns populated Client object or null if not found
    }

    // Method to get all booking belong to a client, return booking ArrayList
    public ArrayList<Booking> getAllBookingByClientID(String clientID) {
        ArrayList<Booking> bookingList = new ArrayList<>();
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try {
            connection = DatabaseConnection.getConnection();
            preparedStatement = connection.prepareStatement(
                    "SELECT * FROM Payment p JOIN Booking b ON p.bookingID = b.bookingID "
                            + "JOIN BookingVehicle bv ON b.bookingID = bv.bookingID "
                            + "WHERE b.clientID = ?");
            preparedStatement.setString(1, clientID);
            LOGGER.log(Level.INFO, "Executing SQL query: {0}", preparedStatement.toString());
            resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                Booking booking = new Booking();
                booking.setBookingId(resultSet.getString("bookingID"));
                booking.setClientId(resultSet.getString("clientID"));
                booking.setVehicleId(resultSet.getString("vehicleId"));
                booking.setAssignedDate(resultSet.getString("assignedDate"));
                booking.setBookingDate(resultSet.getString("bookingDate"));
                booking.setBookingStartDate(resultSet.getString("startDate"));
                booking.setBookingEndDate(resultSet.getString("endDate"));
                booking.setActualReturnDate(resultSet.getString("actualReturnDate"));
                booking.setTotalCost(resultSet.getString("totalCost"));
                booking.setBookingStatus(resultSet.getString("bookingStatus"));
                booking.setCreatedBy(resultSet.getString("createdBy"));
                bookingList.add(booking);
            }
            LOGGER.log(Level.INFO, "Retrieved {0} booking details for client ID: {1}",
                    new Object[] { bookingList.size(), clientID });
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Database error while retrieving booking details: {0}", e.getMessage());
            throw new RuntimeException("Database error while retrieving booking details: " + e.getMessage());
        } finally {
            // Close resources
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
                LOGGER.log(Level.FINE, "Database resources closed.");
            } catch (SQLException ex) {
                LOGGER.log(Level.WARNING, "Error closing database resources", ex);
            }
        }
        return bookingList;
    }

    // Method to get payment details by client ID, return payment ArrayList
    public ArrayList<Payment> getPaymentDetailsByClientID(String clientID) {
        ArrayList<Payment> paymentList = new ArrayList<>();
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try {
            connection = DatabaseConnection.getConnection();
            preparedStatement = connection.prepareStatement("SELECT "
                    + "p.paymentID, "
                    + "p.bookingID, "
                    + "b.clientID, "
                    + "p.paymentType, "
                    + "p.amount, "
                    + "p.paymentStatus, "
                    + "p.referenceNo, "
                    + "p.paymentDate, "
                    + "p.invoiceNumber, "
                    + "p.handledBy, "
                    + "p.proofOfPayment, "
                    + "b.bookingDate, "
                    + "b.startDate, "
                    + "b.endDate, "
                    + "b.totalCost, "
                    + "b.bookingStatus "
                    + "FROM Payment p "
                    + "JOIN Booking b ON p.bookingID = b.bookingID "
                    + "WHERE b.clientID = ?");
            preparedStatement.setString(1, clientID);
            LOGGER.log(Level.INFO, "Executing SQL query: {0}", preparedStatement.toString());
            resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                Payment payment = new Payment();
                payment.setPaymentID(resultSet.getInt("paymentID"));
                payment.setBookingID(resultSet.getString("bookingID"));
                payment.setPaymentType(resultSet.getString("paymentType"));
                payment.setAmount(resultSet.getDouble("amount"));
                payment.setPaymentStatus(resultSet.getString("paymentStatus"));
                payment.setReferenceNo(resultSet.getString("referenceNo"));
                payment.setPaymentDate(resultSet.getString("paymentDate"));
                payment.setInvoiceNumber(resultSet.getString("invoiceNumber"));
                payment.setHandledBy(resultSet.getString("handledBy"));
                payment.setProofOfPayment(resultSet.getString("proofOfPayment"));
                paymentList.add(payment);
            }
            LOGGER.log(Level.INFO, "Retrieved {0} payment details for client ID: {1}",
                    new Object[] { paymentList.size(), clientID });
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Database error while retrieving payment details: {0}", e.getMessage());
            throw new RuntimeException("Database error while retrieving payment details: " + e.getMessage());
        } finally {
            // Close resources
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
                LOGGER.log(Level.FINE, "Database resources closed.");
            } catch (SQLException ex) {
                LOGGER.log(Level.WARNING, "Error closing database resources", ex);
            }
        }
        return paymentList;
    }

    // Method to get payment details by payment ID, return payment object
    public Payment getPaymentById(String paymentID) {
        Payment payment = null;
        try {
            connection = DatabaseConnection.getConnection();
            preparedStatement = connection
                    .prepareStatement("SELECT p.paymentID, p.paymentType, p.amount, p.paymentStatus, p.referenceNo, "
                            + "p.paymentDate, p.invoiceNumber, p.handledBy, p.proofOfPayment, "
                            + "b.bookingID, b.clientID, b.bookingDate, b.startDate, b.endDate, "
                            + "b.actualReturnDate, b.totalCost, b.bookingStatus, "
                            + "bv.vehicleID, bv.assignedDate "
                            + "FROM Payment p "
                            + "JOIN Booking b ON p.bookingID = b.bookingID "
                            + "JOIN BookingVehicle bv ON b.bookingID = bv.bookingID "
                            + "WHERE p.paymentID = ?");
            preparedStatement.setString(1, paymentID);
            LOGGER.log(Level.INFO, "Executing SQL query: {0}", preparedStatement.toString());
            resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                payment = new Payment();
                payment.setPaymentID(resultSet.getInt("paymentID"));
                payment.setBookingID(resultSet.getString("b.bookingID"));
                payment.setPaymentType(resultSet.getString("paymentType"));
                payment.setAmount(resultSet.getDouble("amount"));
                payment.setPaymentStatus(resultSet.getString("paymentStatus"));
                payment.setReferenceNo(resultSet.getString("referenceNo"));
                payment.setPaymentDate(resultSet.getString("paymentDate"));
                payment.setInvoiceNumber(resultSet.getString("invoiceNumber"));
                payment.setHandledBy(resultSet.getString("handledBy"));
                payment.setProofOfPayment(resultSet.getString("proofOfPayment"));
                LOGGER.log(Level.INFO, "Retrieved payment details for payment ID: {0}", paymentID);
            } else {
                LOGGER.log(Level.WARNING, "No payment found with payment ID: {0}", paymentID);
            }

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Database error while retrieving payment details: {0}", e.getMessage());
            throw new RuntimeException("Database error while retrieving payment details: " + e.getMessage());
        } finally {
            // Close resources
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
                LOGGER.log(Level.FINE, "Database resources closed.");
            } catch (SQLException ex) {
                LOGGER.log(Level.WARNING, "Error closing database resources", ex);
            }
        }
        return payment;
    }

    // Method to get payments by booking ID, return booking object
    public Booking getBookingByBookingId(String bookingID) {
        Booking booking = null;
        try {
            connection = DatabaseConnection.getConnection();
            preparedStatement = connection
                    .prepareStatement("SELECT p.paymentID, p.paymentType, p.amount, p.paymentStatus, p.referenceNo, "
                            + "p.paymentDate, p.invoiceNumber, p.handledBy, p.proofOfPayment, "
                            + "b.bookingID, b.clientID, b.bookingDate, b.startDate, b.endDate, "
                            + "b.actualReturnDate, b.totalCost, b.bookingStatus, "
                            + "bv.vehicleID, bv.assignedDate "
                            + "FROM Payment p "
                            + "JOIN Booking b ON p.bookingID = b.bookingID "
                            + "JOIN BookingVehicle bv ON b.bookingID = bv.bookingID "
                            + "WHERE p.bookingID = ?");
            preparedStatement.setString(1, bookingID);
            LOGGER.log(Level.INFO, "Executing SQL query: {0}", preparedStatement.toString());
            resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                booking = new Booking();
                booking.setBookingId(resultSet.getString("bookingID"));
                booking.setClientId(resultSet.getString("clientID"));
                booking.setVehicleId(resultSet.getString("vehicleId"));
                booking.setAssignedDate(resultSet.getString("assignedDate"));
                booking.setBookingDate(resultSet.getString("bookingDate"));
                booking.setBookingStartDate(resultSet.getString("startDate"));
                booking.setBookingEndDate(resultSet.getString("endDate"));
                booking.setActualReturnDate(resultSet.getString("actualReturnDate"));
                booking.setTotalCost(resultSet.getString("totalCost"));
                booking.setBookingStatus(resultSet.getString("bookingStatus"));
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Database error while retrieving payment details: {0}", e.getMessage());
            throw new RuntimeException("Database error while retrieving payment details: " + e.getMessage());
        } finally {
            // Close resources
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
                LOGGER.log(Level.FINE, "Database resources closed.");
            } catch (SQLException ex) {
                LOGGER.log(Level.WARNING, "Error closing database resources", ex);
            }
        }
        return booking;
    }

    // Method to get all booking details, return booking ArrayList
    public ArrayList<Booking> getAllBookingDetails() {
        ArrayList<Booking> bookingList = new ArrayList<>();
        try {
            connection = DatabaseConnection.getConnection();
            // From booking table, booking vehicle table, and payment table
            preparedStatement = connection.prepareStatement("SELECT * FROM Booking b "
                    + "JOIN BookingVehicle bv ON b.bookingID = bv.bookingID "
                    + "JOIN Payment p ON b.bookingID = p.bookingID");
            resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                Booking booking = new Booking();
                booking.setBookingId(resultSet.getString("bookingID"));
                booking.setClientId(resultSet.getString("clientID"));
                booking.setVehicleId(resultSet.getString("vehicleId"));
                booking.setAssignedDate(resultSet.getString("assignedDate"));
                booking.setBookingDate(resultSet.getString("bookingDate"));
                booking.setBookingStartDate(resultSet.getString("startDate"));
                booking.setBookingEndDate(resultSet.getString("endDate"));
                booking.setActualReturnDate(resultSet.getString("actualReturnDate"));
                booking.setTotalCost(resultSet.getString("totalCost"));
                booking.setBookingStatus(resultSet.getString("bookingStatus"));
                bookingList.add(booking);
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Database error while retrieving all booking details: {0}", e.getMessage());
            throw new RuntimeException("Database error while retrieving all booking details: " + e.getMessage());
        } finally {
            // Close resources
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
                LOGGER.log(Level.FINE, "Database resources closed.");
            } catch (SQLException ex) {
                LOGGER.log(Level.WARNING, "Error closing database resources", ex);
            }
        }
        return bookingList;
    }

    // Method to get all booking details by payment ID, return booking object
    public Booking getBookingByPaymentId(String paymentID) {
        Booking booking = null;
        try {
            connection = DatabaseConnection.getConnection();
            preparedStatement = connection.prepareStatement("SELECT * FROM Booking b "
                    + "JOIN BookingVehicle bv ON b.bookingID = bv.bookingID "
                    + "JOIN Payment p ON b.bookingID = p.bookingID "
                    + "WHERE p.paymentID = ?");
            preparedStatement.setString(1, paymentID);
            resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                booking = new Booking();
                booking.setBookingId(resultSet.getString("bookingID"));
                booking.setClientId(resultSet.getString("clientID"));
                booking.setVehicleId(resultSet.getString("vehicleId"));
                booking.setAssignedDate(resultSet.getString("assignedDate"));
                booking.setBookingDate(resultSet.getString("bookingDate"));
                booking.setBookingStartDate(resultSet.getString("startDate"));
                booking.setBookingEndDate(resultSet.getString("endDate"));
                booking.setActualReturnDate(resultSet.getString("actualReturnDate"));
                booking.setTotalCost(resultSet.getString("totalCost"));
                booking.setBookingStatus(resultSet.getString("bookingStatus"));
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Database error while retrieving booking details: {0}", e.getMessage());
            throw new RuntimeException("Database error while retrieving booking details: " + e.getMessage());
        } finally {
            // Close resources
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
                LOGGER.log(Level.FINE, "Database resources closed.");
            } catch (SQLException ex) {
                LOGGER.log(Level.WARNING, "Error closing database resources", ex);
            }
        }
        return booking;
    }

    // Method to get payment details by booking ID, return payment object
    public Payment getPaymentByBookingId(String bookingID) {
        Payment payment = null;
        try {
            connection = DatabaseConnection.getConnection();
            preparedStatement = connection.prepareStatement("SELECT * FROM Payment WHERE bookingID = ?");
            preparedStatement.setString(1, bookingID);
            resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                payment = new Payment();
                payment.setPaymentID(resultSet.getInt("paymentID"));
                payment.setBookingID(resultSet.getString("bookingID"));
                payment.setPaymentType(resultSet.getString("paymentType"));
                payment.setAmount(resultSet.getDouble("amount"));
                payment.setPaymentStatus(resultSet.getString("paymentStatus"));
                payment.setReferenceNo(resultSet.getString("referenceNo"));
                payment.setPaymentDate(resultSet.getString("paymentDate"));
                payment.setInvoiceNumber(resultSet.getString("invoiceNumber"));
                payment.setHandledBy(resultSet.getString("handledBy"));
                payment.setProofOfPayment(resultSet.getString("proofOfPayment"));
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Database error while retrieving payment ID: {0}", e.getMessage());
            throw new RuntimeException("Database error while retrieving payment ID: " + e.getMessage());
        } finally {
            // Close resources
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
                LOGGER.log(Level.FINE, "Database resources closed.");
            } catch (SQLException ex) {
                LOGGER.log(Level.WARNING, "Error closing database resources", ex);
            }
        }
        return payment;
    }

    // Method to get all payment details, return payment ArrayList
    public ArrayList<Payment> getAllPaymentDetails() {
        ArrayList<Payment> paymentList = new ArrayList<>();
        try {
            connection = DatabaseConnection.getConnection();
            preparedStatement = connection.prepareStatement(
                    "SELECT p.paymentID, p.paymentType, p.amount, p.paymentStatus, " +
                            "p.referenceNo, p.paymentDate, p.invoiceNumber, p.handledBy, p.proofOfPayment, " +
                            "b.bookingID, b.clientID, b.bookingDate, b.startDate, b.endDate, " +
                            "b.actualReturnDate, b.totalCost, b.bookingStatus, " +
                            "bv.vehicleID, bv.assignedDate " +
                            "FROM Payment p " +
                            "JOIN Booking b ON p.bookingID = b.bookingID " +
                            "JOIN BookingVehicle bv ON b.bookingID = bv.bookingID " +
                            "WHERE p.paymentType IN ('Cash', 'Bank Transfer');");
            resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                Payment payment = new Payment();
                payment.setPaymentID(resultSet.getInt("paymentID"));
                payment.setBookingID(resultSet.getString("bookingID"));
                payment.setPaymentType(resultSet.getString("paymentType"));
                payment.setAmount(resultSet.getDouble("amount"));
                payment.setPaymentStatus(resultSet.getString("paymentStatus"));
                payment.setReferenceNo(resultSet.getString("referenceNo"));
                payment.setPaymentDate(resultSet.getString("paymentDate"));
                payment.setInvoiceNumber(resultSet.getString("invoiceNumber"));
                payment.setHandledBy(resultSet.getString("handledBy"));
                payment.setProofOfPayment(resultSet.getString("proofOfPayment"));
                paymentList.add(payment);
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Database error while retrieving all payment details: {0}", e.getMessage());
            throw new RuntimeException("Database error while retrieving all payment details: " + e.getMessage());
        } finally {
            // Close resources
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
                LOGGER.log(Level.FINE, "Database resources closed.");
            } catch (SQLException ex) {
                LOGGER.log(Level.WARNING, "Error closing database resources", ex);
            }
        }
        return paymentList;
    }

    // Method to get booking details by booking ID, return booking object
    public Booking getBookingById(String bookingID) {
        Booking booking = null;
        try {
            connection = DatabaseConnection.getConnection();
            preparedStatement = connection.prepareStatement("SELECT * FROM Booking WHERE bookingID = ?");
            preparedStatement.setString(1, bookingID);
            LOGGER.log(Level.INFO, "Executing SQL query: {0}", preparedStatement.toString());
            resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                booking = new Booking();
                booking.setBookingId(resultSet.getString("bookingID"));
                booking.setClientId(resultSet.getString("clientID"));
                booking.setVehicleId(resultSet.getString("vehicleId"));
                booking.setAssignedDate(resultSet.getString("assignedDate"));
                booking.setBookingDate(resultSet.getString("bookingDate"));
                booking.setBookingStartDate(resultSet.getString("startDate"));
                booking.setBookingEndDate(resultSet.getString("endDate"));
                booking.setActualReturnDate(resultSet.getString("actualReturnDate"));
                booking.setTotalCost(resultSet.getString("totalCost"));
                booking.setBookingStatus(resultSet.getString("bookingStatus"));
                booking.setCreatedBy(resultSet.getString("createdBy"));
                LOGGER.log(Level.INFO, "Retrieved booking details for booking ID: {0}", bookingID);
            } else {
                LOGGER.log(Level.WARNING, "No booking found with booking ID: {0}", bookingID);
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Database error while retrieving booking details: {0}", e.getMessage());
            throw new RuntimeException("Database error while retrieving booking details: " + e.getMessage());
        } finally {
            // Close resources
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
                LOGGER.log(Level.FINE, "Database resources closed.");
            } catch (SQLException ex) {
                LOGGER.log(Level.WARNING, "Error closing database resources", ex);
            }
        }
        return booking;
    }

    // Method to get booking vehicle details by booking ID, return booking vehicle
    // object
    public BookingVehicle getBookingVehicleByBookingId(String bookingID) {
        BookingVehicle bookingVehicle = null;
        try {
            connection = DatabaseConnection.getConnection();
            preparedStatement = connection.prepareStatement("SELECT * FROM BookingVehicle WHERE bookingID = ?");
            preparedStatement.setString(1, bookingID);
            LOGGER.log(Level.INFO, "Executing SQL query: {0}", preparedStatement.toString());
            resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                bookingVehicle = new BookingVehicle();
                bookingVehicle.setBookingID(resultSet.getString("bookingID"));
                bookingVehicle.setVehicleID(resultSet.getString("vehicleID"));
                bookingVehicle.setAssignedDate(resultSet.getString("assignedDate"));
                LOGGER.log(Level.INFO, "Retrieved booking vehicle details for booking ID: {0}", bookingID);
            } else {
                LOGGER.log(Level.WARNING, "No booking vehicle found with booking ID: {0}", bookingID);
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Database error while retrieving booking vehicle details: {0}", e.getMessage());
            throw new RuntimeException("Database error while retrieving booking vehicle details: " + e.getMessage());
        } finally {
            // Close resources
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
                LOGGER.log(Level.FINE, "Database resources closed.");
            } catch (SQLException ex) {
                LOGGER.log(Level.WARNING, "Error closing database resources", ex);
            }
        }
        return bookingVehicle;
    }

}
