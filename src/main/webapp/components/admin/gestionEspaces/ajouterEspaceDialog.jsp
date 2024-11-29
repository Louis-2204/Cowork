<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<dialog id="ajouterEspaceDialog" class="md:w-1/2 sm:w-3/4 w-11/12 max-w-[650px] bg-white p-5 rounded-md transition-all duration-300">
    <div class="flex w-full justify-between">
        <h1 class="text-2xl font-semibold pb-2">Ajouter un espace</h1>
        <button id="closeAjouterEspaceDialog" class="text-xl font-semibold hover:bg-gray-200 rounded-full p-1 w-9 h-9 flex items-center justify-center">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
                <path stroke-linecap="round" stroke-linejoin="round" d="M6 18 18 6M6 6l12 12" />
            </svg>
        </button>
    </div>
    <form action="" method="post" class="flex flex-col gap-2">
        <label for="type">Type</label>
        <select name="type" id="type" class="border rounded-md p-1">
            <option value="open_space">Open space</option>
            <option value="bureau">Bureau</option>
            <option value="salle_reunion">Salle de réunion</option>
        </select>
        <label for="image">Image</label>
        <input type="text" name="image" id="image" class="border rounded-md p-1">
        <label for="nom">Nom</label>
        <input type="text" name="nom" id="nom" class="border rounded-md p-1">
        <label for="prix">Prix</label>
        <input type="number" name="prix" id="prix" class="border rounded-md p-1">
        <label for="capacite">Capacité</label>
        <input type="number" name="capacite" id="capacite" class="border rounded-md p-1">
        <label for="equipements">Équipements</label>
        <input type="text" name="equipements" id="equipements" class="border rounded-md p-1">
        <button type="submit" class="bg-[#FF6641] hover:bg-[#d16044] text-white font-semibold py-1 px-3 rounded-md">
            Ajouter
        </button>
    </form>
</dialog>



<script>
    const ajouterEspaceDialog = document.getElementById('ajouterEspaceDialog');
    const ajouterEspace = document.getElementById('ajouterEspace');
    const closeAjouterEspaceDialog = document.getElementById('closeAjouterEspaceDialog');

    ajouterEspace.addEventListener('click', () => {
        ajouterEspaceDialog.showModal();
    });

    closeAjouterEspaceDialog.addEventListener('click', () => {
        ajouterEspaceDialog.close();
    });
    

    ajouterEspaceDialog.addEventListener('close', () => {
        ajouterEspaceDialog.querySelector('form').reset();
    });

    // close dialog when clicking outside
    ajouterEspaceDialog.addEventListener('click', (e) => {
        if (e.target === ajouterEspaceDialog) {
            ajouterEspaceDialog.close();
        }
    });
</script>

<style>
    dialog::backdrop {
        background-color: rgba(0, 0, 0, 0.5);
    }
</style>