import cowork.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import db.DatabaseConnection;


@WebServlet(name = "PostAnswer", value = "/PostAnswer")
public class PostAnswer extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Récupérer les paramètres du formulaire
        String id_parent = request.getParameter("id_parent");
        String content = request.getParameter("content");
        User user = (User) request.getSession().getAttribute("loggedInUser");

        if (id_parent == null || content == null || id_parent.isEmpty() || content.isEmpty() || user == null) {
            response.sendRedirect("/cowork/forum");
            return;
        }

        Connection connection = null;
        ResultSet resultSet = null;


        try {
            // Récupérer la connexion via le singleton
            connection = DatabaseConnection.getInstance();

            // Préparer la requête SQL
            String sql = "INSERT INTO posts (id_parent, content, id_user,created_at) VALUES (?, ?, ?, NOW())";
            PreparedStatement statement = connection.prepareStatement(sql);

            // Remplir les paramètres de la requête
            statement.setInt(1, Integer.parseInt(id_parent));
            statement.setString(2, content);
            statement.setInt(3, user.getId_user());

            // Exécuter la requête
            statement.executeUpdate();

            String query4 = "Insert into notifications (id_user, message, is_read) values ((Select id_user from posts where id_post = ?), ?, false)";
            PreparedStatement statement4 = connection.prepareStatement(query4);
            statement4.setInt(1, Integer.parseInt(id_parent));
            statement4.setString(2, "Vous avez reçu une réponse à votre post");
            statement4.executeUpdate();

            String query5 = "DELETE FROM notifications WHERE is_read = TRUE AND notification_date < NOW() - INTERVAL '1 month'";
            PreparedStatement statement5 = connection.prepareStatement(query5);
            statement5.executeUpdate();

            // Rediriger vers la page de la question
            response.sendRedirect("/cowork/forum?id_post=" + id_parent);
        } catch (SQLException e) {
            e.printStackTrace();
        }

    }
}