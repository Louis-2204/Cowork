import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet implementation class PageController
 */
@WebServlet({"/accueil", "/nos-espaces", "/forum", "/FAQ", "/mes-reservations", "/salle", "/nos-forfaits", "/forfait"})
@WebServlet({"/accueil", "/nos-espaces", "/forum", "/FAQ", "/mes-reservations", "/login", "/inscription","/annuaire-client"})
public class PageController extends HttpServlet {
    private static final long serialVersionUID = 2L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String uri = request.getServletPath(); // Obtenir l'URL demandée
        String page;
        String Title;

        // Ajuster les chemins pour qu'ils pointent correctement vers les JSP
        switch (uri) {
            case "/accueil":
                page = "/accueil.jsp";
                Title = "Accueil";
                break;
            case "/nos-espaces":
                page = "/nos-espaces.jsp";
                Title = "Nos espaces";
                break;
            case "/nos-forfaits":
                page = "/nos-forfaits.jsp";
                Title = "Nos forfaits";
                break;
            case "/forum":
                page = "/forum.jsp";
                Title = "Forum";
                break;
            case "/FAQ":
                page = "/FAQ.jsp";
                Title = "FAQ";
                break;
            case "/mes-reservations":
                page = "/mes-reservations.jsp";
                Title = "Mes réservations";
                break;
            case "/salle":
                // Récupérer le paramètre "id_salle"
                String id_salle = request.getParameter("id");
                if (id_salle != null && id_salle.matches("\\d+")) { // Vérifier si 'id_salle' est un nombre
                    page = "/salle.jsp";
                    Title = "Salle " + id_salle;
                    request.setAttribute("salleId", id_salle); // Passer l'ID de la salle en attribut
                } else {
                    page = "/404.jsp"; // Si l'ID est invalide ou manquant
                    Title = "Erreur 404";
                }
                break;
            case "/forfait":
                String id_forfait = request.getParameter("id");
                if (id_forfait != null && id_forfait.matches("\\d+")) { // Vérifier si 'id_forfait' est un nombre
                    page = "/forfait.jsp";
                    Title = "Forfait " + id_forfait;
                    request.setAttribute("forfaitId", id_forfait); // Passer l'ID du forfait en attribut
                } else {
                    page = "/404.jsp"; // Si l'ID est invalide ou manquant
                    Title = "Erreur 404";
                }
                break;
            default:
            case "/login":
                page = "/login.jsp";
                Title = "Login";
                break;
            case "/inscription":
                page = "/inscription.jsp";
                Title = "Inscription";
                break;
            case "/annuaire-client":
                page = "/annuaire-client.jsp";
                Title = "Annuaire Client";
                break;

                default:
                page = "/404.jsp"; // Page par défaut ou erreur
                Title = "Erreur 404";
        }

        // Définir les attributs pour le layout
        request.setAttribute("pageContent", page);
        request.setAttribute("pageTitle", Title);
        request.getRequestDispatcher("/layout.jsp").forward(request, response);
    }
}
