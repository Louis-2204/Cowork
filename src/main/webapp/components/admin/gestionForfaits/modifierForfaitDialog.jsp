<%@ page import="cowork.Forfait" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Forfait forfait = (Forfait) request.getAttribute("forfait");
%>
<dialog id="modifierForfaitDialog<%= forfait.getId_forfait() %>"
        class="md:w-1/2 sm:w-3/4 w-11/12 max-w-[650px] bg-white p-5 rounded-md transition-all duration-300">
    <div class="flex w-full justify-between">
        <h1 class="text-2xl font-semibold pb-2">Modifier le forfait</h1>
        <button id="closeModifierForfaitDialog<%= forfait.getId_forfait() %>"
                class="text-xl font-semibold hover:bg-gray-200 rounded-full p-1 w-9 h-9 flex items-center justify-center">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5"
                 stroke="currentColor" class="size-6">
                <path stroke-linecap="round" stroke-linejoin="round" d="M6 18 18 6M6 6l12 12"/>
            </svg>
        </button>
    </div>
    <form action="/cowork/admin/updateForfait" method="post" class="flex flex-col gap-2">
        <input type="hidden" id="id_forfait" name="id_forfait" value="<%= forfait.getId_forfait() %>">
        <label for="type">Type</label>
        <select name="type" id="type" class="border rounded-md p-1">
            <option value="co-working" <%= forfait.getType_espace().equals("co-working") ? "selected" : "" %>>
                Co-working
            </option>
            <option value="bureau-privé" <%= forfait.getType_espace().equals("bureau-privé") ? "selected" : "" %>>Bureau
                privé
            </option>
        </select>
        <label for="image">Image</label>
        <input type="text" name="image" id="image" class="border rounded-md p-1" value="<%= forfait.getImage_url() %>">
        <label for="label">Label</label>
        <input type="text" name="label" id="label" class="border rounded-md p-1" value="<%= forfait.getLabel() %>">
        <label for="description">Description</label>
        <textarea name="description" id="description" class="border rounded-md p-1"
                  style="max-height: 500px; min-height: 100px;"><%= forfait.getDescription() %></textarea>
        <label for="prix">Prix</label>
        <input type="number" name="prix" id="prix" class="border rounded-md p-1" value="<%= forfait.getPrix() %>">
        <label for="heure_deb">Heure de début</label>
        <input type="time" name="heure_deb" id="heure_deb" class="border rounded-md p-1"
               value="<%= forfait.getHeure_deb() %>">
        <label for="heure_fin">Heure de fin</label>
        <input type="time" name="heure_fin" id="heure_fin" class="border rounded-md p-1"
               value="<%= forfait.getHeure_fin() %>">
        <button type="submit" class="bg-[#FF6641] hover:bg-[#d16044] text-white font-semibold py-1 px-3 rounded-md">
            Enregistrer
        </button>
    </form>
</dialog>


<script>
    const modifierForfaitDialog<%= forfait.getId_forfait() %> = document.getElementById('modifierForfaitDialog<%= forfait.getId_forfait() %>');
    const modifierForfait<%= forfait.getId_forfait() %> = document.getElementById('gestionEspace<%= forfait.getId_forfait() %>');
    const closeModifierForfaitDialog<%= forfait.getId_forfait() %> = document.getElementById('closeModifierForfaitDialog<%= forfait.getId_forfait() %>');

    modifierForfait<%= forfait.getId_forfait() %>.addEventListener('click', () => {
        modifierForfaitDialog<%= forfait.getId_forfait() %>.showModal();
    });

    closeModifierForfaitDialog<%= forfait.getId_forfait() %>.addEventListener('click', () => {
        modifierForfaitDialog<%= forfait.getId_forfait() %>.close();
    });


    modifierForfaitDialog<%= forfait.getId_forfait() %>.addEventListener('close', () => {
        modifierForfaitDialog<%= forfait.getId_forfait() %>.querySelector('form').reset();
    });

    // close dialog when clicking outside
    modifierForfaitDialog<%= forfait.getId_forfait() %>.addEventListener('click', (e) => {
        if (e.target === modifierForfaitDialog<%= forfait.getId_forfait() %>) {
            modifierForfaitDialog<%= forfait.getId_forfait() %>.close();
        }
    });
</script>

<style>
    dialog::backdrop {
        background-color: rgba(0, 0, 0, 0.5);
    }
</style>