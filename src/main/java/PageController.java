import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet implementation class PageController
 */
@WebServlet({"/accueil", "/nos-espaces", "/forum", "/FAQ", "/mes-reservations"})
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
