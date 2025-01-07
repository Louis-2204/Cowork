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
        String equipements = request.getParameter("equipements");



        if (type == null || nom == null || capacite == 0) {
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

            // split les equipements sur les virgules
            String[] equipementsArray = equipements.split(",");

            System.out.println(equipementsArray);

            // Préparer la requête SQL
            String sql2 = "SELECT id_salle FROM salles WHERE label = ?";
            PreparedStatement statement2 = connection.prepareStatement(sql2);
            statement2.setString(1, nom);
            resultSet = statement2.executeQuery();
            resultSet.next();
            int id = resultSet.getInt("id_salle");

            // Préparer la requête SQL
            String sql3 = "INSERT INTO equipements (label) VALUES (?)";
            PreparedStatement statement3 = connection.prepareStatement(sql3);
            for (String equipement : equipementsArray) {
                // Remplir les paramètres de la requête avec session user
                statement3.setString(1, equipement);
                // Exécuter la requête
                statement3.executeUpdate();
            }

            // Préparer la requête SQL
            String sql4 = "SELECT id_equipement FROM equipements WHERE label = ?";
            PreparedStatement statement4 = connection.prepareStatement(sql4);

            for (String equipement : equipementsArray) {
                statement4.setString(1, equipement);
                resultSet = statement4.executeQuery();
                resultSet.next();
                int idEquipement = resultSet.getInt("id_equipement");
                // Préparer la requête SQL
                String sql5 = "INSERT INTO salles_equipements (id_salle, id_equipement) VALUES (?, ?)";
                PreparedStatement statement5 = connection.prepareStatement(sql5);
                statement5.setInt(1, id);
                statement5.setInt(2, idEquipement);
                // Exécuter la requête
                statement5.executeUpdate();
            }

            // Rediriger vers la page de la question
            response.sendRedirect("/cowork/admin/gestion-espaces");
        } catch (SQLException e) {
            e.printStackTrace();
        }

    }
}