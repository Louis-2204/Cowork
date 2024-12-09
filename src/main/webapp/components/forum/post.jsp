<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="cowork.Post" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="cowork.User" %>
<%
    User user = (User) session.getAttribute("loggedInUser");
    Post post = (Post) request.getAttribute("post");
%>

<%-- IF answers INCLUDE ANSWERS --%>
<% if (post.getAnswers() == null) { %>
<a class="bg-white rounded-md border p-5 flex flex-col gap-2"
   href="${pageContext.request.contextPath}/forum?id_post=<%= post.getId_post() %>">
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
</a>
<% } else { %>
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
    <% if (user != null) { %>
    <div class="w-full flex gap-1">
        <form action="${pageContext.request.contextPath}/PostAnswer" method="POST" class="w-full flex gap-1">
            <input type="hidden" name="id_parent" value="<%= post.getId_post() %>">
            <input type="text" name="content" class="w-full border rounded-sm p-1" placeholder="Répondre...">
            <button type="submit"
                    class="border border-orange-400 hover:bg-orange-400 hover:text-white rounded-sm py-1 px-3 transition-all duration-150">
                Envoyer
            </button>
        </form>
    </div>
    <% } %>
</div>
<% if (post.getAnswers().size() > 0) { %>
<div class="w-full flex flex-col gap-2 bg-white rounded-md max-h-[800px] overflow-y-auto p-3 border">
    <% for (Post answer : post.getAnswers()) { %>
    <% request.setAttribute("answer", answer); %>
    <jsp:include page="/components/forum/postAnswer.jsp"/>
    <% } %>
</div>
<% } else { %>
<div class="w-full flex flex-col gap-2 bg-white rounded-md p-3 border">
    <p class="text-center text-gray-400">Aucune réponse</p>
</div>
<% } %>
<% } %>
