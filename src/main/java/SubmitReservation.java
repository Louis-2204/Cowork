import db.DatabaseConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet(name = "SubmitReservation", value = "/SubmitReservation")
public class SubmitReservation extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //get the salleId from the form
        String salleId = request.getParameter("salleId");
        System.out.println(salleId);
        //get the userId from the form
        String userId = request.getParameter("userId");
        System.out.println(userId);
        //get the timestampDeb from the form
        String timestampDeb = request.getParameter("timestampDeb");
        System.out.println(timestampDeb);
        //get the timestampFin from the form
        String timestampFin = request.getParameter("timestampFin");
        System.out.println(timestampFin);

        ResultSet resultUsersSallesInsert = null;
        PreparedStatement preparedStatement = null;
        try{
            // Récupérer la connexion à la base de données
            Connection connection = DatabaseConnection.getInstance();

            // generate a 6 random characters string, it can be letters and numbers, Ex : 6A4VE5
            String randomString = java.util.UUID.randomUUID().toString().substring(0, 6);

            // Requête SQL pour insérer les données dans la table users_salles
            String query = "INSERT INTO users_salles (id_user, id_salle, timestamp_deb, timestamp_fin, code) VALUES (?, ?, CAST(? AS TIMESTAMP), CAST(? AS TIMESTAMP), ?)";
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setInt(1, Integer.parseInt(userId));
            preparedStatement.setInt(2, Integer.parseInt(salleId));
            preparedStatement.setString(3, timestampDeb);
            preparedStatement.setString(4, timestampFin);
            preparedStatement.setString(5, randomString);

            // Exécuter la requête
            preparedStatement.executeUpdate();

            response.sendRedirect("/cowork/salle?id=" + salleId + "&message=reservation+effectu%C3%A9e");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("/cowork/salle?id=" + salleId + "&message=erreur+lors+de+la+r%C3%A9servation");
            System.out.println(e);
        } finally {
            // Libérer les ressources
            if (resultUsersSallesInsert != null) {
                try {
                    resultUsersSallesInsert.close();
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
            }
            if (preparedStatement != null) {
                try {
                    preparedStatement.close();
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
            }
        }
    }
}