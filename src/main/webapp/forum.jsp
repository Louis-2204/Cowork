<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class='w-full min-h-[calc(100vh-256px)] flex flex-col items-center max-w-[1300px]'>
    <div class='w-full h-full p-6 md:p-10'>
        <h1 class='text-3xl font-medium'>Le forum Cowork</h1>
        <div class="w-full h-full flex flex-col overflow-y-auto py-2 gap-2">
            <%-- Inclure dynamiquement les composants de post --%>
            <jsp:include page="/components/forum/post.jsp" />
        </div>
    </div>
</div>