<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="cowork.Reservation" %>

<%
    // mock data
    ArrayList<Reservation> reservations = new ArrayList<>();
    reservations.add(new Reservation(
            "1",
            "Open space",
            "Forfait open space N°1",
            "08/12/2024",
            "XZBVJD",
            Arrays.asList("bqdqzo", "gdrg", "jgyjd")
    ));
    reservations.add(new Reservation(
            "2",
            "Open space",
            "Forfait open space N°2",
            "08/12/2024",
            "IKEPOC",
            Arrays.asList("bqdqzo", "gdrg", "jgyjd")
    ));
    reservations.add(new Reservation(
            "3",
            "Open space",
            "Forfait open space N°3",
            "08/12/2024",
            "OREHZI",
            Arrays.asList("bqdqzo", "gdrg", "jgyjd")
    ));
%>
<div class='w-full min-h-[calc(100vh-256px)] flex flex-col items-center max-w-[1300px]'>
    <div class='w-full h-full p-6 md:p-10 flex flex-col gap-4 overflow-y-auto'>
        <div class="flex flex-col">
            <div class="flex">
                <h1 class='text-3xl font-medium'>A venir</h1>
            </div>
            <div class="w-full h-full flex flex-col overflow-y-auto py-2 gap-2">
                <%-- Inclure dynamiquement les composants de post --%>
                <%-- <jsp:include page="/components/mesReservations/espace.jsp">
                    <jsp:param name="typeResa" value="avenir" />
                </jsp:include>
                <jsp:include page="/components/mesReservations/espace.jsp">
                    <jsp:param name="typeResa" value="avenir" />
                </jsp:include> --%>
                <% for (Object reservation : reservations) { %>
                <%
                    // Ajout de l'objet "reservation" comme attribut de la requête
                    request.setAttribute("reservation", reservation);
                %>
                <jsp:include page="/components/mesReservations/espace.jsp">
                    <jsp:param name="typeResa" value="avenir" />
                </jsp:include>
                <% } %>
            </div>
        </div>
        <div class="flex flex-col">
            <div class="flex">
                <h1 class='text-3xl font-medium'>Passées</h1>
            </div>
            <div class="w-full h-full flex flex-col overflow-y-auto py-2 gap-2">
                <%-- Inclure dynamiquement les composants de post --%>
                <jsp:include page="/components/mesReservations/espace.jsp">
                    <jsp:param name="typeResa" value="passe" />
                </jsp:include>
            </div>
        </div>
    </div>
</div>