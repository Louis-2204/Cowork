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


@WebServlet(name = "Post", value = "/Post")
public class Post extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Récupérer les paramètres du formulaire
        String content = request.getParameter("content");
        User user = (User) request.getSession().getAttribute("loggedInUser");


        if (content == null || content.isEmpty() || user == null) {
            response.sendRedirect("/cowork/forum");
            return;
        }

        Connection connection = null;
        ResultSet resultSet = null;



        try {
            // Récupérer la connexion via le singleton
            connection = DatabaseConnection.getInstance();

            // Préparer la requête SQL
            String sql = "INSERT INTO posts (id_parent, content, id_user,created_at) VALUES (Null, ?, ?, NOW())";
            PreparedStatement statement = connection.prepareStatement(sql);

            // Remplir les paramètres de la requête avec session user
            statement.setString(1, content);
            statement.setInt(2, user.getId_user());

            // Exécuter la requête
            statement.executeUpdate();

            // Rediriger vers la page de la question
            response.sendRedirect("/cowork/forum");
        } catch (SQLException e) {
            e.printStackTrace();
        }

    }
}