/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author zamza
 */


import java.util.Date;

public class Anggota extends User {
    private String noAnggota;
    private String email;
    private Date tanggalDaftar;

    public Anggota() {
        setRole("Anggota");
    }

    public void setNoAnggota(String no) { this.noAnggota = no; }
    public String getNoAnggota() { return noAnggota; }
    public void setEmail(String email) { this.email = email; }
    public String getEmail() { return email; }
    public void setTanggalDaftar(Date tanggalDaftar) { this.tanggalDaftar = tanggalDaftar; }
    public Date getTanggalDaftar() { return tanggalDaftar; }
}