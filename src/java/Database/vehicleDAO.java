package Database;


import Database.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import Vehicles.Vehicles;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
/**
 *
 * @author nadhi
 */
public class vehicleDAO {

    public static int add(Vehicles v) {
        int status = 0;
        try {
            Connection con = DatabaseConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                    "insert into vehicles(model, brand, manufacturingYear, availability, category, fuelType, transmissionType, mileage, ratePerDay, registrationNo, vehicleImagePath) values (?,?,?,?,?,?,?,?,?,?,?)");
            ps.setString(1, v.getModel());
            ps.setString(2, v.getBrand());
            ps.setInt(3, v.getManufacturingYear());
            ps.setBoolean(4, v.isAvailability());
            ps.setString(5, v.getCategory());
            ps.setString(6, v.getFuelType());
            ps.setString(7, v.getTransmissionType());
            ps.setInt(8, v.getMileage());
            ps.setDouble(9, v.getRatePerDay());
            ps.setString(10, v.getRegistrationNo());
            ps.setString(11, v.getVehicleImagePath());

            status = ps.executeUpdate();

            con.close(); //lookup
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return status;
    }

    public static int update(Vehicles v) {
        int status = 0;
        try {
            Connection con = DatabaseConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                    "UPDATE vehicles SET model=?, brand=?, manufacturingYear=?, availability=?, category=?, fuelType=?, transmissionType=?, mileage=?, ratePerDay=?, registrationNo=?, vehicleImagePath=? WHERE vehicleID=?");

            ps.setString(1, v.getModel());
            ps.setString(2, v.getBrand());
            ps.setInt(3, v.getManufacturingYear());
            ps.setBoolean(4, v.isAvailability());
            ps.setString(5, v.getCategory());
            ps.setString(6, v.getFuelType());
            ps.setString(7, v.getTransmissionType());
            ps.setInt(8, v.getMileage());
            ps.setDouble(9, v.getRatePerDay());
            ps.setString(10, v.getRegistrationNo());
            ps.setString(11, v.getVehicleImagePath());
            ps.setString(12, v.getVehicleID());

            status = ps.executeUpdate();

            con.close();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return status;
    }

    public static int delete(int vehicleID) {
        int status = 0;
        try {
            Connection con = DatabaseConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("delete from vehicles where vehicleID=?");
            ps.setInt(1, vehicleID);
            status = ps.executeUpdate();

            con.close();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return status;
    }

    public static List<Vehicles> getAllVehicles() {
        List<Vehicles> list = new ArrayList<Vehicles>();

        try {
            Connection con = DatabaseConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from vehicles");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Vehicles e = new Vehicles();
                e.setVehicleID(rs.getString(1));
                e.setModel(rs.getString(2));
                e.setBrand(rs.getString(3));
                e.setManufacturingYear(rs.getInt(4));
                e.setAvailability(rs.getBoolean(5));
                e.setCategory(rs.getString(6));
                e.setFuelType(rs.getString(7));
                e.setTransmissionType(rs.getString(8));
                e.setMileage(rs.getInt(9));
                e.setRatePerDay(rs.getDouble(10));
                e.setRegistrationNo(rs.getString(11));
                e.setVehicleImagePath(rs.getString(12));
                list.add(e);
            }

            con.close();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return list;
    }

    public static Vehicles getVehicleById(String vehicleID) {
        Vehicles v = null;
        try {
            Connection con = DatabaseConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM vehicles WHERE vehicleID=?");
            ps.setString(1, vehicleID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                v = new Vehicles();
                v.setVehicleID(rs.getString(1));
                v.setModel(rs.getString(2));
                v.setBrand(rs.getString(3));
                v.setManufacturingYear(rs.getInt(4));
                v.setAvailability(rs.getBoolean(5));
                v.setCategory(rs.getString(6));
                v.setFuelType(rs.getString(7));
                v.setTransmissionType(rs.getString(8));
                v.setMileage(rs.getInt(9));
                v.setRatePerDay(rs.getDouble(10));
                v.setRegistrationNo(rs.getString(11));
                v.setVehicleImagePath(rs.getString(12));
            }
            con.close();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return v;
    }

}
