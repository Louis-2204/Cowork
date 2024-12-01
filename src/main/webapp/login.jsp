<%--
  Created by IntelliJ IDEA.
  User: Neal
  Date: 12/1/2024
  Time: 12:49 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<main class="flex-grow flex items-center justify-center bg-gray-100 min-h-screen">
    <div class="bg-white p-8 rounded-lg shadow-md w-full max-w-md"> <!-- Augmenté de max-w-sm à max-w-md -->
        <div class="mt-10 sm:mx-auto sm:w-full sm:max-w-md">
            <form class="space-y-6" action="#" method="POST">
                <div>
                    <div class="mt-2">
                        <input type="email" name="email" id="email" autocomplete="email" required
                               class="block w-full rounded-md bg-gray-200 px-3 py-1.5 text-base text-gray-500 outline outline-1 -outline-offset-1 outline-gray-300 placeholder:text-gray-400 focus:outline-2 focus:-outline-offset-2 focus:outline-indigo-600 sm:text-sm/6"
                                placeholder="Email">
                    </div>
                </div>
                <div>
                    <div class="mt-2">
                        <input type="password"  name="password" id="password" autocomplete="password" required
                                class="block w-full rounded-md bg-gray-200 px-3 py-1.5 text-base text-gray-500 outline outline-1 -outline-offset-1 outline-gray-300 placeholder:text-gray-400 focus:outline-2 focus:-outline-offset-2 focus:outline-indigo-600 sm:text-sm/6"
                                placeholder="Mot de passe">
                    </div>
                </div>

                <!-- Bouton centré -->
                <div class="flex justify-center">
                    <button
                            type="submit"
                            class="bg-orange-400 w-full md:w-auto rounded-sm text-white px-4 py-2 font-semibold">
                        Se connecter
                    </button>
                </div>
            </form>

            <p class="mt-10 text-center text-sm/6 text-gray-500">
                Nouveau ?
                <a href="#" class="font-semibold text-indigo-600 hover:text-indigo-500">Inscrit toi dès maintenant !</a>
            </p>
        </div>
    </div>
</main>




