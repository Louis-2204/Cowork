<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="cowork.Forfait" %>
<%
    Forfait forfait = (Forfait) request.getAttribute("forfait");
%>
<div class="bg-white rounded-md border flex flex-col">
    <img src="<%= forfait.getImage_url() %>" alt="Espace" class="w-full h-40 object-cover rounded-t-md">
    <div class="flex flex-col py-3 px-5 gap-2 w-full">
        <div class="text-sm text-gray-500">
            <%= forfait.getType_espace().substring(0, 1).toUpperCase() + forfait.getType_espace().substring(1) %>
        </div>
        <div class="text-xl font-semibold">
            <%= forfait.getLabel() %>
        </div>
        <div class="flex w-full justify-between">
            <div class="flex gap-1 font-bold text-2xl text-[#FF6641] items-center">
                <%= forfait.getPrix() %> €
            </div>
            <button id="gestionEspace<%= forfait.getId_forfait() %>"
                    class="border border-[#FF6641] hover:bg-[#FF6641] hover:text-white rounded-sm py-1 px-3 transition-all duration-150">
                Modifier
            </button>
        </div>
    </div>
</div>

<%
    request.setAttribute("forfait", forfait);
%>
<jsp:include page="/components/admin/gestionForfaits/modifierForfaitDialog.jsp"/>
