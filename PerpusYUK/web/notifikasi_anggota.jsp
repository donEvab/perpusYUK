<%-- 
    Document   : notifikasi_anggota
    Created on : May 14, 2026, 7:16:18 PM
    Author     : zamza
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="manager.NotifikasiManager, model.Notifikasi, java.util.*" %>
<%
    if (session.getAttribute("role") == null || !"Anggota".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp"); return;
    }
    int userId = (int) session.getAttribute("userId");
    NotifikasiManager nm = new NotifikasiManager();
    nm.tandaiDibaca(userId);
    List<Notifikasi> listNotif = nm.getNotifikasiByAnggota(userId);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Notifikasi</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="sidebar">
    <div class="logo">📚 Perpustakaan</div>
    <div class="user-info">👤 <%= session.getAttribute("username") %><br><small>Anggota</small></div>
    <a href="dashboard_anggota.jsp">🏠 Dashboard</a>
    <a href="peminjaman_anggota.jsp">🔄 Peminjaman & Pengembalian</a>
    <a href="notifikasi_anggota.jsp" class="active">🔔 Notifikasi</a>
    <div class="logout"><a href="logout.jsp">🚪 Logout</a></div>
</div>
<div class="main-content">
    <div class="page-title">Notifikasi & Reminder</div>
    <div class="card">
        <h3>Notifikasi Saya</h3>
        <% if (listNotif.isEmpty()) { %>
            <p style="text-align:center; color:#aaa; padding:20px;">Tidak ada notifikasi</p>
        <% } else { %>
            <% for (Notifikasi n : listNotif) { %>
            <div class="notif-item dibaca">
                🔔 <%= n.getPesan() %>
                <div class="notif-tanggal"><%= n.getTanggal() %></div>
            </div>
            <% } %>
        <% } %>
        <div style="margin-top:20px; padding:15px; background:#f8f9fa; border-radius:8px; font-size:13px; color:#777;">
            ℹ️ <strong>Info:</strong> Reminder muncul 3 hari sebelum batas kembali. Denda Rp 1.000/hari keterlambatan.
        </div>
    </div>
</div>
</body>
</html>
