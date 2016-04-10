<%-- 
    Document   : reportePagoProveedores
    Created on : 10/12/2015, 08:00:40 PM
    Author     : ricesqgue
--%>
<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"/>
<%@page import="org.json.simple.JSONObject"%>

<%
JSONObject json = new JSONObject();
String fechaInicial = request.getParameter("fechaInicial");
String fechaFinal = request.getParameter("fechaFinal");

String query = " call reportePagoProveedores('"+fechaInicial+"','"+fechaFinal+"');";
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
    float totalCompras = 0;
       String tabla ="<div class='table-responsive datagrid animated slideInRight'>" 
            +"<table id='tablaReporte' class='table table-striped table-bordered' >"
                +"<thead>"
                    +"<tr class='info' >"
                        +"<th>ID Abono</th>"
                        +"<th>Proveedor</th>"
                        +"<th>Cantidad</th>"                      
                        +"<th>Fecha</th>"
                        +"<th>Detalle</th>"                           
                    +"</tr>"                       
                +"</thead>"
                +"<tbody >";                            
                    for(int i=0;i< n;i++){                                
                        tabla += "<td>"+objConn.rs.getString(1)+"</td>";
                        tabla += "<td>"+objConn.rs.getString(2)+"</td>";
                        tabla += "<td>"+objConn.rs.getString(3)+"</td>";
                        tabla += "<td>"+objConn.rs.getString(4)+"</td>";
                        tabla += "<td><span class=\'icon-eye pointer\' onclick='detalleAbono(\""+objConn.rs.getString(1)+"\");'></span></td>";                                             
                        tabla+="</tr>";                                   
                        objConn.rs.next(); 
                    }                           
                    tabla+="</tbody>"
                +"</table>"                    
                +"</div>";
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


