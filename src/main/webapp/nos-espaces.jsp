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
<%
    // Récupérer les paramètres de l'URL
    String type = request.getParameter("type");
    String dateDeb = request.getParameter("dateDeb");
    String dateFin = request.getParameter("dateFin");

    // Initialisation des objets Timestamp
    Timestamp timestampDeb = null;
    Timestamp timestampFin = null;

    // Si dateDeb n'est pas null et n'est pas vide, on le convertit en Timestamp
    // Traitement de la dateDeb (date de début)
    if (dateDeb != null && !dateDeb.trim().isEmpty()) {
        try {
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            Date parsedDateDeb = (Date) dateFormat.parse(dateDeb);
            timestampDeb = new Timestamp(parsedDateDeb.getTime());
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Erreur de format pour dateDeb : " + dateDeb);
        }
    }

    if (dateFin != null && !dateFin.trim().isEmpty()) {
        try {
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            Date parsedDateFin = (Date) dateFormat.parse(dateFin);
            timestampFin = new Timestamp(parsedDateFin.getTime());
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Erreur de format pour dateFin : " + dateFin);
        }
    } else {
        timestampFin = new Timestamp(System.currentTimeMillis());
    }

    // Récupérer la connexion à la base de données
    Connection connection = DatabaseConnection.getInstance();
    PreparedStatement preparedStatement = null;
    ResultSet resultSalles = null;
    ResultSet resultEquipements = null;
    ResultSet resultTypesEspaces = null;

    // Requête SQL pour récupérer les salles
    String query = "SELECT * FROM salles WHERE type_espace LIKE ? AND id_salle NOT IN (SELECT id_salle FROM users_salles WHERE timestamp_deb >= ? AND timestamp_fin <= ?)";

    // Préparer la requête
    preparedStatement = connection.prepareStatement(query);
    preparedStatement.setString(1, type);
    preparedStatement.setTimestamp(2, timestampDeb);
    preparedStatement.setTimestamp(3, timestampFin);

    // Exécuter la requête
    resultSalles = preparedStatement.executeQuery();

    // Créer la liste des salles
    ArrayList<Salle> salles = new ArrayList<>();

    // Parcourir les résultats
    while (resultSalles.next()) {
        int id_salle = resultSalles.getInt("id_salle");
        String label = resultSalles.getString("label");
        String type_espace = resultSalles.getString("type_espace");
        int capacite = resultSalles.getInt("capacite");
        String image_url = resultSalles.getString("image_url");

        // Récupérer les équipements associés à la salle
        String queryEquipements = "SELECT * FROM equipements WHERE id_equipement IN (SELECT id_equipement FROM salles_equipements WHERE id_salle = ?)";
        preparedStatement = connection.prepareStatement(queryEquipements);
        preparedStatement.setInt(1, id_salle);
        resultEquipements = preparedStatement.executeQuery();

        // Créer la liste des équipements
        ArrayList<Equipement> equipements = new ArrayList<>();

        // Parcourir les résultats
        while (resultEquipements.next()) {
            int id_equipement = resultEquipements.getInt("id_equipement");
            String label_equipement = resultEquipements.getString("label");

            equipements.add(new Equipement(id_equipement, label_equipement));
        }


        salles.add(new Salle(id_salle, label, type_espace, capacite, image_url, equipements.toArray(new Equipement[0])));
    }

    // Requête SQL pour récupérer les type_espace
    String queryTypesEspaces = "SELECT distinct type_espace FROM salles";
    preparedStatement = connection.prepareStatement(queryTypesEspaces);
    resultTypesEspaces = preparedStatement.executeQuery();

    // Créer la liste des types d'espaces
    ArrayList<String> typesEspaces = new ArrayList<>();

    // Parcourir les résultats
    while (resultTypesEspaces.next()) {
        String type_espace = resultTypesEspaces.getString("type_espace");
        typesEspaces.add(type_espace);
    }
%>

<div class="w-full bg-gray-500 flex justify-center">
    <form method="post" action="${pageContext.request.contextPath}/SearchNosEspaces" class="flex flex-col w-full max-w-[1300px] md:flex-row items-center gap-1 p-1 rounded-md ">
        <select name="type" class="bg-white/30 text-white ps-2 w-full md:w-auto h-[40px]">
            <option class="bg-white text-cow_text" <%=typesEspaces.isEmpty() ? "selected" : "" %> value="%">Tous</option>
            <% for (String type_espace : typesEspaces) { %>
<%--            if type_espace === type then display an option tag with the selected attribute set to selected otherwise display an option tag without the selected attribute--%>
            <option class="bg-white text-cow_text" <%= type_espace.equals(type) ? "selected" : "" %> value="<%= type_espace %>"><%= type_espace %></option>
            <% } %>
        </select>
        <input value="<%= dateDeb %>" type='datetime-local' name='dateDeb' class="bg-white/30 text-white ps-2 w-full h-[40px]">
        <input value="<%= dateFin %>" type='datetime-local' name='dateFin' class="bg-white/30 text-white ps-2 w-full h-[40px]">
        <button name='accueil-submit' type="submit" class='bg-cow_secondary w-full rounded-sm text-white px-4 py-2 font-semibold '>
            Rechercher
        </button>
    </form>

</div>

<div class="w-full flex justify-center my-10 px-4 md:px-0">
    <div class="w-full max-w-[1300px] grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-4">

        <% for (Salle salle : salles) { %>
        <a href="${pageContext.request.contextPath}/salle/<%=salle.getId_salle()%>" class="bg-white rounded-md border flex flex-col">
            <img src="/cowork/assets/salle.png" alt="Espace" class="w-full h-40 object-cover rounded-t-md">
            <div class="flex flex-col py-3 px-5 gap-2 w-full">
                <div class="text-sm text-gray-500">
                    <%= salle.getType_espace() %>
                </div>
                <div class="flex gap-1 text-xl font-semibold">
                    <span><%= salle.getLabel() %></span>
                </div>
                <div class="flex custom-scrollbar pb-2 max-w-full overflow-x-auto flex-nowrap gap-2">
                    <% for (Equipement equipement : salle.getEquipements()) { %>
                    <span class="text-sm bg-gray-300 rounded-full px-2 whitespace-nowrap"><%= equipement.getLabel() %></span>
                    <% } %>
                </div>
            </div>
        </a>
        <% } %>

    </div>
</div>
