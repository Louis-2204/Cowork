<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, db.DatabaseConnection" %>
<%@ page import="static com.sun.org.apache.xalan.internal.xsltc.compiler.util.Util.println" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="cowork.Salle" %>

<%
    Connection connection = null;
    Statement statement = null;
    ResultSet resultSet = null;

    // Récupérer la connexion via le singleton
    connection = DatabaseConnection.getInstance();

    // Récupérer les paramètres de l'URL
    String type = request.getParameter("type");
    String dateDeb = request.getParameter("dateDeb");
    String dateFin = request.getParameter("dateFin");

    // Initialisation de la requête SQL de base
    String query = "SELECT * FROM salles WHERE 1 = 1 "; // "1 = 1" est une condition qui est toujours vraie

    // Si "type" est spécifié, ajouter un filtre sur ce paramètre
    if (type != null && !type.isEmpty()) {
        query += " AND type_espace = ? ";
    }

    // Ajouter d'autres filtres pour dateDeb et dateFin si présents
    if (dateDeb != null && !dateDeb.isEmpty()) {
        query += " AND date_debut >= ? ";
    }
    if (dateFin != null && !dateFin.isEmpty()) {
        query += " AND date_fin <= ? ";
    }

    // Préparer la requête avec les paramètres
    PreparedStatement preparedStatement = connection.prepareStatement(query);

    // Définir les paramètres dans la requête
    int paramIndex = 1;

    if (type != null && !type.isEmpty()) {
        preparedStatement.setString(paramIndex++, type);
    }

    if (dateDeb != null && !dateDeb.isEmpty()) {
        preparedStatement.setString(paramIndex++, dateDeb);
    }

    if (dateFin != null && !dateFin.isEmpty()) {
        preparedStatement.setString(paramIndex++, dateFin);
    }

    // Exécuter la requête
    resultSet = preparedStatement.executeQuery();

    // Créer la liste des salles
    ArrayList<Salle> salles = new ArrayList<>();

    // Parcourir les résultats et remplir la liste des salles
    while (resultSet.next()) {
        int id_salle = resultSet.getInt("id_salle");
        String label = resultSet.getString("label");
        String type_espace = resultSet.getString("type_espace");
        int capacite = resultSet.getInt("capacite");
        String image_url = resultSet.getString("image_url");

        salles.add(new Salle(id_salle, label, type_espace, capacite, image_url));
    }
%>

<div class="w-full bg-gray-500 flex justify-center">
    <form method="post" action="${pageContext.request.contextPath}/SearchNosEspaces" class="flex flex-col w-full max-w-[1300px] md:flex-row items-center gap-1 p-1 rounded-md ">
        <select name="type" class="bg-white/30 text-white ps-2 w-full md:w-auto h-[40px]">
            <option class="bg-white text-cow_text " value="co-working">Co-Working</option>
            <option class="bg-white text-cow_text" value="openspace">OpenSpace</option>
            <option class="bg-white text-cow_text" value="bureau-prive">Bureaux privés</option>
        </select>
        <input type='datetime-local' name='dateDeb' class="bg-white/30 text-white ps-2 w-full h-[40px]">
        <input type='datetime-local' name='dateFin' class="bg-white/30 text-white ps-2 w-full h-[40px]">
        <button name='accueil-submit' type="submit" class='bg-cow_secondary w-full rounded-sm text-white px-4 py-2 font-semibold '>
            Rechercher
        </button>
    </form>

</div>

<div class="w-full flex justify-center my-10 px-4 md:px-0">
    <div class="w-full max-w-[1300px] grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-4">

        <% for (Salle salle : salles) { %>
        <div class="bg-white rounded-md border flex flex-col">
            <img src="/cowork/assets/salle.png" alt="Espace" class="w-full h-40 object-cover rounded-t-md">
            <div class="flex flex-col py-3 px-5 gap-2 w-full">
                <div class="text-sm text-gray-500">
                    <%= salle.getType_espace() %>
                </div>
                <div class="flex gap-1 text-xl font-semibold">
                    <span><%= salle.getLabel() %></span>
                </div>
<%--                <div class="flex gap-2">--%>
<%--                    <% for (String tag : reservation.getTags()) { %>--%>
<%--                    <span class="text-sm bg-gray-300 rounded-full px-2"><%= tag %></span>--%>
<%--                    <% } %>--%>
<%--                </div>--%>
            </div>
        </div>
        <% } %>

    </div>
</div>
