<%-- 
    Document   : reporteProductosComprados
    Created on : 6/12/2015, 10:51:37 PM
    Author     : ricesqgue
--%>
<%@page import="org.json.simple.JSONArray"%>
<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"/>
<%@page import="org.json.simple.JSONObject"%>
<%
String fechaInicial = request.getParameter("fechaInicial");
String fechaFinal = request.getParameter("fechaFinal");
JSONObject json = new JSONObject();
String query = "call reporteProductosComprados('"+fechaInicial+"','"+fechaFinal+"');";
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
    String tabla = "";
    tabla  +="<div class='table-responsive datagrid animated slideInRight'>" 
                +"<table id='tablaReporte' class='table table-striped table-bordered table-hover'>"
                        +"<thead>"
                           +"<tr class='info' >"
                                +"<th>Código</th>"  
                                +"<th>Producto</th>"
                                +"<th>Marca</th>"
                                +"<th>Categoría</th>"
                                +"<th>Proveedor</th>"
                                +"<th>Cantidad</th>"                               
                            +"</tr>"                       
                        +"</thead>"
                        +"<tbody>";                            
                            for(int i=0;i< n;i++){                                
                                tabla += "<tr>";                                                    
                                    for(int j=1; j<7; j++){                                         
                                        tabla += "<td>"+objConn.rs.getString(j)+"</td>";
                                    } 
                                objConn.rs.next(); 
                            }   
                        tabla+="</tbody>"
                    +"</table>"
                +"</div>";    
    json.put("tabla", tabla);
    
    query = "select p.descripcion as producto, sum(cp.cantidad) as cantidad from compraproducto cp natural join producto p natural join compratotal ct where date(ct.fecha) between '"+fechaInicial+"' and '"+fechaFinal+"' group by producto limit 10;";
    objConn.Consult(query);
    n = 0;
    try{
        if(objConn != null){
            objConn.rs.last();
            n = objConn.rs.getRow();
            objConn.rs.first();
        }
    }catch(Exception e){}
    if(n>0){
        JSONArray labels = new JSONArray(); 
        JSONArray data = new JSONArray(); 
        for(int i = 0; i<n;i++){
            labels.add(objConn.rs.getString("producto"));
            data.add(objConn.rs.getInt("cantidad"));
            objConn.rs.next();
        }
        json.put("labels", labels);
        json.put("data", data);
    }
    
   
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


