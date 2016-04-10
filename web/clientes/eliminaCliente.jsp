<%-- 
    Document   : eliminaCliente
    Created on : 12/11/2015, 01:31:40 PM
    Author     : ricesqgue
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="org.json.simple.JSONObject"%>
<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"></jsp:useBean>

<%
    JSONObject json = new JSONObject();
    String idCliente = request.getParameter("idCliente");
    String query = " ";/*select idProducto from producto where idCliente = "+idCliente+" and stock > 0;"; 
    objConn.Consult(query);  
    int n=0;
    try{
        if(objConn.rs != null){
            objConn.rs.last();
            n = objConn.rs.getRow();            
        }       
    }catch(Exception e){}
    if(n>0){
        //Existen productos en existencia con este cliente. No se puede eliminar.
        json.put("error", "<br><div class='row animated slideInLeft'> <div class='col-md-4 col-md-offset-3'>"
                        + "<div class='alert alert-danger' role='alert'>"
                        + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                        + "<span aria-hidden='true'>&times;</span></button>"
                        + "<strong>Error. </strong> Existen productos del cliente en stock.<br>No se puede eliminar."
                        + "</div></div></div>" );        
    }else{
            */
        //Se puede poner en activo = 0 el cliente.
        query = "update cliente set activo = 0 where idCliente = "+idCliente+";"; 
        System.out.println(query); 
        if(objConn.Update(query)==1){
            //Se eliminó correctamente.
            json.put("exito", "<br><div class='row animated slideInLeft'> <div class='col-md-4 col-md-offset-3'>"
                        + "<div class='alert alert-success' role='alert'>"
                        + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                        + "<span aria-hidden='true'>&times;</span></button>"
                        + "<strong>Éxito. </strong> Cliente eliminado correctamente."
                        + "</div></div></div>");
        }
        else{
            //Error al insertar en la BD.
             json.put("error", "<br><div class='row animated slideInLeft'> <div class='col-md-4 col-md-offset-3'>"
                        + "<div class='alert alert-danger' role='alert'>"
                        + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                        + "<span aria-hidden='true'>&times;</span></button>"
                        + "<strong>Error. </strong> No se pudo eliminar el producto."
                        + "</div></div></div>" );               
        }
    //}
    out.print(json);
    out.flush();
    objConn.desConnect();
%>
