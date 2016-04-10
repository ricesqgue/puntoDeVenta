<%-- 
    Document   : ventasPorMes
    Created on : 3/12/2015, 10:24:26 AM
    Author     : ricesqgue
--%>

<%@page import="java.net.URL"%>
<%@page import="java.util.Properties"%>
<%@page import="java.io.InputStream"%>
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
<!DOCTYPE html>
<html lang="es" ng-app="puntoDeVenta">
    <head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
	<link rel="stylesheet" href="/puntoDeVenta/css/<%=tema%>">
	<link rel="stylesheet" href="../css/puntoDeVenta.css">
	<link rel="stylesheet" href="../css/icons.css">
        <link rel="stylesheet" href="../css/animate.css">
        <title><%=nombreEmpresa %></title>
    </head>
    <body>
	<navbar-principal ng-init="menu.usuario='<%=sesion.getAttribute("nombre")%>'"></navbar-principal>
	<div class="jumbotron">
            <div class="container">
                <h1>Ventas por mes</h1>
            </div>
	</div>

        <div class="container">
            <div id="tabla"></div>
            <br>            
            <div id="divGrafica" class="row">
                <div class="col-md-8 col-md-offset-2">
                    <canvas id="grafica"></canvas>
                </div>
            </div>
            <br>
            <div id="msj"></div>
        </div>
        
        
        <script type="text/javascript" src="../js/jquery.js"></script>
        <script type="text/javascript" src="../js/angular.min.js"></script>
        <script type="text/javascript" src ="../js/bootstrap.min.js"></script>
        <script type="text/javascript" src ="../js/jquery.validate.min.js"></script>
        <script type="text/javascript" src = "../js/puntoDeVenta.js"></script>
        <script type="text/javascript" src ="../js/filtroTabla.js"></script>
        <script type="text/javascript" src="../js/Chart.min.js"></script>
        <script type="text/javascript">      
            function consultaReporte(){                
                $.post("reporteVentasPorMes.jsp",function(res){
                    if(res.tabla !== undefined){
                        $("#tabla").html(res.tabla);
                        $('#tablaReporte').DataTable({paging:false,bInfo: false,bFilter:false});
                        //Grafica                        
                        var graficaLinea = {                            
                            labels: [], 
                            datasets : [
                                {
                                    label: "Ventas por mes",
                                    fillColor: "rgba(151,187,205,0.2)",
                                    strokeColor: "rgba(151,187,205,1)",
                                    pointColor: "rgba(151,187,205,1)",
                                    pointStrokeColor: "#fff",
                                    pointHighlightFill: "#fff",
                                    pointHighlightStroke: "rgba(151,187,205,1)",
                                    data : []
                                }
                            ]
                        };
                        //Inserta labels a la grafica
                        for(var i=0;i<res.labels.length;i++){
                            graficaLinea.labels.push(res.labels[i]);
                        }
                        //Ingresa datos a la grafica
                        for(var i=0;i<res.data.length;i++){
                            graficaLinea.datasets[0].data.push(res.data[i]);
                        }

                        var ctx = document.getElementById("grafica").getContext("2d");
                            window.myLine = new Chart(ctx).Line(graficaLinea, {
                                responsive: true,
                                bezierCurve: false
                    });                                               
                    }
                    else if(res.error !== undefined){
                        $("#msj").html(res.error);
                    }
                },"json");
            }
            consultaReporte();
            
        </script>            
    </body>
</html>
<%
    }
%>