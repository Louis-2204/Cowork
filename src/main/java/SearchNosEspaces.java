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
        String dateDeb = request.getParameter("dateDeb");
        String dateFin = request.getParameter("dateFin");

        // Encoder les paramètres pour les inclure dans l'URL
        String encodedType = URLEncoder.encode(type, StandardCharsets.UTF_8);
        String encodedDateDeb = URLEncoder.encode(dateDeb, StandardCharsets.UTF_8);
        String encodedDateFin = URLEncoder.encode(dateFin, StandardCharsets.UTF_8);

        // Construire l'URL avec les paramètres de recherche
        String redirectUrl = String.format("/cowork/nos-espaces?type=%s&dateDeb=%s&dateFin=%s",
                encodedType, encodedDateDeb, encodedDateFin);

        // Rediriger vers la page /nos-espaces avec les paramètres
        response.sendRedirect(redirectUrl);
    }
}