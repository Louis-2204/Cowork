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


@WebServlet(name = "InsertEspace", value = "/admin/insertEspace")
public class InsertEspace extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Récupérer les paramètres du formulaire
        String type = request.getParameter("type");
        String image = request.getParameter("image");
        String nom = request.getParameter("nom");
        int capacite = Integer.parseInt(request.getParameter("capacite"));



        if (type == null || image == null || nom == null || capacite == 0) {
            response.sendRedirect("/cowork/admin/gestion-espaces");
            return;
        }

        Connection connection = null;
        ResultSet resultSet = null;



        try {
            // Récupérer la connexion via le singleton
            connection = DatabaseConnection.getInstance();

            // Préparer la requête SQL
            String sql = "INSERT INTO salles (type_espace, image_url, label, capacite) VALUES (?, ?, ?, ?)";
            PreparedStatement statement = connection.prepareStatement(sql);

            // Remplir les paramètres de la requête avec session user
            statement.setString(1, type);
            statement.setString(2, image);
            statement.setString(3, nom);
            statement.setInt(4, capacite);

            // Exécuter la requête
            statement.executeUpdate();

            // Rediriger vers la page de la question
            response.sendRedirect("/cowork/admin/gestion-espaces");
        } catch (SQLException e) {
            e.printStackTrace();
        }

    }
}