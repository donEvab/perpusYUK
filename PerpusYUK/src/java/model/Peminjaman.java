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

public class Peminjaman {
    private int id;
    private int idAnggota;
    private int idBuku;
    private Date tanggalPinjam;
    private Date tanggalKembali;
    private String status;
    private int denda;
    private String namaAnggota;
    private String judulBuku;

    public void setId(int id) { this.id = id; }
    public int getId() { return id; }
    public void setIdAnggota(int idAnggota) { this.idAnggota = idAnggota; }
    public int getIdAnggota() { return idAnggota; }
    public void setIdBuku(int idBuku) { this.idBuku = idBuku; }
    public int getIdBuku() { return idBuku; }
    public void setTanggalPinjam(Date tanggalPinjam) { this.tanggalPinjam = tanggalPinjam; }
    public Date getTanggalPinjam() { return tanggalPinjam; }
    public void setTanggalKembali(Date tanggalKembali) { this.tanggalKembali = tanggalKembali; }
    public Date getTanggalKembali() { return tanggalKembali; }
    public void setStatus(String status) { this.status = status; }
    public String getStatus() { return status; }
    public void setDenda(int denda) { this.denda = denda; }
    public int getDenda() { return denda; }
    public void setNamaAnggota(String namaAnggota) { this.namaAnggota = namaAnggota; }
    public String getNamaAnggota() { return namaAnggota; }
    public void setJudulBuku(String judulBuku) { this.judulBuku = judulBuku; }
    public String getJudulBuku() { return judulBuku; }
}
