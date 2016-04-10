<%-- 
    Document   : listaMovimientos
    Created on : 20/11/2015, 11:20:59 PM
    Author     : ricesqgue
--%>

<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"/>
<%@page import="org.json.simple.JSONObject"%>

<%
JSONObject json = new JSONObject(); 
String fecha = request.getParameter("fecha");
String cbEntrada = request.getParameter("cbEntrada");
String cbSalida = request.getParameter("cbSalida");
String condicion = "";
if(cbEntrada.equals("false") && cbSalida.equals("true")){
    condicion = "and tipo = 1";
}
else if(cbEntrada.equals("true") && cbSalida.equals("false")){
    condicion = "and tipo = 2";
}
String query = "select idMovimiento, tipoMovCaja(tipo) as tipo, concat('$',round(cantidad,2)),concepto,time(fecha) from movimientoscaja where date(fecha) = '"+fecha+"' "+condicion+";";
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
   String tabla ="<div class='table-responsive datagrid animated slideInRight'>" 
                    +"<table id='tablaMovimientosCaja' class='table table-striped table-bordered table-hover'>"
                        +"<thead>"
                           +"<tr class='info' >"
                                +"<th>Movimiento</th>"
                                +"<th>Cantidad</th>"
                                +"<th>Concepto</th>"
                                +"<th>Hora</th>"
                                +"<th></th>"                             
                            +"</tr>"                       
                        +"</thead>"
                        +"<tbody>";                            
                            for(int i=0;i< n;i++){                                
                                tabla += "<tr id='row"+objConn.rs.getString(1)+"'>";                                
                                for(int j=2; j<6; j++){                                        
                                    tabla += "<td>"+objConn.rs.getString(j)+"</td>";
                                }
                                tabla += "<td><span class='icon-cross pointer' onclick='idMovimientoCajaEliminar = \""+objConn.rs.getString(1)+"\";' data-toggle=\"modal\" href=\'#modal-eliminar\'></span></td>";
                                tabla+="</tr>";                                   
                                objConn.rs.next(); 
                            }                           
                        tabla+="</tbody>"
                    +"</table>"
                +"</div>";
    json.put("tabla", tabla);
    
}else{
    
   json.put("error","<div id='mensaje' class='col-md-4 animated slideInRight'> "
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