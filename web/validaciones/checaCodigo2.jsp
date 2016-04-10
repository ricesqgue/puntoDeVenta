<%-- 
    Document   : checaCodigo2
    Created on : 24/05/2015, 12:04:50 AM
    Author     : Ricardo
--%>

<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"></jsp:useBean>
<%
    /*****Sesion*****/

    /****************/
    
    //Checa los productos.. devuelve true si existe y false si no existe.
    String codigo = request.getParameter("codigo");
    String query = "select * from producto where codigo = "+codigo+" and activo = 1;";
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