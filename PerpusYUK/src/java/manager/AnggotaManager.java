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
import interfaces.Searchable;
import model.Anggota;
import java.sql.*;
import java.util.*;

public class AnggotaManager implements Searchable {

    public List<Anggota> lihatAnggota() {
        return (List<Anggota>) searchUser("");
    }

    public void editAnggota(int id, String username, String email) {
        try {
            Connection con = DatabaseConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "UPDATE users SET username=?, email=? WHERE id=?"
            );
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setInt(3, id);
            ps.executeUpdate();
            con.close();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void hapusAnggota(int id) {
        try {
            Connection con = DatabaseConnection.getConnection();
            PreparedStatement ps2 = con.prepareStatement("DELETE FROM notifikasi WHERE id_anggota=?");
            ps2.setInt(1, id);
            ps2.executeUpdate();
            PreparedStatement ps3 = con.prepareStatement("DELETE FROM peminjaman WHERE id_anggota=?");
            ps3.setInt(1, id);
            ps3.executeUpdate();
            PreparedStatement ps4 = con.prepareStatement("DELETE FROM anggota WHERE user_id=?");
            ps4.setInt(1, id);
            ps4.executeUpdate();
            PreparedStatement ps = con.prepareStatement("DELETE FROM users WHERE id=?");
            ps.setInt(1, id);
            ps.executeUpdate();
            con.close();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public List searchUser(String keyword) {
        List<Anggota> list = new ArrayList<>();
        try {
            Connection con = DatabaseConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "SELECT u.*, a.no_anggota FROM users u LEFT JOIN anggota a ON u.id = a.user_id " +
                "WHERE u.role='Anggota' AND (u.username LIKE ? OR u.email LIKE ?)"
            );
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Anggota a = new Anggota();
                a.setId(rs.getInt("id"));
                a.setUsername(rs.getString("username"));
                a.setEmail(rs.getString("email"));
                a.setNoAnggota(rs.getString("no_anggota"));
                a.setTanggalDaftar(rs.getDate("tanggal_daftar"));
                list.add(a);
            }
            con.close();
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}
