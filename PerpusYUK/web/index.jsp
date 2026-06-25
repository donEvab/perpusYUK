<%-- 
    Document   : index.jsp
    Created on : May 14, 2026, 8:04:38 PM
    Author     : zamza
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>PerpusYUK</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            background: #1a1a2e;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            font-family: 'Segoe UI', Tahoma, sans-serif;
            overflow: hidden;
        }

        .splash {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 20px;
        }

        .book-icon svg {
            width: 80px;
            height: 80px;
            animation: bookPop 0.7s cubic-bezier(0.34, 1.56, 0.64, 1) 0.1s both;
        }

        .title {
            font-size: 36px;
            font-weight: 700;
            color: #fff;
            letter-spacing: 2px;
            opacity: 0;
            transform: translateY(20px);
            animation: fadeUp 0.8s ease 0.5s forwards;
        }

        .title span { color: #4ecca3; }

        .subtitle {
            font-size: 14px;
            color: rgba(255, 255, 255, 0.5);
            letter-spacing: 4px;
            text-transform: uppercase;
            opacity: 0;
            animation: fadeUp 0.8s ease 0.9s forwards;
        }

        .loader {
            margin-top: 30px;
            width: 160px;
            height: 3px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 99px;
            overflow: hidden;
            opacity: 0;
            animation: fadeIn 0.5s ease 1.2s forwards;
        }

        .loader-bar {
            height: 100%;
            width: 0;
            background: #4ecca3;
            border-radius: 99px;
            animation: load 2s ease 1.4s forwards;
        }

        @keyframes fadeUp {
            to { opacity: 1; transform: translateY(0); }
        }
        @keyframes fadeIn {
            to { opacity: 1; }
        }
        @keyframes load {
            to { width: 100%; }
        }
        @keyframes bookPop {
            0%   { transform: scale(0) rotate(-20deg); opacity: 0; }
            60%  { transform: scale(1.15) rotate(5deg); opacity: 1; }
            100% { transform: scale(1) rotate(0deg); opacity: 1; }
        }
    </style>
</head>
<body>

    <div class="splash">
        <div class="book-icon">
            <svg viewBox="0 0 80 80" fill="none" xmlns="http://www.w3.org/2000/svg">
                <rect x="10" y="12" width="28" height="56" rx="4" fill="#4ecca3"/>
                <rect x="14" y="12" width="4" height="56" fill="rgba(0,0,0,0.15)"/>
                <rect x="42" y="12" width="28" height="56" rx="4" fill="#6edbb3"/>
                <rect x="42" y="12" width="4" height="56" fill="rgba(0,0,0,0.1)"/>
                <line x1="18" y1="25" x2="34" y2="25" stroke="white" stroke-width="2" stroke-linecap="round" opacity="0.5"/>
                <line x1="18" y1="32" x2="34" y2="32" stroke="white" stroke-width="2" stroke-linecap="round" opacity="0.5"/>
                <line x1="18" y1="39" x2="30" y2="39" stroke="white" stroke-width="2" stroke-linecap="round" opacity="0.5"/>
            </svg>
        </div>
        <div class="title">Perpus<span>YUK</span></div>
        <div class="subtitle">Sistem Perpustakaan Digital</div>
        <div class="loader">
            <div class="loader-bar"></div>
        </div>
    </div>

    <script>
        // Redirect ke login.jsp setelah animasi selesai (3.6 detik)
        setTimeout(function () {
            window.location.href = "login.jsp";
        }, 3600);
    </script>

</body>
</html>