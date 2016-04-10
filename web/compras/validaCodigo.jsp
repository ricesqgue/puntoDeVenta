<%-- 
    Document   : validaCodigo
    Created on : 13/11/2015, 11:52:02 AM
    Author     : ricesqgue
--%>

<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"></jsp:useBean>

<%   
String idProveedor = request.getParameter("idProveedor");
String codigo = request.getParameter("codigo");
String valido = "";
if(idProveedor.equals("--- Elegir proveedor ---")){ 
    valido = "false";
}
else{
    String query = "select idProducto from producto where codigo = " + codigo +" and idProveedor = " + idProveedor+" and activo = 1;"; 
    objConn.Consult(query);
    int n=0;
    if(objConn.rs != null){
    try{
        objConn.rs.last();
        n = objConn.rs.getRow();
        objConn.rs.first();
    }catch(Exception e){}
    }
    if(n>0){
        valido = "true";
    }else{
        valido = "false";
    }
    objConn.desConnect();
}
out.print(valido);
out.flush();



%>