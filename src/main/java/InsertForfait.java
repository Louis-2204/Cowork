import db.DatabaseConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;


@WebServlet(name = "InsertForfait", value = "/admin/insertForfait")
public class InsertForfait extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // Récupérer les paramètres du formulaire
        String type = request.getParameter("type");
        String image = request.getParameter("image");
        String label = request.getParameter("label");
        String description = request.getParameter("description");
        int prix = Integer.parseInt(request.getParameter("prix"));
        String heure_deb = request.getParameter("heure_deb");
        String heure_fin = request.getParameter("heure_fin");

        // Vérifier et convertir les chaînes de caractères en type Time
        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
        Time timeDeb = null;
        Time timeFin = null;

        try {
            timeDeb = new Time(sdf.parse(heure_deb).getTime());
            timeFin = new Time(sdf.parse(heure_fin).getTime());
        } catch (ParseException e) {
            e.printStackTrace();
            response.sendRedirect("/cowork/admin/gestion-forfaits");
            return;
        }


        if (type == null || image == null || description == null || heure_deb == null || heure_fin == null || label == null) {
            response.sendRedirect("/cowork/admin/gestion-forfaits");
            return;
        }

        Connection connection = null;
        ResultSet resultSet = null;



        try {
            // Récupérer la connexion via le singleton
            connection = DatabaseConnection.getInstance();

            // Préparer la requête SQL
            String sql = "INSERT INTO forfaits (type_espace, image_url, label, description, prix, heure_deb, heure_fin) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement statement = connection.prepareStatement(sql);

            // Remplir les paramètres de la requête avec session user
            statement.setString(1, type);
            statement.setString(2, image);
            statement.setString(3, label);
            statement.setString(4, description);
            statement.setInt(5, prix);
            statement.setTime(6, timeDeb);
            statement.setTime(7, timeFin);

            // Exécuter la requête
            statement.executeUpdate();

            // Rediriger vers la page de la question
            response.sendRedirect("/cowork/admin/gestion-forfaits");
        } catch (SQLException e) {
            e.printStackTrace();
        }

    }
}