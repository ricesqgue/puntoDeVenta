<%-- 
    Document   : fondoCaja
    Created on : 22/11/2015, 11:04:06 PM
    Author     : ricesqgue

Pagina principal de fondo de caja.
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
                <h1>Fondo de caja</h1>
            </div>
	</div>
                        
        <div class="container">  
            <div class="form-inline">
                <div class="form-group">
                    <label class="control-label">Opciones: </label>
                    <label class="radio-inline"><input type="radio" onchange="cambiaRadio();" value="ingresar" name="opcion" checked="checked">Ingresar</label>
                    <label class="radio-inline"><input type="radio" onchange="cambiaRadio();" value="consultar" name="opcion">Consultar</label>                        
                </div>                                                  
            </div>                                
        </div>
        <br>
        <br>
        <div class="container" id="ingresar">
            <div class="row">
                <div class=" col-xs-12 col-sm-6 col-sm-offset-3 col-md-4 col-md-offset-4 col-lg-6 col-lg-offset-3">
                    <form id="formIngresar" >
                        <center><h4>Ingresar fondo de caja</h4></center>
                        <div class="form-group">
                            <label for="cantidad">Cantidad</label>
                            <input type="number" step="0.1" min="0" class="form-control" name="cantidad" id="cantidad" placeholder="Cantidad">
                        </div>
                        <button type="button" id="btnIngresa" onclick="$('#btnIngresa').attr('disabled','disabled'); ingresaFondoCaja();" class="btn btn-success">Guardar</button>
                    </form>
                </div>                                                                   
            </div>
            <br>
            
            <div clas="row" id="barraProgresoIngresar"></div>
            
            <div class="row">
                <div id="msjIngresar"></div>
            </div> 
        </div>            
        
        <div class="container " id="consultar">
            <div class="row">
                <div class="form-inline col-xs-12 col-sm-6 col-sm-offset-3 col-md-4 col-md-offset-4 col-lg-6 col-lg-offset-3">
                    <div class="form-group">
                        <label class="control-label">Fecha: </label>
                        <div class="input-group">
                            <input type='text' readonly="true" id="fecha" name="fecha" class="form-control" onchange="$('#btnBusca').removeAttr('disabled');" />
                            <span class="input-group-addon pointer" onclick="foco('fecha')">
                                <span class="icon-calendar"></span>
                            </span>
                        </div>
                    </div>

                    <div class="form-group">                    
                        <button disabled="disabled" id="btnBusca" class="btn btn-info" onclick="$('#btnBusca').attr('disabled','disabled'); consultaFondoCaja();"><span class="icon-search"></span></button>
                    </div>                            
                </div>
            </div>
            <br>
            <div clas="row" id="barraProgresoConsultar"></div>
            <div class="row">
                <div class="col-md-12" id="consultarResult"> 
                </div>
            </div>
            <br>
            <div class="row">
                <div id="msjConsultar"></div>
            </div> 
        </div>                    
              
        
        <div class="modal fade" id="modal-eliminar">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">Eliminar fondo de caja</h4>
                    </div>
                    <div class="modal-body">
                        <label>Se eliminará el fondo de caja seleccionado</label><br>
                        <label>Desea continuar?</label><br>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Cancelar</button>
                        <button type="button" class="btn btn-danger" data-dismiss="modal" onclick="eliminarFondoCaja(idFondoCajaEliminar)">Eliminar</button>
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
            $(function (){
                $("#fecha").datepicker();  
            });
            function cambiaRadio(){
                var opcion = $('input:radio[name=opcion]:checked').val();
                if(opcion === "ingresar"){
                    $("#consultar").hide("fast");
                    $("#ingresar").show("slow");
                    $("#msjIngresar").html("");
                    $("#msjConsultar").html("");
                   
                    
                }
                else if(opcion === "consultar"){
                    $("#ingresar").hide("slow");
                    $("#consultar").show("fast");
                    $("#msjIngresar").html("");
                    $("#msjConsultar").html("");
                }
            }
            
            function ingresaFondoCaja(){
                var cantidad = $("#cantidad").val();
                $("#barraProgresoIngresar").html("<div class='col-md-4 col-md-offset-4'>"
                    +"<div class='progress'>"
                    +"<div class='progress-bar  progress-bar-striped active' role='progressbar'"
                    +" aria-valuenow='100' aria-valuemin='0' aria-valuemax='100' style='width:100%'>"
                    +" Cargando..."
                    +"</div>"
                    +"</div>"
                    +"</div>");
                
                if(cantidad === "" || isNaN(cantidad) || cantidad < 0 ){
                    
                    $("#msjIngresar").html("<div id='mensaje' class='col-sm-4 col-sm-offset-4 animated slideInRight'> "
                            + "<div class='alert alert-danger' role='alert'>"
                            + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                            + "<span aria-hidden='true'> &times;</span></button>"
                            + "<strong>Error.</strong> Introduce una cantidad válida."
                            + "</div></div>");
                    
                    foco("cantidad");
                    $("#cantidad").select();
                    $("#barraProgresoIngresar").html("");
                }
                else{
                    $.post("ingresaFondoDeCaja.jsp",{cantidad: cantidad},function (res){
                        if(res.exito !== undefined){
                            $("#msjIngresar").html(res.exito);
                            $("#formIngresar").reset();
                        }
                        else if(res.error !== undefined){
                            $("#msjIngresar").html(res.error);
                            foco("cantidad");
                            $("#cantidad").select();
                            
                        }
                        $("#barraProgresoIngresar").html("");
                    },"json");
                }

                $("#btnIngresa").removeAttr('disabled');
            }
            
            function consultaFondoCaja(){
               $("#barraProgresoConsultar").html("<div class='col-md-4 col-md-offset-4'>"
                    +"<div class='progress'>"
                    +"<div class='progress-bar  progress-bar-striped active' role='progressbar'"
                    +" aria-valuenow='100' aria-valuemin='0' aria-valuemax='100' style='width:100%'>"
                    +" Cargando..."
                    +"</div>"
                    +"</div>"
                    +"</div>");
               var fecha = $("#fecha").val(); 
               if(isDate(fecha)){
                   var valores = fecha.split("/");
                   fecha = valores[2]+"-"+valores[0]+"-"+valores[1];
                   $.post("consultaFondoDeCaja.jsp",{fecha: fecha}, function(res){
                       if(res.tabla !== undefined){
                            $("#consultarResult").html(res.tabla);
                            $('#tablaFondoCaja').DataTable({paging:false,bInfo: false,bFilter: false});
                        }
                        else if(res.error !== undefined){ 
                            $("#consultarResult").html(res.error);
                        }
                        $("#barraProgresoConsultar").html("");
                   },"json");
               }else{
                    $("#msjConsultar").html("<div id='mensaje' class='col-sm-4 col-sm-offset-4 animated slideInRight'> "
                            + "<div class='alert alert-danger' role='alert'>"
                            + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                            + "<span aria-hidden='true'> &times;</span></button>"
                            + "<strong>Error.</strong> Introduce una fecha válida."
                            + "</div></div>");
                    foco("fecha");
                    $("#barraProgresoConsultar").html("");
               }
            
             
            }
            
            function eliminarFondoCaja(id){
                $.post("eliminaFondoDeCaja.jsp",{id: id}, function (res){
                    if(res.exito !== undefined){
                        $("#row"+id).fadeOut("slow");
                        var delay = "2000";
                        setTimeout(function (){$("#row"+id).remove();},delay);
                    }
                    else if(res.error !== undefined){
                        $("#msjConsultar").html(res.error);
                    }
                },"json");                               
            }
            
            //Ocultar div de consultar
            $("#consultar").hide();
            
            var idFondoCajaEliminar="";
        </script>
    </body>
</html>
<%
    }
%>