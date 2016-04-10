<%-- 
    Document   : checkLogin
    Created on : 3/06/2015, 11:45:37 AM
    Author     : Ricardo
--%>
<%@page import="org.json.simple.JSONObject"%> 
<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"></jsp:useBean>
<%
    
    String usuario = "";
    String password = "";
    JSONObject json = new JSONObject();
    if(request.getParameter("password")!= null && request.getParameter("usuario")!= null){
        usuario = request.getParameter("usuario");
        password = request.getParameter("password");
        objConn.Consult("select idUsuario,nombre,permiso from usuario where usuario = '"+usuario+"' and password = MD5('"+password+"') and activo = 1;");
        int n = 0;
        try{
            objConn.rs.last();
            n = objConn.rs.getRow();
            
        }
        catch(Exception e){}
        if(n>0){
            HttpSession sesion = request.getSession();
            sesion.setAttribute("idUsuario",objConn.rs.getString(1));
            sesion.setAttribute("nombre", objConn.rs.getString(2));            
            sesion.setAttribute("permiso",objConn.rs.getString(3)); 
            sesion.setMaxInactiveInterval(-1);
            json.put("respuesta", "1"); 
            objConn.Update("insert into iniciosdesesion values (default,"+objConn.rs.getString(1)+",now());");
        }
        else{
             String mensaje = "<br><div class='row animated slideInLeft'> <div class='col-md-4 col-md-offset-3'>"
                + "<div class='alert alert-danger' role='alert'>"
                + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                + "<span aria-hidden='true'>&times;</span></button>"
                + "<strong>Error.</strong> Usuario o contraseña incorrecta"
                + "</div></div></div>"; 
              json.put("respuesta", mensaje);
        }
        objConn.desConnect(); 
        out.print(json);
        out.flush();
 
    }
            
%>
