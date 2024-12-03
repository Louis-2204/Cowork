import db.DatabaseConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;

@WebServlet(name = "SubscribeForfait", value = "/SubscribeForfait")
public class SubscribeForfait extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Récupérer les paramètres du formulaire
        String idForfait = request.getParameter("idForfait");
        String action = request.getParameter("action");
        // TODO: récupérer l'id de l'utilisateur connecté
        int idUserLogged = 1;
        String message = "";

        try{
            // Récupérer la connexion à la base de données
            Connection connection = DatabaseConnection.getInstance();
            PreparedStatement preparedStatement = null;
            ResultSet resultForfait = null;

            if(action.equals("subscribe")){
                // Requête SQL pour souscrire un forfait
                String query = "Insert into users_forfaits (id_forfait, id_user, subscribed_at) values (?, ?, ?)";

                // Préparer la requête
                preparedStatement = connection.prepareStatement(query);
                preparedStatement.setInt(1, Integer.parseInt(idForfait));
                preparedStatement.setInt(2, idUserLogged);
                preparedStatement.setTimestamp(3, new Timestamp(System.currentTimeMillis()));

                // Exécuter la requête
                preparedStatement.executeUpdate();
                message = "Souscription réalisée avec succès";

            }else{
                if(action.equals("unsubscribe")){
                    // Requête SQL pour désabonner un forfait
                    String query = "Delete from users_forfaits where id_forfait = ? and id_user = ?";

                    // Préparer la requête
                    preparedStatement = connection.prepareStatement(query);
                    preparedStatement.setInt(1, Integer.parseInt(idForfait));
                    preparedStatement.setInt(2, idUserLogged);

                    // Exécuter la requête
                    preparedStatement.executeUpdate();
                    message = "Votre souscription à été annulée avec succès";
                }
            }


            // Encoder les paramètres pour les inclure dans l'URL
            String encodedIdForfait = URLEncoder.encode(idForfait, StandardCharsets.UTF_8);
            String encodedMessage = URLEncoder.encode(message, StandardCharsets.UTF_8);

            // Construire l'URL avec les paramètres de recherche
            String redirectUrl = String.format("/cowork/forfait?id=%s&message=%s",
                    encodedIdForfait, encodedMessage);

            // Rediriger vers la page /nos-espaces avec les paramètres
            response.sendRedirect(redirectUrl);
        }catch(Exception e){
            String encodedIdForfait = URLEncoder.encode(idForfait, StandardCharsets.UTF_8);
            String encodedMessage = URLEncoder.encode("Erreur lors de la souscription", StandardCharsets.UTF_8);
            String redirectUrl = String.format("/cowork/forfait?id=%s&message=%s",
                    encodedIdForfait, encodedMessage);
            response.sendRedirect(redirectUrl);
            return;
        }
    }
}