<%@ page import="java.sql.Connection" %>
<%@ page import="db.DatabaseConnection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="cowork.Salle" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="cowork.Equipement" %>
<%@ page import="cowork.Forfait" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="cowork.User" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // Récupérer les paramètres de l'URL
    String salleIdParam = (String) request.getAttribute("salleId");

    // Récupérer les paramètres de l'URL
    String messageParams = (String) request.getParameter("message");

    // Vérifier si l'ID est valide
    if (salleIdParam == null || !salleIdParam.matches("\\d+")) {
        throw new IllegalArgumentException("ID de salle invalide !");
    }

    int salleId = Integer.parseInt(salleIdParam); // Convertir en entier

    // Récupérer la connexion à la base de données
    Connection connection = DatabaseConnection.getInstance();
    PreparedStatement preparedStatement = null;
    ResultSet resultSalle = null;
    ResultSet resultEquipements = null;
    ResultSet resultForfaits = null;

    int id_user_logged = 0;

    User loggedInUser = (User) request.getSession().getAttribute("loggedInUser");
    if(loggedInUser != null){
        id_user_logged = loggedInUser.getId_user();
    }
    System.out.println(loggedInUser);

    try {
        // Requête SQL pour récupérer les salles
        String query = "SELECT * FROM salles WHERE id_salle = ?";

        // Préparer la requête
        preparedStatement = connection.prepareStatement(query);
        preparedStatement.setInt(1, salleId);

        // Exécuter la requête
        resultSalle = preparedStatement.executeQuery();

        // Vérifier si des résultats ont été trouvés
        if (!resultSalle.next()) {
            throw new Exception("Aucune salle trouvée avec l'ID : " + salleId);
        }

        // Récupérer les données de la salle
        int id_salle = resultSalle.getInt("id_salle");
        String label = resultSalle.getString("label");
        String type_espace = resultSalle.getString("type_espace");
        String description = resultSalle.getString("description");
        int capacite = resultSalle.getInt("capacite");
        String image_url = resultSalle.getString("image_url");

        // Récupérer les équipements associés à la salle
        String queryEquipements = "SELECT * FROM equipements WHERE id_equipement IN (SELECT id_equipement FROM salles_equipements WHERE id_salle = ?)";
        preparedStatement = connection.prepareStatement(queryEquipements);
        preparedStatement.setInt(1, id_salle);
        resultEquipements = preparedStatement.executeQuery();

        // Créer la liste des équipements
        ArrayList<Equipement> equipements = new ArrayList<>();

        while (resultEquipements.next()) {
            int id_equipement = resultEquipements.getInt("id_equipement");
            String label_equipement = resultEquipements.getString("label");

            equipements.add(new Equipement(id_equipement, label_equipement));
        }

        // Créer l'objet salle sélectionnée
        Salle selectedSalle = new Salle(id_salle, label, description,  type_espace, capacite, image_url, equipements.toArray(new Equipement[0]));

        // Passer les données à la JSP
        request.setAttribute("selectedSalle", selectedSalle);


        // Recuperer les forfaits de l'utilisateur connecté

        if(id_user_logged > 0){

            String queryForfaits = "Select * from forfaits where id_forfait in (Select id_forfait from users_forfaits where id_user = ?)";
            preparedStatement = connection.prepareStatement(queryForfaits);
            preparedStatement.setInt(1, id_user_logged);
            resultForfaits = preparedStatement.executeQuery();

            // Créer la liste des forfaits
            ArrayList<Forfait> forfaits = new ArrayList<>();

            // Parcourir les résultats
            while (resultForfaits.next()) {
                int id_forfait = resultForfaits.getInt("id_forfait");
                String label_forfait = resultForfaits.getString("label");
                String description_forfait = resultForfaits.getString("description");
                String type_espace_forfait = resultForfaits.getString("type_espace");
                String image_url_forfait = resultForfaits.getString("image_url");
                int prix_forfait = resultForfaits.getInt("prix");
                String heure_deb_forfait = resultForfaits.getString("heure_deb");
                String heure_fin_forfait = resultForfaits.getString("heure_fin");

                forfaits.add(new Forfait(id_forfait, label_forfait, description_forfait, type_espace_forfait, image_url_forfait, prix_forfait, heure_deb_forfait, heure_fin_forfait));
            }
            request.setAttribute("forfaits", forfaits);
        }



    } catch (Exception e) {
        e.printStackTrace();
        throw new ServletException("Erreur lors de la récupération des informations de la salle.", e);
    } finally {
        // Libérer les ressources
        if (resultEquipements != null) resultEquipements.close();
        if (resultSalle != null) resultSalle.close();
        if (preparedStatement != null) preparedStatement.close();
    }
%>

