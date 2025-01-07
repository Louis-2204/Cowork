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


@WebServlet(name = "UpdateEspace", value = "/admin/updateEspace")
public class UpdateEspace extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Récupérer les paramètres du formulaire
        int id_salle = Integer.parseInt(request.getParameter("id_salle"));
        String type = request.getParameter("type");
        String image = request.getParameter("image");
        String nom = request.getParameter("nom");
        int capacite = Integer.parseInt(request.getParameter("capacite"));
        String equipements = request.getParameter("equipements");



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
            String sql = "UPDATE salles SET type_espace = ?, image_url = ?, label = ?, capacite = ? WHERE id_salle = ?";
            PreparedStatement statement = connection.prepareStatement(sql);

            // Remplir les paramètres de la requête avec session user
            statement.setString(1, type);
            statement.setString(2, image);
            statement.setString(3, nom);
            statement.setInt(4, capacite);
            statement.setInt(5, id_salle);

            // Exécuter la requête
            statement.executeUpdate();

            // split les equipements sur les virgules
            String[] equipementsArray = equipements.split(",");

            // Préparer la requête SQL
            String sql3 = "DELETE FROM salles_equipements WHERE id_salle = ?";
            PreparedStatement statement3 = connection.prepareStatement(sql3);
            statement3.setInt(1, id_salle);
            statement3.executeUpdate();

            // Préparer la requête SQL
            String sql4 = "INSERT INTO equipements (label) VALUES (?)";
            PreparedStatement statement4 = connection.prepareStatement(sql4);
            for (String equipement : equipementsArray) {
                // Remplir les paramètres de la requête avec session user
                statement4.setString(1, equipement);
                // Exécuter la requête
                statement4.executeUpdate();
            }

            // Préparer la requête SQL
            String sql5 = "SELECT id_equipement FROM equipements WHERE label = ?";
            PreparedStatement statement5 = connection.prepareStatement(sql5);

            for (String equipement : equipementsArray) {
                statement5.setString(1, equipement);
                resultSet = statement5.executeQuery();
                resultSet.next();
                int id_equipement = resultSet.getInt("id_equipement");

                // Préparer la requête SQL
                String sql6 = "INSERT INTO salles_equipements (id_salle, id_equipement) VALUES (?, ?)";
                PreparedStatement statement6 = connection.prepareStatement(sql6);
                statement6.setInt(1, id_salle);
                statement6.setInt(2, id_equipement);
                statement6.executeUpdate();
            }

            // Rediriger vers la page de la question
            response.sendRedirect("/cowork/admin/gestion-espaces");
        } catch (SQLException e) {
            e.printStackTrace();
        }

    }
}