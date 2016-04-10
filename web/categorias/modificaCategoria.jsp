<%-- 
    Document   : modificaCategoria
    Created on : 4/11/2015, 08:05:17 PM
    Author     : ricesqgue
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="org.json.simple.JSONObject"%>
<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"></jsp:useBean>

<%
    JSONObject json = new JSONObject();
    String categoria = request.getParameter("nombreCategoria");
    String idCategoria = request.getParameter("idCategoria");
    String query = "select idCategoria from categorias where categoria = '"+categoria+"' and activo = 1;"; 
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
        //Ya existe una categoria con ese nombre.
        json.put("error", "<br><div class='row animated slideInLeft'> <div class='col-md-4 col-md-offset-3'>"
                        + "<div class='alert alert-danger' role='alert'>"
                        + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                        + "<span aria-hidden='true'>&times;</span></button>"
                        + "<strong>Error. </strong> Ya existe una categoría con ese nombre."
                        + "</div></div></div>" );        
    }else{
        //Se procede a insertar la categoria.
        query = "update categorias set categoria = '"+categoria+"' where idCategoria = "+idCategoria+";";
        System.out.println(query); 
        if(objConn.Update(query)==1){
            //Se agregó correctamente.
            json.put("exito", "<br><div class='row animated slideInLeft'> <div class='col-md-4 col-md-offset-3'>"
                        + "<div class='alert alert-success' role='alert'>"
                        + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                        + "<span aria-hidden='true'>&times;</span></button>"
                        + "<strong>Éxito. </strong> Categoría modificada correctamente."
                        + "</div></div></div>");
        }
        else{
            //Error al insertar en la BD.
             json.put("error", "<br><div class='row animated slideInLeft'> <div class='col-md-4 col-md-offset-3'>"
                        + "<div class='alert alert-danger' role='alert'>"
                        + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                        + "<span aria-hidden='true'>&times;</span></button>"
                        + "<strong>Error. </strong> No se pudo modificar la categoría."
                        + "</div></div></div>" );               
        }
    }
    out.print(json);
    out.flush();
    objConn.desConnect();
%>