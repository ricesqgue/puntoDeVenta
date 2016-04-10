<%-- 
    Document   : listaDeudas
    Created on : 24/11/2015, 12:24:27 PM
    Author     : ricesqgue
--%>

<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"/>
<%@page import="org.json.simple.JSONObject"%>

<%
JSONObject json = new JSONObject();
String proveedor = request.getParameter("proveedor");
String query = "select idcompratotal,fechaespanol(date(fecha)) as fecha, folionota, total, abono, deuda, idproveedor from deuda where idProveedor = " + proveedor + ";";
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
    float totalDeuda = 0;
    //Tabla de informacion
       String tabla ="<div class='table-responsive datagrid animated slideInRight'>" 
                    +"<table id='tablaDeudas' class='table table-striped table-bordered' >"
                        +"<thead>"
                           +"<tr class='info' >"
                                +"<th>Folio</th>"
                                +"<th>Fecha</th>"
                                +"<th>Nota</th>"
                                +"<th>Costo</th>"
                                + "<th>Abono</th>"
                                + "<th>Deuda</th>"
                                + "<th>Detalle</th>"                           
                            +"</tr>"                       
                        +"</thead>"
                        +"<tbody >";                            
                            for(int i=0;i< n;i++){                                
                                tabla += "<tr id='row"+objConn.rs.getString(1)+"'>";                                
                                for(int j=1; j<4; j++){                                        
                                    tabla += "<td>"+objConn.rs.getString(j)+"</td>";
                                }
                                tabla += "<td>$"+objConn.rs.getString(4)+"</td>";
                                tabla += "<td>$"+objConn.rs.getString(5)+"</td>";
                                tabla += "<td>$"+objConn.rs.getString(6)+"</td>";
                                totalDeuda += objConn.rs.getFloat(6);
                                tabla += "<td><span class=\'icon-eye pointer\' onclick='detalleCompra(\""+objConn.rs.getString(1)+"\");'></span></td>";
                                tabla+="</tr>";                                   
                                objConn.rs.next(); 
                            }                           
                        tabla+="</tbody>"
                    +"</table>"                    
                +"</div>"
                + "<br><center><h3>Deuda total: $<span id='totalDeuda'>"+totalDeuda+"</span></h3></center>";

                        
    objConn.rs.first();
    
    //Tabla para abonar
    String tabla2 = "<div class='table-responsive datagrid animated slideInLeft'>"
            + "<form id='formTablaAbonar'>" 
                    +"<table id='tablaAbonos' class='table table-striped table-bordered' >"
                        +"<thead>"
                           +"<tr class='info' >"
                                +"<th>Folio</th>"
                                +"<th>Fecha</th>"
                                +"<th>Nota</th>"
                                +"<th>Costo</th>"
                                + "<th>Abono</th>"
                                + "<th>Deuda</th>"
                                + "<th>Abonar</th>"
                                + "<th> </th>"                           
                            +"</tr>"                       
                        +"</thead>"
                        +"<tbody >";  
                            int i = 0;
                            for(i=0;i< n;i++){                                
                                tabla2 += "<tr id='tr"+i+"'>";                                
                                for(int j=1; j<4; j++){                                        
                                    tabla2 += "<td>"+objConn.rs.getString(j)+"</td>";
                                }
                                tabla2 += "<td>$"+objConn.rs.getString(4)+"</td>";
                                tabla2 += "<td>$"+objConn.rs.getString(5)+"</td>";
                                tabla2 += "<td>$<span id='d"+i+"'>"+objConn.rs.getString(6)+"</span></td>";
                                tabla2 += "<td><input type='text' name='a"+i+"' id='a"+i+"' onfocus='borraCantidad(\""+i+"\")' onblur='checaCantidad(\""+i+"\")' value='0' ></td>";
                                tabla2 += "<td><input type='checkbox' id='c"+i+"' onchange='abona(\""+i+"\")'></td>";
                                tabla2 += "<input type='hidden' name='idCompraTotal"+i+"' value='"+objConn.rs.getString(1)+"'>";
                                tabla2+="</tr>";                                   
                                objConn.rs.next(); 
                            }                           
                        tabla2+="</tbody>"
                    +"</table>"
                    + "<input type='hidden' name='numFilas' value='"+(i-1)+"'>"
                + "</form>"
            +"</div>"
            + "<br><center><h3>Cantidad a abonar: $<span id='abono'></span></h3></center><br>"
            + "<div class='row containter'>"
                + "<div class=' col-xs-offset-3 col-xs-4 col-md-1 col-md-offset-5'><button class='btn btn-warning' onclick='regresarAContenido()' type='button'>Regresar</button></div>"
                + "<div class=' col-xs-4 col-md-1'><button class='btn btn-success' id='btnAbonar' disabled='disabled' onclick='confirmaAbono()' type='button'>Abonar</button></div>"
            + "</div>";
                              
    json.put("tabla", tabla);
    json.put("form","<div class='form-inline'>"
                    +"<form id='formAbonar' autocomplete='off'>"
                    +"<div class='form-group'>"
                    +"<label class='control-label' for='cantidad'>Abonar </label>"
                    +" <input type='text' placeholder='Cantidad' name='cantidad' id='cantidad' class='form-control'>"
                    +"</div> "                        
                    +" <div class='form-group'>"
                    +"      <button id='btnCantidad' type='button' onclick='cantidadAbonar()' class='btn btn-success'> <span class='icon-arrow-right2'> </span> <span class='icon-coin-dollar'> </span></button>"
                    +"</div>"                                             
                    +"</form>"           
                    +"</div>");
    json.put("tablaAbonar",tabla2);
    
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

