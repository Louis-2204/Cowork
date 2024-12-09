<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, db.DatabaseConnection" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="cowork.Post" %>
<%@ page import="cowork.User" %>
<%@ page import="java.util.logging.Logger" %>

<%

    Logger logger = Logger.getLogger("cowork");

    // Get URL parameters
    String id_post = request.getParameter("id_post");

    Connection connection = null;
    Statement statement = null;
    ResultSet resultSet = null;


    // Exécuter la requête
    ArrayList<Post> posts;

    if (id_post == null) {
        // Initialisation de la requête SQL de base
        String queryMainPosts = "SELECT * FROM posts p JOIN users u ON p.id_user = u.id_user WHERE p.id_parent IS NULL ORDER BY p.created_at DESC";


        try {

            // Récupérer la connexion via le singleton
            connection = DatabaseConnection.getInstance();

            resultSet = connection.createStatement().executeQuery(queryMainPosts);

            // Créer la liste des posts
            posts = new ArrayList<>();

            // Parcourir les résultats et remplir la liste des posts
            while (resultSet.next()) {
                Post post = new Post(
                        resultSet.getInt("id_post"),
                        resultSet.getString("content"),
                        resultSet.getString("created_at"),
                        resultSet.getString("id_parent"),
                        resultSet.getString("id_user"),
                        new User(
                                resultSet.getInt("id_user"),
                                resultSet.getString("nom"),
                                resultSet.getString("prenom"),
                                resultSet.getString("email"),
                                resultSet.getString("password"),
                                resultSet.getString("entreprise"),
                                resultSet.getString("secteur_activite")
                        )
                );
                posts.add(post);
            }


        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    } else {
        try {

            // Récupérer la connexion via le singleton
            connection = DatabaseConnection.getInstance();

            // Initialisation de la requête SQL de base
            String queryMainPost = "SELECT * FROM posts p JOIN users u ON p.id_user = u.id_user WHERE p.id_post = ?";
            PreparedStatement preparedStatement1 = connection.prepareStatement(queryMainPost);
            preparedStatement1.setInt(1, Integer.parseInt(id_post));

            // Exécuter la requête
            resultSet = preparedStatement1.executeQuery();

            // Créer la liste des posts
            posts = new ArrayList<>();

            // Parcourir les résultats et remplir la liste des posts
            while (resultSet.next()) {
                Post post = new Post(
                        resultSet.getInt("id_post"),
                        resultSet.getString("content"),
                        resultSet.getString("created_at"),
                        resultSet.getString("id_parent"),
                        resultSet.getString("id_user"),
                        new User(
                                resultSet.getInt("id_user"),
                                resultSet.getString("nom"),
                                resultSet.getString("prenom"),
                                resultSet.getString("email"),
                                resultSet.getString("password"),
                                resultSet.getString("entreprise"),
                                resultSet.getString("secteur_activite")
                        )
                );
                posts.add(post);
            }

            // Ajouter les réponses à chaque post
            for (Post post : posts) {

                // Initialisation de la requête SQL pour les réponses
                String queryAnswers = "SELECT * FROM posts p JOIN users u ON p.id_user = u.id_user WHERE p.id_parent = ? ORDER BY p.created_at desc";
                PreparedStatement preparedStatement2 = connection.prepareStatement(queryAnswers);
                preparedStatement2.setInt(1, Integer.parseInt(id_post));

                PreparedStatement preparedStatement = connection.prepareStatement(queryAnswers);
                preparedStatement.setInt(1, post.getId_post());
                ResultSet resultSetAnswers = preparedStatement2.executeQuery();
                ArrayList<Post> answers = new ArrayList<>();
                while (resultSetAnswers.next()) {
                    Post answer = new Post(
                            resultSetAnswers.getInt("id_post"),
                            resultSetAnswers.getString("content"),
                            resultSetAnswers.getString("created_at"),
                            resultSetAnswers.getString("id_parent"),
                            resultSetAnswers.getString("id_user"),
                            new User(
                                    resultSetAnswers.getInt("id_user"),
                                    resultSetAnswers.getString("nom"),
                                    resultSetAnswers.getString("prenom"),
                                    resultSetAnswers.getString("email"),
                                    resultSetAnswers.getString("password"),
                                    resultSetAnswers.getString("entreprise"),
                                    resultSetAnswers.getString("secteur_activite")
                            )
                    );
                    answers.add(answer);
                }
                post.setAnswers(answers);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
%>


<% if (id_post == null) { %>
<div class='w-full min-h-[calc(100vh-256px)] flex flex-col items-center max-w-[1300px]'>
    <div class='w-full h-full p-6 md:p-10'>
        <h1 class='text-3xl font-medium'>Le forum Cowork</h1>
        <div class="w-full flex gap-1 py-4">
            <form action="${pageContext.request.contextPath}/Post" method="POST" class="w-full flex gap-1">
                <input type="hidden" name="id_parent" value="">
                <input type="text" name="content" class="w-full border rounded-sm p-1" placeholder="Écrire un post...">
                <button type="submit"
                        class="border border-orange-400 hover:bg-orange-400 hover:text-white rounded-sm py-1 px-3 transition-all duration-150">
                    Envoyer
                </button>
            </form>
        </div>
        <div class="w-full h-full flex flex-col overflow-y-auto py-2 gap-2">
            <%-- Inclure dynamiquement les composants de post --%>
            <% for (Post post : posts) { %>
            <%
                // Ajout de l'objet "post" comme attribut de la requête
                request.setAttribute("post", post);
            %>
            <jsp:include page="/components/forum/post.jsp"/>
            <% } %>
        </div>
    </div>
</div>
<% } else { %>
<div class='w-full min-h-[calc(100vh-256px)] flex flex-col items-center max-w-[1300px]'>
    <div class='w-full h-full p-6 md:p-10'>
        <div class="flex gap-2 items-center">
            <a href="${pageContext.request.contextPath}/forum" class="flex gap-2 items-center">
                <svg xmlns="http://www.w3.org/2000/svg"
                     class="h-6 w-6 text-gray-400 hover:text-gray-600 transition-all duration-150" fill="none"
                     viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M10 19l-7-7m0 0l7-7m-7 7h18"></path>
                </svg>
            </a>
            <h1 class='text-3xl font-medium'>Le forum Cowork</h1>
        </div>
        <div class="w-full h-full flex flex-col overflow-y-auto py-2 gap-2">
            <%-- Inclure dynamiquement les composants de post --%>
            <% for (Post post : posts) { %>
            <%
                // Ajout de l'objet "post" comme attribut de la requête
                request.setAttribute("post", post);
            %>
            <jsp:include page="/components/forum/post.jsp"/>
            <% } %>
        </div>
    </div>
</div>
<% } %>