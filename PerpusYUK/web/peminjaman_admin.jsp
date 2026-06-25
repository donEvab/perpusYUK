<%-- 
    Document   : peminjaman_admin
    Created on : May 14, 2026, 7:15:19 PM
    Author     : zamza
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="manager.PeminjamanManager, manager.BukuManager, model.Peminjaman, model.Buku, java.util.*, java.text.SimpleDateFormat" %>
<%
    if (session.getAttribute("role") == null || !"Admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp"); return;
    }
    PeminjamanManager pm = new PeminjamanManager();
    BukuManager bm = new BukuManager();
    String msg = "";
    String aksi = request.getParameter("aksi");

    if ("pinjam".equals(aksi)) {
        int idAnggota = Integer.parseInt(request.getParameter("id_anggota"));
        int idBuku = Integer.parseInt(request.getParameter("id_buku"));
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date tanggalKembali = sdf.parse(request.getParameter("tanggal_kembali"));
        pm.prosesPinjam(idAnggota, idBuku, tanggalKembali);
        msg = "Peminjaman berhasil dicatat!";
    } else if ("kembali".equals(aksi)) {
        pm.prosesKembali(Integer.parseInt(request.getParameter("id")));
        msg = "Buku berhasil dikembalikan!";
    }

    List<Peminjaman> listPinjam = pm.semuaPeminjaman();
    List<Buku> listBuku = bm.semuaBuku();

    int aktif = 0, terlambat = 0;
    long totalDenda = 0;
    for (Peminjaman p : listPinjam) {
        if ("Dipinjam".equals(p.getStatus())) aktif++;
        if (p.getDenda() > 0 && !"Dikembalikan".equals(p.getStatus())) { terlambat++; totalDenda += p.getDenda(); }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Peminjaman Admin</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="sidebar">
    <div class="logo">📚 Perpustakaan</div>
    <div class="user-info">👤 <%= session.getAttribute("username") %><br><small>Admin</small></div>
    <a href="dashboard_admin.jsp">🏠 Dashboard</a>
    <a href="manajemen_buku.jsp">📖 Manajemen Buku</a>
    <a href="peminjaman_admin.jsp" class="active">🔄 Peminjaman & Pengembalian</a>
    <a href="manajemen_anggota.jsp">👥 Manajemen Anggota</a>
    <a href="laporan.jsp">📊 Laporan & Statistik</a>
    <a href="notifikasi_admin.jsp">🔔 Notifikasi</a>
    <div class="logout"><a href="logout.jsp">🚪 Logout</a></div>
</div>
<div class="main-content">
    <div class="page-title">Peminjaman & Pengembalian</div>
    <% if (!msg.isEmpty()) { %><div class="alert alert-success"><%= msg %></div><% } %>
    <div class="card-stats" style="grid-template-columns: repeat(3,1fr);">
        <div class="card-stat">
            <div class="icon">🔄</div>
            <div class="number"><%= aktif %></div>
            <div class="label">Peminjaman Aktif</div>
        </div>
        <div class="card-stat">
            <div class="icon">⏰</div>
            <div class="number"><%= terlambat %></div>
            <div class="label">Terlambat</div>
        </div>
        <div class="card-stat">
            <div class="icon">💰</div>
            <div class="number">Rp <%= totalDenda %></div>
            <div class="label">Total Denda</div>
        </div>
    </div>
    <div class="card">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:15px;">
            <h3>Riwayat Peminjaman</h3>
            <button class="btn btn-primary" onclick="openModal('modalPinjam')">+ Pinjam Buku</button>
        </div>
        <table>
            <thead>
                <tr>
                    <th>Anggota</th>
                    <th>Buku</th>
                    <th>Tanggal Pinjam</th>
                    <th>Batas Kembali</th>
                    <th>Status</th>
                    <th>Denda</th>
                    <th>Aksi</th>
                </tr>
            </thead>
            <tbody>
                <% for (Peminjaman p : listPinjam) { %>
                <tr>
                    <td><%= p.getNamaAnggota() %></td>
                    <td><%= p.getJudulBuku() %></td>
                    <td><%= p.getTanggalPinjam() %></td>
                    <td><%= p.getTanggalKembali() %></td>
                    <td>
                        <% if ("Dipinjam".equals(p.getStatus())) { %>
                            <span class="badge badge-yellow">Dipinjam</span>
                        <% } else { %>
                            <span class="badge badge-green">Dikembalikan</span>
                        <% } %>
                    </td>
                    <td><%= p.getDenda() > 0 ? "Rp " + p.getDenda() : "-" %></td>
                    <td>
                        <% if ("Dipinjam".equals(p.getStatus())) { %>
                            <a href="peminjaman_admin.jsp?aksi=kembali&id=<%= p.getId() %>" class="btn btn-success" onclick="return confirm('Proses pengembalian?')">Kembalikan</a>
                        <% } %>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<!-- Modal Pinjam -->
<div class="modal-overlay" id="modalPinjam">
    <div class="modal">
        <h3>Pinjam Buku</h3>
        <form method="post" action="peminjaman_admin.jsp">
            <input type="hidden" name="aksi" value="pinjam">
            <div class="form-group">
                <label>ID Anggota</label>
                <input type="number" name="id_anggota" required>
            </div>
            <div class="form-group">
                <label>Pilih Buku</label>
                <select name="id_buku" required>
                    <% for (Buku b : listBuku) { if (b.getStok() > 0) { %>
                    <option value="<%= b.getId() %>"><%= b.getJudul() %> (Stok: <%= b.getStok() %>)</option>
                    <% } } %>
                </select>
            </div>
            <div class="form-group">
                <label>Tanggal Kembali</label>
                <input type="date" name="tanggal_kembali" required>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('modalPinjam')">Batal</button>
                <button type="submit" class="btn btn-primary">Proses</button>
            </div>
        </form>
    </div>
</div>
<script src="js/script.js"></script>
</body>
</html>
