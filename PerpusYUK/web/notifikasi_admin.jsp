<%-- 
    Document   : notifikasi_admin
    Created on : May 14, 2026, 7:16:09 PM
    Author     : zamza
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="manager.NotifikasiManager, model.Notifikasi, java.util.*" %>
<%
    if (session.getAttribute("role") == null || !"Admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp"); return;
    }
    NotifikasiManager nm = new NotifikasiManager();
    List<Notifikasi> listNotif = nm.semuaNotifikasi();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Notifikasi Admin</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="sidebar">
    <div class="logo">📚 Perpustakaan</div>
    <div class="user-info">👤 <%= session.getAttribute("username") %><br><small>Admin</small></div>
    <a href="dashboard_admin.jsp">🏠 Dashboard</a>
    <a href="manajemen_buku.jsp">📖 Manajemen Buku</a>
    <a href="peminjaman_admin.jsp">🔄 Peminjaman & Pengembalian</a>
    <a href="manajemen_anggota.jsp">👥 Manajemen Anggota</a>
    <a href="laporan.jsp">📊 Laporan & Statistik</a>
    <a href="notifikasi_admin.jsp" class="active">🔔 Notifikasi</a>
    <div class="logout"><a href="logout.jsp">🚪 Logout</a></div>
</div>
<div class="main-content">
    <div class="page-title">Notifikasi & Reminder</div>
    <div class="card">
        <h3>Semua Notifikasi Anggota</h3>
        <% if (listNotif.isEmpty()) { %>
            <p style="text-align:center; color:#aaa; padding:20px;">Tidak ada notifikasi</p>
        <% } else { %>
            <% for (Notifikasi n : listNotif) { %>
            <div class="notif-item <%= n.getStatusBaca() ? "dibaca" : "" %>">
                🔔 <%= n.getPesan() %>
                <div class="notif-tanggal"><%= n.getTanggal() %></div>
            </div>
            <% } %>
        <% } %>
    </div>
</div>
</body>
</html>
