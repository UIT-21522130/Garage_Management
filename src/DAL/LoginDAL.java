/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAL;

import DTO.UserLoginDTO;
import GUI.LoginGUI;
import com.mysql.jdbc.Connection;
import com.mysql.jdbc.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.swing.JOptionPane;

/**
 *
 * @author huynh
 */
public class LoginDAL {
    //Check Password
    public boolean checkPassword(UserLoginDTO dtoUserLogin)
        {
            try{
                Connection con = (Connection) DBConnection.ConnectDb();
                String SQL = "SELECT UserID FROM dangnhap WHERE Username = ? AND Password = ?";
                PreparedStatement ps = (PreparedStatement) con.prepareStatement(SQL);
                ps.setString(1, dtoUserLogin.getUsername());
                ps.setString(2, dtoUserLogin.getPassword());
                ResultSet rs = ps.executeQuery();
                long UserLoginID = 0;
                while(rs.next())
                    UserLoginID = rs.getInt(1);
                con.close();

                if(UserLoginID == 0)
                    return false;
                else 
                    return true;

            }catch(SQLException e)
            {
                JOptionPane.showMessageDialog(null, e);
            }
            return false;    
        }

}
