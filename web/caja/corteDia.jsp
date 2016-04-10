<%-- 
    Document   : corteDia
    Created on : 30/11/2015, 03:59:12 PM
    Author     : ricesqgue
--%>

<%
    HttpSession sesion = request.getSession();
    if(sesion.getAttribute("nombre")==null){
        response.sendRedirect("/puntoDeVenta/index.jsp"); 
    }
    else{
            
        %>
        <jsp:useBean id="conf" class="configpackage.Config"/>
        <%
        conf.setRuta(request);
        conf.carga();
        String nombreEmpresa = conf.getNombreEmpresa();
        String tema = conf.getTema();

%>
<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"/>
<!DOCTYPE html>
<html lang="es" ng-app="puntoDeVenta">
    <head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
	<link rel="stylesheet" href="/puntoDeVenta/css/<%=tema%>">
	<link rel="stylesheet" href="../css/puntoDeVenta.css">
	<link rel="stylesheet" href="../css/icons.css">
        <link rel="stylesheet" href="../css/animate.css"> 
        <link rel="stylesheet" href="../css/jquery-ui.min.css">
        <title><%=nombreEmpresa %></title>
    </head>
    <body>
	<navbar-principal ng-init="menu.usuario='<%=sesion.getAttribute("nombre")%>'"></navbar-principal>
	<div class="jumbotron">
            <div class="container">
                <h1>Corte del día</h1>
            </div>
	</div>
                        
        <div class="container">    
            <div id="contenido">
                <div class="row">
                    <div class="col-md-6">
                        <hr>
                        <h4>
                            <span class="icon-coin-dollar"> Ventas totales: </span><span id="totalVentas"></span>
                        </h4>
                    </div>
                    <div class="col-md-6">
                        <hr>
                        <h4>
                            <span class="icon-stats-bars"> Ganancias: </span><span id="ganancia"> </span>                            
                        </h4>                            
                    </div>
                </div>
    
                <div class="row">
                    <div class="col-md-6">
                        <hr>
                        <h4><span class="icon-drawer"> Dinero en Caja</span></h4>
                        <ul>
                            <li>Fondo de caja: <span id="fondoDeCaja"></span></li>
                            <li>Ventas en efectivo: <span id="ventasEfectivo" style="color:green"></span></li>
                            <li>Entradas: <span id="entradas" style="color:green"></span></li>
                            <li>Salidas: <span id="salidas" style="color:red"></span></li>
                            <li>Total: <span id="totalCaja"> </span></li>                            
                        </ul>
                    </div>
                    <div class="col-md-6">
                        <hr>
                        <h4><span class="icon-coin-dollar"></span> Ventas</h4>
                        <ul>
                            <li>En efectivo: <span id="efectivo" style="color:green"></span></li>
                            <li>Con tarjeta de crédito: <span id="tarjeta" style="color:green"></span></li>
                            <li>Total: <span id="total"></span></li>
                        </ul>
                    </div>
                </div>
                 
                <div class="row">
                    <div class="col-md-6">
                        <hr>
                        <h4><span class="icon-upload2"></span> Salidas de caja</h4>
                        <ul id="listaSalidas">
                            
                        </ul>
                    </div>
                    <div class="col-md-6">
                        <hr>
                        <h4><span class="icon-download2"></span> Entradas de caja</h4>
                        <ul id="listaEntradas">

                        </ul>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-md-6">
                        <hr>
                        <h4>
                            <span class="icon-arrow-down2"> Descuentos: </span><span id="descuento"></span>
                        </h4>
                    </div>
                    <div class="col-md-6">
                        <hr>
                        <h4>
                            <span class="icon-stats-bars"> Productos vendidos: </span><span id="productosVendidos"></span>
                        </h4>
                    </div>
                </div>                
            </div>
            <br>                 
        </div>                                     
       
        
        <script type="text/javascript" src="../js/jquery.js"></script>
        <script type="text/javascript" src="/puntoDeVenta/js/angular.min.js"></script>
        <script type="text/javascript" src ="../js/bootstrap.min.js"></script>
        <script type="text/javascript" src ="../js/jquery.validate.min.js"></script>
        <script type="text/javascript" src = "../js/puntoDeVenta.js"></script>
        <script type="text/javascript" src ="../js/filtroTabla.js"></script>
        <script type="text/javascript" src="../js/jquery-ui.min.js"></script>
        <script type="text/javascript">           
            
            function cargaCorte(){
                
                $.post("consultaCorteDia.jsp",function(res){
                    if(res.exito !== undefined){
                        $("#totalVentas").html(" $"+res.totalVentas);
                        $("#total").html(" $"+res.totalVentas);
                        $("#descuento").html(" $"+res.descuento);
                        $("#efectivo").html(" + $"+res.efectivo);
                        $("#tarjeta").html(" + $"+res.tarjeta);
                        $("#ventasEfectivo").html(" + $"+res.efectivo);
                        $("#entradas").html(" + $"+res.totalEntrada);
                        $("#salidas").html(" - $"+res.totalSalida);
                        $("#fondoDeCaja").html(" $" + res.fondoCaja);
                        var totalCaja = Math.round((res.fondoCaja + res.efectivo + res.totalEntrada - res.totalSalida)*100)/100;
                        $("#totalCaja").html(" $"+totalCaja);
                        $("#listaEntradas").html(res.listaEntrada);
                        $("#listaSalidas").html(res.listaSalida);
                        $("#productosVendidos").html(res.productosVendidos);
                        var gananciaTotal = Math.round((res.ganancia - res.descuento)*100)/100;
                        $("#ganancia").html(" $"+gananciaTotal);
                    }
                },"json");
            }
            
            cargaCorte();
        </script>
    </body>
</html>
<%
    }
%>