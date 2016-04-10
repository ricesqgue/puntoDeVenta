<%-- 
    Document   : checaProveedor2
    Created on : 26/05/2015, 10:24:36 PM
    Author     : Ricardo
--%>

<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"></jsp:useBean>
<%
    /*****Sesion*****/

    /****************/
    
    /***Regresa false si exite el proveedor*/
    String proveedor = request.getParameter("nombre");
    String query = "select * from proveedor where concat(nombre,' ',apellidoPaterno, ' ',apellidoMaterno) = '"+proveedor+"';";
    System.out.println(query);
    objConn.Consult(query);
    int n = 0;
    String valido = "true";
    try{
        objConn.rs.last();
        n = objConn.rs.getRow();
    }
    catch(Exception ex){}
    if(n>0){
        valido = "false";  
    }
    System.out.println("Checa proveedor " + valido +" " + proveedor);  
    out.print(valido); 
    objConn.desConnect(); 
%>