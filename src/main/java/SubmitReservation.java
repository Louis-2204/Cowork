import cowork.User;
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
        User user = (User) request.getSession().getAttribute("loggedInUser");

        if(user == null) {
            response.sendRedirect("/cowork/accueil");
            return;
        }


        //get the salleId from the form
        String salleId = request.getParameter("salleId");
        System.out.println(salleId);
        //get the timestampDeb from the form
        String timestampDeb = request.getParameter("timestampDeb");
        System.out.println(timestampDeb);
        //get the timestampFin from the form
        String timestampFin = request.getParameter("timestampFin");
        System.out.println(timestampFin);

        if(user.getCredits() < 5){
            response.sendRedirect("/cowork/salle?id=" + salleId + "&message=vous n'avez pas assez de credits pour réserver cette salle.");
        }

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
            preparedStatement.setInt(1, user.getId_user());
            preparedStatement.setInt(2, Integer.parseInt(salleId));
            preparedStatement.setString(3, timestampDeb);
            preparedStatement.setString(4, timestampFin);
            preparedStatement.setString(5, randomString);

            // Exécuter la requête
            preparedStatement.executeUpdate();

            String query2 = "INSERT INTO transactions (montant,is_positive,id_user) values (?,false,?)";
            PreparedStatement statement2 = connection.prepareStatement(query2);
            statement2.setInt(1, 5);
            statement2.setInt(2, user.getId_user());
            statement2.executeUpdate();

            String query3 = "UPDATE users set credits = credits - ? WHERE id_user = ?";
            PreparedStatement statement3 = connection.prepareStatement(query3);
            statement3.setInt(1, 5);
            statement3.setInt(2, user.getId_user());
            statement3.executeUpdate();

            String query4 = "Insert into notifications (id_user, message, is_read) values (?, ?, false)";
            PreparedStatement statement4 = connection.prepareStatement(query4);
            statement4.setInt(1, user.getId_user());
            statement4.setString(2, "Votre réservation de la salle " + salleId + " a été effectuée avec succès. Votre code de réservation est : " + randomString);
            statement4.executeUpdate();

            String query5 = "DELETE FROM notifications WHERE is_read = TRUE AND notification_date < NOW() - INTERVAL '1 month'";
            PreparedStatement statement5 = connection.prepareStatement(query5);
            statement5.executeUpdate();

            //update session
            User newUser = new User(
                    user.getEmail(),
                    user.getId_user(),
                    user.getIs_admin(),
                    user.getCredits() - 5
            );
            request.getSession().setAttribute("loggedInUser", newUser);

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