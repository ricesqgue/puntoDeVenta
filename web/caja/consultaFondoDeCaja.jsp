<%-- 
    Document   : consultaFondoDeCaja
    Created on : 24/11/2015, 12:47:15 AM
    Author     : ricesqgue
--%>

<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"/>
<%@page import="org.json.simple.JSONObject"%>

<%
HttpSession sesion = request.getSession();
JSONObject json = new JSONObject();
String fecha = request.getParameter("fecha");

String query = "select idfondocaja, date_format(fecha,'%r') as hora , concat('$',round(cantidad,2)) from fondocaja where date(fecha) = '"+fecha+"';";
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
                    +"<table id='tablaFondoCaja' class='table table-striped table-bordered table-hover'>"
                        +"<thead>"
                           +"<tr class='info' >"
                                +"<th>Hora</th>"
                                +"<th>Cantidad</th>"
                                +"<th></th>"                             
                            +"</tr>"                       
                        +"</thead>"
                        +"<tbody>";                            
                            for(int i=0;i< n;i++){                                
                                tabla += "<tr id='row"+objConn.rs.getString(1)+"'>";                                
                                for(int j=2; j<4; j++){                                        
                                    tabla += "<td>"+objConn.rs.getString(j)+"</td>";
                                }
                                tabla += "<td><span class='icon-cross pointer' onclick='idFondoCajaEliminar = \""+objConn.rs.getString(1)+"\";' data-toggle=\"modal\" href=\'#modal-eliminar\'></span></td>";
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