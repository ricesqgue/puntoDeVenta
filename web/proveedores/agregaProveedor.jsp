<%-- 
    Document   : agregaProveedor
    Created on : 12/11/2015, 06:30:43 PM
    Author     : Ricardo
--%>
<%@page import="org.json.simple.JSONObject"%>

<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"></jsp:useBean>
<%
    JSONObject json = new JSONObject();
    String nombre = request.getParameter("nombre");
    String apePat = request.getParameter("apePat");
    String apeMat = request.getParameter("apeMat");
    String telefono = request.getParameter("tel");
    String email = request.getParameter("email");
    String estado = request.getParameter("estado");
    String municipio = request.getParameter("municipio");
    String calle = request.getParameter("calle");
    String numero = request.getParameter("numero");
    String colonia = request.getParameter("colonia");
    String cp = request.getParameter("cp");
    String rfc = request.getParameter("rfc").toUpperCase(); 
    
    String query ="select idProveedor from proveedor where concat_ws(' ', nombre,apellidoPaterno, apellidoMaterno) = '"+nombre +" "+apePat+" "+ apeMat+"';"; 
    objConn.Consult(query);
    int n = 0;
    if(objConn.rs != null){
        try{
            objConn.rs.last();
            n = objConn.rs.getRow();           
        }
        catch(Exception e){}
    }    
    if(n>0){
        //Ya existe un proveedor con ese nombre.
        json.put("error", "<br><div class='row animated slideInLeft'> <div class='col-md-4 col-md-offset-3'>"
                        + "<div class='alert alert-danger' role='alert'>"
                        + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                        + "<span aria-hidden='true'>&times;</span></button>"
                        + "<strong>Error. </strong> Ya existe un proveedor con ese nombre."
                        + "</div></div></div>" );
    }
    else{
        //Se procede a agregar al proveedor.
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
            query = "insert into proveedor values (default,'"+nombre+"','"+apePat+"','"+apeMat+"','"+telefono+"','"+email+"',"
                    + estado+","+municipio+",'"+colonia+"','"+calle+"','"+numero+"',"+cp+",'"+rfc+"',1)"; 
            if(objConn.Update(query)==1){
                //Se agrego correctamente.
                json.put("exito", "<br><div class='row animated slideInLeft'> <div class='col-md-4 col-md-offset-3'>"
                        + "<div class='alert alert-success' role='alert'>"
                        + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                        + "<span aria-hidden='true'>&times;</span></button>"
                        + "<strong>Éxito. </strong> Proveedor agregado correctamente."
                        + "</div></div></div>");
            }
            else{
                //Error al agregar.
                json.put("error", "<br><div class='row animated slideInLeft'> <div class='col-md-4 col-md-offset-3'>"
                        + "<div class='alert alert-danger' role='alert'>"
                        + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                        + "<span aria-hidden='true'>&times;</span></button>"
                        + "<strong>Error. </strong> No se pudo agregar al proveedor."
                        + "</div></div></div>" );               
            }
                    
        }        
    }
    out.print(json);
    out.flush();
    objConn.desConnect();
    
    
%>
