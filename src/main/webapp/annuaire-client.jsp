<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.ArrayList, cowork.User" %>
<%@ page import="db.DatabaseConnection" %>

<%
    Connection connection = null;
    PreparedStatement preparedStatement = null;
    ResultSet resultSet = null;
    ArrayList<User> users = new ArrayList<>();

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
        out.println("Erreur lors de la récupération des données : " + e.getMessage());
    } finally {
        // Fermeture des ressources
        try {
            if (resultSet != null) resultSet.close();
            if (preparedStatement != null) preparedStatement.close();
            if (connection != null) connection.close();
        } catch (SQLException e) {
            out.println("Erreur lors de la fermeture des ressources : " + e.getMessage());
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

        <ul role="list" class="grid gap-x-6 gap-y-6 sm:grid-cols-2 md:grid-cols-3 xl:grid-cols-3 xl:col-span-2" id="userList">
            <% for (User user : users) {
                String initiales = (user.getNom().substring(0, 1) + user.getPrenom().substring(0, 1)).toUpperCase();
            %>
            <li id="liste<%= user.getId_user() %>" class="bg-white p-8 rounded-lg shadow-md w-3/4 h-64 userItem"
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
            </li>
            <% } %>
        </ul>

    </div>
</div>

<!-- Modal -->
<div id="userModal" class="hidden fixed top-0 left-0 w-full h-full bg-gray-900 bg-opacity-50 flex justify-center items-center">
    <div class="bg-white p-6 rounded-lg shadow-lg w-1/2">
        <h2 class="text-xl font-bold mb-4" id="modalTitle"></h2>
        <input type="hidden" id="userIdHidden">
        <p id="modalPrenom"></p>
        <p id="modalNom"></p>
        <p id="modalEmail"></p>
        <p id="modalEntreprise"></p>
        <p id="modalSecteurActivite"></p>
        <button id="closeModal" class="mt-4 px-4 py-2 bg-red-500 text-white rounded-lg">Fermer</button>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        const userItems = document.querySelectorAll('.userItem');
        const searchInput = document.getElementById('searchInput');
        const userList = document.getElementById('userList');
        const userModal = document.getElementById('userModal');
        const closeModal = document.getElementById('closeModal');

        // Éléments de la modale
        const modalTitle = document.getElementById('modalTitle');
        const modalPrenom = document.getElementById('modalPrenom');
        const modalNom = document.getElementById('modalNom');
        const modalEmail = document.getElementById('modalEmail');
        const modalEntreprise = document.getElementById('modalEntreprise');
        const modalSecteurActivite = document.getElementById('modalSecteurActivite');
        const userIdHidden = document.getElementById('userIdHidden'); // ID caché

        // Fonction de filtrage des utilisateurs
        function filterUsers() {
            const searchTerm = searchInput.value.toLowerCase();
            userItems.forEach(item => {
                const prenom = item.getAttribute('data-prenom').toLowerCase();
                const nom = item.getAttribute('data-nom').toLowerCase();
                const entreprise = item.getAttribute('data-entreprise').toLowerCase();

                if (prenom.includes(searchTerm) || nom.includes(searchTerm) || entreprise.includes(searchTerm)) {
                    item.style.display = 'block'; // Affiche l'utilisateur
                } else {
                    item.style.display = 'none'; // Cache l'utilisateur
                }
            });
        }

        // Écouteur d'événements pour la barre de recherche
        searchInput.addEventListener('input', filterUsers);

        // Gestion du clic sur un utilisateur
        userItems.forEach(item => {
            item.addEventListener('click', () => {
                const prenom = item.getAttribute('data-prenom');
                const nom = item.getAttribute('data-nom');
                const email = item.getAttribute('data-email');
                const entreprise = item.getAttribute('data-entreprise');
                const secteurActivite = item.getAttribute('data-secteur-activite');
                const userId = item.getAttribute('data-id'); // Récupération de l'ID utilisateur

                // Injection des données dans la modale
                modalTitle.textContent = `Informations de ${prenom} ${nom}`;
                modalPrenom.textContent = `Prénom: ${prenom}`;
                modalNom.textContent = `Nom: ${nom}`;
                modalEmail.textContent = `Email: ${email}`;
                modalEntreprise.textContent = `Entreprise: ${entreprise}`;
                modalSecteurActivite.textContent = `Secteur d'activité: ${secteurActivite}`;

                // Injection de l'ID caché
                userIdHidden.value = userId;

                // Afficher la modale
                userModal.classList.remove('hidden');
            });
        });

        // Gestion de la fermeture de la modale
        closeModal.addEventListener('click', () => {
            userModal.classList.add('hidden');
        });
    });
</script>
