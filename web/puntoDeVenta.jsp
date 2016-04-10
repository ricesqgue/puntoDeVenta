<%-- 
    Document   : puntoDeVenr
    Created on : 23/05/2015, 06:14:24 PM
    Author     : Ricardo
--%>
<%@page import="java.io.InputStream"%>
<%@page import="java.util.Properties"%>
<%@page import="java.net.URL"%>
<jsp:useBean id="conf" class="configpackage.Config"/>
<%
    HttpSession sesion = request.getSession();
    if(sesion.getAttribute("nombre")==null){
        response.sendRedirect("/puntoDeVenta/index.jsp");
    }
    else{
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
        <link rel="stylesheet" href="/puntoDeVenta/css/jquery-ui.min.css">
        <title><%=nombreEmpresa %></title>
        <script type="text/javascript">
            var numFilas = 0;
        </script>
    </head>
    <body>
    <navbar-principal ng-init="menu.usuario='<%=sesion.getAttribute("nombre")%>'"></navbar-principal>
	<div class="jumbotron">
            <div class="container">
                <h1>Venta de mostrador</h1>
            </div>
	</div>
	
	<div class="container" id="wrap">
            <div class="bordeado">
                <p><strong>Introduzca los datos de la venta</strong></p>
                <div class="row">
                    <br>
                    <form class="form-inline" id="formulario">
                        <div class="form-group">
                            <label for="codigo">C&oacute;digo</label>
                            <input  id="codigo" type="number" name="codigo" title="Introduce un codigo" class="form-control" placeholder="C&oacute;digo" required tabindex="1" 
                                   min="0" onkeypress="if(enter(event.keyCode) && $('#codigo').val()=== ''){foco('terminaVentaBtn');}else if(enter(event.keyCode) && $('#codigo').val() !== ''){foco('cantidad'); $('#cantidad').val(1).select();}">
                        </div>
                        <div class="form-group" >
                            <label for="cantidad">Cantidad</label>
                            <input type="number" title="Introduce una cantidad" class="form-control" id="cantidad" name="cantidad" placeholder="Cantidad" required tabindex="2" 
                                   onkeypress="if(enter(event.keyCode)){$('#formulario').submit();}">
                        </div>
                        <div class="form-group">
                             <button type="button" title="Agregar a la venta" onclick="$('#formulario').submit()" id = "agregaProductoBtn" class="btn btn-default" tabindex="3" ><span class="icon-checkmark"></span></button>                             
                        </div>
                        <div class="form-group" id="msj">
                            
                        </div>
                        
                        <input id="inputFilas" type="hidden" name="numFilas" value="">
                        <script>
                            document.getElementById("inputFilas").value = numFilas;
                        </script>
                    </form>				                                          
                </div>          
            </div>
            <br><br>
            <div class="row">
                <div class="col-md-12">
                    <form id="formularioTabla" action="terminaVenta.jsp" method="post">
                        <div class="table-responsive">
                            <table id ="filas" class="table table-striped table-bordered table-hover">
                                <tr class="info">
                                    <th>Codigo</th>
                                    <th>Producto</th>
                                    <th>Marca</th>
                                    <th>Categoría</th>
                                    <th>Cantidad</th>
                                    <th>Precio</th>
                                    <th>Total</th>
                                    <th>Mayoreo</th>
                                    <th></th>
                                </tr>
                            </table>	
                        </div>
                        <input id="inputFilas2" type="hidden" name="numFilas" value="0">
                      </form>
                </div>
            </div>
            <div class="row">
                <div class="col-xs-6 col-sm-8 col-md-2">
                    <button class="btn btn-info" id = "terminaVentaBtn" disabled="disabled" onclick="$('#formularioTabla').submit()">
                        Realizar compra 
                        <span class="icon-checkmark2"></span>
                    </button>
                </div>
                <div class="col-xs-6 col-sm-4 col-md-8">
                    <div class="checkbox">
                        <label>

                          <input type="checkbox" name="precioMayoreo" onclick="checaTodoMayoreo()"> 
                            Precio mayoreo                          
                        </label>
                    </div>
                     
                </div>
                
                <div class="col-xs-2 col-sm-2 col-md-1">
                    <br>
                    <button class="btn btn-warning" data-toggle="modal" href='#modal-salidaCaja' onclick="setTimeout(function(){ foco('cantidadSalida'); },500);" title="Salida de caja"><span class="icon-arrow-left"></span> $</button>
                </div>
                
                <div class="col-xs-2 col-sm-2 col-md-1">
                    <br>
                    <button class="btn btn-success" title="Entrada de caja" data-toggle="modal" href='#modal-entradaCaja' onclick="setTimeout(function(){ foco('cantidadEntrada'); },500);"><span class="icon-arrow-right"></span> $</button>
                </div>
            </div>
        </div>
      
        <div class="modal fade" id="modal-salidaCaja">
            <div class="modal-dialog">
		<div class="modal-content">
                    <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                            <h4 class="modal-title">Salida de caja</h4>
                    </div>
                    <div class="modal-body">
                        <form id="form-salidaCaja">
                            <div class="form-group">
                                <label class="control-label" for="cantidad1">Cantidad</label>
                                <input type="number" step="0.1" min="0" onkeypress="if(enter(event.keyCode)){foco('conceptoSalida');}" title="Cantidad de salida $" class="form-control" id="cantidadSalida" name="cantidad1">
                                <br>
                                <label class="control-label" for="concepto1">Concepto</label>
                                <textarea class="form-control" name="concepto1" id="conceptoSalida"></textarea>
                                <input type="hidden" name="movimiento" value="1">
                            </div> 
                            <div id="msjSalida"></div>
                        </form>
                        
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" onclick="$('#msjSalida').hide()" data-dismiss="modal">Cerrar</button>
                        <button type="button" class="btn btn-primary" onclick="salidaCaja()" id="btnGuardarSalida">Guardar salida</button>
                    </div>
		</div>
            </div>
        </div>                  
        
        <div class="modal fade" id="modal-entradaCaja">
            <div class="modal-dialog">
		<div class="modal-content">
                    <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                            <h4 class="modal-title">Entrada de caja</h4>
                    </div>
                    <div class="modal-body">
	    		<form id="form-entradaCaja">
                            <div class="form-group">
                                <label class="control-label" for="cantidad2">Cantidad</label>
                                <input type="number" step="0.1" onkeypress="if(enter(event.keyCode)){foco('conceptoEntrada');}" min="0" title="Cantidad de entrada $" class="form-control" id="cantidadEntrada" name="cantidad2">
                                <br>
                                <label class="control-label" for="concepto2">Concepto</label>
                                <textarea class="form-control"  name="concepto2" id="conceptoEntrada"></textarea>
                                <input type="hidden" name="movimiento" value="2">
                            </div>
                            <div id="msjEntrada"></div>
                        </form>
                        
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" onclick="$('#msEntrada').hide()" data-dismiss="modal">Cerrar</button>
                        <button type="button" class="btn btn-primary" onclick="entradaCaja()" id="btnGuardarEntrada">Guardar entrada</button>
                    </div>
		</div>
            </div>
        </div>                         
                                
        <script type="text/javascript" src="js/jquery.js"></script>
        <script type="text/javascript" src="js/angular.min.js"></script>
        <script type="text/javascript" src ="js/bootstrap.min.js"></script>
        <script type="text/javascript" src ="js/jquery.validate.min.js"></script>
        <script type="text/javascript" src = "js/puntoDeVenta.js"></script>
        <script type="text/javascript">
            $(document).ready(function() { 	
                $("#formulario").validate({ 
                    submitHandler: function(form) {
                        $.post("llenaTabla.jsp",$(form).serialize(),function(res){
                            if(res.exito !== undefined){
                                foco('codigo');
                                hideMsj();
                                numFilas = numFilas + 1;
                                document.getElementById("inputFilas2").value = numFilas; 
                                document.getElementById("inputFilas").value = numFilas;
                                document.getElementById("filas").innerHTML += res.exito; 
                                document.forms[0].reset();
                                $("#terminaVentaBtn").removeAttr("disabled");
                            }
                            else if(res.error !== undefined){                                
                                //No hay producto...
                                if(res.error === "No se completa la cantidad de productos."){
                                   var mensaje = "<div id='mensaje' class='col-md-12 animated slideInRight'> "
                                    + "<div class='alert alert-danger' role='alert'>"
                                    + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                                    + "<span aria-hidden='true'> &times;</span></button>"
                                    + res.error
                                    + "</div></div>";
                                    $("#msj").html(mensaje);
                                    showMsj('msj');
                                    foco('cantidad');
                                    $("#cantidad").select();                                                            
                                }                           
                            }
                        },"json");
                    },                
                    rules: {  
                        codigo:  {required: true, digits: true, remote: {url: "validaciones/checaCodigo2.jsp", type: "get"}},  
                        cantidad: {required: true, digits: true}
                    },  
                    messages: {  
                        codigo:   {           
                            remote:   "El codigo no existe" 
                        }
                        
                    }  
                });  
            });
        </script>
        <script type="text/javascript">
            function renombraFilas(){
                var filas = $("#filas").find("tr");
                var btnEliminar = $(".icon-cross");
                for(var i=1;i<filas.length;i++){
                    var input = filas.eq(i).find("input");
                    input.eq(0).attr("name","cantidad"+(i-1));                    
                    input.eq(1).attr("name","total"+(i-1));/////                   
                    input.eq(2).attr("name","codigo"+(i-1));
                    input.eq(3).attr("name","producto"+(i-1));//
                    input.eq(4).attr("name","idProd"+(i-1));                                                            
                    filas.eq(i).attr("id","f"+(i-1));
                    btnEliminar.eq(i-1).attr("onclick","$(\"#f"+(i-1)+"\").remove(); renombraFilas();");           
                }
                numFilas = filas.length-1;
                $("#inputFilas2").val(numFilas);
                $("#inputFilas").val(numFilas);
                if(numFilas === 0){
                    $("#terminaVentaBtn").attr("disabled","disabled");
                }
            }
            
            function salidaCaja(){
                if(isNaN($("#cantidadSalida").val()) || $("#cantidadSalida").val()===""){
                    var mensaje = "<div id='mensaje' class='col-md-12 animated slideInRight'> "
                    + "<div class='alert alert-danger' role='alert'>"
                    + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                    + "<span aria-hidden='true'> &times;</span></button><strong>Error. </strong>"
                    + "Ingrese una cantidad válida."
                    + "</div></div>";
                     $("#msjSalida").html(mensaje);
                }
                else{                                   
                    $.post("caja/movimientosCaja.jsp",$("#form-salidaCaja").serialize(), function(res){
                        $("#msjSalida").html(res.msj);
                        if(res.tipo==="exito"){
                            document.getElementById("form-salidaCaja").reset();
                        }
                    },"json");
                }
            }
            function entradaCaja(){
                 if(isNaN($("#cantidadEntrada").val()) || $("#cantidadEntrada").val()===""){
                    var mensaje = "<div id='mensaje' class='col-md-12 animated slideInRight'> "
                    + "<div class='alert alert-danger' role='alert'>"
                    + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                    + "<span aria-hidden='true'> &times;</span></button><strong>Error. </strong>"
                    + "Ingrese una cantidad válida."
                    + "</div></div>";
                     $("#msjEntrada").html(mensaje);
                }
                else{
                    $.post("caja/movimientosCaja.jsp",$("#form-entradaCaja").serialize(), function(res){
                        $("#msjEntrada").html(res.msj);
                        if(res.tipo==="exito"){
                           document.getElementById("form-entradaCaja").reset();
                        }
                    },"json");
                }
            }
            
            function checaPrecioMayoreo(precioMayoreo,i){
                if($("[name='precioMayoreo"+i+"']").is(":checked")){
                    $("#f"+i).find("td").eq(5).html("$"+(Math.round(precioMayoreo*100)/100).toFixed(2));
                    var total = (Math.round(precioMayoreo*100)/100) * $("#f"+i).find("td").eq(4).html();
                    $("#f"+i).find("td").eq(6).html("$"+total.toFixed(1));
                }else{
                    
                    $("#f"+i).find("td").eq(5).html("$"+(Math.round($("input[name='precio"+i+"']").val()*100)/100).toFixed(2));
                    var total = Math.round($("input[name='precio"+i+"']").val()*100)/100 * $("#f"+i).find("td").eq(4).html();
                    $("#f"+i).find("td").eq(6).html("$"+total.toFixed(1));
                }
            }
            
            function checaTodoMayoreo(){
                if($("input[name='precioMayoreo']").is(":checked")){
                    for(var i=0;i<numFilas;i++){
                      $("[name='precioMayoreo"+i+"']").prop("checked",true);
                      checaPrecioMayoreo($("[name='precioMayoreo"+i+"']").val(),i);
                    }
                }
                else{
                    for(var i=0;i<numFilas;i++){
                      $("input[name='precioMayoreo"+i+"']").prop("checked",false);  
                      checaPrecioMayoreo($("[name='precioMayoreo"+i+"']").val(),i);
                    }
                }
            }
            
            bloqueaForm("form-salidaCaja");
            bloqueaForm("form-entradaCaja");
        </script>
    </body>
</html>
<%
    }
%>