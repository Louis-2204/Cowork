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


@WebServlet(name = "NotificationRead", value = "/NotificationRead")
public class NotificationRead extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Récupérer les paramètres du formulaire
        int id_notification = Integer.parseInt(request.getParameter("id_notification"));
        User user = (User) request.getSession().getAttribute("loggedInUser");

        if (user == null) {
            response.sendRedirect("/accueil");
            return;
        }

        Connection connection = null;
        ResultSet resultSet = null;


        try {
            // Récupérer la connexion via le singleton
            connection = DatabaseConnection.getInstance();

            // Préparer la requête SQL
            String sql = "UPDATE notifications SET is_read = true WHERE id_notification = ?";
            PreparedStatement statement = connection.prepareStatement(sql);

            // Remplir les paramètres de la requête
            statement.setInt(1, id_notification);

            // Exécuter la requête
            statement.executeUpdate();

            // Rediriger vers la page de la question
            response.sendRedirect("/cowork/notifications");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("/accueil");
            return;
        }

    }
}