<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="cowork.Salle" %>
<%@ page import="cowork.Equipement" %>
<%
    Salle salle = (Salle) request.getAttribute("salle");
%>
<div class="bg-white rounded-md border flex flex-col">
    <img src="<%= salle.getImage_url() %>" alt="Espace" class="w-full h-40 object-cover rounded-t-md">
    <div class="flex flex-col py-3 px-5 gap-2 w-full">
        <div class="text-sm text-gray-500">
            <%= salle.getType_espace().substring(0, 1).toUpperCase() + salle.getType_espace().substring(1) %>
        </div>
        <div class="text-xl font-semibold">
            <%= salle.getLabel() %>
        </div>
        <div class="flex flex-wrap gap-2">
            <% for (Equipement equipement : salle.getEquipementsArrayList()) { %>
            <span class="text-sm bg-gray-300 rounded-full px-2"><%= equipement.getLabel() %></span>
            <% } %>
        </div>
        <div class="flex w-full justify-between">
            <div class="flex gap-1 font-bold text-2xl text-[#FF6641] items-center">
                <%= salle.getCapacite() %>
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5"
                     stroke="currentColor" class="size-6">
                    <path stroke-linecap="round" stroke-linejoin="round"
                          d="M15 19.128a9.38 9.38 0 0 0 2.625.372 9.337 9.337 0 0 0 4.121-.952 4.125 4.125 0 0 0-7.533-2.493M15 19.128v-.003c0-1.113-.285-2.16-.786-3.07M15 19.128v.106A12.318 12.318 0 0 1 8.624 21c-2.331 0-4.512-.645-6.374-1.766l-.001-.109a6.375 6.375 0 0 1 11.964-3.07M12 6.375a3.375 3.375 0 1 1-6.75 0 3.375 3.375 0 0 1 6.75 0Zm8.25 2.25a2.625 2.625 0 1 1-5.25 0 2.625 2.625 0 0 1 5.25 0Z"/>
                </svg>
            </div>
            <div class="flex gap-1">
            <button id="gestionEspace<%= salle.getId_salle() %>" class="border border-[#FF6641] hover:bg-[#FF6641] hover:text-white rounded-sm py-1 px-3 transition-all duration-150">
                Modifier
            </button>
            <form action="/cowork/admin/deleteEspace" method="post">
                <input type="hidden" name="id_salle" value="<%= salle.getId_salle() %>">
                <button type="submit" class="border border-red-500 bg-red-500 text-white rounded-sm py-1 px-3 transition-all duration-150">
                    Supprimer
                </button>
            </form>
            </div>
        </div>
    </div>
</div>

<%
    request.setAttribute("salle", salle);
%>
<jsp:include page="/components/admin/gestionEspaces/modifierEspaceDialog.jsp"/>
