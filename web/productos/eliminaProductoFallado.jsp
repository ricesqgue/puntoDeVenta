<%-- 
    Document   : eliminaProductoFallado
    Created on : 30/11/2015, 02:53:11 PM
    Author     : ricesqgue
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="org.json.simple.JSONObject"%>
<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"></jsp:useBean>

<%
    JSONObject json = new JSONObject();
    String idProductofallado = request.getParameter("idProducto");
    
    String query = "delete from productosfallados where idProductosfallados = "+ idProductofallado+";";
    System.out.print(query);
    if(objConn.Update(query)==1){
            //Se eliminó correctamente.
            json.put("exito", "<br><div class='row animated slideInLeft'> <div class='col-md-4 col-md-offset-3'>"
                        + "<div class='alert alert-success' role='alert'>"
                        + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                        + "<span aria-hidden='true'>&times;</span></button>"
                        + "<strong>Éxito. </strong> Producto fallado eliminado correctamente."
                        + "</div></div></div>");
        }
        else{
            //Error al actualizar en la BD.
             json.put("error", "<br><div class='row animated slideInLeft'> <div class='col-md-4 col-md-offset-3'>"
                        + "<div class='alert alert-danger' role='alert'>"
                        + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                        + "<span aria-hidden='true'>&times;</span></button>"
                        + "<strong>Error. </strong> No se pudo eliminar el producto fallado."
                        + "</div></div></div>" );               
        }
    
    out.print(json);
    out.flush();
    objConn.desConnect();
%>
