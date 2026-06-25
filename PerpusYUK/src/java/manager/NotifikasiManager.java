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
import interfaces.Notifiable;
import model.Notifikasi;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.Date;

public class NotifikasiManager implements Notifiable {

    public void sendNotification(int idAnggota, String pesan) {
        try {
            Connection con = DatabaseConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO notifikasi (id_anggota, pesan, tanggal, status_baca) VALUES (?,?,?,false)"
            );
            ps.setInt(1, idAnggota);
            ps.setString(2, pesan);
            ps.setDate(3, new java.sql.Date(new Date().getTime()));
            ps.executeUpdate();
            con.close();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void cekDanBuatNotifikasi() {
        try {
            Connection con = DatabaseConnection.getConnection();
            String sql = "SELECT p.id, p.id_anggota, p.tanggal_kembali, b.judul FROM peminjaman p " +
                         "JOIN buku b ON p.id_buku = b.id WHERE p.status='Dipinjam'";
            ResultSet rs = con.createStatement().executeQuery(sql);
            while (rs.next()) {
                Date tanggalKembali = rs.getDate("tanggal_kembali");
                Date sekarang = new Date();
                long diff = tanggalKembali.getTime() - sekarang.getTime();
                long hariSisa = diff / (1000 * 60 * 60 * 24);
                if (hariSisa <= 3 && hariSisa >= 0) {
                    String pesan = "Buku '" + rs.getString("judul") + "' harus dikembalikan dalam " + hariSisa + " hari lagi.";
                    sendNotification(rs.getInt("id_anggota"), pesan);
                } else if (hariSisa < 0) {
                    int denda = (int) Math.abs(hariSisa) * 1000;
                    String pesan = "Buku '" + rs.getString("judul") + "' terlambat dikembalikan. Denda: Rp " + denda;
                    sendNotification(rs.getInt("id_anggota"), pesan);
                }
            }
            con.close();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public List<Notifikasi> getNotifikasiByAnggota(int idAnggota) {
        List<Notifikasi> list = new ArrayList<>();
        try {
            Connection con = DatabaseConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM notifikasi WHERE id_anggota=? ORDER BY tanggal DESC"
            );
            ps.setInt(1, idAnggota);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Notifikasi n = new Notifikasi();
                n.setId(rs.getInt("id"));
                n.setIdAnggota(rs.getInt("id_anggota"));
                n.setPesan(rs.getString("pesan"));
                n.setTanggal(rs.getDate("tanggal"));
                n.setStatusBaca(rs.getBoolean("status_baca"));
                list.add(n);
            }
            con.close();
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Notifikasi> semuaNotifikasi() {
        List<Notifikasi> list = new ArrayList<>();
        try {
            Connection con = DatabaseConnection.getConnection();
            ResultSet rs = con.createStatement().executeQuery(
                "SELECT n.*, u.username FROM notifikasi n JOIN users u ON n.id_anggota = u.id ORDER BY n.tanggal DESC"
            );
            while (rs.next()) {
                Notifikasi n = new Notifikasi();
                n.setId(rs.getInt("id"));
                n.setIdAnggota(rs.getInt("id_anggota"));
                n.setPesan(rs.getString("pesan"));
                n.setTanggal(rs.getDate("tanggal"));
                n.setStatusBaca(rs.getBoolean("status_baca"));
                list.add(n);
            }
            con.close();
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public void tandaiDibaca(int idAnggota) {
        try {
            Connection con = DatabaseConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "UPDATE notifikasi SET status_baca=true WHERE id_anggota=?"
            );
            ps.setInt(1, idAnggota);
            ps.executeUpdate();
            con.close();
        } catch (Exception e) { e.printStackTrace(); }
    }
}
