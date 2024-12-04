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

        if (id_parent == null || content == null || id_parent.isEmpty() || content.isEmpty()) {
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
            statement.setInt(3, 1);

            // Exécuter la requête
            statement.executeUpdate();

            // Rediriger vers la page de la question
            response.sendRedirect("/cowork/forum?id_post=" + id_parent);
        } catch (SQLException e) {
            e.printStackTrace();
        }

    }
}