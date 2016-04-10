<%-- 
    Document   : tablaProductos
    Created on : 16/11/2015, 09:11:47 PM
    Author     : ricesqgue
--%>

<%@page import="org.json.simple.JSONObject"%>
<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"/>

<%
JSONObject json = new JSONObject();
String idProveedor = request.getParameter("idProveedor");
String query = "select codigo, descripcion, categoria, marca, stock from producto natural join categorias natural join marcas where producto.activo = 1 and idProveedor = " + idProveedor +" order by codigo;";
objConn.Consult(query);
String tabla = "";
int n = 0; 
if(objConn.rs != null){
    try{
        objConn.rs.last();
         n = objConn.rs.getRow();
         objConn.rs.first();
    }catch(Exception e){}
}
                                                   

                           
if(n>0){
    tabla = "<div class='table-responsive datagrid'><table class='table table-striped' id='tabla'>" 
            + "<thead>"
            + "<tr class='info'>"
            + "<th>Codigo</th>"
            + "<th>Producto</th>"
            + "<th>Categoría</th>"
            + "<th>Marca</th>"
            + "<th>Stock</th>"
            + "</tr>"
            + "</thead>"
            + "<tbody>"; 
    for (int i = 0; i < n; i++) {
        tabla += "<tr>";
        for (int j = 1; j < 6; j++) {
            tabla += "<td style='cursor:pointer' onclick='seleccionProducto(" + objConn.rs.getString(1) + ")'>" + objConn.rs.getString(j) + "</td>";
        }
        tabla += "</tr>";
        objConn.rs.next();
    }
    tabla += "</tbody> </table></div>";
    json.put("tabla",tabla);    
}
objConn.desConnect();
out.print(json);
out.flush();
%>