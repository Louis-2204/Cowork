<%--
  Created by IntelliJ IDEA.
  User: Neal
  Date: 12/1/2024
  Time: 7:29 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<main class="flex-grow flex items-center justify-center bg-gray-100 min-h-screen w-1/3">
  <div class="w-full max-w-md bg-white rounded-lg shadow-md p-6 mb-20 my-20">
    <form action="#" method="POST">

      <!-- Nom -->
      <div class="mb-4">
        <label for="nom" class="block text-sm font-medium text-gray-700">Nom</label>
        <input type="text" id="nom" name="nom" class="block w-full rounded-md bg-gray-200 px-3 py-1.5 text-base text-gray-500 outline outline-1 -outline-offset-1 outline-gray-300 placeholder:text-gray-400 focus:outline-2 focus:-outline-offset-2 focus:outline-indigo-600 focus:transition-all focus:duration-200 sm:text-sm"
               placeholder="Doe" required>
      </div>

      <!-- Prénom -->
      <div class="mb-4">
        <label for="prenom" class="block text-sm font-medium text-gray-700">Prénom</label>
        <input type="text" id="prenom" name="prenom" class="block w-full rounded-md bg-gray-200 px-3 py-1.5 text-base text-gray-500 outline outline-1 -outline-offset-1 outline-gray-300 placeholder:text-gray-400 focus:outline-2 focus:-outline-offset-2 focus:outline-indigo-600 focus:transition-all focus:duration-200 sm:text-sm"
               placeholder="John" required>
      </div>

      <!-- Date de naissance -->
      <div class="mb-4">
        <label for="date_naissance" class="block text-sm font-medium text-gray-700">Date de naissance</label>
        <input type="date" id="date_naissance" name="date_naissance" class="block w-full rounded-md bg-gray-200 px-3 py-1.5 text-base text-gray-500 outline outline-1 -outline-offset-1 outline-gray-300 placeholder:text-gray-400 focus:outline-2 focus:-outline-offset-2 focus:outline-indigo-600 focus:transition-all focus:duration-200 sm:text-sm" required>
      </div>

      <!-- Entreprise -->
      <div class="mb-4">
        <label for="entreprise" class="block text-sm font-medium text-gray-700">Entreprise</label>
        <input type="text" id="entreprise" name="entreprise" class="block w-full rounded-md bg-gray-200 px-3 py-1.5 text-base text-gray-500 outline outline-1 -outline-offset-1 outline-gray-300 placeholder:text-gray-400 focus:outline-2 focus:-outline-offset-2 focus:outline-indigo-600 focus:transition-all focus:duration-200 sm:text-sm"
               placeholder="Nom de l'entreprise" required>
      </div>

      <!-- Secteur d'activité -->
      <div class="mb-4">
        <label for="secteur_activite" class="block text-sm font-medium text-gray-700">Secteur d'activité</label>
        <input type="text" id="secteur_activite" name="secteur_activite" class="block w-full rounded-md bg-gray-200 px-3 py-1.5 text-base text-gray-500 outline outline-1 -outline-offset-1 outline-gray-300 placeholder:text-gray-400 focus:outline-2 focus:-outline-offset-2 focus:outline-indigo-600 focus:transition-all focus:duration-200 sm:text-sm"
               placeholder="Informatique, Commerce" required>
      </div>

      <!-- Email -->
      <div class="mb-4">
        <label for="email" class="block text-sm font-medium text-gray-700">Adresse email</label>
        <input type="email" id="email" name="email" class="block w-full rounded-md bg-gray-200 px-3 py-1.5 text-base text-gray-500 outline outline-1 -outline-offset-1 outline-gray-300 placeholder:text-gray-400 focus:outline-2 focus:-outline-offset-2 focus:outline-indigo-600 focus:transition-all focus:duration-200 sm:text-sm"
               placeholder="john.doe@gmail.com" required>
      </div>

      <!-- Mot de passe -->
      <div class="mb-4">
        <label for="password" class="block text-sm font-medium text-gray-700">Mot de passe</label>
        <input type="password" id="password" name="password" class="block w-full rounded-md bg-gray-200 px-3 py-1.5 text-base text-gray-500 outline outline-1 -outline-offset-1 outline-gray-300 placeholder:text-gray-400 focus:outline-2 focus:-outline-offset-2 focus:outline-indigo-600 focus:transition-all focus:duration-200 sm:text-sm"
               placeholder="Votre mot de passe" required>
      </div>

      <div class="flex justify-center">

        <button type="submit" class="bg-orange-400 w-full md:w-auto rounded-sm text-white px-4 py-2 font-semibold focus:transition-all focus:duration-200">
          S'inscrire
        </button>

      </div>

    </form>

    <p class="mt-4 text-sm text-center text-gray-600">
      Déjà membre ?
      <a href="${pageContext.request.contextPath}/login"
         class="text-indigo-600 hover:underline">Connecte toi !</a>
    </p>
  </div>
</main>


