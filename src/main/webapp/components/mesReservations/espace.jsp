<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="cowork.Reservation" %>
<%@ page import="cowork.Equipement" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    String typeResa = request.getParameter("typeResa");
    Reservation reservation = (Reservation) request.getAttribute("reservation");
%>

<div class="bg-white rounded-md border flex flex-col">
    <div class="w-full flex justify-center bg-gray-300 rounded-t-md">
        <img src="<%= reservation.getSalle().getImage_url() %>" alt="Espace" class="w-full max-w-2xl h-40 object-cover">
    </div>
    <div class="flex flex-col py-3 px-5 gap-2 w-full">
        <div class="text-sm text-gray-500">
            <%= reservation.getSalle().getType_espace().substring(0, 1).toUpperCase() + reservation.getSalle().getType_espace().substring(1) %>
        </div>
        <div class="flex flex-col gap-1 text-xl font-semibold">
            <span><%= reservation.getSalle().getLabel() %></span>
            <div class="text-base text-gray-500">
                <span><%= new SimpleDateFormat("dd/MM/yyyy").format(reservation.getTimestampDeb()) %></span>
                <span><%= new SimpleDateFormat("HH:mm").format(reservation.getTimestampDeb()) %></span>
                <span>-</span>
                <span><%= new SimpleDateFormat("HH:mm").format(reservation.getTimestampFin()) %></span>
            </div>
        </div>
        <div class="flex flex-wrap gap-2">
            <% for (Equipement equipement : reservation.getSalle().getEquipementsArrayList()) { %>
            <span class="text-sm bg-gray-300 rounded-full px-2"><%= equipement.getLabel() %></span>
            <% } %>
        </div>
        <div class="flex w-full justify-end">
            <% if (typeResa.equals("avenir")) { %>
            <button id="codeReservation<%= reservation.getIdUser() + reservation.getCode() %>"
                    class="border border-[#FF6641] hover:bg-[#FF6641] hover:text-white rounded-sm py-1 px-3 transition-all duration-150">
                Afficher le code
            </button>
            <% } else { %>
            <a href="<%= request.getContextPath() %>/salle?id=<%= reservation.getSalle().getId_salle() %>"
               class="border border-[#FF6641] hover:bg-[#FF6641] hover:text-white rounded-sm py-1 px-3 transition-all duration-150">
                Réserver à nouveau
            </a>
            <% } %>
        </div>
    </div>
</div>


<% if (typeResa.equals("avenir")) { %>
<jsp:include page="/components/mesReservations/codeReservationDialog.jsp">
    <jsp:param name="code" value="<%= reservation.getCode() %>"/>
    <jsp:param name="idReservation" value="<%= reservation.getIdUser() + reservation.getCode() %>"/>
</jsp:include>
<% } %>