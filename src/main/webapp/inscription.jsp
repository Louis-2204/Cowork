<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, db.DatabaseConnection" %>
<%@ page import="cowork.User" %>
<%
  // Message d'erreur ou de succès
  String message = null;

  // Vérifiez si le formulaire a été soumis
  if ("POST".equalsIgnoreCase(request.getMethod())) {
    // Récupérer les données du formulaire
    String nom = request.getParameter("nom");
    String prenom = request.getParameter("prenom");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String entreprise = request.getParameter("entreprise");
    String secteurActivite = request.getParameter("secteur_activite");

    // Vérifiez si les champs sont valides
    if (nom == null || prenom == null || email == null || password == null || entreprise == null || secteurActivite == null ||
            nom.isEmpty() || prenom.isEmpty() || email.isEmpty() || password.isEmpty() || entreprise.isEmpty() || secteurActivite.isEmpty()) {
      message = "Tous les champs sont obligatoires.";
    } else {
      try (Connection connection = DatabaseConnection.getInstance();
           PreparedStatement preparedStatement = connection.prepareStatement(
                   "INSERT INTO users (nom, prenom, email, password, entreprise, secteur_activite) VALUES (?, ?, ?, ?, ?, ?)")) {

        // Associez les paramètres
        preparedStatement.setString(1, nom);
        preparedStatement.setString(2, prenom);
        preparedStatement.setString(3, email);
        preparedStatement.setString(4, password);
        preparedStatement.setString(5, entreprise);
        preparedStatement.setString(6, secteurActivite);

        // Exécutez la requête
        int rowsAffected = preparedStatement.executeUpdate();
        if (rowsAffected > 0) {
          message = "Inscription réussie. Vous pouvez vous connecter.";
        } else {
          message = "Erreur lors de l'inscription. Veuillez réessayer.";
        }
      } catch (SQLException e) {
        e.printStackTrace();
        if (e.getMessage().contains("Duplicate entry")) {
          message = "Cet email est déjà utilisé.";
        } else {
          message = "Erreur lors de la connexion à la base de données.";
        }
      }
    }
  }
%>



<main class="flex-grow flex items-center justify-center bg-gray-100 min-h-screen w-full">
  <div class="bg-white p-8 rounded-lg shadow-md w-full max-w-md mb-20 my-20">
    <div class="mt-10 sm:mx-auto sm:w-full sm:max-w-md">
      <form class="space-y-6" action="inscription.jsp" method="POST" id="registrationForm">
        <!-- Nom -->
        <div>
          <input type="text" name="nom" id="nom" required
                 class="block w-full rounded-md bg-gray-200 px-3 py-1.5 text-base text-gray-500 outline outline-1 -outline-offset-1 outline-gray-300 placeholder:text-gray-400 focus:outline-2 focus:-outline-offset-2 focus:outline-indigo-600 sm:text-sm/6"
                 placeholder="Nom">
          <small id="nomError" class="text-red-500"></small>
        </div>

        <!-- prenom -->
        <div>
          <input type="text" name="prenom" id="prenom" required
                 class="block w-full rounded-md bg-gray-200 px-3 py-1.5 text-base text-gray-500 outline outline-1 -outline-offset-1 outline-gray-300 placeholder:text-gray-400 focus:outline-2 focus:-outline-offset-2 focus:outline-indigo-600 sm:text-sm/6"
                 placeholder="Prenom">
          <small id="prenomError" class="text-red-500"></small>
        </div>

        <!-- Entreprise -->
        <div>
          <input type="text" name="entreprise" id="entreprise" required
                 class="block w-full rounded-md bg-gray-200 px-3 py-1.5 text-base text-gray-500 outline outline-1 -outline-offset-1 outline-gray-300 placeholder:text-gray-400 focus:outline-2 focus:-outline-offset-2 focus:outline-indigo-600 sm:text-sm/6"
                 placeholder="Entreprise">
          <small id="entrepriseError" class="text-red-500"></small>
        </div>

        <!-- Secteur d'activité -->
        <div>
          <input type="text" name="secteur_activite" id="secteur_activite" required
                 class="block w-full rounded-md bg-gray-200 px-3 py-1.5 text-base text-gray-500 outline outline-1 -outline-offset-1 outline-gray-300 placeholder:text-gray-400 focus:outline-2 focus:-outline-offset-2 focus:outline-indigo-600 sm:text-sm/6"
                 placeholder="Secteur d'activite">
          <small id="secteurError" class="text-red-500"></small>
        </div>

        <!-- Email -->
        <div>
          <input type="email" name="email" id="email" required
                 class="block w-full rounded-md bg-gray-200 px-3 py-1.5 text-base text-gray-500 outline outline-1 -outline-offset-1 outline-gray-300 placeholder:text-gray-400 focus:outline-2 focus:-outline-offset-2 focus:outline-indigo-600 sm:text-sm/6"
                 placeholder="exemple@gmail.com">
          <small id="emailError" class="text-red-500"></small>
        </div>

        <!-- Mot de passe -->
        <div>
          <input type="password" name="password" id="password" required
                 class="block w-full rounded-md bg-gray-200 px-3 py-1.5 text-base text-gray-500 outline outline-1 -outline-offset-1 outline-gray-300 placeholder:text-gray-400 focus:outline-2 focus:-outline-offset-2 focus:outline-indigo-600 sm:text-sm/6"
                 placeholder="Mot de passe">
          <small id="passwordError" class="text-red-500"></small>
        </div>



        <!-- Bouton de soumission -->
        <div class="flex justify-center">
          <button type="submit" id="submitBtn"
                  class="bg-orange-400 w-full md:w-auto rounded-sm text-white px-4 py-2 font-semibold">
            S'inscrire
          </button>
        </div>
      </form>
    </div>
  </div>
