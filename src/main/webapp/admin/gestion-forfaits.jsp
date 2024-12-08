<%@ page import="java.sql.*" %>
<%@ page import="cowork.Salle" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="db.DatabaseConnection" %>
<%@ page import="cowork.Forfait" %>
<%@ page import="cowork.User" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    User user = (User) session.getAttribute("loggedInUser");
    if (user == null) {
        return;
    }

    Connection connection = null;
    Statement statement = null;
    ResultSet resultSet = null;

    ArrayList<Forfait> forfaits;
    try {
        // Récupérer la connexion via le singleton
        connection = DatabaseConnection.getInstance();

        // Initialisation de la requête SQL pour récupérer les réservations à venir
        String query = "SELECT\n" +
                "id_forfait,\n" +
                "label,\n" +
                "description,\n" +
                "heure_deb,\n" +
                "heure_fin,\n" +
                "type_espace,\n" +
                "image_url,\n" +
                "prix\n" +
                "FROM forfaits" +
                " ORDER BY id_forfait DESC";


        // Exécuter la requête

        resultSet = connection.createStatement().executeQuery(query);

        // Créer la liste des reservations
        forfaits = new ArrayList<>();

        // Parcourir les résultats et remplir la liste des reservationsAvenir
        while (resultSet.next()) {
            // Créer la réservation avec les équipements
            Forfait forfait = new Forfait(
                    resultSet.getInt("id_forfait"),
                    resultSet.getString("label"),
                    resultSet.getString("description"),
                    resultSet.getString("type_espace"),
                    resultSet.getString("image_url"),
                    resultSet.getInt("prix"),
                    resultSet.getString("heure_deb"),
                    resultSet.getString("heure_fin")
            );
            forfaits.add(forfait);
        }
    } catch (SQLException e) {
        throw new RuntimeException(e);
    }
%>
<div class='w-full h-[calc(100vh-256px)] flex flex-col items-center max-w-[1300px]'>
    <div class='w-full h-full p-6 md:p-10'>
        <div class="flex">
            <h1 class='text-3xl font-medium'>Gestion des forfaits</h1>
            <button id="ajouterForfait" class="ml-auto bg-[#FF6641] hover:bg-[#d16044] text-white font-semibold py-1 px-3 rounded-md">
                Ajouter
            </button>
        </div>
        <div class="w-full h-full flex flex-col overflow-y-auto py-2 gap-2">
            <% for (Object forfait : forfaits) { %>
            <%
                // Ajout de l'objet "reservation" comme attribut de la requête
                request.setAttribute("forfait", forfait);
            %>
            <jsp:include page="/components/admin/gestionForfaits/espace.jsp"/>
            <% } %>
        </div>
    </div>
</div>

<jsp:include page="/components/admin/gestionForfaits/ajouterForfaitDialog.jsp" />