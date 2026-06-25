<%-- 
    Document   : laporan
    Created on : May 14, 2026, 7:15:57 PM
    Author     : zamza
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Laporan, db.DatabaseConnection, java.sql.*, java.util.*" %>
<%
    if (session.getAttribute("role") == null || !"Admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp"); return;
    }
    Laporan laporan = new Laporan();
    int totalBuku = laporan.getTotalBuku();
    int totalAnggota = laporan.getTotalAnggota();
    int bukuDipinjam = laporan.getBukuDipinjam();
    int totalDenda = laporan.getTotalDenda();

    List<String[]> bukuPopuler = new ArrayList<>();
    List<String[]> bukuStokMenipis = new ArrayList<>();
    int totalPeminjamanAll = 0, peminjamanAktif = 0, peminjamanTerlambat = 0, peminjamanSelesai = 0;
    int totalBukuFiksi = 0, totalBukuNonFiksi = 0, totalBukuUmum = 0;

    // data grafik per bulan (6 bulan terakhir)
    String[] bulanLabel = new String[6];
    int[] bulanData = new int[6];
    java.util.Calendar cal = java.util.Calendar.getInstance();
    for (int i = 5; i >= 0; i--) {
        java.util.Calendar tmp = java.util.Calendar.getInstance();
        tmp.add(java.util.Calendar.MONTH, -i);
        bulanLabel[5-i] = tmp.getDisplayName(java.util.Calendar.MONTH, java.util.Calendar.SHORT, java.util.Locale.forLanguageTag("id"));
        bulanData[5-i] = 0;
    }
    try {
        Connection con = DatabaseConnection.getConnection();
        ResultSet rs1 = con.createStatement().executeQuery(
            "SELECT b.judul, COUNT(p.id) as total FROM peminjaman p JOIN buku b ON p.id_buku=b.id GROUP BY b.judul ORDER BY total DESC LIMIT 5"
        );
        while (rs1.next()) bukuPopuler.add(new String[]{rs1.getString("judul"), rs1.getString("total")});
        ResultSet rs2 = con.createStatement().executeQuery(
            "SELECT judul, kategori, stok FROM buku WHERE stok <= 3 ORDER BY stok ASC"
        );
        while (rs2.next()) bukuStokMenipis.add(new String[]{rs2.getString("judul"), rs2.getString("kategori"), rs2.getString("stok")});
        ResultSet rs3 = con.createStatement().executeQuery("SELECT COUNT(*) FROM peminjaman");
        if (rs3.next()) totalPeminjamanAll = rs3.getInt(1);
        ResultSet rs4 = con.createStatement().executeQuery("SELECT COUNT(*) FROM peminjaman WHERE status='Dipinjam'");
        if (rs4.next()) peminjamanAktif = rs4.getInt(1);
        ResultSet rs5 = con.createStatement().executeQuery("SELECT COUNT(*) FROM peminjaman WHERE status='Dikembalikan'");
        if (rs5.next()) peminjamanSelesai = rs5.getInt(1);
        ResultSet rs6 = con.createStatement().executeQuery("SELECT COUNT(*) FROM peminjaman WHERE status='Dipinjam' AND tanggal_kembali < CURDATE()");
        if (rs6.next()) peminjamanTerlambat = rs6.getInt(1);
        ResultSet rs7 = con.createStatement().executeQuery("SELECT COUNT(*) FROM buku WHERE tipe='Fiksi'");
        if (rs7.next()) totalBukuFiksi = rs7.getInt(1);
        ResultSet rs8 = con.createStatement().executeQuery("SELECT COUNT(*) FROM buku WHERE tipe='NonFiksi'");
        if (rs8.next()) totalBukuNonFiksi = rs8.getInt(1);
        ResultSet rs9 = con.createStatement().executeQuery("SELECT COUNT(*) FROM buku WHERE tipe='Umum' OR tipe IS NULL");
        if (rs9.next()) totalBukuUmum = rs9.getInt(1);
        // grafik per bulan
        for (int i = 5; i >= 0; i--) {
            java.util.Calendar tmp = java.util.Calendar.getInstance();
            tmp.add(java.util.Calendar.MONTH, -i);
            int bulan = tmp.get(java.util.Calendar.MONTH) + 1;
            int tahun = tmp.get(java.util.Calendar.YEAR);
            PreparedStatement ps = con.prepareStatement(
                "SELECT COUNT(*) FROM peminjaman WHERE MONTH(tanggal_pinjam)=? AND YEAR(tanggal_pinjam)=?"
            );
            ps.setInt(1, bulan);
            ps.setInt(2, tahun);
            ResultSet rsGrafik = ps.executeQuery();
            if (rsGrafik.next()) bulanData[5-i] = rsGrafik.getInt(1);
        }
        con.close();
    } catch (Exception e) { e.printStackTrace(); }
    // buat string JSON untuk chart
    StringBuilder labelJson = new StringBuilder("[");
    StringBuilder dataJson = new StringBuilder("[");
    for (int i = 0; i < 6; i++) {
        labelJson.append("\"").append(bulanLabel[i]).append("\"");
        dataJson.append(bulanData[i]);
        if (i < 5) { labelJson.append(","); dataJson.append(","); }
    }
    labelJson.append("]");
    dataJson.append("]");
    // max untuk grafik bar
    int maxData = 1;
    for (int d : bulanData) if (d > maxData) maxData = d;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Laporan & Statistik</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .grafik-bar-wrap { display:flex; align-items:flex-end; gap:10px; height:160px; padding:10px 0; }
        .grafik-bar-item { flex:1; display:flex; flex-direction:column; align-items:center; gap:5px; height:100%; justify-content:flex-end; }
        .grafik-bar { width:100%; background:#c0392b; border-radius:4px 4px 0 0; min-height:4px; transition:height 0.3s; }
        .grafik-bar-label { font-size:11px; color:#777; }
        .grafik-bar-val { font-size:12px; font-weight:bold; color:#c0392b; }
        .stat-row { display:flex; justify-content:space-between; padding:10px 0; border-bottom:1px solid #f0f0f0; font-size:14px; }
        .stat-row:last-child { border-bottom:none; }
    </style>
</head>
<body>
<div class="sidebar">
    <div class="logo">📚 Perpustakaan</div>
    <div class="user-info">👤 <%= session.getAttribute("username") %><br><small>Admin</small></div>
    <a href="dashboard_admin.jsp">🏠 Dashboard</a>
    <a href="manajemen_buku.jsp">📖 Manajemen Buku</a>
    <a href="peminjaman_admin.jsp">🔄 Peminjaman & Pengembalian</a>
    <a href="manajemen_anggota.jsp">👥 Manajemen Anggota</a>
    <a href="laporan.jsp" class="active">📊 Laporan & Statistik</a>
    <a href="notifikasi_admin.jsp">🔔 Notifikasi</a>
    <div class="logout"><a href="logout.jsp">🚪 Logout</a></div>
</div>
<div class="main-content">
    <div class="page-title">Laporan & Statistik</div>

    <div class="card-stats">
        <div class="card-stat">
            <div class="icon">📚</div>
            <div class="number"><%= totalBuku %></div>
            <div class="label">Total Buku</div>
        </div>
        <div class="card-stat">
            <div class="icon">👥</div>
            <div class="number"><%= totalAnggota %></div>
            <div class="label">Total Anggota</div>
        </div>
        <div class="card-stat">
            <div class="icon">🔄</div>
            <div class="number"><%= bukuDipinjam %></div>
            <div class="label">Sedang Dipinjam</div>
        </div>
        <div class="card-stat">
            <div class="icon">💰</div>
            <div class="number">Rp <%= totalDenda %></div>
            <div class="label">Denda Belum Bayar</div>
        </div>
    </div>

    <div style="display:grid; grid-template-columns:1fr 1fr; gap:20px; margin-bottom:20px;">
        <!-- Grafik Peminjaman per Bulan -->
        <div class="card">
            <h3>📈 Grafik Peminjaman per Bulan</h3>
            <p style="font-size:12px; color:#aaa; margin-bottom:10px;">6 bulan terakhir</p>
            <div class="grafik-bar-wrap">
                <% for (int i = 0; i < 6; i++) {
                    int pct = maxData > 0 ? (bulanData[i] * 140 / maxData) : 0;
                %>
                <div class="grafik-bar-item">
                    <div class="grafik-bar-val"><%= bulanData[i] %></div>
                    <div class="grafik-bar" style="height:<%= pct %>px;"></div>
                    <div class="grafik-bar-label"><%= bulanLabel[i] %></div>
                </div>
                <% } %>
            </div>
        </div>

        <!-- Buku Terpopuler -->
        <div class="card">
            <h3>🏆 Buku Terpopuler</h3>
            <p style="font-size:12px; color:#aaa; margin-bottom:10px;">Top 5 buku paling banyak dipinjam</p>
            <table>
                <thead><tr><th>Judul</th><th>Total</th></tr></thead>
                <tbody>
                    <% for (String[] b : bukuPopuler) { %>
                    <tr>
                        <td><%= b[0] %></td>
                        <td><span class="badge badge-blue"><%= b[1] %>x</span></td>
                    </tr>
                    <% } %>
                    <% if (bukuPopuler.isEmpty()) { %>
                    <tr><td colspan="2" style="text-align:center; color:#aaa;">Belum ada data</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <div style="display:grid; grid-template-columns:1fr 1fr; gap:20px;">
        <!-- Statistik Peminjaman -->
        <div class="card">
            <h3>📊 Statistik Peminjaman</h3>
            <div class="stat-row">
                <span style="color:#777;">Total Peminjaman</span>
                <strong><%= totalPeminjamanAll %></strong>
            </div>
            <div class="stat-row">
                <span style="color:#777;">Peminjaman Aktif</span>
                <strong style="color:#f39c12;"><%= peminjamanAktif %></strong>
            </div>
            <div class="stat-row">
                <span style="color:#777;">Peminjaman Terlambat</span>
                <strong style="color:#c0392b;"><%= peminjamanTerlambat %></strong>
            </div>
            <div class="stat-row">
                <span style="color:#777;">Peminjaman Selesai</span>
                <strong style="color:#27ae60;"><%= peminjamanSelesai %></strong>
            </div>
        </div>

        <!-- Statistik Koleksi -->
        <div class="card">
            <h3>📚 Statistik Koleksi</h3>
            <div class="stat-row">
                <span style="color:#777;">Total Buku</span>
                <strong><%= totalBuku %></strong>
            </div>
            <div class="stat-row">
                <span style="color:#777;">Buku Fiksi</span>
                <strong><%= totalBukuFiksi %></strong>
            </div>
            <div class="stat-row">
                <span style="color:#777;">Buku Non Fiksi</span>
                <strong><%= totalBukuNonFiksi %></strong>
            </div>
            <div class="stat-row">
                <span style="color:#777;">Buku Umum</span>
                <strong><%= totalBukuUmum %></strong>
            </div>
        </div>

        <!-- Buku Stok Menipis -->
        <div class="card" style="grid-column: span 2;">
            <h3>⚠️ Buku dengan Stok Menipis (≤ 3)</h3>
            <table>
                <thead>
                    <tr><th>Judul Buku</th><th>Kategori</th><th>Stok Tersisa</th><th>Status</th></tr>
                </thead>
                <tbody>
                    <% for (String[] b : bukuStokMenipis) { %>
                    <tr>
                        <td><%= b[0] %></td>
                        <td><span class="badge badge-yellow"><%= b[1] %></span></td>
                        <td><span class="badge badge-red"><%= b[2] %></span></td>
                        <td><span style="color:#c0392b; font-size:13px;">⚠️ Perlu Restok</span></td>
                    </tr>
                    <% } %>
                    <% if (bukuStokMenipis.isEmpty()) { %>
                    <tr><td colspan="4" style="text-align:center; color:#27ae60; padding:15px;">✅ Semua stok aman</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>