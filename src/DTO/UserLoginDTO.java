/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DTO;

/**
 *
 * @author huynh
 */
public class UserLoginDTO {
    private int UserID;
    private String Username;
    private String Password;
    private String Role;
    public UserLoginDTO() {
    }
 
    public UserLoginDTO( String userName, String password) {
        super();
        this.Username = userName;
        this.Password = password;
    }
    
    public UserLoginDTO(int userID, String userName, String password, String role) {
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

    public String getRole() {
        return Role;
    }

    public void setRole(String Role) {
        this.Role = Role;
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

}
