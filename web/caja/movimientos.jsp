<%-- 
    Document   : movimientos
    Created on : 20/11/2015, 01:45:35 PM
    Author     : ricesqgue

Pantalla principal de los moviminetos de caja.
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
                <h1>Movimientos de caja</h1>
            </div>
	</div>
                        
        <div class="container">  
            <div class="form-inline">
                <div class="form-group">
                    <label class="control-label">Fecha: </label>
                    <div class="input-group">
                        <input type='text' id="fecha" onchange="$('#btnBusca').removeAttr('disabled')" readonly="true" name="fecha" class="form-control" />
                        <span class="input-group-addon pointer" onclick="foco('fecha')">
                            <span class="icon-calendar"></span>
                        </span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="checkbox">
                        <label>
                            <input type="checkbox" onchange="$('#btnBusca').removeAttr('disabled')" id="cbSalidas" checked="true" name="cbSalidas" >
                            Salidas
                        </label>
                    </div>
                </div>                        
                    <div class="form-group">
                    <div class="checkbox">
                        <label>
                            <input type="checkbox" onchange="$('#btnBusca').removeAttr('disabled')" id="cbEntradas" checked="true" name="cbEntradas" >
                            Entradas
                        </label>
                    </div>
                </div>  
                <div class="form-group">                    
                    <button disabled="disabled" id="btnBusca" class="btn btn-info" onclick="$('#btnBusca').attr('disabled','disabled'); consultaMovimientos();"><span class="icon-search"></span></button>
                </div>
                
                
            </div>
            <br>
            <div class="row">
                <div id="contenido"></div>                 
            </div>
            
        </div>
                        
        <div class="modal fade" id="modal-eliminar">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">Eliminar movimiento de caja</h4>
                    </div>
                    <div class="modal-body">
                        <label>Se eliminará el movimiento seleccionado</label><br>
                        <label>Desea continuar?</label><br>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Cancelar</button>
                        <button type="button" class="btn btn-danger" data-dismiss="modal" onclick="eliminarMovimientoCaja(idMovimientoCajaEliminar)">Eliminar</button>
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

            
            function consultaMovimientos(){
                $('#btnBusca').attr('disabled','disabled');
                var fecha = $("#fecha").val();
                if(isDate(fecha)){
                    if($("#cbEntradas").prop("checked") || $("#cbSalidas").prop("checked")){
                       var valores = fecha.split("/");
                       fecha = valores[2]+"-"+valores[0]+"-"+valores[1];
                       $.post("listaMovimientos.jsp",{fecha: fecha, cbEntrada: $("#cbEntradas").prop("checked"), cbSalida: $("#cbSalidas").prop("checked")}, function (res){
                           if(res.tabla !== undefined){
                               $("#contenido").html(res.tabla);
                               $('#tablaMovimientosCaja').DataTable({paging:false,bInfo: false,bFilter: false});
                           }
                           else if(res.error !== undefined){ 
                               $("#contenido").html(res.error);
                           }
                           
                       },"json");
                    }
                    else{
                        alert("seleccione un tipo de movimiento");
                    }
                }else{
                    alert("ingrese una fecha válida");
                }
            }
            function eliminarMovimientoCaja(id){
                $.post("eliminaMovimiento.jsp",{id: id}, function (res){
                    if(res.exito !== undefined){
                        $("#row"+id).fadeOut("slow");
                        var delay = "2000";
                        setTimeout(function (){$("#row"+id).remove();},delay);
                    }
                    else if(res.error !== undefined){
                        $("#contenido").html(res.error);
                    }
                },"json");
                
                
            }
            var idMovimientoCajaEliminar="";
        </script>
    </body>
</html>
<%
    }
%>