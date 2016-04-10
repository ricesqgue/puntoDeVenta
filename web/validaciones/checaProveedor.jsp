<%-- 
    Document   : checaProveedor
    Created on : 23/05/2015, 10:19:22 PM
    Author     : Ricardo
--%>

<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"></jsp:useBean>
<%
    /*****Sesion*****/

    /****************/
    
    /***Regresa true si exite el proveedor*/
    String proveedor = request.getParameter("proveedor");
    String query = "select * from proveedor where concat(nombre,' ',apellidoPaterno, ' ',apellidoMaterno) = '"+proveedor+"';";
    objConn.Consult(query);
    int n = 0;
    String valido = "false";
    try{
        objConn.rs.last();
        n = objConn.rs.getRow();
    }
    catch(Exception ex){}
    if(n>0){
        valido = "true";  
    }  
    out.print(valido);
    objConn.desConnect(); 
%>