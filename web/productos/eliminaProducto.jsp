<%-- 
    Document   : eliminaProducto
    Created on : 4/11/2015, 09:08:41 PM
    Author     : ricesqgue
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="org.json.simple.JSONObject"%>
<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"></jsp:useBean>

<%
    JSONObject json = new JSONObject();
    String idProducto = request.getParameter("idProducto");
    String query = "select idProducto from producto where idProducto = "+idProducto+" and stock > 0;";
    objConn.Consult(query);
    System.out.print(query);
    int n=0;
    try{
        if(objConn.rs != null){
            objConn.rs.last();
            n = objConn.rs.getRow();            
        }       
    }catch(Exception e){}
    if(n>0){
        //Existen productos en existencia. No se puede eliminar.
        json.put("error", "<br><div class='row animated slideInLeft'> <div class='col-md-4 col-md-offset-3'>"
                        + "<div class='alert alert-danger' role='alert'>"
                        + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                        + "<span aria-hidden='true'>&times;</span></button>"
                        + "<strong>Error. </strong> Hay existencia en stock.<br>No se puede eliminar."
                        + "</div></div></div>" );        
    }else{
        //Se puede poner en activo = 0 el producto.
        query = "update producto set activo = 0 where idProducto = "+idProducto+";"; 
        System.out.println(query); 
        if(objConn.Update(query)==1){
            //Se eliminó correctamente.
            json.put("exito", "<br><div class='row animated slideInLeft'> <div class='col-md-4 col-md-offset-3'>"
                        + "<div class='alert alert-success' role='alert'>"
                        + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                        + "<span aria-hidden='true'>&times;</span></button>"
                        + "<strong>Éxito. </strong> Producto eliminado correctamente."
                        + "</div></div></div>");
        }
        else{
            //Error al actualizar en la BD.
             json.put("error", "<br><div class='row animated slideInLeft'> <div class='col-md-4 col-md-offset-3'>"
                        + "<div class='alert alert-danger' role='alert'>"
                        + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                        + "<span aria-hidden='true'>&times;</span></button>"
                        + "<strong>Error. </strong> No se pudo eliminar el producto."
                        + "</div></div></div>" );               
        }
    }
    out.print(json);
    out.flush();
    objConn.desConnect();
%>
