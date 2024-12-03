<%@ page import="java.sql.Connection" %>
<%@ page import="db.DatabaseConnection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="cowork.Salle" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="cowork.Equipement" %>
<%@ page import="cowork.Forfait" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // Récupérer les paramètres de l'URL
    String salleIdParam = (String) request.getAttribute("forfaitId");

    // Vérifier si l'ID est valide
    if (salleIdParam == null || !salleIdParam.matches("\\d+")) {
        throw new IllegalArgumentException("ID de forfait invalide !");
    }

    int forfaitId = Integer.parseInt(salleIdParam); // Convertir en entier

    // Récupérer la connexion à la base de données
    Connection connection = DatabaseConnection.getInstance();
    PreparedStatement preparedStatement = null;
    ResultSet resultForfait = null;
    ResultSet resultIdsForfaits = null;

    try {
        // Requête SQL pour récupérer les salles
        String query = "SELECT * FROM forfaits WHERE id_forfait = ?";

        // Préparer la requête
        preparedStatement = connection.prepareStatement(query);
        preparedStatement.setInt(1, forfaitId);

        // Exécuter la requête
        resultForfait = preparedStatement.executeQuery();

        // Vérifier si des résultats ont été trouvés
        if (!resultForfait.next()) {
            throw new Exception("Aucun forfait trouvé avec l'ID : " + forfaitId);
        }

        // Récupérer les données de la salle
        int id_salle = resultForfait.getInt("id_forfait");
        String label = resultForfait.getString("label");
        String description = resultForfait.getString("description");
        String type_espace = resultForfait.getString("type_espace");
        String image_url = resultForfait.getString("image_url");
        int prix = resultForfait.getInt("prix");
        String heure_deb = resultForfait.getString("heure_deb");
        String heure_fin = resultForfait.getString("heure_fin");


        // Créer l'objet Forfait
        Forfait forfait = new Forfait( id_salle, label, description, type_espace, image_url, prix, heure_deb, heure_fin);

        // Passer les données à la JSP
        request.setAttribute("selectedForfait", forfait);

        // Récupérer les id de forfaits souscrits par l'utilisateur
        String queryIdsForfaits = "Select distinct id_forfait from users_forfaits where id_user = ?";
        preparedStatement = connection.prepareStatement(queryIdsForfaits);
        // TODO : remplacer par l'id user connecté
        preparedStatement.setInt(1, 1);
        resultIdsForfaits = preparedStatement.executeQuery();

        // Créer la liste des forfaits souscrits
        ArrayList<String> idsForfaits = new ArrayList<>();
        while (resultIdsForfaits.next()) {
            int id_forfait = resultIdsForfaits.getInt("id_forfait");
            idsForfaits.add(Integer.toString(id_forfait));
        }
        request.setAttribute("idsForfaits", idsForfaits);


    } catch (Exception e) {
        e.printStackTrace();
        throw new ServletException("Erreur lors de la récupération des informations du forfait.", e);
    } finally {
        // Libérer les ressources
        if (resultForfait != null) resultForfait.close();
        if (preparedStatement != null) preparedStatement.close();
    }
%>

<%
    Forfait selectedForfait = (Forfait) request.getAttribute("selectedForfait");
    if (selectedForfait == null) {
        throw new IllegalArgumentException("Aucune forfait sélectionnée n'a été trouvée !");
    }

    ArrayList<String> idsForfaits = (ArrayList<String>) request.getAttribute("idsForfaits");
    System.out.println(idsForfaits);
%>


<div class="w-full flex flex-col items-center my-10">
    <%
        String message = (String) request.getParameter("message");
        System.out.println(message);
        if (message != null) {
    %>
    <div class="w-full max-w-[1300px] bg-green-500 text-white text-center p-2 rounded-md mb-4">
        <%= message %>
    </div>
    <%
        }
    %>
    <div class="w-full max-w-[1300px] flex justify-center">
        <div class="w-7/12 flex flex-col gap-4">
            <h1 class="text-2xl font-semibold"><%= selectedForfait.getLabel()%></h1>
            <p class="text-black/70"><%= selectedForfait.getType_espace()%></p>
            <h1 class="text-2xl font-semibold text-cow_secondary "><%= selectedForfait.getPrix()%>€</h1>
            <form class="w-full flex flex-col gap-2" action="${pageContext.request.contextPath}/SubscribeForfait" method="post">
                <input type="hidden" name="idForfait" value="<%= selectedForfait.getId_forfait()%>">
                <input type="hidden" name="action" value="<%= idsForfaits.contains(request.getAttribute("forfaitId")) ? "unsubscribe" : "subscribe" %>">
                <button name='forfait-souscrire' type="submit" class='bg-cow_secondary w-full rounded-sm text-white px-4 py-2 font-semibold '>
                    <%= idsForfaits.contains(request.getAttribute("forfaitId")) ? "Se désabonner" : "Souscrire" %>
                </button>
            </form>
            <h3 class="font-semibold">Description</h3>
            <p><%= selectedForfait.getDescription().replace("\n", "<br>")%></p>
        </div>
        <div class="w-1/12 "></div>
        <div class="w-4/12 flex flex-col">
            <div class="w-full bg-gray-100 rounded-lg overflow-hidden aspect-square">
                <img src="<%= selectedForfait.getImage_url() %>" alt="salle" class="w-full h-full object-cover">
            </div>
        </div>
    </div>
</div>
