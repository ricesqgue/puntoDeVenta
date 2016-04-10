<%-- 
    Document   : movimientosCaja
    Created on : 20/11/2015, 10:17:40 AM
    Author     : ricesqgue

Regitrar movimientos de caja.
--%>

<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"/>
<%@page import="org.json.simple.JSONObject"%>

<%
HttpSession sesion = request.getSession();
String idUsuario = ""+sesion.getAttribute("idUsuario");
JSONObject json = new JSONObject();
String tipo = request.getParameter("movimiento"); 
/*
Tipo = 1 = Salida de caja.
Tipo = 2 = Entrada de caja.
*/
String cantidad = request.getParameter("cantidad"+tipo);
String concepto = request.getParameter("concepto"+tipo);
String query = "insert into movimientoscaja values (default,"+tipo+","+cantidad+",'"+concepto+"',now(),"+idUsuario+");";
String nombreTipo = "";
if(tipo.equals("1")){
    nombreTipo = "Salida";
}
else{
    nombreTipo = "Entrada";
}
if(objConn.Update(query)==1){

String salida = "<div id='mensaje' class='col-md-12 animated slideInRight'> "
        + "<div class='alert alert-success' role='alert'>"
        + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
        + "<span aria-hidden='true'> &times;</span></button><strong>Éxito. </strong>"
        + nombreTipo +" guardada correctamente."
        + "</div></div>";
    json.put("msj", salida);
    json.put("tipo","exito");
}
else{
    String salida = "<div id='mensaje' class='col-md-12 animated slideInRight'> "
            + "<div class='alert alert-danger' role='alert'>"
            + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
            + "<span aria-hidden='true'> &times;</span></button><strong>Error. </strong>"
            + "Error al guardar la " + nombreTipo+". "
            + "</div></div>";
    json.put("msj", salida);
    json.put("tipo","error");
}
objConn.desConnect();
out.print(json);
out.flush();
%>
