<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import=" db.DatabaseConnection" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="cowork.Salle" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="cowork.Equipement" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="cowork.Forfait" %>
<%
    // Récupérer la connexion à la base de données
    Connection connection = DatabaseConnection.getInstance();
    PreparedStatement preparedStatement = null;
    ResultSet resultSalles = null;
    ResultSet resultEquipements = null;
    ResultSet resultTypesEspaces = null;

    // Requête SQL pour récupérer les salles
    String query = "SELECT * FROM forfaits";

    // Préparer la requête
    preparedStatement = connection.prepareStatement(query);

    // Exécuter la requête
    resultSalles = preparedStatement.executeQuery();

    // Créer la liste des salles
    ArrayList<Forfait> forfaits = new ArrayList<>();

    // Parcourir les résultats
    while (resultSalles.next()) {
        int id_forfait = resultSalles.getInt("id_forfait");
        String label = resultSalles.getString("label");
        String description = resultSalles.getString("description");
        String type_espace = resultSalles.getString("type_espace");
        String image_url = resultSalles.getString("image_url");
        int prix = resultSalles.getInt("prix");
        String heure_deb = resultSalles.getString("heure_deb");
        String heure_fin = resultSalles.getString("heure_fin");

        forfaits.add(new Forfait(id_forfait, label, description, type_espace, image_url, prix, heure_deb, heure_fin));
    }
%>

<div class="w-full flex justify-center my-10 px-4 md:px-0">
    <div class="w-full max-w-[1300px] grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-4">

        <% for (Forfait forfait : forfaits) { %>
        <a href="${pageContext.request.contextPath}/forfait?id=<%=forfait.getId_forfait()%>" class="bg-white rounded-md border flex flex-col">
            <img src="<%=forfait.getImage_url()%>" alt="Espace" class="w-full h-40 object-cover rounded-t-md">
            <div class="flex flex-col py-3 px-5 gap-2 w-full">
                <div class="text-sm text-gray-500">
                    <%= forfait.getType_espace() %>
                </div>
                <div class="flex gap-1 text-xl font-semibold">
                    <span><%= forfait.getLabel() %></span>
                </div>
                <div class="flex w-full justify-end">
                    <span class="font-semibold text-cow_secondary"><%= forfait.getPrix() %>€</span>
                </div>
            </div>
        </a>
        <% } %>

    </div>
</div>
