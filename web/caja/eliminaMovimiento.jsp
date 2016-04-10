<%-- 
    Document   : eliminaMovimiento
    Created on : 22/11/2015, 10:52:15 PM
    Author     : ricesqgue
--%>

<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"/>
<%@page import="org.json.simple.JSONObject"%>

<%
JSONObject json = new JSONObject();
String idMovimiento = request.getParameter("id");
String query = "delete from movimientoscaja where idmovimiento = " + idMovimiento +";";
if(objConn.Update(query) == 1){
    json.put("exito", "Eliminado correctamente.");
}
else{
    json.put("error", "<div id='mensaje' class='col-md-12 animated slideInRight'> "
                            + "<div class='alert alert-danger' role='alert'>"
                            + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                            + "<span aria-hidden='true'> &times;</span></button>"
                            + "<strong>Error. </strong> No se pudo eliminar."
                            + "</div></div>");
}
out.print(json);
out.flush();
objConn.desConnect();
%>
