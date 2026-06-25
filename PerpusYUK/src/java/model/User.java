/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author zamza
 */
public class User {
    private int id;
    private String username;
    private String password;
    private String role;

    public void setId(int id) { this.id = id; }
    public int getId() { return id; }
    public void setUsername(String username) { this.username = username; }
    public String getUsername() { return username; }
    public void setPassword(String password) { this.password = password; }
    public String getPassword() { return password; }
    public void setRole(String role) { this.role = role; }
    public String getRole() { return role; }
}
