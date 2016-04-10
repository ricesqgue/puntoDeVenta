<%-- 
    Document   : marcas
    Created on : 4/11/2015, 05:54:42 PM
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
        <link rel="<%=nombreEmpresa%>"</title>
    </head>
    <body>
	<navbar-principal ng-init="menu.usuario='<%=sesion.getAttribute("nombre")%>'"></navbar-principal>
	<div class="jumbotron">
            <div class="container">
                <h1>Marcas</h1>
            </div>
	</div>
        <div class="container">
            <div id="wrap" ></div>
            <div><button class="btn btn-success icon-plus" data-toggle="modal" href="#modal-agregar"></button></div>
            <div id='mensaje'></div>
        </div>
        <div class="container">
                <br>
                <div class="modal fade" id="modal-modificar">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" onclick="$('#nombreMarcaModificar').val('')" data-dismiss="modal" aria-hidden="true">&times;</button>
                                <h3 class="modal-title">Modificar marca</h3>
                                
                            </div>
                            <div class="modal-body">
                                <label>Ingrese el nuevo nombre de la marca: </label>
                                <input type="text" id="nombreMarcaModificar" name="nombreMarcaModificar" class="form-control" >
                                <h5>*Se modificará la marca en los productos registrados.</h5>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" onclick="$('#nombreMarcaModificar').val('')" data-dismiss="modal" >Cancelar</button>
                                <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="modificarMarca(idMarcaModificar,$('#nombreMarcaModificar').val())">Guardar cambios</button>
                            </div>
                        </div>
                    </div>  
                </div>
                
                <div class="modal fade" id="modal-agregar">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
				<button type="button" class="close" onclick="$('#nombreMarca').val('')" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title">Agregar marca</h4>
                            </div>
                            <div class="modal-body">
                                <label>Ingrese el nombre de la marca:</label>
                                <input type="text" id="nombreMarca" name="nombreMarca" class="form-control" >
                            </div>
                            <div class="modal-footer">
				<button type="button" class="btn btn-default" onclick="$('#nombreMarca').val('')" data-dismiss="modal">Cerrar</button>
                                <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="agregarMarca($('#nombreMarca').val())">Guardar</button>
                            </div>
                        </div>
                    </div>
                </div>    
                
                <div class="modal fade" id="modal-eliminar">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
				<button type="button" class="close" onclick="$('#nombreMarcaEliminar').val('')" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title">Eliminar marca</h4>
                            </div>
                            <div class="modal-body">
                                <label>Se eliminará la marca seleccionada</label><br>
                                <label>Desea continuar?</label><br>
                                <h5>*No se podrá eliminar si existen productos relacionados en existencia.</h5>
                            </div>
                            <div class="modal-footer">
				<button type="button" class="btn btn-default" onclick="$('#nombreMarcaEliminar').val('')" data-dismiss="modal">Cancelar</button>
                                <button type="button" class="btn btn-danger" data-dismiss="modal" onclick="eliminarMarca(idMarcaEliminar)">Eliminar</button>
                            </div>
                        </div>
                    </div>
                </div>  
            </div>
                        
        <div id="footer" style="margin-top: 100px;">
            
        </div>
        
        <script type="text/javascript" src="../js/jquery.js"></script>
        <script type="text/javascript" src="../js/angular.min.js"></script>
        <script type="text/javascript" src ="../js/bootstrap.min.js"></script>
        <script type="text/javascript" src ="../js/jquery.validate.min.js"></script>
        <script type="text/javascript" src = "../js/puntoDeVenta.js"></script>
        <script type="text/javascript" src ="../js/filtroTabla.js"></script>
        <script type="text/javascript">
            function catalogo(){
                $.post("catalogoMarcas.jsp",function(res){
                    $("#wrap").html(res.tabla);
                    $('#tablaMarcas').DataTable({paging:false,bInfo: false});
                },"json");                    
            }
            
            function agregarMarca(nombreMarca){
                $('#nombreMarca').val('');
                nombreMarca = nombreMarca.replace(/[,;:|°!\"\'%$#/{}^+*~@]/g,'');                    
                if(nombreMarca === ""){
                    $("#mensaje").html("<br><div class='row animated slideInLeft'> <div class='col-md-4 col-md-offset-3'>"
                        + "<div class='alert alert-danger' role='alert'>"
                        + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                        + "<span aria-hidden='true'>&times;</span></button>"
                        + "<strong>Error. </strong> Ingrese un nombre de marca válido."
                        + "</div></div></div>");
                }else{
                
                    $.post("agregaMarca.jsp",{nombreMarca: nombreMarca}, function(res){                
                        if(res.exito !== undefined) {
                            catalogo();
                            $("#mensaje").html(res.exito);                            
                        }
                        else{
                            $("#mensaje").html(res.error);
                        }
                    },"json");
                }
                
            }
            
            function modificarMarca(idMarca,nombreMarca){
                $('#nombreMarcaModificar').val('');
                nombreMarca = nombreMarca.replace(/[,;:|°!\"\'%$#/{}^+*~@]/g,'');
                if(nombreMarca === ""){
                    $("#mensaje").html("<br><div class='row animated slideInLeft'> <div class='col-md-4 col-md-offset-3'>"
                        + "<div class='alert alert-danger' role='alert'>"
                        + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                        + "<span aria-hidden='true'>&times;</span></button>"
                        + "<strong>Error. </strong> Ingrese un nombre de marca válido."
                        + "</div></div></div>");
                }else{                 
                    $.post("modificaMarca.jsp",{idMarca: idMarca, nombreMarca: nombreMarca}, function(res){
                        if(res.exito !== undefined) {
                            catalogo();
                           $("#mensaje").html(res.exito);      
                        }
                        else{
                            $("#mensaje").html(res.error);
                        }
                    },"json");
                }
                
            }
            
            function eliminarMarca(idMarca){
                $.post("eliminaMarca.jsp",{idMarca: idMarca},function (res){
                    if(res.exito !== undefined) {
                        catalogo();
                        $("#mensaje").html(res.exito);      
                    }
                    else{
                        $("#mensaje").html(res.error);
                    }
                },"json");
            }
 
            //Llamo a la funcion catalogo para cargar la tabla.
            catalogo(); 
            var idMarcaModificar = "";
            var idMarcaEliminar = "";
        </script>            
    </body>
</html>

<%
    }
%>
