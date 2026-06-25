package db;

import java.net.URI;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

public class DatabaseConnection {
    private static final String DEFAULT_HOST = "localhost";
    private static final String DEFAULT_PORT = "3306";
    private static final String DEFAULT_DATABASE = "perpustakaan_db";
    private static final String DEFAULT_USER = "root";
    private static final String DEFAULT_PASSWORD = "";

    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            DatabaseConfig config = loadConfig();
            return DriverManager.getConnection(config.url, config.properties);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private static DatabaseConfig loadConfig() {
        String jdbcUrl = env("DB_URL", env("JDBC_DATABASE_URL", ""));
        if (!jdbcUrl.isBlank()) {
            Properties properties = new Properties();
            properties.setProperty("user", env("DB_USER", env("JDBC_DATABASE_USERNAME", DEFAULT_USER)));
            properties.setProperty("password", env("DB_PASSWORD", env("JDBC_DATABASE_PASSWORD", DEFAULT_PASSWORD)));
            return new DatabaseConfig(ensureMysqlOptions(jdbcUrl), properties);
        }

        String databaseUrl = env("DATABASE_URL", "");
        if (!databaseUrl.isBlank()) {
            return fromDatabaseUrl(databaseUrl);
        }

        String host = env("MYSQLHOST", env("DB_HOST", DEFAULT_HOST));
        String port = env("MYSQLPORT", env("DB_PORT", DEFAULT_PORT));
        String database = env("MYSQLDATABASE", env("DB_NAME", DEFAULT_DATABASE));
        String user = env("MYSQLUSER", env("DB_USER", DEFAULT_USER));
        String password = env("MYSQLPASSWORD", env("DB_PASSWORD", DEFAULT_PASSWORD));

        Properties properties = new Properties();
        properties.setProperty("user", user);
        properties.setProperty("password", password);

        String url = "jdbc:mysql://" + host + ":" + port + "/" + database;
        return new DatabaseConfig(ensureMysqlOptions(url), properties);
    }

    private static DatabaseConfig fromDatabaseUrl(String databaseUrl) {
        try {
            URI uri = URI.create(databaseUrl);
            String user = DEFAULT_USER;
            String password = DEFAULT_PASSWORD;

            if (uri.getUserInfo() != null) {
                String[] parts = uri.getUserInfo().split(":", 2);
                user = decode(parts[0]);
                if (parts.length > 1) {
                    password = decode(parts[1]);
                }
            }

            String database = uri.getPath() == null ? DEFAULT_DATABASE : uri.getPath().replaceFirst("^/", "");
            String query = uri.getQuery() == null ? "" : "?" + uri.getQuery();
            String port = uri.getPort() > 0 ? ":" + uri.getPort() : "";
            String url = "jdbc:mysql://" + uri.getHost() + port + "/" + database + query;

            Properties properties = new Properties();
            properties.setProperty("user", user);
            properties.setProperty("password", password);

            return new DatabaseConfig(ensureMysqlOptions(url), properties);
        } catch (Exception e) {
            throw new IllegalArgumentException("Format DATABASE_URL tidak valid.", e);
        }
    }

    private static String ensureMysqlOptions(String url) {
        if (url.contains("?")) {
            return url + "&useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
        }
        return url + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    }

    private static String env(String key, String fallback) {
        String value = System.getenv(key);
        return value == null || value.isBlank() ? fallback : value;
    }

    private static String decode(String value) {
        return URLDecoder.decode(value, StandardCharsets.UTF_8);
    }

    private static class DatabaseConfig {
        private final String url;
        private final Properties properties;

        private DatabaseConfig(String url, Properties properties) {
            this.url = url;
            this.properties = properties;
        }
    }
}
