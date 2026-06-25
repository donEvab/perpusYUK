<%-- 
    Document   : manajemen_anggota
    Created on : May 14, 2026, 7:15:47 PM
    Author     : zamza
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="manager.AnggotaManager, model.Anggota, db.DatabaseConnection, java.sql.*, java.util.*" %>
<%
    if (session.getAttribute("role") == null || !"Admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp"); return;
    }
    AnggotaManager am = new AnggotaManager();
    String msg = "";
    String aksi = request.getParameter("aksi");

    if ("edit".equals(aksi)) {
        am.editAnggota(Integer.parseInt(request.getParameter("id")), request.getParameter("username"), request.getParameter("email"));
        msg = "Data anggota berhasil diperbarui!";
    } else if ("hapus".equals(aksi)) {
        am.hapusAnggota(Integer.parseInt(request.getParameter("id")));
        msg = "Anggota berhasil dihapus!";
    }

    String keyword = request.getParameter("keyword") != null ? request.getParameter("keyword") : "";
    List<Anggota> listAnggota = (List<Anggota>) am.searchUser(keyword);

    // hitung stats
    int totalAnggota = listAnggota.size();
    int anggotaAktif = 0;
    int totalDendaBelumBayar = 0;
    try {
        Connection con = DatabaseConnection.getConnection();
        ResultSet rs1 = con.createStatement().executeQuery(
            "SELECT COUNT(DISTINCT id_anggota) FROM peminjaman WHERE status='Dipinjam'"
        );
        if (rs1.next()) anggotaAktif = rs1.getInt(1);
        ResultSet rs2 = con.createStatement().executeQuery(
            "SELECT SUM(denda) FROM peminjaman WHERE status != 'Dikembalikan' AND denda > 0"
        );
        if (rs2.next()) totalDendaBelumBayar = rs2.getInt(1);
        con.close();
    } catch (Exception e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manajemen Anggota</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="sidebar">
    <div class="logo">📚 Perpustakaan</div>
    <div class="user-info">👤 <%= session.getAttribute("username") %><br><small>Admin</small></div>
    <a href="dashboard_admin.jsp">🏠 Dashboard</a>
    <a href="manajemen_buku.jsp">📖 Manajemen Buku</a>
    <a href="peminjaman_admin.jsp">🔄 Peminjaman & Pengembalian</a>
    <a href="manajemen_anggota.jsp" class="active">👥 Manajemen Anggota</a>
    <a href="laporan.jsp">📊 Laporan & Statistik</a>
    <a href="notifikasi_admin.jsp">🔔 Notifikasi</a>
    <div class="logout"><a href="logout.jsp">🚪 Logout</a></div>
</div>
<div class="main-content">
    <div class="page-title">Manajemen Anggota</div>
    <% if (!msg.isEmpty()) { %><div class="alert alert-success"><%= msg %></div><% } %>

    <div class="card-stats" style="grid-template-columns: repeat(3,1fr);">
        <div class="card-stat">
            <div class="icon">👥</div>
            <div class="number"><%= totalAnggota %></div>
            <div class="label">Total Anggota</div>
        </div>
        <div class="card-stat">
            <div class="icon">✅</div>
            <div class="number"><%= anggotaAktif %></div>
            <div class="label">Anggota Aktif Meminjam</div>
        </div>
        <div class="card-stat">
            <div class="icon">💰</div>
            <div class="number">Rp <%= totalDendaBelumBayar %></div>
            <div class="label">Denda Belum Dibayar</div>
        </div>
    </div>

    <div class="card">
        <div class="search-bar">
            <form method="get" action="manajemen_anggota.jsp" style="display:flex; gap:10px; flex:1;">
                <input type="text" name="keyword" placeholder="Cari anggota berdasarkan nama, username, atau email..." value="<%= keyword %>">
                <button type="submit" class="btn btn-secondary">Cari</button>
            </form>
        </div>
        <table>
            <thead>
                <tr>
                    <th>Anggota</th>
                    <th>Kontak</th>
                    <th>No. Anggota</th>
                    <th>Tanggal Daftar</th>
                    <th>Total Pinjaman</th>
                    <th>Denda</th>
                    <th>Aksi</th>
                </tr>
            </thead>
            <tbody>
                <% for (Anggota a : listAnggota) {
                    // ambil total pinjaman dan denda per anggota
                    int totalPinjaman = 0;
                    int dendaAnggota = 0;
                    try {
                        Connection con = DatabaseConnection.getConnection();
                        PreparedStatement ps = con.prepareStatement(
                            "SELECT COUNT(*) as total, COALESCE(SUM(denda),0) as denda FROM peminjaman WHERE id_anggota=?"
                        );
                        ps.setInt(1, a.getId());
                        ResultSet rs = ps.executeQuery();
                        if (rs.next()) {
                            totalPinjaman = rs.getInt("total");
                            dendaAnggota = rs.getInt("denda");
                        }
                        con.close();
                    } catch (Exception e) { e.printStackTrace(); }
                %>
                <tr>
                    <td>
                        <strong><%= a.getUsername() %></strong><br>
                        <small style="color:#aaa;">ID: <%= a.getId() %></small>
                    </td>
                    <td>
                        <%= a.getEmail() != null && !a.getEmail().isEmpty() ? a.getEmail() : "-" %><br>
                        <small style="color:#aaa;"><%= a.getNoAnggota() != null ? a.getNoAnggota() : "-" %></small>
                    </td>
                    <td><%= a.getNoAnggota() != null ? a.getNoAnggota() : "-" %></td>
                    <td><%= a.getTanggalDaftar() != null ? a.getTanggalDaftar() : "-" %></td>
                    <td><span class="badge badge-blue"><%= totalPinjaman %> kali</span></td>
                    <td>
                        <% if (dendaAnggota > 0) { %>
                            <span class="badge badge-red">Rp <%= dendaAnggota %></span>
                        <% } else { %>
                            <span class="badge badge-green">-</span>
                        <% } %>
                    </td>
                    <td style="display:flex; gap:5px;">
                        <button class="btn btn-secondary" onclick="lihatDetail(<%= a.getId() %>,'<%= a.getUsername() %>','<%= a.getEmail() != null ? a.getEmail() : "" %>','<%= a.getNoAnggota() != null ? a.getNoAnggota() : "" %>','<%= a.getTanggalDaftar() != null ? a.getTanggalDaftar() : "" %>',<%= totalPinjaman %>,<%= dendaAnggota %>)" title="Lihat Detail">👁</button>
                        <button class="btn btn-warning" onclick="isiFormEditAnggota(<%= a.getId() %>,'<%= a.getUsername() %>','<%= a.getEmail() != null ? a.getEmail() : "" %>')" title="Edit">✏️</button>
                        <a href="manajemen_anggota.jsp?aksi=hapus&id=<%= a.getId() %>" class="btn btn-danger" onclick="return konfirmasiHapus()" title="Hapus">🗑</a>
                    </td>
                </tr>
                <% } %>
                <% if (listAnggota.isEmpty()) { %>
                <tr><td colspan="7" style="text-align:center; color:#aaa; padding:20px;">Tidak ada data anggota</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<!-- Modal Detail Anggota -->
<div class="modal-overlay" id="modalDetailAnggota">
    <div class="modal">
        <h3>👤 Detail Anggota</h3>
        <div style="display:grid; gap:12px;">
            <div style="display:flex; justify-content:space-between; padding:10px; background:#f8f9fa; border-radius:8px;">
                <span style="color:#777; font-size:13px;">Username</span>
                <strong id="detail_username"></strong>
            </div>
            <div style="display:flex; justify-content:space-between; padding:10px; background:#f8f9fa; border-radius:8px;">
                <span style="color:#777; font-size:13px;">Email</span>
                <strong id="detail_email"></strong>
            </div>
            <div style="display:flex; justify-content:space-between; padding:10px; background:#f8f9fa; border-radius:8px;">
                <span style="color:#777; font-size:13px;">No. Anggota</span>
                <strong id="detail_no"></strong>
            </div>
            <div style="display:flex; justify-content:space-between; padding:10px; background:#f8f9fa; border-radius:8px;">
                <span style="color:#777; font-size:13px;">Tanggal Daftar</span>
                <strong id="detail_tgl"></strong>
            </div>
            <div style="display:flex; justify-content:space-between; padding:10px; background:#f8f9fa; border-radius:8px;">
                <span style="color:#777; font-size:13px;">Total Pinjaman</span>
                <strong id="detail_pinjam"></strong>
            </div>
            <div style="display:flex; justify-content:space-between; padding:10px; background:#f8f9fa; border-radius:8px;">
                <span style="color:#777; font-size:13px;">Total Denda</span>
                <strong id="detail_denda"></strong>
            </div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-secondary" onclick="closeModal('modalDetailAnggota')">Tutup</button>
        </div>
    </div>
</div>

<!-- Modal Edit Anggota -->
<div class="modal-overlay" id="modalEditAnggota">
    <div class="modal">
        <h3>✏️ Edit Anggota</h3>
        <form method="post" action="manajemen_anggota.jsp">
            <input type="hidden" name="aksi" value="edit">
            <input type="hidden" name="id" id="edit_anggota_id">
            <div class="form-group">
                <label>Username</label>
                <input type="text" name="username" id="edit_anggota_username" required>
            </div>
            <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" id="edit_anggota_email">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('modalEditAnggota')">Batal</button>
                <button type="submit" class="btn btn-primary">Simpan</button>
            </div>
        </form>
    </div>
</div>

<script src="js/script.js"></script>
<script>
function lihatDetail(id, username, email, no, tgl, pinjam, denda) {
    document.getElementById('detail_username').innerText = username;
    document.getElementById('detail_email').innerText = email || '-';
    document.getElementById('detail_no').innerText = no || '-';
    document.getElementById('detail_tgl').innerText = tgl || '-';
    document.getElementById('detail_pinjam').innerText = pinjam + ' kali';
    document.getElementById('detail_denda').innerText = denda > 0 ? 'Rp ' + denda : '-';
    openModal('modalDetailAnggota');
}

function isiFormEditAnggota(id, username, email) {
    document.getElementById('edit_anggota_id').value = id;
    document.getElementById('edit_anggota_username').value = username;
    document.getElementById('edit_anggota_email').value = email;
    openModal('modalEditAnggota');
}
</script>
</body>
</html>
