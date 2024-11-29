<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="bg-white rounded-md border p-5 flex flex-col gap-2">
    <div class="flex gap-2 w-full items-center">
        <div class="h-7 w-7 bg-gray-300 rounded-full flex items-center justify-center">
            <%-- GET FIRST LETTER OF FIRST NAME AND LAST NAME --%>
            <%-- TODO --%>
            <span class="text-sm">AL</span>
        </div>
        <div class="text-xl">Alexys Laurent</div>
    </div>
    <p class="w-full pl-10">
        Lorem ipsum dolor sit, amet consectetur adipisicing elit. 
        Ex totam, doloremque assumenda cumque necessitatibus ad nostrum pariatur rerum quia temporibus ratione dolor, 
        reprehenderit earum, ea natus eaque beatae optio non!
    </p>
    <%-- INCLUDE ANSWERS --%>
    <jsp:include page="/components/forum/postAnswer.jsp" />
    <div class="w-full flex gap-1 pl-10">
        <input type="text" class="w-full border rounded-sm p-1" placeholder="Répondre...">
        <button class="border border-orange-400 hover:bg-orange-400 hover:text-white rounded-sm py-1 px-3 transition-all duration-150">Envoyer</button>
    </div>
</div>