<%
    Salle selectedSalle = (Salle) request.getAttribute("selectedSalle");
    if (selectedSalle == null) {
        throw new IllegalArgumentException("Aucune salle sélectionnée n'a été trouvée !");
    }

    ArrayList<Forfait> forfaits = (ArrayList<Forfait>) request.getAttribute("forfaits");
    String forfaitsJson = new Gson().toJson(forfaits);
%>

<div class="w-full flex flex-col items-center my-10">
    <% if (messageParams != null) { %>
    <div class="w-full max-w-[1300px] bg-green-500 text-white text-center p-2 rounded-md mb-4">
        <%= messageParams %>
    </div>
    <% } %>
    <div class="w-full max-w-[1300px] flex flex-col-reverse gap-4 sm:gap-0 sm:flex-row justify-center">
        <div class="w-full sm:w-7/12 flex flex-col gap-4">
<h1 class="text-2xl font-semibold"><%= selectedSalle.getLabel() %></h1>
<p class="text-black/70"><%= selectedSalle.getType_espace() %></p>
<p>Voir les disponibilités :</p>

<%
    if (loggedInUser != null) {
        if (!forfaits.isEmpty()) {
%>
            <form class="w-full flex flex-col gap-2" action="${pageContext.request.contextPath}/SubmitReservation" method="post">
                <label>Forfait :</label>
                <select name="forfaitId" id="selectForfaitId" class="bg-[#F0F0F0] border-[1px] border-[#CACACA] w-full h-[40px]">
                    <% for (Forfait forfait : forfaits) { %>
                    <option class="bg-white text-cow_text" value="<%= forfait.getId_forfait() %>"><%= forfait.getLabel() %></option>
                    <% } %>
                </select>
                <p class="text-red-500 hidden" id="unauthorized_forfait">Votre forfait actuel ne vous permet pas de réserver ce type de salle.</p>
                <label id="label_input_date">Date :</label>
                <input id="date" type='date' name='date' class="ps-2 bg-[#F0F0F0] border-[1px] border-[#CACACA] w-full h-[40px]">
                <div id="time-selector" class="time-selector hidden">
                    <label>Heures :</label>
                    <div class="time-list"></div> <!-- Les heures sont générées ici -->
                </div>
                <input type='datetime-local' id="timestampDeb" name='timestampDeb' class="hidden ps-2 bg-[#F0F0F0] border-[1px] border-[#CACACA] w-full h-[40px]">
                <input type='datetime-local' id="timestampFin" name='timestampFin' class="hidden ps-2 bg-[#F0F0F0] border-[1px] border-[#CACACA] w-full h-[40px]">
                <input type='text' class="hidden" id="salleId" name='salleId' value="<%= selectedSalle.getId_salle() %>">
                <input type='text' class="hidden" id="userId" name='userId' value="<%= id_user_logged %>">
                <button disabled name='salle-reserver' type="submit" class='bg-cow_secondary disabled:bg-cow_secondary/50 w-full rounded-sm text-white px-4 py-2 font-semibold '>
                    Réserver
                </button>
            </form>
<%
        } else {
%>
            <p class="text-red-500 font-medium">Vous n'avez souscrit à aucun forfait vous permettant de réserver cette salle.</p>
<%
        }
    } else {
%>
    <p class="text-red-500 font-medium">Vous devez être connecté pour réserver un espace.</p>
<%
    }
%>
            <h3 class="font-semibold">Description</h3>
            <p><%= selectedSalle.getDescription().replace("\n", "<br>")%></p>
            <h3 class="font-semibold">Équipements</h3>
            <div class="flex w-full items-center flex-wrap gap-2">
                <% for (Equipement equipement : selectedSalle.getEquipements()) { %>
                <span class="text-sm bg-gray-300 rounded-full px-2 whitespace-nowrap"><%= equipement.getLabel() %></span>
                <% } %>
            </div>
        </div>
        <div class="hidden sm:block w-1/12 "></div>
        <div class="w-full sm:w-4/12 flex flex-col">
            <div class="w-full bg-gray-100 rounded-lg overflow-hidden aspect-square">
                <img src="<%= selectedSalle.getImage_url() %>" alt="salle" class="w-full h-full object-cover">
            </div>
        </div>
    </div>
</div>


<style>
    .time-selector {
        margin-top: 0.5rem;
        font-family: Arial, sans-serif;
    }

    label {
        font-size: 1rem;
        display: block;
        margin-bottom: 10px;
    }

    .time-list {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 10px;
    }

    .time-item {
        padding: 10px;
        background-color: #f0f0f0;
        text-align: center;
        border: 1px solid #ddd;
        border-radius: 5px;
        cursor: pointer;
        user-select: none;
    }

    .time-item.selected {
        background-color: #FF6641;
        color: white;
    }

    .time-item.range {
        background-color: #FF6641;
        color: white;
    }

    .selected-time {
        margin-top: 20px;
        font-size: 1.2rem;
        text-align: center;
    }

    .time-item.disabled {
        background-color: #e0e0e0;
        color: #aaa;
        pointer-events: none; /* Empêche toute interaction */
        cursor: not-allowed;
    }
