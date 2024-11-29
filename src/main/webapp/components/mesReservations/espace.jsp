<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="cowork.Reservation" %>
<%
    String typeResa = request.getParameter("typeResa");
    Reservation reservation = (Reservation) request.getAttribute("reservation");
%>
<div class="bg-white rounded-md border flex flex-col">
    <img src="/cowork/assets/salle.png" alt="Espace" class="w-full h-40 object-cover rounded-t-md">
    <div class="flex flex-col py-3 px-5 gap-2 w-full">
        <div class="text-sm text-gray-500">
            <%= reservation.getType() %>
        </div>
        <div class="flex gap-1 text-xl font-semibold">
            <span><%= reservation.getName() %></span>
            <span>•</span>
            <span><%= reservation.getDate() %></span>
        </div>
        <div class="flex gap-2">
            <% for (String tag : reservation.getTags()) { %>
                <span class="text-sm bg-gray-300 rounded-full px-2"><%= tag %></span>
            <% } %>
        </div>
        <div class="flex w-full justify-end">
            <% if (typeResa.equals("avenir")) { %>
                <button id="codeReservation<%= reservation.getId() %>" class="border border-[#FF6641] hover:bg-[#FF6641] hover:text-white rounded-sm py-1 px-3 transition-all duration-150">Afficher le code</button>
            <% } %>
        </div>
    </div>
</div>


<% if (typeResa.equals("avenir")) { %>
    <jsp:include page="/components/mesReservations/codeReservationDialog.jsp">
        <jsp:param name="code" value="<%= reservation.getCode() %>" />
        <jsp:param name="idReservation" value="<%= reservation.getId() %>" />
    </jsp:include>
<% } %>