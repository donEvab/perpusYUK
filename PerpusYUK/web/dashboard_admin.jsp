<%-- 
    Document   : dashboard_admin
    Created on : May 14, 2026, 7:14:32 PM
    Author     : zamza
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Laporan, manager.NotifikasiManager" %>
<%
    if (session.getAttribute("role") == null || !"Admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    NotifikasiManager nm = new NotifikasiManager();
    nm.cekDanBuatNotifikasi();
    Laporan laporan = new Laporan();
    int totalBuku = laporan.getTotalBuku();
    int totalAnggota = laporan.getTotalAnggota();
    int bukuDipinjam = laporan.getBukuDipinjam();
    int totalDenda = laporan.getTotalDenda();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard Admin</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="sidebar">
    <div class="logo">📚 Perpustakaan</div>
    <div class="user-info">👤 <%= session.getAttribute("username") %><br><small>Admin</small></div>
    <a href="dashboard_admin.jsp" class="active">🏠 Dashboard</a>
    <a href="manajemen_buku.jsp">📖 Manajemen Buku</a>
    <a href="peminjaman_admin.jsp">🔄 Peminjaman & Pengembalian</a>
    <a href="manajemen_anggota.jsp">👥 Manajemen Anggota</a>
    <a href="laporan.jsp">📊 Laporan & Statistik</a>
    <a href="notifikasi_admin.jsp">🔔 Notifikasi</a>
    <div class="logout">
        <a href="logout.jsp">🚪 Logout</a>
    </div>
</div>
<div class="main-content">
    <div class="page-title">Dashboard</div>
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
            <div class="label">Buku Dipinjam</div>
        </div>
        <div class="card-stat">
            <div class="icon">💰</div>
            <div class="number">Rp <%= totalDenda %></div>
            <div class="label">Total Denda</div>
        </div>
    </div>
    <div class="card">
        <h3>Selamat datang, <%= session.getAttribute("username") %>!</h3>
        <p style="color:#777; font-size:14px;">Gunakan menu di sebelah kiri untuk mengelola perpustakaan.</p>
    </div>
</div>
</body>
</html>