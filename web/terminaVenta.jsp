<%-- 
    Document   : terminaVenta
    Created on : 1/06/2015, 06:56:58 PM
    Author     : Ricardo
--%>
<%@page import="java.util.ArrayList"%>
<%
    HttpSession sesion = request.getSession();
    if(sesion.getAttribute("nombre")==null || request.getParameter("numFilas")==null || request.getParameter("cantidad0")==null){
        response.sendRedirect("/puntoDeVenta/index.jsp");
    }
    else{
        %>
        <jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"/>
        <jsp:useBean id="conf" class="configpackage.Config"/>
        <%
        conf.setRuta(request);
        conf.carga();
        String nombreEmpresa = conf.getNombreEmpresa();
        String tema = conf.getTema();

%>
<!DOCTYPE html>
<html lang="es" ng-app="puntoDeVenta">
    <head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
	<link rel="stylesheet" href="/puntoDeVenta/css/<%=tema%>">
	<link rel="stylesheet" href="/puntoDeVenta/css/puntoDeVenta.css">
	<link rel="stylesheet" href="/puntoDeVenta/css/icons.css">
        <link rel="stylesheet" href="/puntoDeVenta/css/animate.css">
        <link rel="stylesheet" href="/puntoDeVentacss/jquery-ui.min.css">
        <title><%=nombreEmpresa %></title>
    </head>
    <body>
        <navbar-principal ng-init="menu.usuario='<%=sesion.getAttribute("nombre")%>'"></navbar-principal>
        
        <div class="jumbotron">
            <div class="container">
		<h1>Venta de mostrador</h1>
            </div>
	</div>
      
        <form id="formulario"  method="post" action="cobrar.jsp"> 
            <div class="container">
            <%
                int numFilas = Integer.parseInt(request.getParameter("numFilas")); 
                ArrayList <String> producto = new ArrayList();
                ArrayList <String> codigo = new ArrayList();
                ArrayList <Integer> cantidad = new ArrayList();
                ArrayList <String> idProducto = new ArrayList();
                ArrayList <Float> total = new ArrayList();                
                //Leo los parametros
                float total1 = 0; // para calcular precio * cantidad de cada producto.
                for(int i = 0;i<numFilas;i++){
                    producto.add(request.getParameter("producto"+i));
                    codigo.add(request.getParameter("codigo"+i));                    
                    cantidad.add(Integer.parseInt(request.getParameter("cantidad"+i)));
                    idProducto.add(request.getParameter("idProd"+i));
                    //Checo si esta precio de mayoreo
                    if(request.getParameter("precioMayoreo"+i) != null){
                        total1 = Math.round(Float.parseFloat(request.getParameter("precioMayoreo"+i)) * Integer.parseInt(request.getParameter("cantidad"+i))*10)/10;
                        total.add(total1);
                    }
                    else{
                        total1 = Math.round(Float.parseFloat(request.getParameter("precio"+i)) * Integer.parseInt(request.getParameter("cantidad"+i))*10)/10;
                        total.add(total1);                       
                    }
                }
                
                //Acomodo los arraylist
                for(int i = 0; i<producto.size();i++){
                    String cod = codigo.get(i);
                    int cant = cantidad.get(i);
                    float tot = total.get(i); 
                    for(int j=1+i;j<producto.size();j++){
                        if(codigo.get(j).equals(cod)){  
                            cant += cantidad.get(j);
                            tot += total.get(j);
                            producto.remove(j);
                            cantidad.remove(j);
                            codigo.remove(j);
                            idProducto.remove(j);
                            total.remove(j);
                            j--;
                        }
                    }
                    cantidad.set(i,cant);
                    total.set(i, tot);
                }
                
                //Obtengo el total de la compra
                float totalGeneral = 0;
                for(int i = 0; i<producto.size();i++){
                    totalGeneral += total.get(i);
                }
                
                //Obtengo la cantidad de productos.
                int cantidadProductos = 0;
                for(int i = 0; i<cantidad.size();i++){
                    cantidadProductos += cantidad.get(i);
                }                                  
                %>
                <div class="row">
                    <div class="col-md-12">      
                        <div class="table-responsive">
                            <table id ="filas" class="table table-striped table-bordered table-hover">
                                <thead>
                                    <tr class="info">
                                        <th>Codigo</th>
                                        <th>Producto</th>
                                        <th>Cantidad</th>
                                        <th>Precio unitario</th>
                                        <th>Total</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <%
                                    //Se llena la tabla con las listas ya acomodadas
                                    for(int i = 0; i<producto.size();i++){                                       
                                    %>                                 
                                        <tr>                                   
                                            <td><%= codigo.get(i)%></td>
                                            <td><%= producto.get(i)%></td>
                                            <td><%=cantidad.get(i)%></td>
                                            <td>$<%=Math.rint(total.get(i)/cantidad.get(i)*100)/100%></td>
                                            <td>$<%=total.get(i)%></td>
                                            <input type="hidden" name="idProd<%=i%>" value="<%= idProducto.get(i) %>"
                                            <input type="hidden" name="codigo<%=i%>" value="<%=codigo.get(i)%>"> 
                                            <input type="hidden" name="cantidad<%=i%>" value="<%=cantidad.get(i)%>">
                                            <input type="hidden" name="precio<%=i%>" value="<%=Math.rint(total.get(i)/cantidad.get(i)*100)/100%>">                                        
                                        </tr>
                                    <% 
                                    }
                                    %>
                                </tbody>
                            </table>	
                        </div> 
                    </div>
		</div>
                <div class="row container">
                    <div class="col-xs-10 col-sm-5">
                        <label>
                            Cantidad de productos: <%=cantidadProductos%> 
                        </label>
                    </div>
                    <div class="col-xs-2 col-sm-1">
                        <button class=" btn btn-warning" type="button" title="Regresar" value="back" onclick="history.back(-1);"><span class="icon icon-undo2"></span></button>
                    </div>
                        
                    <div class="col-xs-10 col-sm-6">
                        <%
                        objConn.Consult("select idCliente,concat_ws(' ',nombre,apellidoPaterno,apellidoMaterno) as nombre from cliente where activo = 1 order by nombre;");
                        int n = 0;
                        if(objConn.rs != null){
                            try{
                                objConn.rs.last();
                                n = objConn.rs.getRow();
                                objConn.rs.first();
                            }catch(Exception e){}
                        }
                        if(n>0){                            
                        
                        %>
                        <select class="form-control"  name="cliente">
                            <%
                            for(int i=0; i<n; i++){
                                if(objConn.rs.getString(1).equals(1)){
                                %>
                                <option value="<%=objConn.rs.getString(1)%>" selected><%=objConn.rs.getString(2)%></option>
                                <%
                                }
                                else{
                                    %>
                                    <option value="<%=objConn.rs.getString(1)%>"><%=objConn.rs.getString(2)%></option>
                                    <%
                                }
                                objConn.rs.next();
                            }
                            %>
                        </select>
                        <%                        
                        }
                        else{
                        %>
                        <select name="cliente">
                            <option selected value="1">Cliente General</option>
                        </select>
                        <%
                        }
                        %>
                        <br>
                    </div>
                        
                </div>
                <div class="row container">
                    <div class="form-group col-xs-10 col-sm-5">
                        <label for="descuento">Descuento $</label>
                        <input class="form-control" type="number" min="0" max="<%=totalGeneral%>" name="descuento" id="descuento" tabindex="1" onkeypress="if(enter(event.keyCode)){if($('#descuento').val()==='0'){$('#descuento').val('0');} foco('descuentoBtn')}else{desactivaTerminaVenta();}">
                     </div>
                     
                    <div class="form-group col-xs-2 col-sm-1">
                        <button class="btn btn-success btn-termVenta" title="Aplicar descuento" type="button" id="descuentoBtn" onclick="foco('cantidadRecibida'); descuenta(<%=totalGeneral%>); " tabindex="2"><span class="icon icon-arrow-right2"></span></button>
                    </div>
                    
                    <div class="form-group col-xs-12 col-sm-6">
                        <label for="total" >Total $</label>
                        <input class="form-control" type="text" name="total" id="total" value="<%=totalGeneral%>" readonly>
                    </div>
                </div>
                <div class="row container">    
                    <div class="form-group col-xs-10 col-sm-5">
                        <label for="cantidadRecibida" >Cantidad recibida $</label>
                        <input class="form-control" type="number" name="cantidadRecibida" id="cantidadRecibida" tabindex="3" min="<%=totalGeneral%>" onkeypress="if(enter(event.keyCode)){if(checaCambio()){foco('btnTermina');}}else{desactivaTerminaVenta();}">
                    </div>
                    
                    
                    <div class="form-group col-xs-2 col-sm-1" >
                        <button class="btn btn-success btn-termVenta" title="Obtener cambio" type="button" id="cambioBtn" onclick="checaCambio()"  tabindex="4"><span class="icon icon-arrow-right2"></span></button>
                    </div>
                    
                    <div class="form-group col-xs-12 col-sm-6" >
                        <label for="cambio" >Cambio $</label>
                        <input class="form-control" type="text" name="cambio" id="cambio" readonly>
                    </div>      
                </div>               
            </div>          
            <input type="hidden" name="numFilas" value="<%=producto.size()%>">
            <input type="hidden" name="tarjeta" id="tarjeta" value="0">
            <input type="hidden" name="totalGeneral" value="<%=totalGeneral%>">
        </form>
        <div class="container">
            <div class="container">
                <button class="btn btn-info" id="btnTarjeta" disabled data-toggle="modal" href='#modal-tarjeta' onclick="pagoTarjeta();" type="button"><span class="icon-credit-card"></span></button>
                <button class="btn btn-success" title="Terminar venta" onclick="cobrar()" id="btnTermina" disabled  tabindex="5" ><span class="icon-coin-dollar"></span> Cobrar</button>
            </div>
        </div>
        
        <div class="modal fade" id="modal-tarjeta">
            <div class="modal-dialog">
		<div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <center><h2 class="modal-title">Pago con tarjeta <span class="icon-credit-card"></span></h2></center>
                    </div>
                    <div class="modal-body">
                        <div id="infoModalTarjeta"></div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Cancelar</button>
                        <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="cobrar();">Continuar</button>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="modal fade" id="modal-exito">
            <div class="modal-dialog">
		<div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">Mensaje</h4>
                    </div>
                    <div class="modal-body">
                        <center><h3>Venta realizada con éxito</h3></center>                            
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" id="btnFin" data-dismiss="modal" onclick="window.location.href='puntoDeVenta.jsp'">Cerrar</button>
                    </div>
		</div>
            </div>
        </div>
        <br>
        <div class="row">
            <div class="col-xs-12 col-sm-6 col-sm-offset-2 col-md-4 col-md-offset-3">
                <div id="msj"></div>
            </div>
        </div>
        
        <script type="text/javascript" src="js/jquery.js"></script>
        <script type="text/javascript" src="js/angular.min.js"></script>
        <script type="text/javascript" src="js/jquery.validate.min.js"></script>
        <script type="text/javascript" src ="js/bootstrap.min.js"></script>
        <script type="text/javascript" src="js/puntoDeVenta.js"></script>
        <script type="text/javascript" src="js/jquery-ui.min.js"></script>
        
        <script type="text/javascript">

            foco("descuento");
            $("#descuento").val("0");
            $("#descuento").select();
	</script>
        
        <script>
            function pagoTarjeta(){
                var total = $("#total").val();
                var efectivo = $("#cantidadRecibida").val();
                var tarjeta;
                if(efectivo === ""){
                    efectivo = 0;
                    $("#cantidadRecibida").val(efectivo);
                }
                if(efectivo>=total){
                    tarjeta = 0;
                    efectivo = efectivo - (efectivo-total)
                }
                else{
                   tarjeta = total - efectivo;
                }
                $("#tarjeta").val(tarjeta);
                $("#infoModalTarjeta").html("<h3>Total: $"+total+" </h3><h3>Pago en efectivo: $"+efectivo+"</h3><h3>Pago con tarjeta: $"+tarjeta+"</h3>");
            }
            
            function cobrar(){
                var cambio = $("#cambio").val();
                if(cambio===""){
                    cambio = 0;
                }                
                $("#btnTermina").attr("disabled","disabled");
                $("#btnTarjeta").attr("disabled","disabled");
                $("#cantidadRecibida").val($("#cantidadRecibida").val()-cambio);
                $.post("cobrar.jsp",$("#formulario").serialize(),function(res){
                    if(res.exito !== undefined){
                        $("#modal-exito").modal("show");
                        foco("btnFin");
                        var delay=1500;   
                        setTimeout(function(){                    
                            window.location.href='puntoDeVenta.jsp';
                        }, delay); 
                    }
                    else if(res.error){
                        var mensaje = "<div id='mensaje' class='col-md-12 animated slideInRight'> "
                            + "<div class='alert alert-danger' role='alert'>"
                            + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                            + "<span aria-hidden='true'> &times;</span></button>"
                            + res.error
                            + "</div></div>";
                            $("#msj").html(mensaje);
                            showMsj('msj');
                            $("#btnTermina").removeAttr("disabled");
                            $("#btnTarjeta").removeAttr("disabled");
                    }
                    
                },"json");
            }
        </script>
    </body>
</html>
<%
    }
%>
 