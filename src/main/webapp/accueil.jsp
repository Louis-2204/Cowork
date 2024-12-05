<%@ page import="java.sql.Connection" %>
<%@ page import="db.DatabaseConnection" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.util.ArrayList" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%

    // Récupérer la connexion à la base de données
    Connection connection = DatabaseConnection.getInstance();
    PreparedStatement preparedStatement = null;
    ResultSet resultTypesEspaces = null;

    try {

        // Requête SQL pour récupérer les type_espace
        String queryTypesEspaces = "SELECT distinct type_espace FROM salles";
        preparedStatement = connection.prepareStatement(queryTypesEspaces);
        resultTypesEspaces = preparedStatement.executeQuery();

        // Créer la liste des types d'espaces
        ArrayList<String> typesEspaces = new ArrayList<>();

        // Parcourir les résultats
        while (resultTypesEspaces.next()) {
            String type_espace = resultTypesEspaces.getString("type_espace");
            typesEspaces.add(type_espace);
        }

        // Passer les types à la JSP
        request.setAttribute("typesEspaces", typesEspaces);


    } catch (Exception e) {
        e.printStackTrace();
        throw new ServletException("Erreur lors de la récupération des données.", e);
    } finally {
        if (resultTypesEspaces != null) resultTypesEspaces.close();
        if (preparedStatement != null) preparedStatement.close();
    }
%>
<% ArrayList<String> typesEspaces = (ArrayList<String>) request.getAttribute("typesEspaces"); %>

<div class="w-full h-[calc(100svh-56px)] bg-cow_bg_dark flex justify-center">
    <div class="w-full max-w-[1300px] flex flex-col gap-4 items-center justify-center text-white relative">
        <img src="assets/illu.png" class='absolute opacity-10' alt="illustration">
        <div class="z-10 flex flex-col items-center justify-center gap-4">
            <h1 class='text-3xl md:text-5xl font-bold text-center'>Co-Working. Réunions. Brainstorming.</h1>
            <p>Louer le lieu idéal en quelques cliques.</p>
            <form method="post" action="${pageContext.request.contextPath}/SearchNosEspaces">
                <div class="flex flex-col w-[calc(100svw-100px)] md:w-auto md:flex-row items-center gap-1 p-1 rounded-md bg-white/40 mt-12">
                <select name="type" class="bg-white/30 text-white ps-2 w-full md:w-auto h-[40px]">
                    <option class="bg-white text-cow_text" <%=typesEspaces.isEmpty() ? "selected" : "" %> value="%">Tous</option>
                    <% for (String type_espace : typesEspaces) { %>
                    <%--            if type_espace === type then display an option tag with the selected attribute set to selected otherwise display an option tag without the selected attribute--%>
                    <option class="bg-white text-cow_text" value="<%= type_espace %>"><%= type_espace %></option>
                    <% } %>
                </select>
                <input type='date' name='date' class="bg-white/30 text-white ps-2 w-full h-[40px]">
                <input type='time' name='timeDeb' class="bg-white/30 text-white ps-2 w-full h-[40px]">
                <input type='time' name='timeFin' class="bg-white/30 text-white ps-2 w-full h-[40px]">
                <button name='accueil-submit' type="submit" class='bg-cow_secondary w-full rounded-sm text-white px-4 py-2 font-semibold '>
                    Rechercher
                </button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class='w-full bg-black/20 flex justify-center py-10'>
    <div class='flex flex-col w-full max-w-[1300px] items-center justify-center gap-10'>
        <h2 class='text-2xl md:text-4xl text-cow_text font-bold'>Nos partenaires</h2>
        <div class='flex items-center justify-around w-full max-w-[700px]'>
            <img src="https://img.icons8.com/?size=512&id=17949&format=png" class='w-16' alt="google">
            <img src="https://companieslogo.com/img/orig/NVDA-220e1e03.png?t=1722952498" class='w-16' alt="nvidia">
            <img src="https://cdn.jim-nielsen.com/ios/512/duolingo-2019-01-02.png?rf=1024" class='w-16' alt="duolingo">
            <img src="https://freelogopng.com/images/all_img/1656152266logo-twitch.png" class='w-16' alt="twitch">
        </div>
    </div>
</div>

