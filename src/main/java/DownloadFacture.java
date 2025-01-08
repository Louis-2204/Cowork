import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Text;
import com.itextpdf.kernel.font.PdfFont;
import com.itextpdf.kernel.font.PdfFontFactory;
import com.itextpdf.layout.property.TextAlignment;
import cowork.User;
import db.DatabaseConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet(name = "DownloadFacture", value = "/downloadFacture")
public class DownloadFacture extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int idFacture = Integer.parseInt(request.getParameter("id_facture"));
        User user = (User) request.getSession().getAttribute("loggedInUser");

        try {
            // Récupérer les informations de la facture
            Connection connection = DatabaseConnection.getInstance();
            String query = "SELECT * FROM factures WHERE id_facture = ? and id_user = ?";
            PreparedStatement preparedStatement = connection.prepareStatement(query);
            preparedStatement.setInt(1, idFacture);
            preparedStatement.setInt(2, user.getId_user());
            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                // Créer un nouveau document PDF
                ByteArrayOutputStream baos = new ByteArrayOutputStream();
                PdfWriter writer = new PdfWriter(baos);
                PdfDocument pdf = new PdfDocument(writer);
                Document document = new Document(pdf);

                // Créer les fonts
                PdfFont font = PdfFontFactory.createFont();

                // Titre
                Paragraph title = new Paragraph();
                Text titleText = new Text("FACTURE")
                        .setFont(font)
                        .setFontSize(24)
                        .setBold();
                title.add(titleText);
                title.setTextAlignment(TextAlignment.CENTER);
                document.add(title);
                document.add(new Paragraph(""));  // Espace

                // Informations de la société
                document.add(new Paragraph("CoWork").setFont(font).setFontSize(14).setBold());
                document.add(new Paragraph("123 rue Example").setFont(font).setFontSize(12));
                document.add(new Paragraph("75000 Paris").setFont(font).setFontSize(12));
                document.add(new Paragraph("Tél: 01 23 45 67 89").setFont(font).setFontSize(12));
                document.add(new Paragraph("")); // Espace

                // Informations de la facture
                document.add(new Paragraph("Facture N°: " + idFacture).setFont(font).setFontSize(12).setBold());
                SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
                document.add(new Paragraph("Date: " + formatter.format(new Date())).setFont(font).setFontSize(12));
                document.add(new Paragraph("")); // Espace

                // Détails de la facture
                document.add(new Paragraph("Description:").setFont(font).setFontSize(12).setBold());
                document.add(new Paragraph(resultSet.getString("libelle")).setFont(font).setFontSize(12));
                document.add(new Paragraph("")); // Espace

                // Montant
                document.add(new Paragraph("Montant:").setFont(font).setFontSize(12).setBold());
                document.add(new Paragraph(String.format("%.2f €", resultSet.getFloat("montant")))
                        .setFont(font)
                        .setFontSize(12));

                // Fermer le document
                document.close();

                // Configurer la réponse HTTP
                byte[] pdfBytes = baos.toByteArray();
                response.setContentType("application/pdf");
                response.setHeader("Content-Disposition", "attachment; filename=facture_" + resultSet.getDate("date").toString() + ".pdf");
                response.setContentLength(pdfBytes.length);

                // Écrire le PDF dans la réponse
                response.getOutputStream().write(pdfBytes);
                response.getOutputStream().flush();

            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Facture non trouvée");
            }

        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erreur lors de la génération de la facture");
        }
    }
}