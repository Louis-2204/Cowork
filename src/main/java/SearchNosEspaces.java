import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet(name = "SearchNosEspaces", value = "/SearchNosEspaces")
public class SearchNosEspaces extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Récupérer les paramètres du formulaire
        String type = request.getParameter("type");
        String date = request.getParameter("date");
        String timeDeb = request.getParameter("timeDeb");
        String timeFin = request.getParameter("timeFin");

        // Encoder les paramètres pour les inclure dans l'URL
        String encodedType = URLEncoder.encode(type, StandardCharsets.UTF_8);
        String encodedDate = URLEncoder.encode(date, StandardCharsets.UTF_8);
        String encodedTimeDeb = URLEncoder.encode(timeDeb, StandardCharsets.UTF_8);
        String encodedTimeFin = URLEncoder.encode(timeFin, StandardCharsets.UTF_8);

        // Construire l'URL avec les paramètres de recherche
        String redirectUrl = String.format("/cowork/nos-espaces?type=%s&date=%s&timeDeb=%s&timeFin=%s",
                encodedType, encodedDate, encodedTimeDeb, encodedTimeFin);

        // Rediriger vers la page /nos-espaces avec les paramètres
        response.sendRedirect(redirectUrl);
    }
}