<%@ page import="cowork.Post" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Post answer = (Post) request.getAttribute("answer");
%>
<div class="flex flex-col gap-2 p-3">
    <div class="flex gap-2 w-full items-center">
        <div class="h-7 w-7 bg-gray-300 rounded-full flex items-center justify-center">
            <%-- GET FIRST LETTER OF FIRST NAME AND LAST NAME --%>
            <span class="text-sm">
                <%= String.valueOf(answer.getUser().getPrenom().charAt(0)) + String.valueOf(answer.getUser().getNom().charAt(0)) %>
            </span>
        </div>
        <div class="flex justify-between w-full items-center">
            <div class="text-xl">
                <%= answer.getUser().getPrenom() + " " + answer.getUser().getNom() %>
            </div>
            <div class="text-sm text-gray-400">
                <%= new SimpleDateFormat("dd/MM/yyyy HH:mm").format(java.sql.Timestamp.valueOf(answer.getCreated_at())) %>
            </div>
        </div>
    </div>
    <p class="w-full pl-10">
        <%= answer.getContent() %>
    </p>
</div>