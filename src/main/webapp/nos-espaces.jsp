<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import=" db.DatabaseConnection" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="cowork.Salle" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="cowork.Equipement" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.sql.*" %>
<%
    // Récupérer les paramètres de l'URL
    String type = request.getParameter("type");
    String date = request.getParameter("date");
    String timeDeb = request.getParameter("timeDeb");
    String timeFin = request.getParameter("timeFin");

    // Initialisation des objets Timestamp
    Timestamp timestampDeb = null;
    Timestamp timestampFin = null;

    // Si la date n'est pas nulle et non vide
    if (date != null && !date.trim().isEmpty()) {
        try {
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date parsedDate = dateFormat.parse(date);

            // Si les heures sont également fournies
            if (timeDeb != null && !timeDeb.trim().isEmpty()) {
                String dateTimeDeb = date + " " + timeDeb + ":00"; // Ajouter les secondes
                SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                timestampDeb = new Timestamp(dateTimeFormat.parse(dateTimeDeb).getTime());
            }

            if (timeFin != null && !timeFin.trim().isEmpty()) {
                String dateTimeFin = date + " " + timeFin + ":00"; // Ajouter les secondes
                SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                timestampFin = new Timestamp(dateTimeFormat.parse(dateTimeFin).getTime());
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Erreur de formatage pour la date ou l'heure : " + e.getMessage());
        }
    }

    // Récupérer la connexion à la base de données
    Connection connection = DatabaseConnection.getInstance();
    PreparedStatement preparedStatement = null;
    ResultSet resultSalles = null;
    ResultSet resultTypesEspaces = null;
    ResultSet resultEquipements = null;

    try {
        // Construire la requête SQL
        StringBuilder queryBuilder = new StringBuilder("SELECT * FROM salles WHERE 1=1");

        // Ajouter la condition pour le type d'espace
        if (type != null && !type.trim().isEmpty()) {
            queryBuilder.append(" AND type_espace LIKE ?");
        }

        // Ajouter les conditions pour la disponibilité
        if (timestampDeb != null && timestampFin != null) {
            queryBuilder.append(" AND id_salle NOT IN (");
            queryBuilder.append(" SELECT id_salle FROM users_salles WHERE ");
            queryBuilder.append(" (timestamp_deb < ? AND timestamp_fin > ?)");
            queryBuilder.append(")");
        }

        // Préparer la requête
        preparedStatement = connection.prepareStatement(queryBuilder.toString());

        // Ajouter les paramètres
        int paramIndex = 1;
        if (type != null && !type.trim().isEmpty()) {
            preparedStatement.setString(paramIndex++, "%" + type + "%");
        }
        if (timestampDeb != null && timestampFin != null) {
            preparedStatement.setTimestamp(paramIndex++, timestampFin); // timestamp_fin > timestampDeb
            preparedStatement.setTimestamp(paramIndex++, timestampDeb); // timestamp_deb < timestampFin
        }

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

        // Passer les types à la JSP
        request.setAttribute("typesEspaces", typesEspaces);
        request.setAttribute("salles", salles);


    } catch (Exception e) {
        e.printStackTrace();
        throw new ServletException("Erreur lors de la récupération des données.", e);
    } finally {
        if (resultSalles != null) resultSalles.close();
        if (resultTypesEspaces != null) resultTypesEspaces.close();
        if (preparedStatement != null) preparedStatement.close();
    }
%>

<%
    ArrayList<String> typesEspaces = (ArrayList<String>) request.getAttribute("typesEspaces");
    ArrayList<Salle> salles = (ArrayList<Salle>) request.getAttribute("salles");
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
        <input value="<%= date %>" type='date' name='date' class="bg-white/30 text-white ps-2 w-full h-[40px]">
        <input value="<%= timeDeb %>" type='time' name='timeDeb' class="bg-white/30 text-white ps-2 w-full h-[40px]">
        <input value="<%= timeFin %>" type='time' name='timeFin' class="bg-white/30 text-white ps-2 w-full h-[40px]">
        <button name='espaces-submit' type="submit" class='bg-cow_secondary w-full rounded-sm text-white px-4 py-2 font-semibold '>
            Rechercher
        </button>
    </form>

</div>

<div class="w-full flex justify-center my-10 px-4 md:px-0">
    <div class="w-full max-w-[1300px] grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-4">

        <% for (Salle salle : salles) { %>
        <a href="${pageContext.request.contextPath}/salle?id=<%=salle.getId_salle()%>" class="bg-white rounded-md border flex flex-col">
            <img src="<%=salle.getImage_url()%>" alt="Espace" class="w-full h-40 object-cover rounded-t-md">
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
