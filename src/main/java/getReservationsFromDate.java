import com.google.gson.Gson;
import db.DatabaseConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "getReservationsFromDate", value = "/getReservationsFromDate")
public class getReservationsFromDate extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String date = request.getParameter("date");
        System.out.println(date);
        if (date == null || date.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "La date est requise.");
            return;
        }

        ArrayList<Map<String, Timestamp>> timeRanges = new ArrayList<>();
        ResultSet resultReservations = null;
        PreparedStatement preparedStatement = null;

        try {
            // Connexion à la base de données
            Connection connection = DatabaseConnection.getInstance();

            // Requête SQL
            String query = "SELECT * FROM users_salles WHERE DATE(timestamp_deb) = DATE(?)";
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, date);

            // Exécution de la requête
            resultReservations = preparedStatement.executeQuery();

            // Construction des résultats
            while (resultReservations.next()) {
                Map<String, Timestamp> timeRange = new HashMap<>();
                timeRange.put("timestampDeb", resultReservations.getTimestamp("timestamp_deb"));
                timeRange.put("timestampFin", resultReservations.getTimestamp("timestamp_fin"));
                timeRanges.add(timeRange);
            }

            // Conversion en JSON
            String reservationsDatesToJson = new Gson().toJson(timeRanges);

            // Réponse HTTP
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(reservationsDatesToJson);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erreur lors de la récupération des réservations.");
        } finally {
            // Libération des ressources
            if (resultReservations != null) {
                try {
                    resultReservations.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (preparedStatement != null) {
                try {
                    preparedStatement.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
