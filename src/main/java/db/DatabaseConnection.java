package db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import io.github.cdimascio.dotenv.Dotenv;

public class DatabaseConnection {
    private static Connection connection = null;
    private static final Dotenv dotenv = Dotenv.configure()
            .load();

    private DatabaseConnection() {}

    public static Connection getInstance() throws SQLException {
        if (connection == null || connection.isClosed()) {
            synchronized (DatabaseConnection.class) {
                if (connection == null || connection.isClosed()) {
                    try {
                        // Charger le pilote PostgreSQL
                        Class.forName("org.postgresql.Driver");
                    } catch (ClassNotFoundException e) {
                        throw new RuntimeException("Pilote JDBC PostgreSQL introuvable.", e);
                    }

                    // Lire les variables d'environnement
                    String url = dotenv.get("DB_URL");
                    String user = dotenv.get("DB_USER");
                    String password = dotenv.get("DB_PASSWORD");

                    if (url == null || user == null || password == null) {
                        throw new IllegalArgumentException("Les informations de connexion sont manquantes dans le fichier .env");
                    }

                    // Établir la connexion
                    connection = DriverManager.getConnection(url, user, password);
                }
            }
        }
        return connection;
    }

    public static void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}