<%-- 
    Document   : manajemen_buku
    Created on : May 14, 2026, 7:15:05 PM
    Author     : zamza
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="manager.BukuManager, model.Buku, model.BukuFiksi, model.BukuNonFiksi, java.util.*" %>
<%
    if (session.getAttribute("role") == null || !"Admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp"); return;
    }
    BukuManager bm = new BukuManager();
    String msg = "";

    String aksi = request.getParameter("aksi");
    if ("tambah".equals(aksi)) {
        String tipe = request.getParameter("tipe");
        Buku buku;
        if ("Fiksi".equals(tipe)) {
            BukuFiksi bf = new BukuFiksi();
            bf.setGenre(request.getParameter("genre"));
            buku = bf;
        } else if ("NonFiksi".equals(tipe)) {
            BukuNonFiksi bnf = new BukuNonFiksi();
            bnf.setBidangIlmu(request.getParameter("bidang_ilmu"));
            buku = bnf;
        } else {
            buku = new Buku();
        }
        buku.setJudul(request.getParameter("judul"));
        buku.setPengarang(request.getParameter("pengarang"));
        buku.setKategori(request.getParameter("kategori"));
        buku.setIsbn(request.getParameter("isbn"));
        buku.setStok(Integer.parseInt(request.getParameter("stok")));
        bm.tambahBuku(buku);
        msg = "Buku berhasil ditambahkan!";
    } else if ("edit".equals(aksi)) {
        Buku buku = new Buku();
        buku.setId(Integer.parseInt(request.getParameter("id")));
        buku.setJudul(request.getParameter("judul"));
        buku.setPengarang(request.getParameter("pengarang"));
        buku.setKategori(request.getParameter("kategori"));
        buku.setIsbn(request.getParameter("isbn"));
        buku.setStok(Integer.parseInt(request.getParameter("stok")));
        bm.editBuku(buku);
        msg = "Buku berhasil diperbarui!";
    } else if ("hapus".equals(aksi)) {
        bm.hapusBuku(Integer.parseInt(request.getParameter("id")));
        msg = "Buku berhasil dihapus!";
    }

    String keyword = request.getParameter("keyword") != null ? request.getParameter("keyword") : "";
    List<Buku> listBuku = bm.cariBuku(keyword);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manajemen Buku</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="sidebar">
    <div class="logo">📚 Perpustakaan</div>
    <div class="user-info">👤 <%= session.getAttribute("username") %><br><small>Admin</small></div>
    <a href="dashboard_admin.jsp">🏠 Dashboard</a>
    <a href="manajemen_buku.jsp" class="active">📖 Manajemen Buku</a>
    <a href="peminjaman_admin.jsp">🔄 Peminjaman & Pengembalian</a>
    <a href="manajemen_anggota.jsp">👥 Manajemen Anggota</a>
    <a href="laporan.jsp">📊 Laporan & Statistik</a>
    <a href="notifikasi_admin.jsp">🔔 Notifikasi</a>
    <div class="logout"><a href="logout.jsp">🚪 Logout</a></div>
</div>
<div class="main-content">
    <div class="page-title">Manajemen Buku</div>
    <% if (!msg.isEmpty()) { %>
        <div class="alert alert-success"><%= msg %></div>
    <% } %>
    <div class="card">
        <div class="search-bar">
            <form method="get" action="manajemen_buku.jsp" style="display:flex; gap:10px; flex:1;">
                <input type="text" name="keyword" placeholder="Cari buku berdasarkan judul, pengarang, atau ISBN..." value="<%= keyword %>">
                <button type="submit" class="btn btn-secondary">Cari</button>
            </form>
            <button class="btn btn-primary" onclick="openModal('modalTambahBuku')">+ Tambah Buku</button>
        </div>
        <table id="tabelBuku">
            <thead>
                <tr>
                    <th>Judul</th>
                    <th>Pengarang</th>
                    <th>Kategori</th>
                    <th>ISBN</th>
                    <th>Stok</th>
                    <th>Aksi</th>
                </tr>
            </thead>
            <tbody>
                <% for (Buku b : listBuku) { %>
                <tr>
                    <td><%= b.getJudul() %></td>
                    <td><%= b.getPengarang() %></td>
                    <td><span class="badge badge-blue"><%= b.getKategori() %></span></td>
                    <td><%= b.getIsbn() %></td>
                    <td><%= b.getStok() %></td>
                    <td>
                        <button class="btn btn-warning" onclick="isiFormEdit(<%= b.getId() %>,'<%= b.getJudul().replace("'","") %>','<%= b.getPengarang().replace("'","") %>','<%= b.getKategori() %>','<%= b.getIsbn() %>',<%= b.getStok() %>)">Edit</button>
                        <a href="manajemen_buku.jsp?aksi=hapus&id=<%= b.getId() %>" class="btn btn-danger" onclick="return konfirmasiHapus()">Hapus</a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<!-- Modal Tambah Buku -->
<div class="modal-overlay" id="modalTambahBuku">
    <div class="modal">
        <h3>Tambah Buku</h3>
        <form method="post" action="manajemen_buku.jsp">
            <input type="hidden" name="aksi" value="tambah">
            <div class="form-group">
                <label>Tipe Buku</label>
                <select name="tipe">
                    <option value="Umum">Umum</option>
                    <option value="Fiksi">Fiksi</option>
                    <option value="NonFiksi">Non Fiksi</option>
                </select>
            </div>
            <div class="form-group">
                <label>Judul</label>
                <input type="text" name="judul" required>
            </div>
            <div class="form-group">
                <label>Pengarang</label>
                <input type="text" name="pengarang">
            </div>
            <div class="form-group">
                <label>Kategori</label>
                <input type="text" name="kategori">
            </div>
            <div class="form-group">
                <label>ISBN</label>
                <input type="text" name="isbn">
            </div>
            <div class="form-group">
                <label>Stok</label>
                <input type="number" name="stok" value="1" min="0">
            </div>
            <div class="form-group">
                <label>Genre (khusus Fiksi)</label>
                <input type="text" name="genre">
            </div>
            <div class="form-group">
                <label>Bidang Ilmu (khusus Non Fiksi)</label>
                <input type="text" name="bidang_ilmu">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('modalTambahBuku')">Batal</button>
                <button type="submit" class="btn btn-primary">Simpan</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal Edit Buku -->
<div class="modal-overlay" id="modalEditBuku">
    <div class="modal">
        <h3>Edit Buku</h3>
        <form method="post" action="manajemen_buku.jsp">
            <input type="hidden" name="aksi" value="edit">
            <input type="hidden" name="id" id="edit_id">
            <div class="form-group">
                <label>Judul</label>
                <input type="text" name="judul" id="edit_judul" required>
            </div>
            <div class="form-group">
                <label>Pengarang</label>
                <input type="text" name="pengarang" id="edit_pengarang">
            </div>
            <div class="form-group">
                <label>Kategori</label>
                <input type="text" name="kategori" id="edit_kategori">
            </div>
            <div class="form-group">
                <label>ISBN</label>
                <input type="text" name="isbn" id="edit_isbn">
            </div>
            <div class="form-group">
                <label>Stok</label>
                <input type="number" name="stok" id="edit_stok" min="0">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('modalEditBuku')">Batal</button>
                <button type="submit" class="btn btn-primary">Simpan</button>
            </div>
        </form>
    </div>
</div>

<script src="js/script.js"></script>
</body>
</html>