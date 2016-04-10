<%-- 
    Document   : terminaCompra
    Created on : 16/11/2015, 11:48:31 PM
    Author     : ricesqgue
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="org.json.simple.JSONObject"%>
<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"/>

<%
HttpSession sesion = request.getSession();
String idUsuario = ""+ sesion.getAttribute("idUsuario");  
String idProveedor = request.getParameter("idProveedor");
JSONObject json = new JSONObject();
int numFilas = Integer.parseInt(request.getParameter("numProductos"));
float total = 0;
String query = ""; 
ArrayList <Integer> cantidad = new ArrayList();
ArrayList <Float> importe = new ArrayList();
ArrayList <String> codigo = new ArrayList();
for(int i=0;i<numFilas;i++){ 
       cantidad.add(Integer.parseInt(request.getParameter("cantidad"+i)));
        importe.add(Float.parseFloat(request.getParameter("importe"+i))); 
        codigo.add(request.getParameter("codigo"+i));
}
query = "insert into compratotal values (default,"+idUsuario+",0,now(),'"+request.getParameter("folioNota")+"',"+idProveedor+");";
int idCompraTotal = objConn.Update2(query);
if(idCompraTotal != -1){
   boolean correcto = true;
   for(int i=0;i<codigo.size();i++){
       String idProducto;
       objConn.Consult("select idProducto from producto where codigo = '" + codigo.get(i) + "' and activo = 1;");
       idProducto = objConn.rs.getString(1);
       total += importe.get(i);
       query = "insert into compraproducto values(default,"+idProducto+","+cantidad.get(i)+",round("+(Math.rint(importe.get(i)/cantidad.get(i)*100)/100)+",2),"+idCompraTotal+");";
       if(objConn.Update(query)==0){
           query = "delete from compraproducto where idcompratotal = " + idCompraTotal+";";
           objConn.Update(query);
           query = "delete from compratotal where idcompratotal = " + idCompraTotal+";";
           objConn.Update(query); 
           correcto = false;
           i = codigo.size()+1;
       }       
   }
   if(correcto){
       objConn.Update("update compratotal set total=round("+ total +",2) where idcompratotal = " + idCompraTotal +";");
       json.put("exito", "Compra guardada correctamente.");
   }
   else{
       json.put("error", "Error. No se pudo guardar la compra.");
   }
}else{
    json.put("error", "Error. No se pudo guardar la compra.");
}
out.print(json);
objConn.desConnect();
out.flush();       
 %>