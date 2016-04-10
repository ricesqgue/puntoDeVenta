<%-- 
    Document   : modificaMarca
    Created on : 4/11/2015, 08:05:17 PM
    Author     : ricesqgue
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="org.json.simple.JSONObject"%>
<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"></jsp:useBean>

<%
    JSONObject json = new JSONObject();
    String marca = request.getParameter("nombreMarca");
    String idMarca = request.getParameter("idMarca");
    String query = "select idMarca from marcas where marca = '"+marca+"' and activo = 1;";
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
        //Ya existe una marca con ese nombre.
        json.put("error", "<br><div class='row animated slideInLeft'> <div class='col-md-4 col-md-offset-3'>"
                        + "<div class='alert alert-danger' role='alert'>"
                        + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                        + "<span aria-hidden='true'>&times;</span></button>"
                        + "<strong>Error. </strong> Ya existe una marca con ese nombre."
                        + "</div></div></div>" );        
    }else{
        //Se procede a insertar la marca.
        query = "update marcas set marca = '"+marca+"' where idMarca = "+idMarca+";";
        System.out.println(query); 
        if(objConn.Update(query)==1){
            //Se agregó correctamente.
            json.put("exito", "<br><div class='row animated slideInLeft'> <div class='col-md-4 col-md-offset-3'>"
                        + "<div class='alert alert-success' role='alert'>"
                        + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                        + "<span aria-hidden='true'>&times;</span></button>"
                        + "<strong>Éxito. </strong> Marca modificada correctamente."
                        + "</div></div></div>");
        }
        else{
            //Error al insertar en la BD.
             json.put("error", "<br><div class='row animated slideInLeft'> <div class='col-md-4 col-md-offset-3'>"
                        + "<div class='alert alert-danger' role='alert'>"
                        + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                        + "<span aria-hidden='true'>&times;</span></button>"
                        + "<strong>Error. </strong> No se pudo modificar la marca."
                        + "</div></div></div>" );               
        }
    }
    out.print(json);
    out.flush();
    objConn.desConnect();
%>