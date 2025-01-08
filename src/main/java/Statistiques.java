import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import db.DatabaseConnection;

@WebServlet(name = "Statistiques", value = "/statistics")
public class Statistiques extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("Servlet statistics appelée");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        System.out.println("Dates reçues : " + startDate + " to " + endDate);

        try {
            Connection connection = DatabaseConnection.getInstance();
            Map<String, Object> statistics = new HashMap<>();

            // Récupérer toutes les statistiques
            statistics.put("occupationByHour", getOccupationByHour(connection, startDate, endDate));
            statistics.put("occupationByRoom", getOccupationByRoom(connection, startDate, endDate));
            statistics.put("popularTimeSlots", getPopularTimeSlots(connection, startDate, endDate));

            System.out.println("Données récupérées : " + new Gson().toJson(statistics));

            if (request.getHeader("X-Requested-With") != null) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(new Gson().toJson(statistics));
            } else {
                request.setAttribute("statistics", statistics);
                request.getRequestDispatcher("/WEB-INF/jsp/statistics.jsp").forward(request, response);  // Modifiez le chemin selon votre structure
            }

        } catch (SQLException e) {
            System.out.println("Erreur SQL : " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Database error", e);
        }
    }


    private List<Map<String, Object>> getOccupationByHour(Connection connection, String startDate, String endDate)
            throws SQLException {
        // Cette requête va générer une série de créneaux de 30min et compter les réservations qui les couvrent
        String query =
                "WITH RECURSIVE TimeSeries AS (" +
                        "    SELECT generate_series(" +
                        "        date_trunc('hour', ?::timestamp)," +
                        "        date_trunc('hour', ?::timestamp + interval '23 hours 30 minutes')," +
                        "        interval '30 minutes'" +
                        "    ) AS time_slot" +
                        ")" +
                        "SELECT " +
                        "    EXTRACT(HOUR FROM t.time_slot) as hour," +
                        "    FLOOR(EXTRACT(MINUTE FROM t.time_slot))::integer as minute," +
                        "    COUNT(DISTINCT us.id_user || '_' || us.timestamp_deb) as count " + // Modifié ici
                        "FROM TimeSeries t " +
                        "LEFT JOIN users_salles us ON " +
                        "    t.time_slot >= date_trunc('hour', us.timestamp_deb) AND " +
                        "    t.time_slot < us.timestamp_fin AND " +
                        "    date_trunc('day', us.timestamp_deb) >= date_trunc('day', ?::timestamp) AND " +
                        "    date_trunc('day', us.timestamp_deb) <= date_trunc('day', ?::timestamp) " +
                        "GROUP BY " +
                        "    EXTRACT(HOUR FROM t.time_slot)," +
                        "    FLOOR(EXTRACT(MINUTE FROM t.time_slot)) " +
                        "ORDER BY " +
                        "    hour, minute";

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            // Définir les paramètres 4 fois car la requête utilise ? quatre fois
            stmt.setString(1, startDate);
            stmt.setString(2, endDate);
            stmt.setString(3, startDate);
            stmt.setString(4, endDate);

            System.out.println("Exécution requête occupation par créneau entre " + startDate + " et " + endDate);

            List<Map<String, Object>> results = new ArrayList<>();
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                int hour = rs.getInt("hour");
                int minute = rs.getInt("minute");
                int count = rs.getInt("count");

                // Formatage de l'heure (ex: "8:30" ou "8:00")
                String timeLabel = String.format("%d:%02d", hour, minute);
                System.out.println("Occupation trouvée : " + timeLabel + " - " + count + " réservations");

                row.put("hour", hour);
                row.put("minute", minute);
                row.put("timeLabel", timeLabel);
                row.put("count", count);
                results.add(row);
            }

            return results;
        }
    }

    private List<Map<String, Object>> getOccupationByRoom(Connection connection, String startDate, String endDate)
            throws SQLException {
        String query = "SELECT s.label, COUNT(*) as count " +
                "FROM users_salles us " +
                "JOIN salles s ON us.id_salle = s.id_salle " +
                "WHERE timestamp_deb >= ? AND timestamp_deb <= ? " +
                "GROUP BY s.id_salle, s.label " +
                "ORDER BY count DESC";

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setDate(1, java.sql.Date.valueOf(startDate));
            stmt.setDate(2, java.sql.Date.valueOf(endDate));

            List<Map<String, Object>> results = new ArrayList<>();
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("room", rs.getString("label"));
                row.put("count", rs.getInt("count"));
                results.add(row);
            }

            return results;
        }
    }

    private List<Map<String, Object>> getPopularTimeSlots(Connection connection, String startDate, String endDate)
            throws SQLException {
        String query = "SELECT " +
                "EXTRACT(HOUR FROM timestamp_deb) as start_hour, " +
                "FLOOR(EXTRACT(MINUTE FROM timestamp_deb)/30)*30 as start_minute, " +
                "EXTRACT(HOUR FROM timestamp_fin) as end_hour, " +
                "FLOOR(EXTRACT(MINUTE FROM timestamp_fin)/30)*30 as end_minute, " +
                "COUNT(*) as count " +
                "FROM users_salles " +
                "WHERE timestamp_deb >= ? AND timestamp_deb <= ? " +
                "GROUP BY " +
                "EXTRACT(HOUR FROM timestamp_deb), " +
                "FLOOR(EXTRACT(MINUTE FROM timestamp_deb)/30)*30, " +
                "EXTRACT(HOUR FROM timestamp_fin), " +
                "FLOOR(EXTRACT(MINUTE FROM timestamp_fin)/30)*30 " +
                "ORDER BY count DESC LIMIT 5";

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setDate(1, java.sql.Date.valueOf(startDate));
            stmt.setDate(2, java.sql.Date.valueOf(endDate));

            List<Map<String, Object>> results = new ArrayList<>();
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                int startHour = rs.getInt("start_hour");
                int startMinute = rs.getInt("start_minute");
                int endHour = rs.getInt("end_hour");
                int endMinute = rs.getInt("end_minute");
                int count = rs.getInt("count");

                String startTime = String.format("%d:%02d", startHour, startMinute);
                String endTime = String.format("%d:%02d", endHour, endMinute);

                System.out.println("Créneau trouvé : " + startTime + " - " + endTime + " : " + count + " réservations");

                row.put("startTime", startTime);
                row.put("endTime", endTime);
                row.put("count", count);
                results.add(row);
            }

            return results;
        }
    }
}