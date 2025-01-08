<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="cowork.User" %>
<%
    User user = (User) request.getSession().getAttribute("loggedInUser");
%>
<!DOCTYPE html>
<html lang="en" class='w-full h-full'>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle}</title>
    <link rel="stylesheet" href="./index.css">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        cow_bg_light: '#F7F7F9',
                        cow_bg_dark: '#141518',
                        cow_text: '#121212',
                        cow_secondary: '#FF6641'
                    }
                }
            }
        }
    </script>
</head>
<body class='flex flex-col w-full justify-center bg-[#F7F7F9]'>
<header class='w-full flex flex-col items-center bg-white sticky top-0 z-50'>
    <nav class='w-full max-w-[1300px] flex flex-col md:flex-row items-center p-2 h-[56px]'>
        <div class="relative bg-transparent w-full h-full md:w-3/12 flex justify-center md:justify-start items-center">
            <p class='text-2xl font-bold text-cow_text !m-0'>CoWork</p>
            <button class="md:hidden absolute right-0" onclick="toggleMenu()">
                <svg id="buttonMenuOpen" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
                     stroke-width="1.5" stroke="currentColor" class="h-7 w-7 text-cow_text">
                    <path stroke-linecap="round" stroke-linejoin="round"
                          d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5"/>
                </svg>
                <svg id="buttonMenuClose" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
                     stroke-width="1.5" stroke="currentColor" class="h-7 w-7 text-cow_text hidden">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M6 18 18 6M6 6l12 12"/>
                </svg>
            </button>
        </div>
        <div class="w-full md:w-9/12 flex flex-col md:flex-row items-center justify-center md:justify-between gap-2 h-0 md:h-auto overflow-hidden md:overflow-visible">
            <div class="w-full md:w-6/12 min-w-fit">
                <ul class='list-none flex flex-col md:flex-row gap-6 items-center justify-end text-base !m-0'>
                    <li class="hover:bg-gray-200 rounded-md">
                        <a class="w-full p-2 flex justify-center items-center text-black no-underline"
                           href="/cowork/accueil">Accueil</a>
                    </li>
                    <li class="hover:bg-gray-200 rounded-md">
                        <a class="w-full p-2 flex justify-center items-center text-black no-underline"
                           href="/cowork/nos-espaces?type=%25&dateDeb=&dateFin=">Espaces</a>
                    </li>
                    <li class="hover:bg-gray-200 rounded-md">
                        <a class="w-full p-2 flex justify-center items-center text-black no-underline"
                           href="/cowork/nos-forfaits">Forfaits</a>
                    </li>
                    <li class="hover:bg-gray-200 rounded-md">
                        <a class="w-full p-2 flex justify-center items-center text-black no-underline"
                           href="/cowork/forum">Forum</a>
                    </li>
                    <li class="hover:bg-gray-200 rounded-md">
                        <a class="w-full p-2 flex justify-center items-center text-black no-underline"
                           href="/cowork/FAQ">FAQ</a>
                    </li>
                </ul>
            </div>
            <div class="w-full md:w-fit flex justify-end items-center relative">
                <% if (user == null) { %>
                <a class='bg-orange-400 w-full md:w-auto rounded-sm text-white px-4 py-2 font-semibold text-center'
                   href="/cowork/login">
                    Connexion
                </a>
                <% } else { %>
                <button class="w-8 h-8 rounded-full bg-gray-400" onclick="togglePop()"></button>
                <div id="popover" class="absolute top-12 right-0 bg-white shadow-lg rounded-md p-4 hidden w-[175px]">
                    <ul class="mt-2 flex flex-col gap-1">
                        <% if (user.getIs_admin()) { %>
                        <li><a href="/cowork/admin/annuaire-client" class="text-purple-500 hover:underline">Annuaire des
                            clients</a></li>
                        <li><a href="/cowork/admin/gestion-espaces" class="text-purple-500 hover:underline">Gestion des
                            espaces</a></li>
                        <li><a href="/cowork/admin/gestion-forfaits" class="text-purple-500 hover:underline">Gestion des
                            forfaits</a></li>
                        <li><a href="/cowork/admin/statistiques"
                               class="text-purple-500 hover:underline">Statistiques</a>
                                <% } %>
                        <li><a href="/cowork/mes-reservations" class="text-blue-500 hover:underline">Mes
                            réservations</a></li>
                        <li><a href="/cowork/factures" class="text-blue-500 hover:underline">Mes factures</a></li>
                        <li><a href="/cowork/logout" class="text-red-500 hover:underline">Déconnexion</a></li>
                    </ul>
                </div>
                <% } %>
            </div>
        </div>
    </nav>

    <div id="menu-sm"
         class="w-full flex flex-col md:flex-row items-center justify-center md:justify-between gap-2 h-0 overflow-hidden">
        <div class="w-full md:w-6/12 ">
            <ul class='list-none flex flex-col md:flex-row gap-2 items-center justify-center text-base'>
                <li class="w-full hover:bg-gray-200 rounded-sm">
                    <a class="w-full p-2 flex justify-center items-center"
                       href="${pageContext.request.contextPath}/accueil">Accueil</a>
                </li>
                <li class="w-full hover:bg-gray-200 rounded-sm">
                    <a class="w-full p-2 flex justify-center items-center" href="nos-espaces">Espaces</a>
                </li>
                <li class="w-full hover:bg-gray-200 rounded-sm">
                    <a class="w-full p-2 flex justify-center items-center"
                       href="${pageContext.request.contextPath}/forum">Forum</a>
                </li>
                <li class="w-full hover:bg-gray-200 rounded-sm">
                    <a class="w-full p-2 flex justify-center items-center"
                       href="${pageContext.request.contextPath}/FAQ">FAQ</a>
                </li>
            </ul>
        </div>
        <div class="w-full md:w-3/12 flex flex-col justify-end items-center">
            <% if (user == null) { %>
            <button class='bg-orange-400 w-full md:w-auto rounded-sm text-white px-4 py-2 font-semibold '>
                <a href="${pageContext.request.contextPath}/login">
                    Se connecter
                </a>
            </button>
            <% } else { %>
            <ul class="w-full flex flex-col gap-1">
                    <% if (user.getIs_admin()) { %>
                <li class="w-full hover:bg-gray-200 rounded-sm">
                    <a href="/cowork/admin/annuaire-client"
                       class="w-full text-purple-500 p-2 flex justify-center items-center">Annuaire des
                        clients</a>
                </li>
                <li class="w-full hover:bg-gray-200 rounded-sm">
                    <a href="/cowork/admin/gestion-espaces"
                       class="w-full text-purple-500 p-2 flex justify-center items-center">Gestion des
                        espaces</a>
                </li>
                <li class="w-full hover:bg-gray-200 rounded-sm">
                    <a href="/cowork/admin/gestion-forfaits"
                       class="w-full text-purple-500 p-2 flex justify-center items-center">Gestion des
                        forfaits</a>
                </li>
                <li class="w-full hover:bg-gray-200 rounded-sm">
                    <a href="/cowork/admin/statistiques"
                       class="w-full text-purple-500 p-2 flex justify-center items-center">Statistiques</a>
                        <% } %>
                <li class="w-full hover:bg-gray-200 rounded-sm">
                    <a href="/cowork/mes-reservations"
                       class="w-full p-2 text-blue-500 flex justify-center items-center">Mes réservations</a>
                </li>
                <li class="w-full hover:bg-gray-200 rounded-sm">
                    <a href="/cowork/factures"
                       class="w-full p-2 text-blue-500 flex justify-center items-center">Mes factures</a>
                </li>
                <li class="w-full hover:bg-gray-200 rounded-sm">
                    <a href="/cowork/logout" class="w-full p-2 text-red-500 flex justify-center items-center">Déconnexion</a>
                </li>
                    <% } %>
        </div>
    </div>
