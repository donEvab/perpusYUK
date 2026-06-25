# PerpusYUK

PerpusYUK adalah aplikasi web manajemen perpustakaan berbasis JSP, Java, Tomcat, dan MySQL. Aplikasi ini mendukung login admin/anggota, manajemen buku, manajemen anggota, peminjaman, notifikasi, dan laporan.

## Fitur

- Login dan registrasi anggota
- Dashboard admin dan anggota
- CRUD data buku
- CRUD data anggota
- Peminjaman dan pengembalian buku
- Notifikasi jatuh tempo dan keterlambatan
- Laporan stok, peminjaman, dan denda

## Akun Demo

Setelah database di-import dari `perpustakaan_db.sql`, gunakan akun berikut:

| Role | Username | Password |
| --- | --- | --- |
| Admin | `admin` | `admin123` |
| Anggota | `roku` | `123` |
| Anggota | `juan` | `123` |

## Struktur Project

```text
.
├── Dockerfile
├── railway.json
├── perpustakaan_db.sql
├── PerpusYUK
│   ├── src/java
│   └── web
└── README.md
```

## Konfigurasi Database

Aplikasi membaca koneksi database dari environment variable. Untuk local development, salin `.env.example` menjadi `.env` lalu isi sesuai MySQL lokal.

Variable yang didukung:

| Variable | Keterangan |
| --- | --- |
| `DB_URL` | JDBC URL langsung, contoh `jdbc:mysql://host:3306/perpustakaan_db` |
| `DATABASE_URL` | URL MySQL format platform, contoh `mysql://user:password@host:3306/perpustakaan_db` |
| `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD` | Konfigurasi manual |
| `MYSQLHOST`, `MYSQLPORT`, `MYSQLDATABASE`, `MYSQLUSER`, `MYSQLPASSWORD` | Format umum Railway MySQL |

Jika tidak ada environment variable, aplikasi memakai fallback lokal:

```text
jdbc:mysql://localhost:3306/perpustakaan_db
user: root
password: kosong
```

## Menjalankan Lokal

1. Buat database MySQL bernama `perpustakaan_db`.
2. Import `perpustakaan_db.sql`.
3. Jalankan project di Tomcat 10.1 atau deploy dengan Docker:

```bash
docker build -t perpusyuk .
docker run --env-file .env -p 8080:8080 perpusyuk
```

Buka `http://localhost:8080`.

## Deploy Online

Cara paling sederhana adalah memakai platform yang mendukung Dockerfile dan MySQL, misalnya Railway.

1. Push repository ini ke GitHub.
2. Buat project baru di Railway dari repository GitHub.
3. Tambahkan service MySQL.
4. Import `perpustakaan_db.sql` ke database MySQL Railway.
5. Hubungkan environment variable MySQL ke service aplikasi. Railway biasanya menyediakan `MYSQLHOST`, `MYSQLPORT`, `MYSQLDATABASE`, `MYSQLUSER`, dan `MYSQLPASSWORD`.
6. Deploy service aplikasi.

Setelah deploy berhasil, URL public dari platform bisa dipakai sebagai link demo online.

## Catatan Keamanan

Project ini disiapkan untuk demo. Password demo masih tersimpan sebagai plain text sesuai struktur awal aplikasi, jadi jangan gunakan akun/password nyata untuk production.
