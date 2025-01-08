<%@ page import="java.sql.Connection" %>
<%@ page import="db.DatabaseConnection" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="cowork.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%

    User user = (User) request.getSession().getAttribute("loggedInUser");
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");

    if (user == null) {
        response.sendRedirect("/cowork/login");
    }

    // Récupérer la connexion à la base de données
    Connection connection = DatabaseConnection.getInstance();
    PreparedStatement preparedStatement = null;
    ResultSet result = null;

    try {

        // Requête SQL pour récupérer les factures
        String query = "SELECT * from factures where id_user = ? order by date desc";
        preparedStatement = connection.prepareStatement(query);
        preparedStatement.setInt(1, user.getId_user());
        result = preparedStatement.executeQuery();

        // Créer la liste des factures
        ArrayList<Object> factures = new ArrayList<>();

        while (result.next()) {
            factures.add(result.getInt("id_facture"));
            factures.add(result.getString("libelle"));
            factures.add(result.getFloat("montant"));
            factures.add(result.getDate("date"));
        }

        // Passer les factures à la JSP
        request.setAttribute("factures", factures);

    } catch (Exception e) {
        e.printStackTrace();
        throw new ServletException("Erreur lors de la récupération des données.", e);
    }
%>
<% ArrayList<Object> factures = (ArrayList<Object>) request.getAttribute("factures"); %>

<div>
    <h1 class='text-3xl md:text-5xl font-bold text-center'>Vos factures</h1>
    <table class='w-full mt-4'>
        <thead>
        <tr>
            <th class='text-left p-2'>Libellé</th>
            <th class='text-left p-2'>Montant</th>
            <th class='text-left p-2'>Date</th>
            <th class='text-left p-2'>Actions</th>
        </tr>
        </thead>
        <% if (factures.isEmpty()) { %>
        <tr>
            <td class='p-2' colspan='4'>Aucune facture trouvée.</td>
        </tr>
        <% } %>
        <tbody>
        <% for (int i = 0; i < factures.size(); i += 4) { %>
        <tr>
            <td class='p-2'><%= factures.get(i + 1) %></td>
            <td class='p-2'><%= factures.get(i + 2) %></td>
            <td class='p-2'><%= dateFormat.format((Date) factures.get(i + 3)) %></td>
            <td class='p-2'>
                <form action="/cowork/downloadFacture" method="GET">
                    <input type="hidden" name="id_facture" value="<%= factures.get(i) %>">
                    <button type="submit" class="bg-[#FF6641] hover:bg-[#d16044] text-white font-semibold py-1 px-3 rounded-md">
                        Télécharger
                    </button>
                </form>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
</div>