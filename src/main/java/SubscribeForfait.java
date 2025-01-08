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
        int idUserLogged = Integer.parseInt(request.getParameter("userId"));
        String message = "";

        try {
            // Récupérer la connexion à la base de données
            Connection connection = DatabaseConnection.getInstance();
            PreparedStatement preparedStatement = null;
            ResultSet resultForfait = null;

            if(action.equals("subscribe")) {
                // D'abord récupérer les informations du forfait
                String queryForfait = "SELECT label, prix FROM forfaits WHERE id_forfait = ?";
                preparedStatement = connection.prepareStatement(queryForfait);
                preparedStatement.setInt(1, Integer.parseInt(idForfait));
                resultForfait = preparedStatement.executeQuery();

                if(resultForfait.next()) {
                    String libelleForfait = resultForfait.getString("label");
                    double montantForfait = resultForfait.getDouble("prix");

                    // Commencer une transaction
                    connection.setAutoCommit(false);

                    try {
                        // 1. Insérer la souscription
                        String querySubscribe = "INSERT INTO users_forfaits (id_forfait, id_user, subscribed_at) VALUES (?, ?, ?)";
                        preparedStatement = connection.prepareStatement(querySubscribe);
                        preparedStatement.setInt(1, Integer.parseInt(idForfait));
                        preparedStatement.setInt(2, idUserLogged);
                        preparedStatement.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
                        preparedStatement.executeUpdate();

                        // 2. Créer la facture
                        String queryFacture = "INSERT INTO factures (libelle, montant, id_user) VALUES (?, ?, ?)";
                        preparedStatement = connection.prepareStatement(queryFacture);
                        preparedStatement.setString(1, "Souscription - " + libelleForfait);
                        preparedStatement.setDouble(2, montantForfait);
                        preparedStatement.setInt(3, idUserLogged);
                        preparedStatement.executeUpdate();

                        // Valider la transaction
                        connection.commit();
                        message = "Souscription réalisée avec succès";
                    } catch (Exception e) {
                        // En cas d'erreur, annuler la transaction
                        connection.rollback();
                        throw e;
                    } finally {
                        // Rétablir l'auto-commit
                        connection.setAutoCommit(true);
                    }
                } else {
                    throw new Exception("Forfait non trouvé");
                }
            } else if(action.equals("unsubscribe")) {
                // Requête SQL pour désabonner un forfait
                String query = "DELETE FROM users_forfaits WHERE id_forfait = ? AND id_user = ?";
                preparedStatement = connection.prepareStatement(query);
                preparedStatement.setInt(1, Integer.parseInt(idForfait));
                preparedStatement.setInt(2, idUserLogged);
                preparedStatement.executeUpdate();
                message = "Votre souscription a été annulée avec succès";
            }

            // Encoder les paramètres pour les inclure dans l'URL
            String encodedIdForfait = URLEncoder.encode(idForfait, StandardCharsets.UTF_8);
            String encodedMessage = URLEncoder.encode(message, StandardCharsets.UTF_8);

            // Construire l'URL avec les paramètres de recherche
            String redirectUrl = String.format("/cowork/forfait?id=%s&message=%s",
                    encodedIdForfait, encodedMessage);

            // Rediriger vers la page /nos-espaces avec les paramètres
            response.sendRedirect(redirectUrl);
        } catch(Exception e) {
            String encodedIdForfait = URLEncoder.encode(idForfait, StandardCharsets.UTF_8);
            String encodedMessage = URLEncoder.encode("Erreur lors de la souscription", StandardCharsets.UTF_8);
            String redirectUrl = String.format("/cowork/forfait?id=%s&message=%s",
                    encodedIdForfait, encodedMessage);
            response.sendRedirect(redirectUrl);
            return;
        }
    }
}