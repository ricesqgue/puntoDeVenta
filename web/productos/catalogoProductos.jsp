<%--    
    Document   : catalogoProductos
    Created on : 4/11/2015, 06:00:10 PM
    Author     : ricesqgue
--%>

<%@page import="org.json.simple.JSONObject" %>
<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"></jsp:useBean>    
<%     
    JSONObject json = new JSONObject();
    String query = "select p.idProducto, p.codigo, p.descripcion, concat_ws(' ',pr.nombre, pr.apellidoPaterno, pr.apellidoMaterno), c.categoria, m.marca,"
            + "p.stock, round(precioVenta,2), round(precioMayoreo,2) from producto p natural join proveedor pr natural join categorias c natural join marcas m where p.activo = 1;";          
    System.out.print("Query 1: Catalogo Producto: " + query);
    objConn.Consult(query);
    int n = 0;
    String salida = "";
    try {
        if(objConn.rs != null){
            objConn.rs.last();
            n = objConn.rs.getRow();
            objConn.rs.first();
        }
    } catch (Exception e) {}
    if(n>0){        
        salida  +="<div class='table-responsive datagrid'>" 
                    +"<table id='tablaProductos' class='table table-striped table-bordered table-hover'>"
                        +"<thead>"
                           +"<tr class='info' >"
                                +"<th>Código</th>"
                                +"<th>Producto</th>"
                                +"<th>Proveedor</th>"
                                +"<th>Categoría</th>"
                                +"<th>Marca</th>"
                                +"<th>Stock</th>"
                                +"<th>Precio de venta</th>"
                                + "<th>Precio de mayoreo</th>"
                                +"<th></th><th></th>"                                
                            +"</tr>"                       
                        +"</thead>"
                        +"<tbody>";
                            
                            for(int i=0;i< n;i++){                                
                                salida += "<tr>";                                
                                for(int j=2; j<10; j++){                                        
                                    salida += "<td>"+objConn.rs.getString(j)+"</td>";
                                }
                                
                                salida += "<td><span class='icon-pencil pointer' onclick='llenaFormulario(\""+objConn.rs.getString(1)+"\",\""+objConn.rs.getString(2)+"\",\""+objConn.rs.getString(3)+"\",\""+objConn.rs.getString(4)+"\",\""+objConn.rs.getString(5)+"\",\""+objConn.rs.getString(6)+"\",\""+objConn.rs.getString(8)+"\",\""+objConn.rs.getString(9)+"\")' data-toggle=\"modal\" href=\'#modal-modificar\'></span></td>"
                                        + "<td><span class='icon-cross pointer' onclick='idProductoEliminar = \""+objConn.rs.getString(1)+"\";' data-toggle=\"modal\" href=\'#modal-eliminar\'></span></td>";
                                salida+="</tr>";                                   
                                objConn.rs.next(); 
                            }                           
                        salida+="</tbody>"
                    +"</table>"
                +"</div>";                
                json.put("tabla", salida);                                    
            }else{            
               salida += " <h3>No hay productos registrados</h3>";                    
               json.put("tabla", salida);            
            }       
            objConn.desConnect();
            out.print(json);
            out.flush();        
%>

