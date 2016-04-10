<%-- 
    Document   : agregaProductoFallado
    Created on : 30/11/2015, 02:35:38 PM
    Author     : ricesqgue
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="org.json.simple.JSONObject"%>
<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"></jsp:useBean>

<%
    HttpSession sesion = request.getSession();
    String idUsuario = ""+sesion.getAttribute("idUsuario");
    JSONObject json = new JSONObject();
    String idProducto = request.getParameter("id");
    String defecto = request.getParameter("defecto");
    objConn.Consult("select stock from producto where idProducto = " + idProducto+";");
    int stock = 0;
    try{
        stock = objConn.rs.getInt(1);
    }catch(Exception e){
        stock= 0; 
    }
    if(stock>0){
        String query = "insert into productosfallados values (default,"+idProducto+",'"+defecto+"',now(),"+idUsuario+");";
        if(objConn.Update(query) == 1){
            json.put("exito", "<br><div class='row animated slideInLeft'> <div class='col-md-4 col-md-offset-3'>"
                            + "<div class='alert alert-success' role='alert'>"
                            + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                            + "<span aria-hidden='true'>&times;</span></button>"
                            + "<strong>Éxito. </strong> Producto agregado correctamente."
                            + "</div></div></div>");
        }
        else{
            json.put("error", "<br><div class='row animated slideInLeft'> <div class='col-md-4 col-md-offset-3'>"
                            + "<div class='alert alert-danger' role='alert'>"
                            + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                            + "<span aria-hidden='true'>&times;</span></button>"
                            + "<strong>Error. </strong> No se pudo agregar el producto."
                            + "</div></div></div>" );  
        }
    }else{
        json.put("error", "<br><div class='row animated slideInLeft'> <div class='col-md-4 col-md-offset-3'>"
                 + "<div class='alert alert-danger' role='alert'>"
                 + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                 + "<span aria-hidden='true'>&times;</span></button>"
                 + "<strong>Error. </strong> No hay producto en stock."
                 + "</div></div></div>" );  
    }
    
    out.print(json);
    out.flush();
    objConn.desConnect();
%>