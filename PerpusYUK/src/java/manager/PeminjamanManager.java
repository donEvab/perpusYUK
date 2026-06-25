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
import interfaces.Dendable;
import model.Peminjaman;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.Date;

public class PeminjamanManager implements Dendable {

    public void prosesPinjam(int idAnggota, int idBuku, Date tanggalKembali) {
        try {
            Connection con = DatabaseConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO peminjaman (id_anggota, id_buku, tanggal_pinjam, tanggal_kembali, status) VALUES (?,?,?,?,'Dipinjam')"
            );
            ps.setInt(1, idAnggota);
            ps.setInt(2, idBuku);
            ps.setDate(3, new java.sql.Date(new Date().getTime()));
            ps.setDate(4, new java.sql.Date(tanggalKembali.getTime()));
            ps.executeUpdate();

            PreparedStatement ps2 = con.prepareStatement("UPDATE buku SET stok = stok - 1 WHERE id=?");
            ps2.setInt(1, idBuku);
            ps2.executeUpdate();
            con.close();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void prosesKembali(int idPeminjaman) {
        try {
            Connection con = DatabaseConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "SELECT tanggal_kembali FROM peminjaman WHERE id=?"
            );
            ps.setInt(1, idPeminjaman);
            ResultSet rs = ps.executeQuery();
            int denda = 0;
            int idBuku = 0;
            if (rs.next()) {
                Date tanggalKembali = rs.getDate("tanggal_kembali");
                denda = hitungDenda(tanggalKembali, new Date());
            }

            PreparedStatement ps2 = con.prepareStatement(
                "SELECT id_buku FROM peminjaman WHERE id=?"
            );
            ps2.setInt(1, idPeminjaman);
            ResultSet rs2 = ps2.executeQuery();
            if (rs2.next()) idBuku = rs2.getInt("id_buku");

            PreparedStatement ps3 = con.prepareStatement(
                "UPDATE peminjaman SET status='Dikembalikan', denda=? WHERE id=?"
            );
            ps3.setInt(1, denda);
            ps3.setInt(2, idPeminjaman);
            ps3.executeUpdate();

            PreparedStatement ps4 = con.prepareStatement("UPDATE buku SET stok = stok + 1 WHERE id=?");
            ps4.setInt(1, idBuku);
            ps4.executeUpdate();
            con.close();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public int hitungDenda(Date tanggalKembali, Date tanggalSekarang) {
        long diff = tanggalSekarang.getTime() - tanggalKembali.getTime();
        long hariTerlambat = diff / (1000 * 60 * 60 * 24);
        if (hariTerlambat > 0) return (int) hariTerlambat * 1000;
        return 0;
    }

    public List<Peminjaman> semuaPeminjaman() {
        List<Peminjaman> list = new ArrayList<>();
        try {
            Connection con = DatabaseConnection.getConnection();
            String sql = "SELECT p.*, u.username, b.judul FROM peminjaman p " +
                         "JOIN users u ON p.id_anggota = u.id " +
                         "JOIN buku b ON p.id_buku = b.id ORDER BY p.id DESC";
            ResultSet rs = con.createStatement().executeQuery(sql);
            while (rs.next()) {
                Peminjaman pm = new Peminjaman();
                pm.setId(rs.getInt("id"));
                pm.setIdAnggota(rs.getInt("id_anggota"));
                pm.setIdBuku(rs.getInt("id_buku"));
                pm.setTanggalPinjam(rs.getDate("tanggal_pinjam"));
                pm.setTanggalKembali(rs.getDate("tanggal_kembali"));
                pm.setStatus(rs.getString("status"));
                pm.setDenda(rs.getInt("denda"));
                pm.setNamaAnggota(rs.getString("username"));
                pm.setJudulBuku(rs.getString("judul"));
                list.add(pm);
            }
            con.close();
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Peminjaman> peminjamanByAnggota(int idAnggota) {
        List<Peminjaman> list = new ArrayList<>();
        try {
            Connection con = DatabaseConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "SELECT p.*, b.judul FROM peminjaman p JOIN buku b ON p.id_buku = b.id WHERE p.id_anggota=? ORDER BY p.id DESC"
            );
            ps.setInt(1, idAnggota);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Peminjaman pm = new Peminjaman();
                pm.setId(rs.getInt("id"));
                pm.setIdAnggota(rs.getInt("id_anggota"));
                pm.setIdBuku(rs.getInt("id_buku"));
                pm.setTanggalPinjam(rs.getDate("tanggal_pinjam"));
                pm.setTanggalKembali(rs.getDate("tanggal_kembali"));
                pm.setStatus(rs.getString("status"));
                pm.setDenda(rs.getInt("denda"));
                pm.setJudulBuku(rs.getString("judul"));
                list.add(pm);
            }
            con.close();
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}
