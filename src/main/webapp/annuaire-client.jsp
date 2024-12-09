<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.ArrayList, cowork.User" %>
<%@ page import="db.DatabaseConnection" %>
<%@ page import="java.util.Objects" %>

<%
    Connection connection = null;
    PreparedStatement preparedStatement = null;
    ResultSet resultSet = null;
    ArrayList<User> users = new ArrayList<>();
    boolean showModal = Objects.equals(request.getParameter("showModal"), "true");
    int selectedUserId = Integer.parseInt(request.getParameter("selectedUserId") != null ? request.getParameter("selectedUserId") : "0");
    try {
        // Récupérer la connexion via le singleton
        connection = DatabaseConnection.getInstance();

        // Préparer la requête SQL
        String query = "SELECT * FROM users";
        preparedStatement = connection.prepareStatement(query);

        // Exécuter la requête
        resultSet = preparedStatement.executeQuery();

        // Parcourir les résultats et remplir la liste des utilisateurs
        while (resultSet.next()) {
            int id = resultSet.getInt("id_user");
            String nom = resultSet.getString("nom");
            String prenom = resultSet.getString("prenom");
            String email = resultSet.getString("email");
            String password = resultSet.getString("password");
            String entreprise = resultSet.getString("entreprise");
            String secteurActivite = resultSet.getString("secteur_activite");

            users.add(new User(id, nom, prenom, email, password, entreprise, secteurActivite));
        }
    } catch (SQLException e) {
        System.out.println("Erreur lors de la récupération des données : " + e.getMessage());
    } finally {
        // Fermeture des ressources
        try {
            if (resultSet != null) resultSet.close();
            if (preparedStatement != null) preparedStatement.close();
            if (connection != null) connection.close();
        } catch (SQLException e) {
            System.out.println("Erreur lors de la fermeture des ressources : " + e.getMessage());
        }
    }
%>

<div class="py-24 sm:py-32 w-full">
    <div class="mx-auto grid max-w-7xl gap-6 px-6 lg:px-8 xl:grid-cols-3">
        <h2 class="text-pretty text-3xl font-semibold tracking-tight text-gray-900 sm:text-4xl mb-4">Annuaire Client</h2>
        <div class="mb-8">
            <!-- Barre de recherche -->
            <input id="searchInput" type="text" class="w-full px-4 py-2 border border-gray-300 bg-gray-200 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
                   placeholder="Rechercher un client">
        </div>

        <div role="list" class="grid gap-x-6 gap-y-6 sm:grid-cols-2 md:grid-cols-3 xl:grid-cols-3 xl:col-span-2" id="userList">
            <% for (User user : users) {
                String initiales = (user.getNom().substring(0, 1) + user.getPrenom().substring(0, 1)).toUpperCase();
            %>
            <a href="${pageContext.request.contextPath}/annuaire-client?showModal=true&selectedUserId=<%= user.getId_user() %>" id="liste<%= user.getId_user() %>" class="bg-white p-8 rounded-lg shadow-md w-3/4 h-64 userItem"
                data-id="<%= user.getId_user() %>"
                data-prenom="<%= user.getPrenom() %>"
                data-nom="<%= user.getNom() %>"
                data-email="<%= user.getEmail() %>"
                data-entreprise="<%= user.getEntreprise() %>"
                data-secteur-activite="<%= user.getSecteur_activte() %>">

                <div class="flex justify-center items-center mb-4">
                    <div class="w-32 h-32 rounded-full bg-gray-200 text-black flex items-center justify-center font-bold text-4xl">
                        <span><%= initiales %></span>
                    </div>
                </div>
                <div class="text-center">
                    <h3 class="text-lg font-semibold text-gray-900 userPrenom"><%= user.getPrenom() %></h3>
                    <p class="text-sm font-medium text-gray-900 userNom"><%= user.getNom() %></p>
                    <p class="text-sm font-medium text-gray-300 userEntreprise"><%= user.getEntreprise() %></p>
                </div>
            </a>
            <% } %>
        </div>

    </div>
</div>

<!-- Modal -->
<% if (showModal) { %>
<div id="userModal" class="fixed top-0 left-0 w-full h-full bg-gray-900 bg-opacity-50 flex justify-center items-center">
    <% if (selectedUserId > 0) { %>
    <div class="bg-white flex flex-col gap-2 p-6 rounded-lg shadow-lg w-1/2">
        <h2 class="text-xl font-bold mb-4" id="modalTitle">Informations de l'utilisateur</h2>
        <input type="hidden" id="userIdHidden">
        <label class="font-semibold" for="modalPrenom">Prénom :</label>
        <p id="modalPrenom"><%= users.get(selectedUserId - 1).getPrenom() %></p>
        <label class="font-semibold" for="modalNom">Nom :</label>
        <p id="modalNom"><%= users.get(selectedUserId - 1).getNom() %></p>
        <label class="font-semibold" for="modalEmail">Email :</label>
        <p id="modalEmail"><%= users.get(selectedUserId - 1).getEmail() %></p>
        <label class="font-semibold" for="modalEntreprise">Entreprise :</label>
        <p id="modalEntreprise"><%= users.get(selectedUserId - 1).getEntreprise() %></p>
        <label class="font-semibold" for="modalSecteurActivite">Secteur d'activité :</label>
        <p id="modalSecteurActivite"><%= users.get(selectedUserId - 1).getSecteur_activte() %></p>
        <a href="${pageContext.request.contextPath}/annuaire-client?showModal=false" id="closeModal" class="mt-4 px-4 py-2 bg-red-500 text-white w-fit rounded-lg">Fermer</a>
    </div>
    <% } %>
</div>
<% } %>
