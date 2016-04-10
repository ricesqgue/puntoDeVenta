<%-- 
    Document   : llenaTabla
    Created on : 28/05/2015, 09:49:23 PM
    Author     : Ricardo
--%>

<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"/>
<%@page import="org.json.simple.JSONObject"%>

<%
JSONObject json = new JSONObject();
String codigo = request.getParameter("codigo");
String cantidad = request.getParameter("cantidad");
String importe = request.getParameter("importe"); 
String numFilas = request.getParameter("numFilas");
String query = "select idProducto, codigo, descripcion, marca, categoria from producto natural join categorias natural join marcas where codigo = '"+codigo+"' and activo = 1;";
objConn.Consult(query);
int n = 0;
if(objConn.rs != null){
    try{
        objConn.rs.last();
        n = objConn.rs.getRow();
        objConn.rs.first();
    }catch(Exception e){}    
}
if(n>0){   
    float cant = Float.parseFloat(cantidad);
    float impor = Float.parseFloat(importe);
    
    String salida = "<tr id='f"+numFilas+"'>" 
            + "<td>"+objConn.rs.getString(2)+"</td>"
            + "<td>"+objConn.rs.getString(3)+"</td>"
            + "<td>"+objConn.rs.getString(4)+"</td>"
            + "<td>"+objConn.rs.getString(5)+"</td>"
            + "<td>"+cantidad+"</td>"
            + "<td> $"+Math.rint((impor/cant)*100)/100+"</td>" 
            + "<td> $"+importe+"</td>"
            + "<td ><span class='icon-cross pointer' onclick='$(\"#f"+numFilas.toString()+"\").remove(); renombraFilas();'></span></td>"
            + "<input type='hidden' name=\"cantidad"+numFilas+"\" value=\""+cantidad+"\">"
            + "<input type='hidden' name=\"codigo"+numFilas+"\" value=\""+codigo+"\">"
            + "<input type='hidden' name=\"producto"+numFilas+"\" value=\""+objConn.rs.getString(3) +"\">"
            + "<input type='hidden' name=\"importe"+numFilas+"\" value=\""+importe+"\">"
            + "</tr>";
    json.put("exito", salida);
}
else{
    System.out.print("Error");    
    json.put("error", "error");
}
out.print(json);
out.flush();
objConn.desConnect();

%>