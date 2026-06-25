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

public class Notifikasi {
    private int id;
    private int idAnggota;
    private String pesan;
    private Date tanggal;
    private boolean statusBaca;

    public void setId(int id) { this.id = id; }
    public int getId() { return id; }
    public void setIdAnggota(int idAnggota) { this.idAnggota = idAnggota; }
    public int getIdAnggota() { return idAnggota; }
    public void setPesan(String pesan) { this.pesan = pesan; }
    public String getPesan() { return pesan; }
    public void setTanggal(Date tanggal) { this.tanggal = tanggal; }
    public Date getTanggal() { return tanggal; }
    public void setStatusBaca(boolean statusBaca) { this.statusBaca = statusBaca; }
    public boolean getStatusBaca() { return statusBaca; }
}
