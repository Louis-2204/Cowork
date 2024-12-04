<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, db.DatabaseConnection" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="cowork.Reservation" %>
<%@ page import="cowork.Salle" %>
<%@ page import="cowork.Equipement" %>

<%@ page import="java.util.logging.Logger "%>
<%@ page import="java.util.Arrays" %>
<%! static Logger logger = Logger.getLogger("cowork"); %>

<%
    Connection connection = null;
    Statement statement = null;
    ResultSet resultSetAVenir = null;
    ResultSet resultSetPasse = null;

    // Récupérer la connexion via le singleton
    connection = DatabaseConnection.getInstance();

//    private String id_user;
//    private String id_salle;
//    private Timestamp timestamp_deb;
//    private Timestamp timestamp_fin;
//    private String code;
//    private ArrayList<Equipement> equipements;
//    private Salle salle;

    // Initialisation de la requête SQL pour récupérer les réservations à venir
    String queryReservationsAvenir = "SELECT\n" +
            "    us.id_user,\n" +
            "    us.id_salle,\n" +
            "    us.timestamp_deb,\n" +
            "    us.timestamp_fin,\n" +
            "    us.code,\n" +
            "    s.label AS salle_label,\n" +
            "    s.type_espace,\n" +
            "    s.capacite,\n" +
            "    s.image_url,\n" +
            "    s.description,\n" +
            "    STRING_AGG(e.label, ', ') AS equipements\n" +
            "FROM users_salles us\n" +
            "         JOIN salles s ON us.id_salle = s.id_salle\n" +
            "         LEFT JOIN salles_equipements se ON s.id_salle = se.id_salle\n" +
            "         LEFT JOIN equipements e ON se.id_equipement = e.id_equipement\n" +
            "WHERE us.id_user = 1\n" +
            "AND us.timestamp_fin > (Select now())\n" +
            "GROUP BY\n" +
            "    us.id_user,\n" +
            "    us.id_salle,\n" +
            "    us.timestamp_deb,\n" +
            "    us.timestamp_fin,\n" +
            "    us.code,\n" +
            "    s.label,\n" +
            "    s.type_espace,\n" +
            "    s.capacite,\n" +
            "    s.image_url,\n" +
            "    s.description;";

    // Initialisation de la requête SQL pour récupérer les réservations à venir
    String queryReservationsPasse = "SELECT\n" +
            "    us.id_user,\n" +
            "    us.id_salle,\n" +
            "    us.timestamp_deb,\n" +
            "    us.timestamp_fin,\n" +
            "    us.code,\n" +
            "    s.label AS salle_label,\n" +
            "    s.type_espace,\n" +
            "    s.capacite,\n" +
            "    s.image_url,\n" +
            "    s.description,\n" +
            "    STRING_AGG(e.label, ', ') AS equipements\n" +
            "FROM users_salles us\n" +
            "         JOIN salles s ON us.id_salle = s.id_salle\n" +
            "         LEFT JOIN salles_equipements se ON s.id_salle = se.id_salle\n" +
            "         LEFT JOIN equipements e ON se.id_equipement = e.id_equipement\n" +
            "WHERE us.id_user = 1\n" +
            "AND us.timestamp_fin <= (Select now())\n" +
            "GROUP BY\n" +
            "    us.id_user,\n" +
            "    us.id_salle,\n" +
            "    us.timestamp_deb,\n" +
            "    us.timestamp_fin,\n" +
            "    us.code,\n" +
            "    s.label,\n" +
            "    s.type_espace,\n" +
            "    s.capacite,\n" +
            "    s.image_url,\n" +
            "    s.description;";


    // Exécuter les requêtes
    ArrayList<Reservation> reservationsAvenir;
    ArrayList<Reservation> reservationsPasse;

    try {
        resultSetAVenir = connection.createStatement().executeQuery(queryReservationsAvenir);
        resultSetPasse = connection.createStatement().executeQuery(queryReservationsPasse);

        // Créer la liste des reservations
        reservationsAvenir = new ArrayList<>();
        reservationsPasse = new ArrayList<>();

        // Parcourir les résultats et remplir la liste des reservationsAvenir
        while (resultSetAVenir.next()) {
            // Récupérer la chaîne d'équipements
            String equipementsString = resultSetAVenir.getString("equipements");

            // Si la chaîne est non vide et non null, la diviser en tableau, sinon créer une liste vide
            ArrayList<Equipement> equipementsList = new ArrayList<>();
            if (equipementsString != null && !equipementsString.trim().isEmpty()) {
                // Diviser la chaîne d'équipements en un tableau
                String[] equipementsArray = equipementsString.split(", ");

                // Créer une liste d'objets Equipement
                for (String equipementLabel : equipementsArray) {
                    equipementsList.add(new Equipement(equipementLabel));  // Créer un objet Equipement pour chaque label
                }
            }

            // Créer la réservation avec les équipements
            Reservation reservation = new Reservation(
                    resultSetAVenir.getString("id_user"),
                    resultSetAVenir.getString("id_salle"),
                    resultSetAVenir.getTimestamp("timestamp_deb"),
                    resultSetAVenir.getTimestamp("timestamp_fin"),
                    resultSetAVenir.getString("code"),
                    equipementsList,  // Utilisation de la liste d'équipements, vide si aucun équipement
                    new Salle(
                            resultSetAVenir.getInt("id_salle"),
                            resultSetAVenir.getString("salle_label"),
                            resultSetAVenir.getString("type_espace"),
                            resultSetAVenir.getInt("capacite"),
                            resultSetAVenir.getString("image_url")
                    )
            );
            reservationsAvenir.add(reservation);
        }



        // Parcourir les résultats et remplir la liste des reservationsPasse
        while (resultSetPasse.next()) {
            // Récupérer la chaîne d'équipements
            String equipementsString = resultSetPasse.getString("equipements");

            // Si la chaîne est non vide et non null, la diviser en tableau, sinon créer une liste vide
            ArrayList<Equipement> equipementsList = new ArrayList<>();
            if (equipementsString != null && !equipementsString.trim().isEmpty()) {
                // Diviser la chaîne d'équipements en un tableau
                String[] equipementsArray = equipementsString.split(", ");

                // Créer une liste d'objets Equipement
                for (String equipementLabel : equipementsArray) {
                    equipementsList.add(new Equipement(equipementLabel));  // Créer un objet Equipement pour chaque label
                }
            }

            // Créer la réservation avec les équipements
            Reservation reservation = new Reservation(
                    resultSetPasse.getString("id_user"),
                    resultSetPasse.getString("id_salle"),
                    resultSetPasse.getTimestamp("timestamp_deb"),
                    resultSetPasse.getTimestamp("timestamp_fin"),
                    resultSetPasse.getString("code"),
                    equipementsList,  // Utilisation de la liste d'équipements, vide si aucun équipement
                    new Salle(
                            resultSetPasse.getInt("id_salle"),
                            resultSetPasse.getString("salle_label"),
                            resultSetPasse.getString("type_espace"),
                            resultSetPasse.getInt("capacite"),
                            resultSetPasse.getString("image_url")
                    )
            );
            reservationsPasse.add(reservation);
        }

    } catch (SQLException e) {
        throw new RuntimeException(e);
    }