</main>

<script>
  // Validation dynamique du formulaire
  const form = document.getElementById('registrationForm');
  const fields = {
    nom: {
      element: document.getElementById('nom'),
      error: document.getElementById('nomError'),
      validator: (value) => value.trim().length >= 4 || "Le nom doit contenir au moins 4 caracteres."
    },
    prenom: {
      element: document.getElementById('prenom'),
      error: document.getElementById('prenomError'),
      validator: (value) => value.trim().length >= 4 || "Le prenom doit contenir au moins 4 caracteres."
    },
    email: {
      element: document.getElementById('email'),
      error: document.getElementById('emailError'),
      validator: (value) => /\S+@\S+\.\S+/.test(value) || "L'email n'est pas valide."
    },
    password: {
      element: document.getElementById('password'),
      error: document.getElementById('passwordError'),
      validator: (value) =>
              /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/.test(value) ||
              "Le mot de passe doit contenir au moins 8 caracteres, une majuscule, un chiffre et un caractere special."
    },
    entreprise: {
      element: document.getElementById('entreprise'),
      error: document.getElementById('entrepriseError'),
      validator: (value) => value.trim().length >= 4 || "Le nom de l'entreprise doit contenir au moins 4 caracteres."
    },
    secteur_activite: {
      element: document.getElementById('secteur_activite'),
      error: document.getElementById('secteurError'),
      validator: (value) => value.trim().length >= 4 || "Le secteur d'activite doit contenir au moins 4 caracteres."
    }
  };

  // Ajout des événements d'écoute pour chaque champ
  for (const key in fields) {
    const field = fields[key];
    field.element.addEventListener('input', () => validateField(field));
  }

  form.addEventListener('submit', (e) => {
    let isValid = true;
    for (const key in fields) {
      const field = fields[key];
      if (!validateField(field)) {
        isValid = false;
      }
    }
    if (!isValid) {
      e.preventDefault(); // Empêcher l'envoi du formulaire si des erreurs existent
    }
  });

  function validateField(field) {
    const value = field.element.value;
    const errorMessage = field.validator(value);
    if (errorMessage === true) {
      field.error.textContent = '';
      field.element.classList.remove('outline-red-500');
      field.element.classList.add('outline-indigo-600');
      return true;
    } else {
      field.error.textContent = errorMessage;
      field.element.classList.add('outline-red-500');
      field.element.classList.remove('outline-indigo-600');
      return false;
    }
  }
</script>
