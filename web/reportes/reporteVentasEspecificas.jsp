<%-- 
    Document   : reporteVentasEspecificas
    Created on : 4/12/2015, 09:08:21 PM
    Author     : ricesqgue
--%>

<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"/>
<%@page import="org.json.simple.JSONObject"%>

<%
JSONObject json = new JSONObject();
String fechaInicial = request.getParameter("fechaInicial");
String fechaFinal = request.getParameter("fechaFinal");

String query = "call reporteVentasEspecificas('"+fechaInicial+"','"+fechaFinal+"');"; 
objConn.Consult(query);
int n = 0;
if(objConn.rs != null){
    try{
        objConn.rs.last();
        n = objConn.rs.getRow();
        objConn.rs.first();
    }
    catch(Exception e){}    
}
if(n>0){
    float totalVentas = 0;
       String tabla ="<div class='table-responsive datagrid animated slideInRight'>" 
            +"<table id='tablaReporte' class='table table-striped table-bordered' >"
                +"<thead>"
                    +"<tr class='info' >"
                        +"<th>Folio</th>"
                        +"<th>Fecha</th>"
                        +"<th>Total</th>"
                        +"<th>Descuento</th>"
                        +"<th>P. Efectivo</th>"
                        +"<th>P. Tarjeta</th>"
                        +"<th>Detalle</th>"                           
                    +"</tr>"                       
                +"</thead>"
                +"<tbody >";                            
                    for(int i=0;i< n;i++){                                
                        tabla += "<td>"+objConn.rs.getString(1)+"</td>";
                        tabla += "<td>"+objConn.rs.getString(2)+"</td>";
                        tabla += "<td>$"+objConn.rs.getString(3)+"</td>";
                        tabla += "<td>$"+objConn.rs.getString(4)+"</td>";
                        tabla += "<td>$"+objConn.rs.getString(5)+"</td>";
                        tabla += "<td>$"+objConn.rs.getString(6)+"</td>";
                        totalVentas += (objConn.rs.getFloat("total")-objConn.rs.getFloat("descuento"));
                        tabla += "<td><span class=\'icon-eye pointer\' onclick='detalleVenta(\""+objConn.rs.getString(1)+"\");'></span></td>";
                        tabla+="</tr>";                                   
                        objConn.rs.next(); 
                    }                           
                    tabla+="</tbody>"
                +"</table>"                    
                +"</div>"
                + "<br><center><h3>Venta total: $"+totalVentas+"</h3></center>";
    json.put("tabla", tabla);
                           
}else{
    json.put("error", "<div id='mensaje' class='col-sm-4 col-sm-offset-4 animated slideInRight'> "
        + "<div class='alert alert-warning' role='alert'>"
        + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
        + "<span aria-hidden='true'> &times;</span></button>"
        + "<strong>No se encontraron resultados.</strong>"
        + "</div></div>");
}
objConn.desConnect();
out.print(json);
out.flush();

%>

