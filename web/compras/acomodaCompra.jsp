<%-- 
    Document   : acomodaCompra
    Created on : 16/11/2015, 10:40:41 PM
    Author     : ricesqgue
--%>


<%@page import="java.util.ArrayList"%>
<%@page import="org.json.simple.JSONObject"%>

<%
JSONObject json = new JSONObject();
int numFilas = Integer.parseInt(request.getParameter("numFilas")); 
ArrayList <String> codigo = new ArrayList();
ArrayList <String> producto = new ArrayList();  
ArrayList <Integer> cantidad = new ArrayList();
ArrayList <Float> importe = new ArrayList();
float totalCompra = 0;
for(int i = 0;i<numFilas;i++){
    codigo.add(request.getParameter("codigo"+i));
    cantidad.add(Integer.parseInt(request.getParameter("cantidad"+i)));
    producto.add(request.getParameter("producto"+i));
    importe.add(Float.parseFloat(request.getParameter("importe"+i)));
}
for(int i = 0; i<codigo.size();i++){
    String cod = codigo.get(i);
    int cant = cantidad.get(i);
    float impo = importe.get(i);
    for(int j=1+i;j<codigo.size();j++){
        if(codigo.get(j).equals(cod)){ 
            cant += cantidad.get(j);
            impo += importe.get(j);       
            codigo.remove(j);
            cantidad.remove(j);
            producto.remove(j);
            importe.remove(j);
            j--;
        }
    }
    cantidad.set(i,cant);
    importe.set(i,impo);
}
String idProveedor = request.getParameter("idProveedor"); 
 String tabla = "<form id='formTerminaCompra'>"
         + "<label class='control-label' for='folioNota'>Folio de nota</label>"         
         + "<input type='text' name='folioNota' id='folioNota' class='form-control'>"
         + "<br>"
         + "<div class='table-responsive'><table class='table table-striped'>"
            + "<input type='hidden' name='numProductos' value='"+codigo.size()+"'>"
            + "<input type='hidden' name='idProveedor' value='"+idProveedor+"'>" 
            + "<thead>"
            + "<tr class='info'>"
            + "<th>Codigo</th>"
            + "<th>Producto</th>"
            + "<th>Cantidad</th>"
            + "<th>Precio Unitario</th>"
            + "<th>Importe total</th>"
            + "</tr>"
            + "</thead>"
            + "<tbody>"; 
    for (int i = 0; i < codigo.size(); i++) {
        tabla += "<tr>";
        tabla += "<td>"+ codigo.get(i) +"</td>"
                + "<input type='hidden' name='codigo"+i+"' value='"+codigo.get(i)+"'>"
                +"<td>"+ producto.get(i) +"</td>"
                +"<td>"+ cantidad.get(i) +"</td>"
                + "<input type='hidden' name='cantidad"+i+"' value='"+cantidad.get(i)+"'>" 
                +"<td>"+ Math.rint(importe.get(i)/cantidad.get(i)*100)/100 +"</td>"
                + "<input type='hidden' name='importe"+i+"' value='"+importe.get(i)+"'>"                
                +"<td>"+ importe.get(i) +"</td>";        
        tabla += "</tr>";
        totalCompra += importe.get(i); 
    }
    tabla += "</tbody> </table></div><h3>Total $"+Math.rint(totalCompra*100)/100+"</h3></form>";
    json.put("tabla",tabla); 
    out.print(json);
    out.flush();
    
 
%>