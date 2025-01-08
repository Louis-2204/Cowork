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


@WebServlet(name = "BuyCredits", value = "/BuyCredits")
public class BuyCredits extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Récupérer les paramètres du formulaire
        int new_credits = Integer.parseInt(request.getParameter("new_credits"));
        User user = (User) request.getSession().getAttribute("loggedInUser");

        if (new_credits == 0 || new_credits < 0 || user == null) {
            response.sendRedirect("/cowork/credits?error=true&message=Une erreur est survenue lors de l'achat des crédits");
            return;
        }

        Connection connection = null;
        ResultSet resultSet = null;


        try {
            // Récupérer la connexion via le singleton
            connection = DatabaseConnection.getInstance();

            System.out.println(new_credits);

            // Préparer la requête SQL
            String sql = "UPDATE users SET credits = credits + ? WHERE id_user = ?";
            PreparedStatement statement = connection.prepareStatement(sql);

            // Remplir les paramètres de la requête
            statement.setInt(1, new_credits);
            statement.setInt(2, user.getId_user());

            // Exécuter la requête
            statement.executeUpdate();

            String sql2 = "INSERT INTO transactions (montant,is_positive,id_user) values (?,true,?)";
            PreparedStatement statement2 = connection.prepareStatement(sql2);
            statement2.setInt(1, new_credits);
            statement2.setInt(2, user.getId_user());
            statement2.executeUpdate();

            //update session
            User newUser = new User(
                    user.getEmail(),
                    user.getId_user(),
                    user.getIs_admin(),
                    user.getCredits() + new_credits
            );
            request.getSession().setAttribute("loggedInUser", newUser);

            // Rediriger vers la page de la question
            response.sendRedirect("/cowork/credits?success=true&message=Achat réussi avec succès");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("/cowork/credits?error=true&message=Une erreur est survenue lors de l'achat des crédits");
            return;
        }

    }
}