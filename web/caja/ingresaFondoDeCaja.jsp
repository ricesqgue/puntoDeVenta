<%-- 
    Document   : ingresaFondoDeCaja
    Created on : 24/11/2015, 12:23:11 AM
    Author     : ricesqgue
--%>

<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"/>
<%@page import="org.json.simple.JSONObject"%>

<%
HttpSession sesion = request.getSession();
String idUsuario = ""+sesion.getAttribute("idUsuario");
JSONObject json = new JSONObject();
String cant = request.getParameter("cantidad");
float cantidad = 0;
try{
    cantidad = Float.parseFloat(cant);
}
catch(Exception e){
    cantidad = -1;
}
if(cantidad<0){
    json.put("error","<div id='mensaje' class='col-sm-4 col-sm-offset-4 animated slideInRight'> "
        + "<div class='alert alert-danger' role='alert'>"
        + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
        + "<span aria-hidden='true'> &times;</span></button>"
        + "<strong>Error.</strong> Introduce una cantidad válida."
        + "</div></div>");
}
else{
    String query = "insert into fondocaja values (default,round("+cantidad+",2),now(),"+idUsuario+");"; 
    if(objConn.Update(query)==1){
            json.put("exito","<div id='mensaje' class='col-sm-4 col-sm-offset-4 animated slideInRight'> "
                + "<div class='alert alert-success' role='alert'>"
                + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                + "<span aria-hidden='true'> &times;</span></button>"
                + "<strong>Éxito. </strong> Fondo de caja guardado correctamente."
                + "</div></div>");
    }else{
         json.put("error","<div id='mensaje' class='col-sm-4 col-sm-offset-4 animated slideInRight'> "
        + "<div class='alert alert-danger' role='alert'>"
        + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
        + "<span aria-hidden='true'> &times;</span></button>"
        + "<strong>Error. </strong> Intente nuevamente."
        + "</div></div>");
    }
    objConn.desConnect();
}
out.print(json);
out.flush();
%>