<div class='flex w-full justify-center'>
    <div class='flex flex-col w-full max-w-[1300px] items-center jusitfy-center'>
        <div class='flex flex-col items-center w-full py-10 gap-12'>
            <h2 class='text-xl md:text-3xl text-cow_text font-bold'><u class='text-cow_secondary'>Tout</u> ce qu'il vous
                faut</h2>
            <div class='flex flex-col gap-6 md:gap-0 md:flex-row flex-wrap items-center justify-around w-full'>

                <div class='flex items-center'>
                    <div class='flex flex-col w-[280px] h-[280px] overflow-hidden rounded-md bg-white border rounded-md'>
                        <div class='h-[240px] w-full overflow-hidden'>
                            <img src="https://image.workin.space/wijpeg-dmzei97hlpgu47xqnpmbac0js/wojo-lyon-grand-hotel-coworking-lyon-0002-standard_standard.jpg?crop=0%2C0%2C1777%2C1333"
                                 class='object-cover h-full' alt="twitch">
                        </div>
                        <div class='flex items-center justify-center h-[40px]'>
                            <p class='font-semibold'>Espace de co-working</p>
                        </div>
                    </div>
                </div>
                <div class='flex items-center'>
                    <div class='flex flex-col w-[280px] h-[280px] overflow-hidden rounded-md bg-white border rounded-md'>
                        <div class='h-[240px] w-full overflow-hidden'>
                            <img src="https://www.laradiodesentreprises.com/wp-content/uploads/2022/02/_x_amenagement-salle-de-reunion.jpeg"
                                 class='object-cover h-full' alt="twitch">
                        </div>
                        <div class='flex items-center justify-center h-[40px]'>
                            <p class='font-semibold'>Salles de réunion</p>
                        </div>
                    </div>
                </div>
                <div class='flex items-center'>
                    <div class='flex flex-col w-[280px] h-[280px] overflow-hidden rounded-md bg-white border rounded-md'>
                        <div class='h-[240px] w-full overflow-hidden'>
                            <img src="https://www.flokk.com/hubfs/The%20New%20Office/013-1.jpg"
                                 class='object-cover w-full h-full' alt="twitch">
                        </div>
                        <div class='flex items-center justify-center h-[40px]'>
                            <p class='font-semibold'>Espace de concentration</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class='flex flex-col md:flex-row p-2 md:py-10 items-center justify-center w-full gap-4 '>
            <p class='font-medium text-lg'>Présent depuis 5 ans, CoWork <strong class='text-cow_secondary'> réinvente le
                concept de coworking </strong> en facilitant les échanges entre professionnels et particuliers.
                Notre mission est de transformer les espaces de travail en véritables hubs de collaboration, où
                innovation et créativité se rencontrent. Que vous soyez <strong class='text-cow_secondary'>
                    entrepreneur, freelance, ou étudiant </strong> , CoWork vous propose un environnement flexible et
                dynamique, adapté à vos besoins.</p>
            <div class='w-4/6 aspect-square bg-gray-400 rounded-full overflow-hidden'>
                <img src="https://image.workin.space/wipng-81r1p88bxp4qdi5gazrj047ti/coworking-amenagement.png"
                     class='object-cover h-full' alt="twitch">
            </div>
        </div>
    </div>

</div>


<div class='w-full bg-cow_bg_dark flex justify-center overflow-hidden my-20'>
    <div class='w-full flex flex-col gap-6 items-center justify-center max-w-[1300px] py-10 relative'>
        <h3 class='text-xl md:text-2xl text-white font-bold'>Truster par plus de 700 utilisateurs !</h3>
        <img src="https://cdn.prod.website-files.com/653808c6aad5b33f7627afd4/653fc6adf24a0e228d43f3ba_trust_pilot.png"
             class='w-1/4' alt="trustpilot 5 stars">

        <div class='w-[50px] md:w-[110px] h-[50px] md:h-[110px] rounded-full bg-cow_secondary/30 absolute -top-3 left-[17%]'></div>
        <div class='w-[50px] md:w-[110px] h-[50px] md:h-[110px] rounded-full bg-white/20 absolute -bottom-1 -left-[2%]'></div>
        <div class='w-[50px] md:w-[110px] h-[50px] md:h-[110px] rounded-full bg-cow_secondary/30 absolute -top-1 right-[3%]'></div>
        <div class='w-[50px] md:w-[110px] h-[50px] md:h-[110px] rounded-full bg-white/20 absolute -bottom-5 right-[13%]'></div>
    </div>
</div>