%>
<div class='w-full min-h-[calc(100vh-256px)] flex flex-col items-center max-w-[1300px]'>
    <div class='w-full h-full p-6 md:p-10 flex flex-col gap-4 overflow-y-auto'>
        <div class="flex flex-col">
            <div class="flex">
                <h1 class='text-3xl font-medium'>A venir</h1>
            </div>
            <div class="w-full h-full flex flex-col overflow-y-auto py-2 gap-2">
                <%-- Si aucune réservation à venir, afficher un message --%>
                <% if (reservationsAvenir.isEmpty()) { %>
                    <div class="text-center text-gray-500">Aucune réservation à venir</div>
                <% } %>
                <%-- Inclure dynamiquement les composants de post --%>
                <% for (Object reservation : reservationsAvenir) { %>
                <%
                    // Ajout de l'objet "reservation" comme attribut de la requête
                    request.setAttribute("reservation", reservation);
                %>
                <jsp:include page="/components/mesReservations/espace.jsp">
                    <jsp:param name="typeResa" value="avenir" />
                </jsp:include>
                <% } %>
            </div>
        </div>
        <div class="flex flex-col">
            <div class="flex">
                <h1 class='text-3xl font-medium'>Passées</h1>
            </div>
            <div class="w-full h-full flex flex-col overflow-y-auto py-2 gap-2">
                <%-- Si aucune réservation passe, afficher un message --%>
                <% if (reservationsPasse.isEmpty()) { %>
                <div class="text-center text-gray-500">Aucune réservation passée</div>
                <% } %>
                <%-- Inclure dynamiquement les composants de post --%>
                <% for (Object reservation : reservationsPasse) { %><%
                    // Ajout de l'objet "reservation" comme attribut de la requête
                    request.setAttribute("reservation", reservation);%>
                    <jsp:include page="/components/mesReservations/espace.jsp">
                    <jsp:param name="typeResa" value="passe" />
                </jsp:include><% } %>
            </div>
        </div>
    </div>
</div>