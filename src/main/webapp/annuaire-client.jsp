<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, db.DatabaseConnection" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="cowork.User" %>

<%
    Connection connection = null;
    PreparedStatement preparedStatement = null;
    ResultSet resultSet = null;

    // Récupérer la connexion via le singleton
    connection = DatabaseConnection.getInstance();

    // Initialisation de la requête SQL
    String query = "SELECT * FROM users";

    // Préparer la requête
    preparedStatement = connection.prepareStatement(query);

    // Exécuter la requête
    resultSet = preparedStatement.executeQuery();

    // Créer la liste des utilisateurs
    ArrayList<User> users = new ArrayList<>();

    // Parcourir les résultats et remplir la liste des utilisateurs
    while (resultSet.next()) {
        String nom = resultSet.getString("nom");
        String prenom = resultSet.getString("prenom");
        String email = resultSet.getString("email");
        String password = resultSet.getString("password");
        String entreprise = resultSet.getString("entreprise");
        String secteurActivite = resultSet.getString("secteur_activite");

        users.add(new User(nom, prenom, email, password, entreprise, secteurActivite));
    }
%>

<div class="py-24 sm:py-32 w-full">
    <div class="mx-auto grid max-w-7xl gap-6 px-6 lg:px-8 xl:grid-cols-3">
        <h2 class="text-pretty text-3xl font-semibold tracking-tight text-gray-900 sm:text-4xl mb-4">Annuaire Client</h2>
        <div class="mb-8">
            <input type="text" class="w-full px-4 py-2 border border-gray-300 bg-gray-200 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
                   placeholder="Rechercher un client">
        </div>

        <ul role="list" class="grid gap-x-6 gap-y-6 sm:grid-cols-2 md:grid-cols-3 xl:grid-cols-3 xl:col-span-2">

            <% for (User user : users) {
                // Créer les initiales à partir du nom et du prénom
                String initiales = (user.getNom().substring(0, 1) + user.getPrenom().substring(0, 1)).toUpperCase();
            %>
            <li class="bg-white p-8 rounded-lg shadow-md w-3/4 h-64">
                <div class="flex justify-center items-center mb-4">
                    <div class="w-32 h-32 rounded-full bg-gray-200 text-black flex items-center justify-center font-bold text-4xl">
                        <span><%= initiales %></span>
                    </div>
                </div>
                <div class="text-center">
                    <h3 class="text-lg font-semibold text-gray-900"><%= user.getPrenom() %> <%= user.getNom() %></h3>
                    <p class="text-sm font-medium text-gray-300"><%= user.getEntreprise() %></p>
                </div>
            </li>
            <% } %>

        </ul>
    </div>
</div>
