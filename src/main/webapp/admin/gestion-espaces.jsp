<%@ page import="cowork.User" %>
<%@ page import="java.sql.*" %>
<%@ page import="cowork.Salle" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="db.DatabaseConnection" %>
<%@ page import="cowork.Equipement" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    User user = (User) session.getAttribute("loggedInUser");
    if (user == null) {
        return;
    }

    Connection connection = null;
    Statement statement = null;
    ResultSet resultSet = null;

    ArrayList<Salle> salles;
    try {
        // Récupérer la connexion via le singleton
        connection = DatabaseConnection.getInstance();

        // Initialisation de la requête SQL pour récupérer les réservations à venir
        String query = "SELECT\n" +
                "    s.id_salle,\n" +
                "    s.label AS salle_label,\n" +
                "    s.type_espace,\n" +
                "    s.capacite,\n" +
                "    s.image_url,\n" +
                "    STRING_AGG(e.label, ', ') AS equipements\n" +
                "FROM salles s\n" +
                "         LEFT JOIN salles_equipements se ON s.id_salle = se.id_salle\n" +
                "         LEFT JOIN equipements e ON se.id_equipement = e.id_equipement\n" +
                "GROUP BY\n" +
                "    s.id_salle,\n" +
                "    s.label,\n" +
                "    s.type_espace,\n" +
                "    s.capacite,\n" +
                "    s.image_url,\n" +
                "    s.description;";

        // Exécuter la requête

        resultSet = connection.createStatement().executeQuery(query);

        // Créer la liste des reservations
        salles = new ArrayList<>();

        // Parcourir les résultats et remplir la liste des reservationsAvenir
        while (resultSet.next()) {
            // Récupérer la chaîne d'équipements
            String equipementsString = resultSet.getString("equipements");

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
            Salle reservation = new Salle(
                    resultSet.getInt("id_salle"),
                    resultSet.getString("salle_label"),
                    resultSet.getString("type_espace"),
                    resultSet.getInt("capacite"),
                    resultSet.getString("image_url"),
                    equipementsList
            );
            salles.add(reservation);
        }
    } catch (SQLException e) {
        throw new RuntimeException(e);
    }
%>
<div class='w-full h-[calc(100vh-256px)] flex flex-col items-center max-w-[1300px]'>
    <div class='w-full h-full p-6 md:p-10'>
        <div class="flex">
            <h1 class='text-3xl font-medium'>Gestion des espaces</h1>
            <button id="ajouterEspace"
                    class="ml-auto bg-[#FF6641] hover:bg-[#d16044] text-white font-semibold py-1 px-3 rounded-md">
                Ajouter
            </button>
        </div>
        <div class="w-full h-full flex flex-col overflow-y-auto py-2 gap-2">
            <% for (Object salle : salles) { %>
            <%
                // Ajout de l'objet "reservation" comme attribut de la requête
                request.setAttribute("salle", salle);
            %>
            <jsp:include page="/components/admin/gestionEspaces/espace.jsp"/>
            <% } %>
        </div>
    </div>
</div>

<jsp:include page="/components/admin/gestionEspaces/ajouterEspaceDialog.jsp"/>