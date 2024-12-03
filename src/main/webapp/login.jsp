<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, db.DatabaseConnection" %>
<%@ page import="cowork.User" %>
<%
    String errorMessage = null;
    User loggedInUser = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try {
            // Récupérer la connexion via le singleton
            connection = DatabaseConnection.getInstance();

            // Récupérer les paramètres du formulaire de connexion
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            // Préparer la requête SQL
            String query = "SELECT * FROM users WHERE email = ? AND password = ?";

            preparedStatement = connection.prepareStatement(query);

            // Associer les paramètres
            preparedStatement.setString(1, email);
            preparedStatement.setString(2, password);

            // Exécuter la requête
            resultSet = preparedStatement.executeQuery();

            // Vérifier si un utilisateur correspondant a été trouvé
            if (resultSet.next()) {

                // Créer une instance de User
                loggedInUser = new User(
                        resultSet.getString("email"),
                        resultSet.getString("password")
                );

                // Stocker l'utilisateur dans la session
                session.setAttribute("loggedInUser", loggedInUser);

                // Redirection vers accueil.jsp
                response.sendRedirect(request.getContextPath() + "/accueil");
                return; // Arrête l'exécution de la page actuelle
            } else {
                // Définit le message d'erreur
                errorMessage = "Identifiant ou mot de passe incorrect.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            errorMessage = "Erreur lors de la connexion : " + e.getMessage();
        } finally {
            // Libérer les ressources
            try {
                if (resultSet != null) resultSet.close();
                if (preparedStatement != null) preparedStatement.close();
                if (connection != null) connection.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
%>

<main class="flex-grow flex items-center justify-center bg-gray-100 min-h-screen w-full">
    <div class="bg-white p-8 rounded-lg shadow-md w-full max-w-md mb-20 my-20">
        <div class="mt-10 sm:mx-auto sm:w-full sm:max-w-md">
            <form class="space-y-6" action="login.jsp" method="POST">
                <div>
                    <div class="mt-2">
                        <input type="email" name="email" id="email" autocomplete="email" required
                               class="block w-full rounded-md bg-gray-200 px-3 py-1.5 text-base text-gray-500 outline outline-1 -outline-offset-1 outline-gray-300 placeholder:text-gray-400 focus:outline-2 focus:-outline-offset-2 focus:outline-indigo-600 sm:text-sm/6"
                               placeholder="Email">
                    </div>
                </div>
                <div>
                    <div class="mt-2">
                        <input type="password" name="password" id="password" autocomplete="password" required
                               class="block w-full rounded-md bg-gray-200 px-3 py-1.5 text-base text-gray-500 outline outline-1 -outline-offset-1 outline-gray-300 placeholder:text-gray-400 focus:outline-2 focus:-outline-offset-2 focus:outline-indigo-600 sm:text-sm/6"
                               placeholder="Mot de passe">
                    </div>
                </div>

                <div class="flex justify-center">
                    <button type="submit" class="bg-orange-400 w-full md:w-auto rounded-sm text-white px-4 py-2 font-semibold">
                        Se connecter
                    </button>
                </div>

                <% if (errorMessage != null) { %>
                <div class="text-red-600 text-center mt-4">
                    <%= errorMessage %>
                </div>
                <% } %>
            </form>

            <p class="mt-10 text-center text-sm/6 text-gray-500">
                Nouveau ?
                <a href="${pageContext.request.contextPath}/inscription"
                   class="font-semibold text-indigo-600 hover:text-indigo-500">
                    Inscrit toi dès maintenant !</a>
            </p>
        </div>
    </div>
</main>
s