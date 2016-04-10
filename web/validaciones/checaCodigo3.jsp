<%-- 
    Document   : checaCodigo3
    Created on : 24/05/2015, 12:35:39 AM
    Author     : Ricardo
--%>

<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"></jsp:useBean>
<%
    /*****Sesion*****/

    /****************/
    
    //Checa codigo para modificar.. devuelve true si es valido modificar y false si no es valido
    String oldCodigo = request.getParameter("oldCodigo"); 
    String codigo = request.getParameter("codigo");
    if(oldCodigo.equals(codigo)){
        out.print("true"); 
    }else{
        String query = "select * from producto where codigo = "+codigo+" and activo = 1;";
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
        out.print(valido);
        objConn.desConnect(); 
    }
%>