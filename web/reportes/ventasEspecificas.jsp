<%-- 
    Document   : ventasEspecificas
    Created on : 4/12/2015, 09:06:06 PM
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
                <h1>Ventas específicas</h1>
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
                            <button id="btnBusca" class="btn btn-info" onclick="$('#btnBusca').attr('disabled','disabled'); validaFechas();"><span class="icon-search"></span></button>
                        </div>                                
                    </div> 
                </div>
            </div>
            <br>
            <div id="tabla"></div>
            <br>            
            <div id="msj"></div>
            
            <div class="modal fade" id="modal-detalle">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                            <h3 class="modal-title">Detalle de venta</h3>
                        </div>
                        <div class="modal-body" id="detalle">                            
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-primary" data-dismiss="modal">Cerrar</button>
                        </div>
                    </div>
                </div>
            </div>
        
        </div>
        
        
        <script type="text/javascript" src="../js/jquery.js"></script>
        <script type="text/javascript" src="../js/angular.min.js"></script>
        <script type="text/javascript" src ="../js/bootstrap.min.js"></script>
        <script type="text/javascript" src ="../js/jquery.validate.min.js"></script>
        <script type="text/javascript" src = "../js/puntoDeVenta.js"></script>
        <script type="text/javascript" src ="../js/filtroTabla.js"></script>
        <script type="text/javascript" src="../js/jquery-ui.min.js"></script>
        <script type="text/javascript">
            var botones = "";
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
                $.post("reporteVentasEspecificas.jsp",{fechaInicial: inicial, fechaFinal: final},function(res){
                   if(res.tabla !== undefined){
                       $("#tabla").html(res.tabla);
                       $('#tablaReporte').DataTable({bInfo: true,bFilter:true,bPaginate: true, bLengthChange: true});                       
                       botones = setInterval(function (){botonesPaginacion();},100);
            
                       
                   }
                   else if(res.error !== undefined){
                       $("#msj").html(res.error);
                       $("#tabla").hide("slow");
                       clearInterval(botones);
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
                clearInterval(botones);
                var mensaje = "<div id='mensaje' class='col-md-4 col-md-offset-3 animated slideInRight'> "
                        + "<div class='alert alert-danger' role='alert'>"
                        + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                        + "<span aria-hidden='true'> &times;</span></button><strong>Error. </strong>"
                        + "Ingrese fechas válidas."
                        + "</div></div>";
                $("#msj").html(mensaje);
                $("#tabla").hide("slow");
                setTimeout(function(){$("#tabla").html(""); $("#tabla").show();},1500);
            }     
            
            function botonesPaginacion(){
                $(".paginate_button").addClass("btn");                               
                $(".paginate_button").addClass("btn-default"); 
                $(".current").addClass("active");
            }
            
            function detalleVenta(id){
                $.post("detalleVenta.jsp",{id: id}, function(res){
                    if(res.exito !== undefined){
                        $("#detalle").html(res.exito);
                        $("#modal-detalle").modal("toggle");
                    }
                    else if(res.error !== undefined){
                        $("#detalle").html(res.error);
                        $("#modal-detalle").modal("toggle");
                    }
                },"json");
            }
            
            
        </script>            
    </body>
</html>
<%
    }
%>