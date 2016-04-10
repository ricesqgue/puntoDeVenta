<%-- 
    Document   : cobrar
    Created on : 2/06/2015, 10:41:28 PM
    Author     : Ricardo
--%>

<%@page import="java.util.ArrayList"%>
<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"></jsp:useBean>
<%@page import="org.json.simple.JSONObject"%>
<%
    HttpSession sesion = request.getSession();
    String idUsuario = ""+sesion.getAttribute("idUsuario");
    JSONObject json = new JSONObject();
    int numFilas = Integer.parseInt(request.getParameter("numFilas"));
    float total = Float.parseFloat(request.getParameter("totalGeneral"));
    float descuento = Float.parseFloat (request.getParameter("descuento"));
    float efectivo = Float.parseFloat(request.getParameter("cantidadRecibida"));
    float tarjeta = Float.parseFloat(request.getParameter("tarjeta"));
    float precioCompra = 0;
    float ganancia = 0; 
    String query = "" ;
    String cliente = request.getParameter("cliente");
    System.out.println("Num filas: "+numFilas);
    System.out.println("total: " +total);
    System.out.println("descuento: " + descuento);
    System.out.println("efeectivo: " + efectivo);
    System.out.println("tarjeta: " + tarjeta);
    System.out.println("cliente: " + cliente);
    if(total!=(efectivo+tarjeta+descuento)){
        //Error de que no coinciden las cantidades.
        json.put("error","Ocurrio un error. intente nuevamente (06x1)");
    }
    else{
        
        ArrayList <String> idProducto = new ArrayList();
        ArrayList <Integer> cantidad = new ArrayList();
        ArrayList <Float> precio = new ArrayList();
        ArrayList <String> codigo = new ArrayList();
        
        for(int i=0;i<numFilas;i++){ 
            cantidad.add(Integer.parseInt(request.getParameter("cantidad"+i)));
            precio.add(Float.parseFloat(request.getParameter("precio"+i))); 
            codigo.add(request.getParameter("codigo"+i));
            idProducto.add(request.getParameter("idProd"+i));
            query = "select p.precioU from compraProducto p natural join compraTotal t where p.idProducto = "+ request.getParameter("idProd"+i) +" order by t.fecha desc limit 1;";
            System.out.println(query);
            objConn.Consult(query);
            precioCompra = objConn.rs.getFloat(1);
            System.out.println(precioCompra + "adasdasdasd"); 
            ganancia += Float.parseFloat(request.getParameter("precio"+i)) - precioCompra;
        }
        query = "insert into ventatotal values (default,"+idUsuario+",now(),"+total+","+descuento+","+cliente+","+efectivo+","+tarjeta+","+ganancia+");";
        int idVentaTotal = objConn.Update2(query); 
        
        if(idVentaTotal != -1){ 
            boolean correcto = true;
            for(int i=0;i<codigo.size();i++){
                query = "insert into ventaproducto values(default,"+idProducto.get(i)+","+cantidad.get(i)+",round("+precio.get(i)+",2),"+idVentaTotal+");";  
                if(objConn.Update(query)==0){
                    query = "delete from ventaproducto where idventatotal = " + idVentaTotal+";";
                    objConn.Update(query);
                    query = "delete from ventatotal where idventatotal = " + idVentaTotal+";";
                    objConn.Update(query); 
                    correcto = false;
                    i = codigo.size()+1;
                }       
            }
            if(correcto){                
                json.put("exito", "exito");
            }
            else{
                //Error al insertar alguna de las ventasproducto
                json.put("error", "Error. No se pudo guardar la venta. (06x2)");
            }
        }else{
            //No se pudo insertar la ventatotal
            json.put("error", "Error. No se pudo guardar la venta. (06x3)");
        }
        objConn.desConnect();
    }
    out.print(json);
    out.flush();
%>
