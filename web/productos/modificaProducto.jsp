<%-- 
    Document   : modificaProducto
    Created on : 4/11/2015, 08:05:17 PM
    Author     : ricesqgue
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="org.json.simple.JSONObject"%>
<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"></jsp:useBean>

<%
    JSONObject json = new JSONObject();
    String idProducto = request.getParameter("idProductom"); 
    String codigo = request.getParameter("codigom");
    String descripcion = request.getParameter("descripcionm");
    String categoria = request.getParameter("categoriam");
    String marca = request.getParameter("marcam");
    String proveedor = request.getParameter("proveedorm");
    String precioVenta = request.getParameter("precioVentam");     
    String precioMayoreo = request.getParameter("precioMayoreom");         
    String query = "select idproducto from producto where (codigo = "+codigo+" or descripcion = '"+descripcion+"') and idProducto != "+idProducto+" and activo = 1;";
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
        //Ya existe una producto con ese nombre o codigo.
        json.put("error", "<br><div class='row animated slideInLeft'> <div class='col-md-4 col-md-offset-3'>"
                + "<div class='alert alert-danger' role='alert'>"
                + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                + "<span aria-hidden='true'>&times;</span></button>"
                + "<strong>Error. </strong> Ya existe un producto con ese código y/o descripción."
                + "</div></div></div>" );        
    }else{
        //Se procede a modificar el producto.
        query = "select (select idCategoria from categorias where categoria = '"+categoria+"') as categoria, "
                + "(select idMarca from marcas where marca = '"+marca+"') as marca, "
                + "(select idProveedor from proveedor where concat_ws(' ', nombre,apellidoPaterno,apellidoMaterno) = '"+proveedor+"') as proveedor;";
        System.out.println(query);  
        objConn.Consult(query);
        categoria = objConn.rs.getString(1);
        marca = objConn.rs.getString(2);
        proveedor = objConn.rs.getString(3); 
        query = "update producto set codigo = "+codigo+", descripcion = '"+descripcion+"', idproveedor = "+proveedor+", precioVenta = "+precioVenta+", precioMayoreo = "+precioMayoreo+", idcategoria = "+categoria+", idmarca = "+marca+"  where idProducto = "+idProducto+ ";";
        System.out.println(query); 
        if(objConn.Update(query)==1){
            //Se modificó correctamente.
            json.put("exito", "<br><div class='row animated slideInLeft'> <div class='col-md-4 col-md-offset-3'>"
                        + "<div class='alert alert-success' role='alert'>"
                        + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                        + "<span aria-hidden='true'>&times;</span></button>"
                        + "<strong>Éxito. </strong> Producto modificado correctamente."
                        + "</div></div></div>");
        }
        else{
            //Error al insertar en la BD.
             json.put("error", "<br><div class='row animated slideInLeft'> <div class='col-md-4 col-md-offset-3'>"
                        + "<div class='alert alert-danger' role='alert'>"
                        + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                        + "<span aria-hidden='true'>&times;</span></button>"
                        + "<strong>Error. </strong> No se pudo modificar el producto."
                        + "</div></div></div>" );               
        }
    }
    out.print(json);
    out.flush();
    objConn.desConnect();
%>