</header>

<main class='w-full flex flex-col items-center'>
    <jsp:include page="${pageContent}"/>
</main>
<div class='flex w-full justify-center bg-white'>
    <footer class='w-full max-w-[1300px] py-10 flex flex-col md:flex-row items-center justify-around'>
        <div class='flex flex-col w-full md:w-auto items-center md:items-start gap-2 font-semibold text-cow_text'>
            <p>© 2024 CoWork. Tous droits réservés.</p>
            <p>123 Rue des Entrepreneurs, 75000 Paris, France</p>
            <p>Email : contact@cowork.com </p>
            <p>Téléphone : +33 1 23 45 67 89</p>
        </div>
        <div class='flex flex-col w-full md:w-auto items-center md:items-start gap-2 font-semibold text-cow_text'>
            <p>Mentions légales</p>
            <p>Politique de cookies</p>
            <p>Conditions générales d’utilisation (CGU)</p>
            <p>Politique de confidentialité</p>
        </div>
    </footer>
</div>
</body>

<script>
    function toggleMenu() {
        const menu = document.getElementById('menu-sm');
        const buttonMenuOpen = document.getElementById('buttonMenuOpen');
        const buttonMenuClose = document.getElementById('buttonMenuClose');
        if (menu.classList.contains('h-0')) {
            menu.classList.remove('h-0');
            menu.style.height = 'auto';
            buttonMenuOpen.classList.add('hidden');
            buttonMenuClose.classList.remove('hidden');
        } else {
            menu.classList.add('h-0');
            menu.style.height = '0px';
            buttonMenuOpen.classList.remove('hidden');
            buttonMenuClose.classList.add('hidden');
        }
    }

    function togglePop() {
        console.log('toggle');
        const popover = document.getElementById('popover');
        if (popover.classList.contains('hidden')) {
            popover.classList.remove('hidden');
        } else {
            popover.classList.add('hidden');
        }
    }
</script>

</html>