<%-- 
    Document   : checaCodigo
    Created on : 23/05/2015, 10:08:06 PM
    Author     : Ricardo
--%>

    

<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"></jsp:useBean>
<%
    /*****Sesion*****/

    
    /****************/
    
    //Checa los productos.. devuelve true si no existe y false si existe.
    String codigo = request.getParameter("codigo");
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
%>
