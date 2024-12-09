<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.google.zxing.BarcodeFormat" %>
<%@ page import="com.google.zxing.qrcode.QRCodeWriter" %>
<%@ page import="com.google.zxing.common.BitMatrix" %>
<%@ page import="com.google.zxing.client.j2se.MatrixToImageWriter" %>
<%@ page import="java.io.ByteArrayOutputStream" %>
<%@ page import="java.util.Base64" %>
<%
    String code = request.getParameter("code");
    String idReservation = request.getParameter("idReservation");

//    Générer le QR code en base64
    String qrCodeBase64 = "";
    try {
        QRCodeWriter qrCodeWriter = new QRCodeWriter();
        BitMatrix bitMatrix = qrCodeWriter.encode(code, BarcodeFormat.QR_CODE, 300, 300);

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        MatrixToImageWriter.writeToStream(bitMatrix, "PNG", baos);
        byte[] qrCodeBytes = baos.toByteArray();

        // Encoder en base64 pour l'inclure dans une balise <img>
        qrCodeBase64 = Base64.getEncoder().encodeToString(qrCodeBytes);
    } catch (Exception e) {
        System.out.println("Erreur lors de la génération du QR code : " + e.getMessage());
        e.printStackTrace();
    }
%>

<dialog id="codeReservationDialog<%= idReservation %>" class="md:w-1/2 sm:w-3/4 w-11/12 max-w-[650px] bg-white p-5 rounded-md transition-all duration-300">
    <div class="flex w-full justify-between">
        <h1 class="text-2xl font-semibold pb-2">Code</h1>
        <button id="closeCodeReservationDialog<%= idReservation %>" class="text-xl font-semibold hover:bg-gray-200 rounded-full p-1 w-9 h-9 flex items-center justify-center">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
                <path stroke-linecap="round" stroke-linejoin="round" d="M6 18 18 6M6 6l12 12" />
            </svg>
        </button>
    </div>
    <%-- Code --%>
    <div class="w-full h-full flex items-center justify-center font-bold text-5xl md:text-6xl text-[#FF6641]">
        <%= code.toUpperCase() %>
    </div>
        <!-- QR Code -->
    <div class="w-full h-60 md:h-80 flex items-center justify-center">
        <img src="data:image/png;base64, <%= qrCodeBase64 %>" alt="QR Code" class="h-full object-cover rounded-md aspect-square">
    </div>
</dialog>



<script>
    const codeReservationDialog<%= idReservation %> = document.getElementById('codeReservationDialog<%= idReservation %>');
    const codeReservation<%= idReservation %> = document.getElementById('codeReservation<%= idReservation %>');
    const closeCodeReservationDialog<%= idReservation %> = document.getElementById('closeCodeReservationDialog<%= idReservation %>');

    codeReservation<%= idReservation %>.addEventListener('click', () => {
        codeReservationDialog<%= idReservation %>.showModal();
    });

    closeCodeReservationDialog<%= idReservation %>.addEventListener('click', () => {
        codeReservationDialog<%= idReservation %>.close();
    });

    // close dialog when clicking outside
    codeReservationDialog<%= idReservation %>.addEventListener('click', (e) => {
        if (e.target === codeReservationDialog<%= idReservation %>) {
            codeReservationDialog<%= idReservation %>.close();
        }
    });
</script>

<style>
    dialog::backdrop {
        background-color: rgba(0, 0, 0, 0.5);
    }
</style>