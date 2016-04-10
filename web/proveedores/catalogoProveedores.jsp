<%-- 
    Document   : catalogoProveedor
    Created on : 14/07/2015, 02:56:58 PM
    Author     : ricesque
--%>
<%@page import="org.json.simple.JSONObject" %>
<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"></jsp:useBean>
<%         
    JSONObject json = new JSONObject();
    String query = "select idproveedor,nombre,apellidoPaterno, apellidoMaterno,telefono, email, calle , numero, colonia, municipio, estado, cp, ucase(rfc) from proveedor natural join estados natural join municipios where activo = 1;";
    objConn.Consult(query); 
    int n = 0;
    if(objConn.rs != null){
        try {
            objConn.rs.last();
            n = objConn.rs.getRow();
            objConn.rs.first();
        } catch (Exception e) {}
    }
    String salida = "";
    if(n>0){
    salida += "<div class=\"table-responsive datagrid\">"
           +  "<table id=\"tablaProveedores\" class=\"table table-striped table-bordered table-hover\">"
                +"<thead>"
                    +"<tr class=\"info\">"
                        +"<th>Nombre</th>"
                        +"<th>Teléfono</th>"
                        +"<th>Email</th>"
                        +"<th>Calle</th>"
                        +"<th>Colonia</th>"
                        +"<th>Municipio</th>"
                        +"<th>Estado</th>"
                        +"<th>CP</th>"
                        +"<th>RFC</th>"
                        +"<th></th><th></th>" 
                    +"</tr>"
                +"</thead>"
                +"<tbody>";                        
                for(int i=0;i< n;i++){                
                    salida += "<tr>";
                    salida += "<td>"+objConn.rs.getString(2)+ " " + objConn.rs.getString(3) +" " + objConn.rs.getString(4) + "</td>"
                            + "<td>"+objConn.rs.getString(5)+"</td>"
                            + "<td>"+objConn.rs.getString(6)+"</td>"
                            + "<td>"+objConn.rs.getString(7)+ " #" + objConn.rs.getString(8) +"</td>"
                            + "<td>"+objConn.rs.getString(9)+"</td>"
                            + "<td>"+objConn.rs.getString(10)+"</td>"
                            + "<td>"+objConn.rs.getString(11)+"</td>"
                            + "<td>"+objConn.rs.getString(12)+"</td>"
                            + "<td>"+objConn.rs.getString(13)+"</td>";
                    
                    salida += "<td><span class='pointer icon-pencil' data-toggle=\"modal\" href=\'#modal-modificar\' onclick='llenaFormulario(\""+objConn.rs.getString(1)+"\",\""+objConn.rs.getString(2)+"\",\""+objConn.rs.getString(3)+"\",\""+objConn.rs.getString(4)+"\",\""+objConn.rs.getString(5)+"\",\""+objConn.rs.getString(6)+"\",\""+objConn.rs.getString(7)+"\",\""+objConn.rs.getString(8)+"\",\""+objConn.rs.getString(9)+"\",\""+objConn.rs.getString(10)+"\",\""+objConn.rs.getString(11)+"\",\""+objConn.rs.getString(12)+"\",\""+objConn.rs.getString(13)+"\")' ></span></td>"
                           + "<td><span class='pointer icon-cross' onclick='idProveedorEliminar = \""+objConn.rs.getString(1)+"\";' data-toggle=\"modal\" href=\'#modal-eliminar\'></span></td></tr>" ;                                   
                    objConn.rs.next(); 
                }
                
                    salida += "</tbody>"
                        +"</table>"
                +"</div>";                                      
                           json.put("tabla", salida);                                    
            }else{            
               salida += " <h3>No hay proveedores registrados</h3>";                    
               json.put("tabla", salida);            
            }       
            objConn.desConnect();
            out.print(json);
            out.flush(); 
            %>
           
        