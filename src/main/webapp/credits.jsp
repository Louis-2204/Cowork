<%@ page import="java.util.Objects" %>
<%@ page import="cowork.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    User user = (User) request.getSession().getAttribute("loggedInUser");
    boolean transactionError = Objects.equals(request.getParameter("error"), "true");
    boolean transactionSuccess = Objects.equals(request.getParameter("success"), "true");
    String message = request.getParameter("message");
    %>


<% if (transactionError && !message.isEmpty()) { %>
<div class="w-full py-2 px-4 bg-red-400 text-white"><%=message%></div>
<% } else if(transactionSuccess && !message.isEmpty()) { %>
<div class="w-full py-2 px-4 bg-green-400 text-white"><%=message%></div>
<%}%>

<div class="w-full flex flex-col justify-center items-center min-h-[calc(100svh-256px)]">
    <h1 class="text-2xl font-semibold">Votre solde de crédits est de : <%=user.getCredits()%> crédit(s)</h1>
    <p class="mb-3 text-xl font-medium">Voulez-vous racheter des crédits ?</p>
    <form method="post" action="${pageContext.request.contextPath}/BuyCredits" class="flex flex-col gap-2 bg-white rounded-md w-full max-w-[1000px] p-4">
        <label>Montant</label>
        <input type="number" placeholder="Montant des crédits à recharger" name="new_credits" class="py-1 px-2 rounded-md border-[1px] border-black/10"/>
        <label>Nom affiché sur la carte</label>
        <input type="text" placeholder="Paul Dupont" name="name" class="py-1 px-2 rounded-md border-[1px] border-black/10"/>
        <label>Numéro de carte</label>
        <input type="text" placeholder="XXXX-XXXX-XXXXX-XXXX" name="card_number" class="py-1 px-2 rounded-md"/>
        <label>Exp</label>
        <input type="text" placeholder="XX/XX" name="card_exp" class="py-1 px-2 rounded-md border-[1px] border-black/10"/>
        <label>CVV</label>
        <input type="text" placeholder="XXX" name="card_cvv" class="py-1 px-2 rounded-md border-[1px] border-black/10"/>
        <button class="bg-orange-500 text-white font-semibold rounded-md px-3 py-1 w-fit" type="submit">Acheter</button>
    </form>
</div>
