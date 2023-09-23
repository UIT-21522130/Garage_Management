/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DTO;

/**
 *
 * @author huynh
 */
public class LoginDTO {
    private int UserID;
    private String Username;
    private String Password;
    private String Role;
 
    public LoginDTO() {
    }
 
    public LoginDTO(int userID, String userName, String password, String role) {
        super();
        this.UserID = userID;
        this.Username = userName;
        this.Password = password;
        this.Role = role;
    }

    public int getUserID() {
        return UserID;
    }

    public void setUserID(int UserID) {
        this.UserID = UserID;
    }

    public String getUsername() {
        return Username;
    }

    public void setUsername(String Username) {
        this.Username = Username;
    }

    public String getPassword() {
        return Password;
    }

    public void setPassword(String Password) {
        this.Password = Password;
    }

    public String getRole() {
        return Role;
    }

    public void setRole(String Role) {
        this.Role = Role;
    } 
}
