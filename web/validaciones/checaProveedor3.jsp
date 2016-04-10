<%-- 
    Document   : checaProveedor3
    Created on : 26/05/2015, 11:04:29 PM
    Author     : Ricardo
--%>

<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"></jsp:useBean>
<%
    /*****Sesion*****/

    /****************/
    
    
    String oldProveedor = request.getParameter("oldProveedor"); //Nombre 
    String proveedor = request.getParameter("proveedor");
    if(oldProveedor.equals(proveedor)){
        out.print("true");
    }else{
        String query = "select * from proveedor where concat(nombre,' ',apellidoPaterno, ' ',apellidoMaterno) = '"+proveedor+"';";
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
    }
%>
