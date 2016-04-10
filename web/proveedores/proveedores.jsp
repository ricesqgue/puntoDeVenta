<%-- 
    Document   : proveedores
    Created on : 12/11/2015, 10:15:32 AM
    Author     : ricesqgue
--%>

<%
    HttpSession sesion = request.getSession();
    if(sesion.getAttribute("nombre")==null){
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
	<link rel="stylesheet" href="../css/puntoDeVenta.css">
	<link rel="stylesheet" href="../css/icons.css">
        <link rel="stylesheet" href="../css/animate.css">
        <link rel="stylesheet" href="../css/jquery-ui.min.css">
        <title><%=nombreEmpresa%></title>
    </head>
    <body>
	<navbar-principal ng-init="menu.usuario='<%=sesion.getAttribute("nombre")%>'"></navbar-principal>
	<div class="jumbotron">
            <div class="container">
                <h1>Proveedores</h1>
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
                                <button type="button" class="close" onclick="$('#nombreProveedorModificar').val('')" data-dismiss="modal" aria-hidden="true">&times;</button>
                                <h3 class="modal-title">Modificar proveedor</h3>                                
                            </div>
                            <div class="modal-body" style="max-height: 400px; overflow-y: auto">                          
                                <form class="form-group" id="formModificar">
                                    <input type="hidden" name="idProveedorm" id="idProveedorm" >
                                    <label class="control-label">Nombre</label>
                                    <input type="text" name="nombrem" id="nombrem" class="form-control">
                                    <label class="control-label">Apellido paterno</label>
                                    <input type="text" name="apePatm" id="apePatm" class="form-control">                                    
                                    <label class="control-label">Apellido materno</label>
                                    <input type="text" name="apeMatm" id="apeMatm" class="form-control">
                                    <label class="control-label">Teléfono</label>
                                    <input type="tel" name="telm" id="telm" class="form-control">
                                    <label class="control-label">Email</label>
                                    <input type="email" name="emailm" id="emailm" class="form-control">
                                    <label class="control-label">Estado</label>
                                    <select name="estadom" id="estadom" class="form-control" onchange="cambiaMunicipios()">
                                        <option selected value="--- Elegir estado ---">--- Elegir estado ---</option>
                                        <%
                                        objConn.Consult("select estado from estados;");
                                        objConn.rs.last();
                                        int num = objConn.rs.getRow();
                                        objConn.rs.first();
                                        for(int i=0;i<num;i++){
                                            %>
                                            <option value="<%=objConn.rs.getString(1)%>"><%=objConn.rs.getString(1)%></option>
                                            <%
                                            objConn.rs.next(); 
                                        }
                                        %>
                                    </select>
                                    <label class="control-label">Municipio</label>
                                    <select name="municipiom" id="municipiom" class="form-control">
                                        <option selected value="--- Elegir municipio ---">--- Elegir municipio ---</option>
                                    </select>
                                    <label class="control-label">Calle</label>
                                    <input type="text" name="callem" id="callem" class="form-control">
                                    <label class="control-label">Número</label>
                                    <input type="text" name="numerom" id="numerom" class="form-control">
                                    <label class="control-label">Colonia</label>
                                    <input type="text" name="coloniam" id="coloniam" class="form-control">
                                    <label class="control-label">Código postal</label>
                                    <input type="number" name="cpm" id="cpm" class="form-control">
                                    <label class="control-label">RFC</label>
                                    <input type="text" style="text-transform: uppercase" name="rfcm" id="rfcm" class="form-control">
                                </form>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" onclick="document.getElementById('formModificar').reset()" data-dismiss="modal" >Cancelar</button>
                                <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="modificarProveedor()">Guardar cambios</button>
                            </div>
                        </div>
                    </div>  
                </div>
                
                <div class="modal fade" id="modal-agregar">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
				<button type="button" class="close"  data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title">Agregar proveedor</h4>
                            </div>
                            <div class="modal-body" style="max-height: 400px; overflow-y: auto">
                                <form class="form-group" id="formAgregar">
                                    <label class="control-label">Nombre</label>
                                    <input type="text" name="nombre" id="nombre" class="form-control">
                                    <label class="control-label">Apellido paterno</label>
                                    <input type="text" name="apePat" id="apePat" class="form-control">                                    
                                    <label class="control-label">Apellido materno</label>
                                    <input type="text" name="apeMat" id="apeMat" class="form-control">
                                    <label class="control-label">Teléfono</label>
                                    <input type="tel" name="tel" id="tel" class="form-control">
                                    <label class="control-label">Email</label>
                                    <input type="email" name="email" id="email" class="form-control">
                                    <label class="control-label">Estado</label>
                                    <select name="estado" id="estado" class="form-control" onchange="cambiaMunicipios()">
                                        <option selected value="--- Elegir estado ---">--- Elegir estado ---</option>
                                        <%
                                        objConn.Consult("select estado from estados;");
                                        objConn.rs.last();
                                        num = objConn.rs.getRow();
                                        objConn.rs.first();
                                        for(int i=0;i<num;i++){
                                            %>
                                            <option value="<%=objConn.rs.getString(1)%>"><%=objConn.rs.getString(1)%></option>
                                            <%
                                            objConn.rs.next(); 
                                        }
                                        %>
                                    </select>
                                    <label class="control-label">Municipio</label>
                                    <select name="municipio" id="municipio" class="form-control">
                                        <option selected value="--- Elegir municipio ---">--- Elegir municipio ---</option>
                                    </select>
                                    <label class="control-label">Calle</label>
                                    <input type="text" name="calle" id="calle" class="form-control">
                                    <label class="control-label">Número</label>
                                    <input type="text" name="numero" id="numero" class="form-control">
                                    <label class="control-label">Colonia</label>
                                    <input type="text" name="colonia" id="colonia" class="form-control">
                                    <label class="control-label">Código postal</label>
                                    <input type="number" name="cp" id="cp" class="form-control">
                                    <label class="control-label">RFC</label>
                                    <input type="text" style="text-transform: uppercase" name="rfc" id="rfc" class="form-control">
                                </form>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" onclick="document.getElementById('formAgregar').reset();" data-dismiss="modal">Cerrar</button>
                                <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="agregarProveedor()">Guardar</button>
                            </div>
                        </div>
                    </div>
                </div>    
                
                <div class="modal fade" id="modal-eliminar">
                    <div class="modal-dialog"> 
                        <div class="modal-content">
                            <div class="modal-header">
				<button type="button" class="close" onclick="$('#nombreProveedorEliminar').val('')" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title">Eliminar proveedor</h4>
                            </div>
                            <div class="modal-body">
                                <label>Se eliminará el proveedor seleccionado</label><br>
                                <label>Desea continuar?</label><br>
                                <h5>*No se podrá eliminar si existen productos del proveedor en stock.</h5>
                            </div>
                            <div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Cancelar</button>
                                <button type="button" class="btn btn-danger" data-dismiss="modal" onclick="eliminarProveedor(idProveedorEliminar)">Eliminar</button>
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
                $.post("catalogoProveedores.jsp",function(res){
                    $("#wrap").html(res.tabla);
                    $('#tablaProveedores').DataTable({paging:false,bInfo: false});
                },"json");                    
            }
            
            function agregarProveedor(){
                var nombre = $("#nombre").val();
                nombre = nombre.replace(/[,;:|°!\"\'%$#/{}^+*~@]/g,'');
                var apePat = $("#apePat").val();
                apePat = apePat.replace(/[,;:|°!\"\'%$#/{}^+*~@]/g,'');
                var apeMat = $("#apeMat").val();
                apeMat = apeMat.replace(/[,;:|°!\"\'%$#/{}^+*~@]/g,'');
                var tel = $("#tel").val();
                var email = $("#email").val();
                var estado = $("#estado").val();
                var municipio = $("#municipio").val();
                var calle = $("#calle").val();
                calle = calle.replace(/[,;:|°!\"\'%$#/{}^+*~@]/g,'');
                var numero = $("#numero").val();
                numero = numero.replace(/[,;:|°!\"\'%$#/{}^+*~@]/g,'');
                var colonia = $("#colonia").val();
                colonia = colonia.replace(/[,;:|°!\"\'%$#/{}^+*~@]/g,'');
                var cp = $("#cp").val();
                var rfc = $("#rfc").val();
                rfc = rfc.replace(/[,;:|°!\"\'%$#/{}^+*~@]/g,'');
                var validaTelefono = new RegExp("^[0-9]{10}$");
                var validaEmail = new RegExp("^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$");
                var error = "";
                if(nombre === ""){
                    error = "Ingrese un nombre válido.";
                }
                else if(apePat === ""){
                    error = "Ingrese un apellido paterno válido.";
                }
                else if(apeMat === ""){
                    error = "Ingrese un apellido materno válido.";
                }
                else if(!validaTelefono.test(tel)){
                    error = "Ingrese un teléfono válido. (10 dígitos, sólo números).";
                }
                else if(!validaEmail.test(email)){
                    error = "Ingrese un email válido.";
                }
                else if(estado === "--- Elegir estado ---"){
                    error = "Seleccione un estado.";
                }
                else if(municipio === "--- Elegir municipio ---"){
                    error = "Seleccione un municipio.";
                }
                else if(calle === ""){
                    error = "Ingrese una calle válida.";
                }
                else if(numero === ""){
                    error = "Ingrese un número de domicilio válido.";
                }
                else if(cp === "" || cp.length < 4 || cp.length > 5){
                    error = "Ingrese un código postal válido.";
                }
                else if(rfc !== "" && (rfc.length < 12 || rfc.length > 13)){
                    error = "Ingrese un rfc válido.";
                }
                if(error !== ""){
                    $("#mensaje").html("<br><div class='row animated slideInLeft'> <div class='col-md-4 col-md-offset-3'>"
                        + "<div class='alert alert-danger' role='alert'>"
                        + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                        + "<span aria-hidden='true'>&times;</span></button>"
                        + "<strong>Error. </strong>" + error +""
                        + "</div></div></div>");
                }else{                
                    $.post("agregaProveedor.jsp",$("#formAgregar").serialize(), function(res){ 
                        
                        if(res.exito !== undefined) {
                            document.getElementById("formAgregar").reset();
                            catalogo();
                            $("#mensaje").html(res.exito);                            
                        }
                        else{
                            $("#mensaje").html(res.error);
                        }
                    },"json");
                }
                
            }
            
            function modificarProveedor(){
                var nombre = $("#nombrem").val();
                nombre = nombre.replace(/[,;:|°!\"\'%$#/{}^+*~@]/g,'');
                var apePat = $("#apePatm").val();
                apePat = apePat.replace(/[,;:|°!\"\'%$#/{}^+*~@]/g,'');
                var apeMat = $("#apeMatm").val();
                apeMat = apeMat.replace(/[,;:|°!\"\'%$#/{}^+*~@]/g,'');
                var tel = $("#telm").val();
                var email = $("#emailm").val();
                var estado = $("#estadom").val();
                var municipio = $("#municipiom").val();
                var calle = $("#callem").val();
                calle = calle.replace(/[,;:|°!\"\'%$#/{}^+*~@]/g,'');
                var numero = $("#numerom").val();
                numero = numero.replace(/[,;:|°!\"\'%$#/{}^+*~@]/g,'');
                var colonia = $("#coloniam").val();
                colonia = colonia.replace(/[,;:|°!\"\'%$#/{}^+*~@]/g,'');
                var cp = $("#cpm").val();
                var rfc = $("#rfcm").val();
                rfc = rfc.replace(/[,;:|°!\"\'%$#/{}^+*~@]/g,'');
                var validaTelefono = new RegExp("^[0-9]{10}$");
                var validaEmail = new RegExp("^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$");
                var error = "";
                if(nombre === ""){
                    error = "Ingrese un nombre válido.";
                }
                else if(apePat === ""){
                    error = "Ingrese un apellido paterno válido.";
                }
                else if(apeMat === ""){
                    error = "Ingrese un apellido materno válido.";
                }
                else if(!validaTelefono.test(tel)){
                    error = "Ingrese un teléfono válido. (10 dígitos, sólo números).";
                }
                else if(!validaEmail.test(email)){
                    error = "Ingrese un email válido.";
                }
                else if(estado === "--- Elegir estado ---"){
                    error = "Seleccione un estado.";
                }
                else if(municipio === "--- Elegir municipio ---"){
                    error = "Seleccione un municipio.";
                }
                else if(calle === ""){
                    error = "Ingrese una calle válida.";
                }
                else if(numero === ""){
                    error = "Ingrese un número de domicilio válido.";
                }
                else if(cp === "" || cp.length < 4 || cp.length > 5){
                    error = "Ingrese un código postal válido.";
                }
                else if(rfc !== "" && (rfc.length < 12 || rfc.length > 13)){
                    error = "Ingrese un rfc válido.";
                }
                if(error !== ""){
                    $("#mensaje").html("<br><div class='row animated slideInLeft'> <div class='col-md-4 col-md-offset-3'>"
                        + "<div class='alert alert-danger' role='alert'>"
                        + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                        + "<span aria-hidden='true'>&times;</span></button>"
                        + "<strong>Error. </strong>" + error +""
                        + "</div></div></div>");
                }else{                 
                    $.post("modificaProveedor.jsp",$("#formModificar").serialize(), function(res){
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
            
            function eliminarProveedor(idProveedor){
                $.post("eliminaProveedor.jsp",{idProveedor: idProveedor},function (res){
                    if(res.exito !== undefined) {
                        catalogo();
                        $("#mensaje").html(res.exito);      
                    }
                    else{
                        $("#mensaje").html(res.error);
                    }
                },"json");
            }
            function llenaFormulario(idProveedor,nombre,apePat,apeMat,telefono,email,calle,numero,colonia,municipio,estado,cp,rfc){  
                $("#idProveedorm").val(idProveedor);
                $("#nombrem").val(nombre);
                $("#apePatm").val(apePat);
                $("#apeMatm").val(apeMat);
                $("#telm").val(telefono);
                $("#emailm").val(email);
                $("#estadom").val(estado);
                $.post("cargaMunicipios.jsp",{estado: estado}, function (res){
                    $("#municipiom").html("<option value='--- Elegir municipio ---' selected>--- Elegir municipio ---</option>" + res.opciones);
                },"json");               
                $("#callem").val(calle);
                $("#numerom").val(numero);
                $("#coloniam").val(colonia);
                $("#cpm").val(cp);
                $("#rfcm").val(rfc);
                var delay=100;   
                setTimeout(function(){                    
                    $("#municipiom").val(municipio);
                }, delay)   ; 
                
            }
            
            function cambiaMunicipios(){
                var estado = $("#estado").val();
                if(estado !== "--- Elegir estado ---"){
                    $.post("cargaMunicipios.jsp",{estado: estado}, function (res){
                        $("#municipio").html("<option value='--- Elegir municipio ---' selected>--- Elegir municipio ---</option>" + res.opciones);
                    },"json");
                }                                    
            }
 
            //Llamo a la funcion catalogo para cargar la tabla.
            catalogo(); 
            var idProveedorModificar = "";
            var idProveedorEliminar = "";
        </script>            
    </body>
</html>
<%
    }
%>