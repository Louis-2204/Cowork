<%@ page import="cowork.Post" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Post post = (Post) request.getAttribute("post");
%>
<div class="bg-white rounded-md border p-5 flex flex-col gap-2">
    <div class="flex gap-2 w-full items-center">
        <div class="h-7 w-7 bg-gray-300 rounded-full flex items-center justify-center">
            <%-- GET FIRST LETTER OF FIRST NAME AND LAST NAME --%>
            <span class="text-sm">
                <%= String.valueOf(post.getUser().getPrenom().charAt(0)) + String.valueOf(post.getUser().getNom().charAt(0)) %>
            </span>
        </div>
        <div class="flex justify-between w-full items-center">
            <div class="text-xl">
                <%= post.getUser().getPrenom() + " " + post.getUser().getNom() %>
            </div>
            <div class="text-sm text-gray-400">
                <%= new SimpleDateFormat("dd/MM/yyyy HH:mm").format(java.sql.Timestamp.valueOf(post.getCreated_at())) %>
            </div>
        </div>
    </div>
    <p class="w-full pl-10">
        <%= post.getContent() %>
    </p>
    <%-- INCLUDE ANSWERS --%>
    <div class="w-full flex flex-col gap-2">
        <% for (Post answer : post.getAnswers()) { %>
            <% request.setAttribute("answer", answer); %>
            <jsp:include page="/components/forum/postAnswer.jsp" />
        <% } %>
    </div>
    <div class="w-full flex gap-1 pl-10">
        <input type="text" class="w-full border rounded-sm p-1" placeholder="Répondre...">
        <button class="border border-orange-400 hover:bg-orange-400 hover:text-white rounded-sm py-1 px-3 transition-all duration-150">Envoyer</button>
    </div>
</div>