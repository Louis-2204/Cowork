        <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, db.DatabaseConnection" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="cowork.Post" %>
<%@ page import="cowork.User" %>

<%
    Connection connection = null;
    Statement statement = null;
    ResultSet resultSet = null;

    // Récupérer la connexion via le singleton
    connection = DatabaseConnection.getInstance();

//    public Post(String id_post, String content, String created_at, String id_parent, String id_user, User user, ArrayList<Post> answers) {
//    this.id_post = id_post;
//    this.content = content;
//    this.created_at = created_at;
//    this.id_parent = id_parent;
//    this.id_user = id_user;
//    this.user = user;
//    this.answers = answers;
//    }

//    public User(String id_user, String nom, String prenom, String email, String password, String entreprise, String secteur_activite) {
//    this.id_user = id_user;
//    this.nom = nom;
//    this.prenom = prenom;
//    this.email = email;
//    this.password = password;
//    this.entreprise = entreprise;
//    this.secteur_activite = secteur_activite;
//    }

    // Initialisation de la requête SQL de base
    String queryMainPosts = "SELECT * FROM posts p JOIN users u ON p.id_user = u.id_user WHERE p.id_parent IS NULL ORDER BY p.created_at DESC";


    String queryAnswers = "SELECT * FROM posts p JOIN users u ON p.id_user = u.id_user WHERE p.id_parent = ? ORDER BY p.created_at asc";

    // Exécuter la requête
    ArrayList<Post> posts;
    try {
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
                            resultSet.getString("id_user"),
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
            PreparedStatement preparedStatement = connection.prepareStatement(queryAnswers);
            preparedStatement.setInt(1, post.getId_post());
            ResultSet resultSetAnswers = preparedStatement.executeQuery();
            ArrayList<Post> answers = new ArrayList<>();
            while (resultSetAnswers.next()) {
                Post answer = new Post(
                        resultSetAnswers.getInt("id_post"),
                        resultSetAnswers.getString("content"),
                        resultSetAnswers.getString("created_at"),
                        resultSetAnswers.getString("id_parent"),
                        resultSetAnswers.getString("id_user"),
                        new User(
                                resultSetAnswers.getString("id_user"),
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
%>


<div class='w-full min-h-[calc(100vh-256px)] flex flex-col items-center max-w-[1300px]'>
    <div class='w-full h-full p-6 md:p-10'>
        <h1 class='text-3xl font-medium'>Le forum Cowork</h1>
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
