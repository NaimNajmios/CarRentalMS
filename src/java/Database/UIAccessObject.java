/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Database;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 *
 * @author Naim Najmi
 */
public class UIAccessObject {

    // Instance of DatabaseConnection to manage database connections
    private DatabaseConnection db;
    Connection connection = null;
    PreparedStatement preparedStatement = null;
    ResultSet resultSet = null;

    public UIAccessObject() {
        // Constructor
        this.db = new DatabaseConnection();
    }

}
