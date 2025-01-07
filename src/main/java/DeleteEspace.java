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


@WebServlet(name = "DeleteEspace", value = "/admin/deleteEspace")
public class DeleteEspace extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Récupérer les paramètres du formulaire
        int id_salle = Integer.parseInt(request.getParameter("id_salle"));


        Connection connection = null;
        ResultSet resultSet = null;



        try {
            // Récupérer la connexion via le singleton
            connection = DatabaseConnection.getInstance();


            // Préparer la requête SQL
            String sql1 = "SELECT * FROM salles_equipements WHERE id_salle = ?";
            PreparedStatement statement1 = connection.prepareStatement(sql1);
            statement1.setInt(1, id_salle);

            // Exécuter la requête
            resultSet = statement1.executeQuery();

            // Préparer la requête SQL
            String sql = "DELETE FROM salles WHERE id_salle = ?";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, id_salle);

            // Exécuter la requête
            statement.executeUpdate();



            // préparer la requête SQL
            String sql2 = "DELETE FROM salles_equipements WHERE id_salle = ?";
            PreparedStatement statement2 = connection.prepareStatement(sql2);
            statement2.setInt(1, id_salle);

            // Exécuter la requête
            statement2.executeUpdate();

            while (resultSet.next()) {
                // préparer la requête SQL
                String sql3 = "DELETE FROM equipements WHERE id_equipement = ?";
                PreparedStatement statement3 = connection.prepareStatement(sql3);
                statement3.setInt(1, resultSet.getInt("id_equipement"));

                // Exécuter la requête
                statement3.executeUpdate();
            }

            // Rediriger vers la page de la question
            response.sendRedirect("/cowork/admin/gestion-espaces");
        } catch (SQLException e) {
            e.printStackTrace();
        }

    }
}