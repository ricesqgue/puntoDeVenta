<%-- 
    Document   : reporteComprasPorMes
    Created on : 6/12/2015, 10:55:10 PM
    Author     : ricesqgue
--%>

<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"/>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray" %>
<%
JSONObject json = new JSONObject();
String [] meses = {"","Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"};

String query = "call reporteComprasPorMes();";

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
    JSONArray labels = new JSONArray(); 
    JSONArray data = new JSONArray(); 
    String tabla = "";
    tabla  +="<div class='table-responsive datagrid'>" 
                +"<table id='tablaReporte' class='table table-striped table-bordered table-hover'>"
                        +"<thead>"
                           +"<tr class='info' >"
                                +"<th>Mes</th>"                                 
                                +"<th>Total</th>"                               
                            +"</tr>"                       
                        +"</thead>"
                        +"<tbody>";                            
                            for(int i=0;i< n;i++){                                
                                tabla += "<tr>";
                                tabla += "<td>"+meses[objConn.rs.getInt(1)]+"</td>";
                                labels.add(meses[objConn.rs.getInt(1)]);
                                tabla += "<td>"+objConn.rs.getString(2)+"</td>";  
                                data.add(objConn.rs.getFloat(3)); 
                                objConn.rs.next(); 
                            }   
                        tabla+="</tbody>"
                    +"</table>"
                +"</div>";    
    json.put("tabla", tabla);
    json.put("labels", labels); 
    json.put("data",data);      
}else{
    json.put("error", "<br><div class='row animated slideInLeft'> <div class='col-md-4 col-md-offset-3'>"
        + "<div class='alert alert-warning' role='alert'>"
        + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
        + "<span aria-hidden='true'>&times;</span></button>"
        + "<strong>No se encontraron resultados.</stong>"
        + "</div></div></div>" );  
    }
    
objConn.desConnect(); 
out.print(json);
out.flush();
%>