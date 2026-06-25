<%-- 
    Document   : login
    Created on : May 21, 2026, 11:24:57 PM
    Author     : zamza
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="db.DatabaseConnection, java.sql.*" %>
<%
    String error = "";
    String success = "";

    if ("POST".equals(request.getMethod())) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String action = request.getParameter("action");

        if ("login".equals(action)) {
            try {
                Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(
                    "SELECT * FROM users WHERE username=? AND password=?"
                );
                ps.setString(1, username);
                ps.setString(2, password);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                session.setAttribute("userId", rs.getInt("id"));
                session.setAttribute("username", rs.getString("username"));
                session.setAttribute("role", rs.getString("role"));

                String role = rs.getString("role");

                con.close();

                if ("admin".equalsIgnoreCase(role)) {
                    response.sendRedirect("dashboard_admin.jsp");
                } else {
                    response.sendRedirect("dashboard_anggota.jsp");
                }

                return;
            } else {
                error = "Username atau password salah!";
            }
                con.close();
            } catch (Exception e) {
                    e.printStackTrace();
                    error = e.getMessage();
            }
        } else if ("register".equals(action)) {
            try {
                Connection con = DatabaseConnection.getConnection();
                PreparedStatement cek = con.prepareStatement("SELECT id FROM users WHERE username=?");
                cek.setString(1, username);
                ResultSet cekRs = cek.executeQuery();
                if (cekRs.next()) {
                    error = "Username sudah digunakan!";
                } else {
                    PreparedStatement ps = con.prepareStatement(
                        "INSERT INTO users (username, password, role) VALUES (?,?,'Anggota')",
                        Statement.RETURN_GENERATED_KEYS
                    );
                    ps.setString(1, username);
                    ps.setString(2, password);
                    ps.executeUpdate();
                    ResultSet keys = ps.getGeneratedKeys();
                    if (keys.next()) {
                        int newId = keys.getInt(1);
                        String noAnggota = "ANG" + String.format("%04d", newId);
                        PreparedStatement ps2 = con.prepareStatement(
                            "INSERT INTO anggota (user_id, no_anggota) VALUES (?,?)"
                        );
                        ps2.setInt(1, newId);
                        ps2.setString(2, noAnggota);
                        ps2.executeUpdate();
                    }
                    success = "Registrasi berhasil! Silakan login.";
                }
                con.close();
            } catch (Exception e) {
                error = "Registrasi gagal!";
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - Perpustakaan</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="login-wrapper">
    <div class="login-box">
        <div class="logo-icon"><span>📚</span></div>
        <h2>Sistem Manajemen Perpustakaan</h2>

        <% if (!error.isEmpty()) { %>
            <div class="alert alert-error"><%= error %></div>
        <% } %>
        <% if (!success.isEmpty()) { %>
            <div class="alert alert-success"><%= success %></div>
        <% } %>

        <div class="tab-switch">
            <button id="btnLogin" class="active" onclick="switchTab('login')">Login</button>
            <button id="btnRegister" onclick="switchTab('register')">Register</button>
        </div>

        <div id="formLogin">
            <form method="post" action="login.jsp">
                <input type="hidden" name="action" value="login">
                <div class="form-group">
                    <label>Username</label>
                    <input type="text" name="username" placeholder="Masukkan username" required>
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" placeholder="Masukkan password" required>
                </div>
                <button type="submit" class="btn btn-primary" style="width:100%; padding:12px;">Masuk</button>
            </form>
        </div>

        <div id="formRegister" style="display:none;">
            <form method="post" action="login.jsp">
                <input type="hidden" name="action" value="register">
                <div class="form-group">
                    <label>Username</label>
                    <input type="text" name="username" placeholder="Masukkan username" required>
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" placeholder="Masukkan password" required>
                </div>
                <button type="submit" class="btn btn-primary" style="width:100%; padding:12px;">Daftar</button>
            </form>
        </div>
    </div>
</div>
<script src="js/script.js"></script>
<script>
function switchTab(tab) {
    if (tab === 'login') {
        document.getElementById('formLogin').style.display = 'block';
        document.getElementById('formRegister').style.display = 'none';
        document.getElementById('btnLogin').classList.add('active');
        document.getElementById('btnRegister').classList.remove('active');
    } else {
        document.getElementById('formLogin').style.display = 'none';
        document.getElementById('formRegister').style.display = 'block';
        document.getElementById('btnLogin').classList.remove('active');
        document.getElementById('btnRegister').classList.add('active');
    }
}
</script>
</body>
</html>
