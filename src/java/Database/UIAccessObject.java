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
}
