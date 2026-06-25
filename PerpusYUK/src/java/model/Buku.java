/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author zamza
 */
public class Buku {
    private int id;
    private String judul;
    private String pengarang;
    private String kategori;
    private String isbn;
    private int stok;

    public void setId(int id) { this.id = id; }
    public int getId() { return id; }
    public void setJudul(String judul) { this.judul = judul; }
    public String getJudul() { return judul; }
    public void setPengarang(String pengarang) { this.pengarang = pengarang; }
    public String getPengarang() { return pengarang; }
    public void setKategori(String kategori) { this.kategori = kategori; }
    public String getKategori() { return kategori; }
    public void setIsbn(String isbn) { this.isbn = isbn; }
    public String getIsbn() { return isbn; }
    public void setStok(int stok) { this.stok = stok; }
    public int getStok() { return stok; }
}
