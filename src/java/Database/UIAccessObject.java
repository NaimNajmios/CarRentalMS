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
            resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                booking.setBookingId(resultSet.getString("bookingID"));
                booking.setVehicleId(resultSet.getString("vehicleID"));
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
            resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                booking.setBookingId(resultSet.getString("bookingID"));
                booking.setVehicleId(resultSet.getString("vehicleID"));
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

            // Execute the query
            resultSet = preparedStatement.executeQuery();

            // If a record is found, create a User object and return it
            if (resultSet.next()) {
                user.setUserID(resultSet.getString("userID"));
                user.setUsername(resultSet.getString("username"));
                user.setRole(resultSet.getString("role"));

            } else {
                System.out.println("No user found with userID: " + userID);
            }

        } catch (SQLException | ClassNotFoundException e) {
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
            } catch (SQLException e) {
                throw new RuntimeException("Error closing database resources: " + e.getMessage());
            }
        }
        System.out.println(user);
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
            } else {
                System.out.println("No user found with userID: " + userID);
            }

        } catch (SQLException | ClassNotFoundException e) {
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
            } catch (SQLException e) {
                throw new RuntimeException("Error closing database resources: " + e.getMessage());
            }
        }

        System.out.println(client);
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
            } else {
                System.out.println("No client found with clientID: " + clientID);
            }

        } catch (SQLException | ClassNotFoundException e) {
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
            } catch (SQLException e) {
                throw new RuntimeException("Error closing database resources: " + e.getMessage());
            }
        }

        System.out.println(client);
        return client; // Returns populated Client object or null if not found
    }

    // Method to get payment details by client ID
    public Payment getPaymentDetailsByClientID(String clientID) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        Payment payment = null;

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
            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                payment = new Payment();
                payment.setPaymentID(resultSet.getString("paymentID"));
                payment.setBookingID(resultSet.getString("bookingID"));
            }
        } catch (SQLException | ClassNotFoundException e) {
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
    }

}
