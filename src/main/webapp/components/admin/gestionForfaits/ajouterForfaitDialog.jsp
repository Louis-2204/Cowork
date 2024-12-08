<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<dialog id="ajouterForfaitDialog" class="md:w-1/2 sm:w-3/4 w-11/12 max-w-[650px] bg-white p-5 rounded-md transition-all duration-300">
    <div class="flex w-full justify-between">
        <h1 class="text-2xl font-semibold pb-2">Ajouter un forfait</h1>
        <button id="closeAjouterForfaitDialog" class="text-xl font-semibold hover:bg-gray-200 rounded-full p-1 w-9 h-9 flex items-center justify-center">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
                <path stroke-linecap="round" stroke-linejoin="round" d="M6 18 18 6M6 6l12 12" />
            </svg>
        </button>
    </div>
    <form action="/cowork/admin/insertForfait" method="post" class="flex flex-col gap-2">
        <label for="type">Type</label>
        <select name="type" id="type" class="border rounded-md p-1">
            <option value="co-working">
                Co-working
            </option>
            <option value="bureau-privé">Bureau
                privé
            </option>
        </select>
        <label for="image">Image</label>
        <input type="text" name="image" id="image" class="border rounded-md p-1">
        <label for="label">Label</label>
        <input type="text" name="label" id="label" class="border rounded-md p-1">
        <label for="description">Description</label>
        <textarea name="description" id="description" class="border rounded-md p-1"
                  style="max-height: 500px; min-height: 100px;"></textarea>
        <label for="prix">Prix</label>
        <input type="number" name="prix" id="prix" class="border rounded-md p-1">
        <label for="heure_deb">Heure de début</label>
        <input type="time" name="heure_deb" id="heure_deb" class="border rounded-md p-1">
        <label for="heure_fin">Heure de fin</label>
        <input type="time" name="heure_fin" id="heure_fin" class="border rounded-md p-1">
        <button type="submit" class="bg-[#FF6641] hover:bg-[#d16044] text-white font-semibold py-1 px-3 rounded-md">
            Enregistrer
        </button>
    </form>
</dialog>



<script>
    const ajouterForfaitDialog = document.getElementById('ajouterForfaitDialog');
    const ajouterForfait = document.getElementById('ajouterForfait');
    const closeAjouterForfaitDialog = document.getElementById('closeAjouterForfaitDialog');

    ajouterForfait.addEventListener('click', () => {
        ajouterForfaitDialog.showModal();
    });

    closeAjouterForfaitDialog.addEventListener('click', () => {
        ajouterForfaitDialog.close();
    });
    

    ajouterForfaitDialog.addEventListener('close', () => {
        ajouterForfaitDialog.querySelector('form').reset();
    });

    // close dialog when clicking outside
    ajouterForfaitDialog.addEventListener('click', (e) => {
        if (e.target === ajouterForfaitDialog) {
            ajouterForfaitDialog.close();
        }
    });
</script>

<style>
    dialog::backdrop {
        background-color: rgba(0, 0, 0, 0.5);
    }
</style>