<%-- 
    Document   : dashboard_anggota
    Created on : May 14, 2026, 7:14:45 PM
    Author     : zamza
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="manager.PeminjamanManager, manager.NotifikasiManager, model.Peminjaman, model.Notifikasi, java.util.*" %>
<%
    if (session.getAttribute("role") == null || !"Anggota".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp"); return;
    }
    int userId = (int) session.getAttribute("userId");
    NotifikasiManager nm = new NotifikasiManager();
    nm.cekDanBuatNotifikasi();
    PeminjamanManager pm = new PeminjamanManager();
    List<Peminjaman> listPinjam = pm.peminjamanByAnggota(userId);
    List<Notifikasi> listNotif = nm.getNotifikasiByAnggota(userId);

    int aktif = 0;
    long totalPinjam = listPinjam.size();
    for (Peminjaman p : listPinjam) if ("Dipinjam".equals(p.getStatus())) aktif++;
    long unread = 0;
    for (Notifikasi n : listNotif) if (!n.getStatusBaca()) unread++;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard Anggota</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="sidebar">
    <div class="logo">📚 Perpustakaan</div>
    <div class="user-info">👤 <%= session.getAttribute("username") %><br><small>Anggota</small></div>
    <a href="dashboard_anggota.jsp" class="active">🏠 Dashboard</a>
    <a href="peminjaman_anggota.jsp">🔄 Peminjaman & Pengembalian</a>
    <a href="notifikasi_anggota.jsp">🔔 Notifikasi <% if (unread > 0) { %><span class="badge-notif"><%= unread %></span><% } %></a>
    <div class="logout"><a href="logout.jsp">🚪 Logout</a></div>
</div>
<div class="main-content">
    <div class="page-title">Dashboard</div>
    <div class="card-stats" style="grid-template-columns: repeat(3,1fr);">
        <div class="card-stat">
            <div class="icon">📚</div>
            <div class="number"><%= totalPinjam %></div>
            <div class="label">Total Pinjam</div>
        </div>
        <div class="card-stat">
            <div class="icon">🔄</div>
            <div class="number"><%= aktif %></div>
            <div class="label">Sedang Dipinjam</div>
        </div>
        <div class="card-stat">
            <div class="icon">🔔</div>
            <div class="number"><%= unread %></div>
            <div class="label">Notifikasi Baru</div>
        </div>
    </div>
    <div class="card">
        <h3>Peminjaman Aktif</h3>
        <% boolean adaAktif = false; %>
        <% for (Peminjaman p : listPinjam) { if ("Dipinjam".equals(p.getStatus())) { adaAktif = true; %>
        <div style="padding:12px; border-bottom:1px solid #eee;">
            <strong><%= p.getJudulBuku() %></strong>
            <span class="badge badge-yellow" style="margin-left:10px;">Dipinjam</span>
            <div style="font-size:12px; color:#aaa; margin-top:4px;">Batas kembali: <%= p.getTanggalKembali() %></div>
        </div>
        <% } } %>
        <% if (!adaAktif) { %><p style="text-align:center; color:#aaa; padding:15px;">Tidak ada peminjaman aktif</p><% } %>
    </div>
</div>
</body>
</html>