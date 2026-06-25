/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package manager;

/**
 *
 * @author zamza
 */
import db.DatabaseConnection;
import model.Buku;
import model.BukuFiksi;
import model.BukuNonFiksi;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BukuManager {

    public void tambahBuku(Buku buku) {
        try {
            Connection con = DatabaseConnection.getConnection();
            String tipe = "Umum";
            String genre = null;
            String bidang = null;
            if (buku instanceof BukuFiksi) { tipe = "Fiksi"; genre = ((BukuFiksi) buku).getGenre(); }
            else if (buku instanceof BukuNonFiksi) { tipe = "NonFiksi"; bidang = ((BukuNonFiksi) buku).getBidangIlmu(); }

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO buku (judul, pengarang, kategori, isbn, stok, tipe, genre, bidang_ilmu) VALUES (?,?,?,?,?,?,?,?)"
            );
            ps.setString(1, buku.getJudul());
            ps.setString(2, buku.getPengarang());
            ps.setString(3, buku.getKategori());
            ps.setString(4, buku.getIsbn());
            ps.setInt(5, buku.getStok());
            ps.setString(6, tipe);
            ps.setString(7, genre);
            ps.setString(8, bidang);
            ps.executeUpdate();
            con.close();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void editBuku(Buku buku) {
        try {
            Connection con = DatabaseConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "UPDATE buku SET judul=?, pengarang=?, kategori=?, isbn=?, stok=? WHERE id=?"
            );
            ps.setString(1, buku.getJudul());
            ps.setString(2, buku.getPengarang());
            ps.setString(3, buku.getKategori());
            ps.setString(4, buku.getIsbn());
            ps.setInt(5, buku.getStok());
            ps.setInt(6, buku.getId());
            ps.executeUpdate();
            con.close();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void hapusBuku(int id) {
        try {
            Connection con = DatabaseConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("DELETE FROM buku WHERE id=?");
            ps.setInt(1, id);
            ps.executeUpdate();
            con.close();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public List<Buku> cariBuku(String keyword) {
        List<Buku> list = new ArrayList<>();
        try {
            Connection con = DatabaseConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM buku WHERE judul LIKE ? OR pengarang LIKE ? OR isbn LIKE ?"
            );
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ps.setString(3, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Buku b = new Buku();
                b.setId(rs.getInt("id"));
                b.setJudul(rs.getString("judul"));
                b.setPengarang(rs.getString("pengarang"));
                b.setKategori(rs.getString("kategori"));
                b.setIsbn(rs.getString("isbn"));
                b.setStok(rs.getInt("stok"));
                list.add(b);
            }
            con.close();
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Buku> semuaBuku() {
        return cariBuku("");
    }
}
