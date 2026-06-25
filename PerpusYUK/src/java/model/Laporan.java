/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author zamza
 */
import interfaces.Reportable;
import db.DatabaseConnection;
import java.sql.*;

public class Laporan implements Reportable {

    public String generateReport() {
        return "Laporan berhasil dibuat";
    }

    public int getTotalBuku() {
        try {
            Connection con = DatabaseConnection.getConnection();
            ResultSet rs = con.createStatement().executeQuery("SELECT COUNT(*) FROM buku");
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public int getTotalAnggota() {
        try {
            Connection con = DatabaseConnection.getConnection();
            ResultSet rs = con.createStatement().executeQuery("SELECT COUNT(*) FROM users WHERE role='Anggota'");
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public int getBukuDipinjam() {
        try {
            Connection con = DatabaseConnection.getConnection();
            ResultSet rs = con.createStatement().executeQuery("SELECT COUNT(*) FROM peminjaman WHERE status='Dipinjam'");
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public int getTotalDenda() {
        try {
            Connection con = DatabaseConnection.getConnection();
            ResultSet rs = con.createStatement().executeQuery("SELECT SUM(denda) FROM peminjaman WHERE status != 'Dikembalikan'");
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }
}