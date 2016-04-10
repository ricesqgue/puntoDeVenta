<%-- 
    Document   : modificaProveedor
    Created on : 12/11/2015, 02:24:44 PM
    Author     : ricesqgue
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="org.json.simple.JSONObject"%>
<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"></jsp:useBean>

<%
    JSONObject json = new JSONObject();
    String idProveedor = request.getParameter("idProveedorm"); 
    String nombre = request.getParameter("nombrem");
    String apePat = request.getParameter("apePatm");
    String apeMat = request.getParameter("apeMatm");
    String telefono = request.getParameter("telm");
    String email = request.getParameter("emailm");
    String estado = request.getParameter("estadom");
    String municipio = request.getParameter("municipiom");
    String calle = request.getParameter("callem");
    String numero = request.getParameter("numerom");
    String colonia = request.getParameter("coloniam");
    String cp = request.getParameter("cpm");
    String rfc = request.getParameter("rfcm"); 
    String query = "select idProveedor from proveedor where concat_ws(' ', nombre,apellidoPaterno, apellidoMaterno) = '"+nombre +" "+apePat+" "+ apeMat+"' and idProveedor != "+idProveedor+" and activo = 1;";
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
        //Ya existe una proveedor con ese nombre.
        json.put("error", "<br><div class='row animated slideInLeft'> <div class='col-md-4 col-md-offset-3'>"
                + "<div class='alert alert-danger' role='alert'>"
                + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                + "<span aria-hidden='true'>&times;</span></button>"
                + "<strong>Error. </strong> Ya existe un proveedor con ese nombre."
                + "</div></div></div>" );        
    }else{
        //Se procede a insertar el producto.
        query = "select e.idestado, m.idmunicipio from estados e natural join municipios  m where estado = '"+estado+"' and municipio = '"+municipio+"';";
        objConn.Consult(query);   
        if(objConn.rs == null){
            json.put("error", "<br><div class='row animated slideInLeft'> <div class='col-md-4 col-md-offset-3'>"
                        + "<div class='alert alert-danger' role='alert'>"
                        + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                        + "<span aria-hidden='true'>&times;</span></button>"
                        + "<strong>Error. </strong> Estado y/o municipio no válido(s)."
                        + "</div></div></div>" );
        }
        else{
            estado = objConn.rs.getString(1);
            municipio = objConn.rs.getString(2);
            query = "update proveedor set nombre='"+nombre+"', apellidoPaterno = '"+apePat+"', apellidoMaterno='"+apeMat+"',"
                    + "idEstado = " + estado +" , idMunicipio="+ municipio +", calle='"+calle+"', numero = '"+numero+"' ,"
                    + "colonia = '"+colonia+"' , cp = " + cp +" , rfc = '"+rfc+"', email = '"+email+"', telefono = '"+telefono+"' "
                    + "where idProveedor = "+idProveedor+";"; 
            if(objConn.Update(query)==1){
                //Se modifico correctamente.
                json.put("exito", "<br><div class='row animated slideInLeft'> <div class='col-md-4 col-md-offset-3'>"
                        + "<div class='alert alert-success' role='alert'>"
                        + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                        + "<span aria-hidden='true'>&times;</span></button>"
                        + "<strong>Éxito. </strong> Proveedor modificado correctamente."
                        + "</div></div></div>");
            }
            else{
                //Error al modificicar.
                json.put("error", "<br><div class='row animated slideInLeft'> <div class='col-md-4 col-md-offset-3'>"
                        + "<div class='alert alert-danger' role='alert'>"
                        + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                        + "<span aria-hidden='true'>&times;</span></button>"
                        + "<strong>Error. </strong> No se pudo modificar el proveedor."
                        + "</div></div></div>" );               
            }
        }
    }
    out.print(json);
    out.flush();
    objConn.desConnect();
%>