/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DTO;

import java.sql.Connection;
import java.sql.DriverManager;

/**
 *
 * @author MyPC
 */
public class Connect 
{
    public Connection getConnection ()
    {
        Connection conn = null;
        try 
        {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection ("jdbc:mysql://localhost:3306/garage_final?useSSL=false","root","");
            if (conn != null)
                {
                    System.err.println("Ket noi thanh cong!!!");
                }
        } catch (Exception ex)
            {
                System.out.println(ex.toString());
            }
        return conn;
    }
}
