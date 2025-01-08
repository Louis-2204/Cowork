import cowork.User;
import db.DatabaseConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet(name = "GetUnreadCount", value = "/getUnreadCount")
public class UnreadCount extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Récupérer l'utilisateur connecté depuis la session
        User user = (User) request.getSession().getAttribute("loggedInUser");

        if (user == null) {
            // Si l'utilisateur n'est pas connecté, renvoyer une erreur ou une valeur par défaut
            response.setContentType("application/json");
            response.getWriter().write("{\"count\": 0}");
            return;
        }

        int unreadCount = 0;

        try (Connection connection = DatabaseConnection.getInstance()) {
            // Requête SQL pour obtenir le nombre de notifications non lues
            String sql = "SELECT COUNT(*) AS unread_count FROM notifications WHERE id_user = ? AND is_read = FALSE";

            // Préparer la requête
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setInt(1, user.getId_user());

                // Exécuter la requête
                try (ResultSet resultSet = statement.executeQuery()) {
                    if (resultSet.next()) {
                        unreadCount = resultSet.getInt("unread_count");
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            // En cas d'erreur avec la base de données, vous pouvez aussi retourner un count de 0 ou loguer l'erreur
        }

        // Renvoyer la réponse sous forme JSON
        response.setContentType("application/json");
        response.getWriter().write("{\"count\": " + unreadCount + "}");
    }
}
