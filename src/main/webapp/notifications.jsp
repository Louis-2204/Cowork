<%@ page import="cowork.User" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="db.DatabaseConnection" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="cowork.Notification" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    User user = (User) request.getSession().getAttribute("loggedInUser");

    // Récupérer la connexion à la base de données
    Connection connection = DatabaseConnection.getInstance();
    PreparedStatement preparedStatement = null;
    ResultSet resultNotifications = null;

    // Requête SQL pour récupérer les notifications
    String query = "SELECT * FROM notifications WHERE id_user = ? ORDER BY notification_date DESC";

    // Préparer la requête
    preparedStatement = connection.prepareStatement(query);
    preparedStatement.setInt(1, user.getId_user());

    // Exécuter la requête
    resultNotifications = preparedStatement.executeQuery();

    // Créer la liste des notifications
    ArrayList<Notification> notifications = new ArrayList<>();

    // Parcourir les résultats
    while (resultNotifications.next()) {
        int id_notification = resultNotifications.getInt("id_notification");
        int id_user = resultNotifications.getInt("id_user");
        String notificationDate = resultNotifications.getString("notification_date");
        String message = resultNotifications.getString("message");
        Boolean isRead = resultNotifications.getBoolean("is_read");

        // Ajouter à la liste des notifications
        notifications.add(new Notification(id_notification, id_user, notificationDate, message, isRead));
    }
%>

<div class="w-full flex flex-col items-center gap-2 py-10">
    <h1 class="text-2xl font-semibold mb-7">Vos notifications : </h1>
    <% if(notifications.isEmpty()) { %>
    <p class="text-lg font-medium">Vous n'avez pas de notifications</p>
    <% } %>
    <%
        // Afficher les notifications dans la div
        for (Notification notification : notifications) {
    %>
    <div class="w-full max-w-[1000px] bg-white p-4 border border-gray-200 rounded-lg">
        <p class="font-semibold text-lg">Notification</p>
        <p><strong>Date :</strong> <%= notification.getNotificationDate() %></p>
        <p><strong>Message :</strong> <%= notification.getMessage() %></p>
        <p><strong>Statut :</strong> <%= notification.isRead() ? "Lue" : "Non lue" %></p>

        <% if (!notification.isRead()) { %>
        <form action="${pageContext.request.contextPath}/NotificationRead" method="POST">
            <input type="hidden" name="id_notification" value="<%= notification.getIdNotification() %>">
            <button type="submit" class="mt-2 px-4 py-2 bg-orange-500 text-white rounded-lg hover:bg-orange-600">Marquer comme lue</button>
        </form>
        <% } %>
    </div>
    <%
        }
    %>
</div>
