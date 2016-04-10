<%-- 
    Document   : productosComprados
    Created on : 6/12/2015, 10:50:03 PM
    Author     : ricesqgue
--%>

<%
HttpSession sesion = request.getSession();
    if(sesion.getAttribute("nombre")==null){
        response.sendRedirect("/puntoDeVenta/index.jsp");
    }else{   
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
        <link rel="stylesheet" href="../css/jquery-ui.min.css">
        <title><%=nombreEmpresa %></title>
    </head>
    <body>
	<navbar-principal ng-init="menu.usuario='<%=sesion.getAttribute("nombre")%>'"></navbar-principal>
	<div class="jumbotron">
            <div class="container">
                <h1>Productos comprados</h1>
            </div>
	</div>

        <div class="container">
            
            <div class="row" id="divFormulario">
                <div class="col-xs-12">
                    <div class="form-inline">
                        <div class="form-group">
                            <label class="control-label">Fecha inicial: </label>
                            <div class="input-group">
                                <input type='text' id="fechaInicial" onchange="$('#btnBusca').removeAttr('disabled')" readonly="true" name="fechaInicial" class="form-control" />
                                <span class="input-group-addon pointer" onclick="foco('fechaInicial')">
                                    <span class="icon-calendar"></span>
                                </span>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label class="control-label">Fecha final: </label>
                            <div class="input-group">
                                <input type='text' id="fechaFinal" onchange="$('#btnBusca').removeAttr('disabled')" readonly="true" name="fechaFinal" class="form-control"/>
                                <span class="input-group-addon pointer" onclick="foco('fechaFinal')">
                                    <span class="icon-calendar"></span>
                                </span>
                            </div>
                        </div>
                        
                        <div class="form-group">                    
                            <button  id="btnBusca" class="btn btn-info" onclick="$('#btnBusca').attr('disabled','disabled'); validaFechas();"><span class="icon-search"></span></button>
                        </div>                                
                    </div> 
                </div>
            </div>
            <br>
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
        <script type="text/javascript" src="../js/jquery-ui.min.js"></script>
        <script type="text/javascript" src="../js/Chart.min.js"></script>
        <script type="text/javascript">
            $(function (){                    
                $("#fechaInicial").datepicker();  
                $("#fechaFinal").datepicker();
                var fecha = new Date();
                var dia,mes,anio;
                dia = fecha.getDate();
                mes = fecha.getMonth() +1;
                anio = fecha.getFullYear();
                if(dia<10){
                    dia = "0"+dia;
                }
                if(mes<10){
                    mes = "0"+mes;
                }
                $("#fechaInicial").val(mes+"/"+dia+"/"+anio);
                $("#fechaFinal").val(mes+"/"+dia+"/"+anio);
            });
            function consultaReporte(){ 
                var inicial = $("#fechaInicial").val();
                var final = $("#fechaFinal").val();                
                var valores = inicial.split("/");
                inicial = valores[2]+"-"+valores[0]+"-"+valores[1];
                valores = final.split("/");
                final = valores[2]+"-"+valores[0]+"-"+valores[1];
                $("#msj").html("");
                $.post("reporteProductosComprados.jsp",{fechaInicial: inicial, fechaFinal: final},function(res){
                   if(res.tabla !== undefined){
                       $("#tabla").html(res.tabla);
                       $('#tablaReporte').DataTable({paging:false,bInfo: false,bFilter:true});
                        //Grafica                        
                        var graficaLinea = {                            
                            labels: [], 
                            datasets : [
                                {
                                    label: "Productos más comprados",
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
                        $("#grafica").show();
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
                       $("#tabla").hide("slow");                       
                       setTimeout(function(){$("#tabla").html(""); $("#tabla").show();},1500);
                   }
                },"json");
            }
            
            function validaFechas(){
                var inicial = $("#fechaInicial").val();
                var final = $("#fechaFinal").val();
                inicial = inicial.split("/");
                final = final.split("/");
                
                
                if(inicial[2]>final[2]){
                    //El año es mayor en la inicial.
                    mensaje();
                }
                else if(inicial[2]===final[2]){
                    //Los años son iguales
                    if(inicial[0]>final[0]){
                        mensaje();
                    }else if(inicial[0]=== final[0]){
                        if(inicial[1]>final[1]){
                            mensaje();
                        }
                        else{
                            consultaReporte();
                        }
                    }else{
                        consultaReporte();
                    }
                    
                }else{
                    consultaReporte();
                }                                               
            }
            
            function mensaje(){
                var mensaje = "<div id='mensaje' class='col-md-4 col-md-offset-3 animated slideInRight'> "
                        + "<div class='alert alert-danger' role='alert'>"
                        + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                        + "<span aria-hidden='true'> &times;</span></button><strong>Error. </strong>"
                        + "Ingrese fechas válidas."
                        + "</div></div>";
                $("#msj").html(mensaje);
                $("#tabla").hide("slow");
                window.myLine.removeData();
                $("#grafica").hide();
                setTimeout(function(){$("#tabla").html(""); $("#tabla").show();},1500);
            }
            
            
        </script>            
    </body>
</html>
<%
    }
%>