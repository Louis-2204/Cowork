<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class='w-full h-[calc(100vh-256px)] flex flex-col items-center max-w-[1300px]'>
    <div class='w-full h-full p-6 md:p-10'>
        <div class="flex">
            <h1 class='text-3xl font-medium'>Gestion des espaces</h1>
            <button id="ajouterEspace" class="ml-auto bg-[#FF6641] hover:bg-[#d16044] text-white font-semibold py-1 px-3 rounded-md">
                Ajouter
            </button>
        </div>
        <div class="w-full h-full flex flex-col overflow-y-auto py-2 gap-2">
            <%-- Inclure dynamiquement les composants de post --%>
            <jsp:include page="/components/admin/gestionEspaces/espace.jsp" />
        </div>
    </div>
</div>

<jsp:include page="/components/admin/gestionEspaces/ajouterEspaceDialog.jsp" />