</style>

<script type="text/javascript">

    const forfaitsJson = <%= forfaitsJson %>;

    // Initialisation
    let bookedSlots = [];
    let isSelecting = false;
    let startTime = null;
    let endTime = null;

    attachEvents();

    const getReservationsDates = async (date) => {
        const res = await fetch('getReservationsFromDate?date=' + date);
        const data = await res.json();
        bookedSlots = data.map(date => ({
            from: new Date(date.timestampDeb).toTimeString().slice(0, 5),
            to: new Date(date.timestampFin).toTimeString().slice(0, 5)
        }));
        attachEvents()
    }

    const isForfaitAuthorized = async () => {
        //find the selected forfait by searching in forfaitsJson
        const forfait = forfaitsJson.find(forfait => forfait.id_forfait.toString() === document.getElementById("selectForfaitId").value.toString());
        if (!forfait) {
            console.error("Forfait non trouvé avec l'ID : " + forfaitId);
            return;
        }
        if(forfait.type_espace !== "<%= selectedSalle.getType_espace()%>"){
            document.getElementById("unauthorized_forfait").classList.remove("hidden");
            document.getElementById("date").value = null;
            document.getElementById("date").classList.add("hidden");
            document.getElementById("label_input_date").classList.add("hidden");
        }else{
            document.getElementById("unauthorized_forfait").classList.add("hidden");
            document.getElementById("date").classList.remove("hidden");
            document.getElementById("label_input_date").classList.remove("hidden");
        }
    }
    isForfaitAuthorized()

    function updateTimeCalandar () {
        // reset the selected time
        startTime = null;
        endTime = null;
        document.getElementById('timestampDeb').value = "";
        document.getElementById('timestampFin').value = "";
        updateDisbleSubmitButton()
        // hide the time selector
        document.getElementById("time-selector").classList.add("hidden");

        // if there is no date or if the date is invalid or if the date year is < to doday year  , do nothing
        if(!document.getElementById("date").value || isNaN(Date.parse(document.getElementById("date").value)) || new Date().getFullYear() > new Date(document.getElementById("date").value).getFullYear() || new Date(document.getElementById("date").value).getFullYear().toString().length > 4) {
            return;
        }
        const forfaitId = document.getElementById("selectForfaitId").value;
        if(!forfaitId) {
            console.error("Forfait non trouvé avec l'ID : " + forfaitId);
            return;
        }
        //find the selected forfait by searching in forfaitsJson
        const forfait = forfaitsJson.find(forfait => forfait.id_forfait.toString() === forfaitId.toString());
        if (!forfait) {
            console.error("Forfait non trouvé avec l'ID : " + forfaitId);
            return;
        }

        const timStart = forfait.heure_deb.split(":").slice(0, 2).join(":");
        const timEnd = forfait.heure_fin.split(":").slice(0, 2).join(":");
        getReservationsDates(document.getElementById("date").value);
        generateTimeItems(timStart, timEnd);
    }

    document.getElementById("date").addEventListener("change", updateTimeCalandar);
    updateTimeCalandar();

    document.getElementById("selectForfaitId").addEventListener("change", function () {
        document.getElementById("date").value = null;
        updateTimeCalandar();
        updateDisbleSubmitButton();
        isForfaitAuthorized();
    });

    // Ajouter les événements après génération des éléments
    function attachEvents() {
        const timeItems = document.querySelectorAll('.time-item');

        // Réinitialiser la sélection
        function resetSelection() {
            timeItems.forEach(item => {
                item.classList.remove('selected', 'range');
            });
            startTime = null;
            endTime = null;
            document.getElementById('timestampDeb').value = "";
            document.getElementById('timestampFin').value = "";
        }

        // Désactiver les plages occupées
        function disableBookedSlots() {
            timeItems.forEach(item => {
                const time = item.dataset.time;
                // Vérifie si l'heure fait partie d'une plage occupée
                const isBooked = bookedSlots.some(slot => time >= slot.from && time <= slot.to);
                if (isBooked) {
                    item.classList.add('disabled');
                    item.setAttribute('disabled', 'true');
                }
            });
        }

        // Mettre à jour les plages sélectionnées
        function updateRange() {
            timeItems.forEach(item => {
                const time = item.dataset.time;
                if (
                    startTime &&
                    endTime &&
                    time >= startTime &&
                    time <= endTime &&
                    !item.classList.contains('disabled')
                ) {
                    item.classList.add('range');
                } else {
                    item.classList.remove('range');
                }
            });
        }

        // Ajouter les événements pour chaque item
        timeItems.forEach(item => {
            item.addEventListener('mousedown', () => {
                if (item.classList.contains('disabled')) return;
                resetSelection();
                isSelecting = true;
                startTime = item.dataset.time;

                const forwardLimit = findBoundary(1, startTime);
                const backwardLimit = findBoundary(-1, startTime);

                item.setAttribute('data-min', backwardLimit);
                item.setAttribute('data-max', forwardLimit);

                item.classList.add('selected');

               // get the date from the input with id "date" and merge as datetime-local yyyy-MM-ddThh:mm the date and the time and apply it as value to the input with id "timestampDeb"
                const date = document.getElementById("date").value;
                const timestampDeb = date + "T" + startTime;
                document.getElementById("timestampDeb").value = timestampDeb;
                //     reset the input with id "timestampFin" to empty
                document.getElementById("timestampFin").value = "";
                updateDisbleSubmitButton()
            });

            item.addEventListener('mouseenter', () => {
                if (isSelecting && startTime) {
                    const time = item.dataset.time;

                    const minTime = findBoundary(-1, startTime);
                    const maxTime = findBoundary(1, startTime);

                    if (time >= minTime && time <= maxTime && !item.classList.contains('disabled')) {
                        endTime = time;
                        updateRange();
                        // get the date from the input with id "date" and merge as datetime-local yyyy-MM-ddThh:mm the date and the time and apply it as value to the input with id "timestampFin"
                        const date = document.getElementById("date").value;
                        const timestampFin = date + "T" + endTime;
                        document.getElementById("timestampFin").value = timestampFin;
                        updateDisbleSubmitButton()
                    }
                }
            });

            item.addEventListener('mouseup', () => {
                if (startTime && endTime) {
                    isSelecting = false;
                }
            });
        });

        // Empêche les clics ou actions en dehors de la liste
        document.addEventListener('mouseup', () => {
            isSelecting = false;
        });

        disableBookedSlots();
    }

    // Trouver la limite de glissement (avant ou arrière)
    function findBoundary(direction, currentTime) {
        const timeArray = Array.from(document.querySelectorAll('.time-item'));
        const currentIndex = timeArray.findIndex(item => item.dataset.time === currentTime);

        for (let i = currentIndex + direction; i >= 0 && i < timeArray.length; i += direction) {
            const item = timeArray[i];
            if (item.classList.contains('disabled')) {
                return item.dataset.time;
            }
        }

        return direction > 0 ? "20:00" : "08:00";
    }

    // Génère les éléments HTML pour les heures avec des steps de 30 minutes
    function generateTimeItems(heure_min, heure_max) {
        document.getElementById("time-selector").classList.remove("hidden");
        const timeListContainer = document.querySelector('.time-list');
        timeListContainer.innerHTML = ""; // Nettoyer le conteneur

        let currentHour = heure_min;

        while (currentHour <= heure_max) {
            const timeItem = document.createElement('div');
            timeItem.classList.add('time-item');
            timeItem.dataset.time = currentHour;
            timeItem.textContent = currentHour;
            timeListContainer.appendChild(timeItem);

            // Incrémenter de 30 minutes
            const [hours, minutes] = currentHour.split(':').map(Number);
            const nextStep = new Date(0, 0, 0, hours, minutes + 30); // Ajouter 30 minutes
            currentHour = nextStep.toTimeString().slice(0, 5); // Formater HH:MM
        }
    }

    function setDisableSubmitButton(isDisabled) {
        const submitButton = document.querySelector('button[name="salle-reserver"]');
        submitButton.disabled = isDisabled;
    }

    function updateDisbleSubmitButton() {
        // if the timestampDeb.value is null set disable submit button, if timestampFin.value is null set disable submit button, if timestampDeb.value is > timestampFin.value set disable submit button, if date are not correct set disable submit button, if the year of both dates are < today's year set disable submit button, otherwise enable submit button
        const timestampDeb = document.getElementById("timestampDeb").value;
        const timestampFin = document.getElementById("timestampFin").value;
        if (timestampDeb === null) {
            setDisableSubmitButton(true);
        } else if (timestampFin === null) {
            setDisableSubmitButton(true);
        } else if (timestampDeb > timestampFin) {
            setDisableSubmitButton(true);
        } else if (timestampDeb.substring(0, 4) < new Date().getFullYear()) {
            setDisableSubmitButton(true);
        } else {
            setDisableSubmitButton(false);
        }
    }


</script>
