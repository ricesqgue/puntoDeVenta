<%-- 
    Document   : consultaCorteDia
    Created on : 1/12/2015, 06:46:10 PM
    Author     : ricesqgue
--%>
<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"/>
<%@page import="org.json.simple.JSONObject"%>

<%
    JSONObject json = new JSONObject();
    String query = "select total, descuento, efectivo ,tarjeta from corte where fecha = date(now());";
    float totalVentas = 0;
    float efectivo = 0;
    float tarjeta = 0;
    float descuento = 0; 
    float fondoDeCaja = 0;
    float totalSalida = 0;
    float totalEntrada = 0;
    float ganancia = 0;
    int productosVendidos = 0; 
    String listaSalida = "";
    String listaEntrada = ""; 

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
        totalVentas = objConn.rs.getFloat("total");        
        efectivo = objConn.rs.getFloat("efectivo");
        tarjeta = objConn.rs.getFloat("tarjeta");
        descuento = objConn.rs.getFloat("descuento");
    }
    objConn.Consult("select cantidad from fondocaja order by idfondocaja desc limit 1;");
    if(objConn.rs != null){
        try{
            fondoDeCaja = objConn.rs.getFloat("cantidad");
        }catch(Exception e){}
    }
    objConn.Consult("select sum(cantidad) as cantidad, tipo from movimientoscaja where date(fecha) = date(now()) group by tipo order by tipo desc;");
    if(objConn.rs != null){
        try{            
            if(objConn.rs.getString("tipo").equals("1")){
                totalSalida = objConn.rs.getFloat("cantidad");
            }
            else{
                totalEntrada = objConn.rs.getFloat("cantidad"); 
            }
            objConn.rs.next();            
            if(objConn.rs.getString("tipo").equals("1")){
                totalSalida = objConn.rs.getFloat("cantidad");
            }
            else{
                totalEntrada = objConn.rs.getFloat("cantidad"); 
            }
        }catch(Exception e){}
    }
    objConn.Consult("select concepto,concat('$',round(cantidad,2)) as cantidad,tipo from movimientoscaja where date(fecha)=date(now()) order by tipo;");
    int numMovimientos = 0;
    if(objConn.rs!= null){
        try{
            objConn.rs.last();
            numMovimientos = objConn.rs.getRow();
            objConn.rs.first();               
        }catch(Exception e){}            
    }
    if(numMovimientos>0){
        for(int i=0;i<numMovimientos;i++){
            if(objConn.rs.getString("tipo").equals("1")){
                listaSalida += "<li>"+objConn.rs.getString("concepto")+": "+objConn.rs.getString("cantidad")+"</li>";
            }
            else{
                listaEntrada += "<li>"+objConn.rs.getString("concepto")+": "+objConn.rs.getString("cantidad")+"</li>"; 
            }
            objConn.rs.next();
        }            
    }
    objConn.Consult("select sum(vp.cantidad) as cantidad from ventaproducto vp  natural join ventatotal vt where date(vt.fecha) = date(now());");      
    if(objConn.rs != null){
        try{
            productosVendidos = objConn.rs.getInt("cantidad");                
        }catch(Exception e){}
    }    
    objConn.Consult("select sum(ganancia) as ganancia from ventaTotal where date(fecha) = date(now());");
    if(objConn.rs != null){
        try{
            ganancia = objConn.rs.getFloat("ganancia");                
        }catch(Exception e){}
    }
    //json.put("exito", "exito");    
    json.put("exito", "exito");
    json.put("totalVentas", totalVentas);
    json.put("efectivo", efectivo);
    json.put("tarjeta", tarjeta);
    json.put("descuento",descuento);
    json.put("fondoCaja", fondoDeCaja);
    json.put("totalSalida", totalSalida);
    json.put("totalEntrada",totalEntrada);
    json.put("listaEntrada", listaEntrada);
    json.put("listaSalida", listaSalida);    
    json.put("productosVendidos",productosVendidos);
    json.put("ganancia", ganancia);
    out.print(json);
    objConn.desConnect();
    out.flush();
%>
