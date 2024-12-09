<%@ page import="cowork.Salle" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Salle salle = (Salle) request.getAttribute("salle");
%>
<dialog id="modifierEspaceDialog<%= salle.getId_salle() %>" class="md:w-1/2 sm:w-3/4 w-11/12 max-w-[650px] bg-white p-5 rounded-md transition-all duration-300">
    <div class="flex w-full justify-between">
        <h1 class="text-2xl font-semibold pb-2">Modifier l'espace</h1>
        <button id="closeModifierEspaceDialog<%= salle.getId_salle() %>" class="text-xl font-semibold hover:bg-gray-200 rounded-full p-1 w-9 h-9 flex items-center justify-center">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
                <path stroke-linecap="round" stroke-linejoin="round" d="M6 18 18 6M6 6l12 12" />
            </svg>
        </button>
    </div>
    <form action="/cowork/admin/updateEspace" method="post" class="flex flex-col gap-2">
        <input type="hidden" id="id_salle" name="id_salle" value="<%= salle.getId_salle() %>">
        <label for="type">Type</label>
        <select name="type" id="type" class="border rounded-md p-1">
            <option value="co-working" <%= salle.getType_espace().equals("co-working") ? "selected" : "" %>>Co-working</option>
            <option value="bureau-privé" <%= salle.getType_espace().equals("bureau-privé") ? "selected" : "" %>>Bureau privé</option>
        </select>
        <label for="image">Image</label>
        <input type="text" name="image" id="image" class="border rounded-md p-1" value="<%= salle.getImage_url() %>">
        <label for="nom">Nom</label>
        <input type="text" name="nom" id="nom" class="border rounded-md p-1" value="<%= salle.getLabel() %>">
        <label for="capacite">Capacité</label>
        <input type="number" name="capacite" id="capacite" class="border rounded-md p-1" value="<%= salle.getCapacite() %>">
        <label for="equipements">Équipements</label>
        <input type="text" name="equipements" id="equipements" class="border rounded-md p-1">
        <button type="submit" class="bg-[#FF6641] hover:bg-[#d16044] text-white font-semibold py-1 px-3 rounded-md">
            Enregistrer
        </button>
    </form>
</dialog>



<script>
    const modifierEspaceDialog<%= salle.getId_salle() %> = document.getElementById('modifierEspaceDialog<%= salle.getId_salle() %>');
    const modifierEspace<%= salle.getId_salle() %> = document.getElementById('gestionEspace<%= salle.getId_salle() %>');
    const closeModifierEspaceDialog<%= salle.getId_salle() %> = document.getElementById('closeModifierEspaceDialog<%= salle.getId_salle() %>');

    modifierEspace<%= salle.getId_salle() %>.addEventListener('click', () => {
        modifierEspaceDialog<%= salle.getId_salle() %>.showModal();
    });

    closeModifierEspaceDialog<%= salle.getId_salle() %>.addEventListener('click', () => {
        modifierEspaceDialog<%= salle.getId_salle() %>.close();
    });
    

    modifierEspaceDialog<%= salle.getId_salle() %>.addEventListener('close', () => {
        modifierEspaceDialog<%= salle.getId_salle() %>.querySelector('form').reset();
    });

    // close dialog when clicking outside
    modifierEspaceDialog<%= salle.getId_salle() %>.addEventListener('click', (e) => {
        if (e.target === modifierEspaceDialog<%= salle.getId_salle() %>) {
            modifierEspaceDialog<%= salle.getId_salle() %>.close();
        }
    });
</script>

<style>
    dialog::backdrop {
        background-color: rgba(0, 0, 0, 0.5);
    }
</style>