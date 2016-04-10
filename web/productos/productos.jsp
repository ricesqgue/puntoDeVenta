<%-- 
    Document   : producto
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
                <h1>Productos</h1>
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
                                <button type="button" class="close" onclick="$('#nombreProductoModificar').val('')" data-dismiss="modal" aria-hidden="true">&times;</button>
                                <h3 class="modal-title">Modificar producto</h3>
                                
                            </div>
                            <div class="modal-body">
                                <form class="form-group" id="formModificar">
                                    <input type="hidden" name="idProductom" id="idProductom">
                                    <label for="codigom">Código</label>
                                    <input type="number" class="form-control" name="codigom" id="codigom">
                                    <label for="descripcionm">Descripción</label>
                                    <input type="text" class="form-control" name="descripcionm" id="descripcionm">
                                    <label for="categoriam">Categoría</label>
                                    <select name="categoriam" id="categoriam" class="form-control">
                                        <option selected>--- Elegir categoría ---</option>
                                        <%
                                        String query = "select categoria from categorias where activo = 1";
                                        objConn.Consult(query);
                                        int n = 0;
                                        if(objConn.rs != null){
                                            try{
                                                objConn.rs.last();
                                                n = objConn.rs.getRow();
                                                objConn.rs.first();
                                            }catch(Exception e){}
                                        }
                                        if(n>0){
                                            for(int i=0;i<n;i++){
                                                %>
                                                <option><%=objConn.rs.getString(1)%></option>
                                                <%
                                                objConn.rs.next();
                                            }
                                        }
                                        %>
                                    </select>
                                    <label for="marcam">Marca</label>
                                    <select name="marcam" id="marcam" class="form-control">
                                        <option selected>--- Elegir marca ---</option>
                                        <%
                                        query = "select marca from marcas where activo = 1";
                                        objConn.Consult(query);
                                        n = 0; 
                                        if(objConn.rs != null){
                                            try{
                                                objConn.rs.last();
                                                n = objConn.rs.getRow();
                                                objConn.rs.first();
                                            }catch(Exception e){}
                                        }
                                        if(n>0){
                                            for(int i=0;i<n;i++){
                                                %>
                                                <option><%=objConn.rs.getString(1)%></option>
                                                <%
                                                objConn.rs.next();
                                            }
                                        }
                                        %>
                                    </select>
                                    <label for="proveedor">Proveedor</label>
                                    <select name="proveedorm" id="proveedorm" class="form-control">
                                        <option selected>--- Elegir proveedor ---</option>
                                        <%
                                        query = "select concat_ws(' ', nombre, apellidoPaterno,apellidoMaterno) from proveedor where activo = 1 order by nombre";
                                        objConn.Consult(query);
                                        n = 0; 
                                        if(objConn.rs != null){
                                            try{
                                                objConn.rs.last();
                                                n = objConn.rs.getRow();
                                                objConn.rs.first();
                                            }catch(Exception e){}
                                        }
                                        if(n>0){
                                            for(int i=0;i<n;i++){
                                                %>
                                                <option><%=objConn.rs.getString(1)%></option>
                                                <%
                                                objConn.rs.next();
                                            }
                                        }
                                        objConn.desConnect();
                                        %>
                                    </select>
                                    <label for="precioVentam">Precio de venta</label>
                                    <input type="number" class="form-control" min="0" step="0.01" name="precioVentam" id="precioVentam">
                                    <label for="precioMayoreom">Precio de mayoreo</label>
                                    <input type="number" class="form-control" min="0" step="0.01" name="precioMayoreom" id="precioMayoreom">
                                    
                                </form>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" onclick="document.getElementById('formModificar').reset()" data-dismiss="modal" >Cancelar</button>
                                <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="modificarProducto()">Guardar cambios</button>
                            </div>
                        </div>
                    </div>  
                </div>
                
                <div class="modal fade" id="modal-agregar">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
				<button type="button" class="close" onclick="$('#nombreProducto').val('')" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title">Agregar producto</h4>
                            </div>
                            <div class="modal-body">
                                <form class="form-group" id="formAgregar">
                                    <label for="codigo">Código</label>
                                    <input type="number" class="form-control" name="codigo" id="codigo">
                                    <label for="descripcion">Descripción</label>
                                    <input type="text" class="form-control" name="descripcion" id="descripcion">
                                    <label for="categoria">Categoría</label>
                                    <select name="categoria" id="categoria" class="form-control">
                                        <option selected>--- Elegir categoría ---</option>
                                        <%
                                        query = "select categoria from categorias where activo = 1";
                                        objConn.Consult(query);
                                        n = 0;
                                        if(objConn.rs != null){
                                            try{
                                                objConn.rs.last();
                                                n = objConn.rs.getRow();
                                                objConn.rs.first();
                                            }catch(Exception e){}
                                        }
                                        if(n>0){
                                            for(int i=0;i<n;i++){
                                                %>
                                                <option><%=objConn.rs.getString(1)%></option>
                                                <%
                                                objConn.rs.next();
                                            }
                                        }
                                        %>
                                    </select>
                                    <label for="marca">Marca</label>
                                    <select name="marca" id="marca" class="form-control">
                                        <option selected>--- Elegir marca ---</option>
                                        <%
                                        query = "select marca from marcas where activo = 1";
                                        objConn.Consult(query);
                                        n = 0; 
                                        if(objConn.rs != null){
                                            try{
                                                objConn.rs.last();
                                                n = objConn.rs.getRow();
                                                objConn.rs.first();
                                            }catch(Exception e){}
                                        }
                                        if(n>0){
                                            for(int i=0;i<n;i++){
                                                %>
                                                <option><%=objConn.rs.getString(1)%></option>
                                                <%
                                                objConn.rs.next();
                                            }
                                        }
                                        %>
                                    </select>
                                    <label for="proveedor">Proveedor</label>
                                    <select name="proveedor" id="proveedor" class="form-control">
                                        <option selected>--- Elegir proveedor ---</option>
                                        <%
                                        query = "select concat_ws(' ', nombre, apellidoPaterno,apellidoMaterno) from proveedor where activo = 1 order by nombre";
                                        objConn.Consult(query);
                                        n = 0; 
                                        if(objConn.rs != null){
                                            try{
                                                objConn.rs.last();
                                                n = objConn.rs.getRow();
                                                objConn.rs.first();
                                            }catch(Exception e){}
                                        }
                                        if(n>0){
                                            for(int i=0;i<n;i++){
                                                %>
                                                <option><%=objConn.rs.getString(1)%></option>
                                                <%
                                                objConn.rs.next();
                                            }
                                        }
                                        objConn.desConnect();
                                        %>
                                    </select>
                                    <label for="precioVenta">Precio de venta</label>
                                    <input type="number" class="form-control" min="0" step="0.01" name="precioVenta" id="precioVenta">
                                    <label for="precioMayoreo">Precio de mayoreo</label>
                                    <input type="number" class="form-control" min="0" step="0.01" name="precioMayoreo" id="precioMayoreo">
                                    
                                </form>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" onclick="document.getElementById('formAgregar').reset();" data-dismiss="modal">Cerrar</button>
                                <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="agregarProducto()">Guardar</button>
                            </div>
                        </div>
                    </div>
                </div>    
                
                <div class="modal fade" id="modal-eliminar">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
				<button type="button" class="close" onclick="$('#nombreProductoEliminar').val('')" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title">Eliminar producto</h4>
                            </div>
                            <div class="modal-body">
                                <label>Se eliminará el producto seleccionado</label><br>
                                <label>Desea continuar?</label><br>
                                <h5>*No se podrá eliminar si hay existencia en stock.</h5>
                            </div>
                            <div class="modal-footer">
				<button type="button" class="btn btn-default" onclick="$('#nombreProductoEliminar').val('')" data-dismiss="modal">Cancelar</button>
                                <button type="button" class="btn btn-danger" data-dismiss="modal" onclick="eliminarProducto(idProductoEliminar)">Eliminar</button>
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
                $.post("catalogoProductos.jsp",function(res){
                    $("#wrap").html(res.tabla);
                    $('#tablaProductos').DataTable({paging:false,bInfo: false});
                },"json");                    
            }
            
            function agregarProducto(){
                var codigo = $("#codigo").val();
                var descripcion = $("#descripcion").val();
                var categoria = $("#categoria").val();
                var marca = $("#marca").val();
                var proveedor = $("#proveedor").val();
                var precioVenta = $("#precioVenta").val();
                var precioMayoreo = $("#precioMayoreo").val();
                if(precioVenta === ""){
                    $("#precioVenta").val("0");
                    precioVenta = $("#precioVenta").val();
                }
                if(precioMayoreo === ""){
                    $("#precioMayoreo").val("0");   
                    precioMayoreo = $("#precioMayoreo").val();
                }
                var error = "";
                
                descripcion = descripcion.replace(/[,;:|°!\"\'%$#/{}^+*~@]/g,'');
                if(codigo === "" || isNaN(codigo)){
                    error = "Ingrese un código válido.";
                }
                else if (descripcion === ""){
                    error = "Ingrese una descripción de producto válida.";
                }
                else if(categoria === "--- Elegir categoría ---"){
                    error = "Seleccione una categoría.";
                }
                else if(marca === "--- Elegir marca ---"){
                    error = "Seleccione una marca.";
                }
                else if(proveedor === "--- Elegir proveedor ---"){
                    error = "Seleccione un proveedor.";
                }
                else if(isNaN(precioVenta)){
                    error = "Ingrese un precio de venta válido.";
                }     
                else if(isNaN(precioMayoreo)){
                    error = "Ingrese un precio de mayoreo válido.";
                }                     
                if(error !== ""){
                    $("#mensaje").html("<br><div class='row animated slideInLeft'> <div class='col-md-4 col-md-offset-3'>"
                        + "<div class='alert alert-danger' role='alert'>"
                        + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                        + "<span aria-hidden='true'>&times;</span></button>"
                        + "<strong>Error. </strong>" + error +""
                        + "</div></div></div>");
                }else{                
                    $.post("agregaProducto.jsp",$("#formAgregar").serialize(), function(res){ 
                        document.getElementById("formAgregar").reset();
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
            
            function modificarProducto(){
                var codigo = $("#codigom").val();
                var descripcion = $("#descripcionm").val();
                var categoria = $("#categoriam").val();
                var marca = $("#marcam").val();
                var proveedor = $("#proveedorm").val();
                var precioVenta = $("#precioVentam").val();
                var precioMayoreo = $("#precioMayoreom").val();
                if(precioVenta === ""){
                    $("#precioVentam").val("0");
                    precioVenta = "0";
                    
                }
                if(precioMayoreo === ""){
                    $("#precioMayoreom").val("0");
                    precioMayoreo = "0";
                }
                var error = "";
                
                descripcion = descripcion.replace(/[,;:|°!\"\'%$#/{}^+*~@]/g,'');
                if(codigo === "" || isNaN(codigo)){
                    error = "Ingrese un código válido.";
                }
                else if (descripcion === ""){
                    error = "Ingrese una descripción de producto válida.";
                }
                else if(categoria === "--- Elegir categoría ---"){
                    error = "Seleccione una categoría.";
                }
                else if(marca === "--- Elegir marca ---"){
                    error = "Seleccione una marca.";
                }
                else if(proveedor === "--- Elegir proveedor ---"){
                    error = "Seleccione un proveedor.";
                }
                else if(isNaN(precioVenta)){
                    error = "Ingrese un precio de venta válido.";
                }       
                else if(isNaN(precioMayoreo)){
                    error = "Ingrese un precio de mayoreo válido.";
                }   
                if(error !== ""){
                    $("#mensaje").html("<br><div class='row animated slideInLeft'> <div class='col-md-4 col-md-offset-3'>"
                        + "<div class='alert alert-danger' role='alert'>"
                        + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                        + "<span aria-hidden='true'>&times;</span></button>"
                        + "<strong>Error. </strong>" + error +""
                        + "</div></div></div>");                
                }else{                 
                    $.post("modificaProducto.jsp",$("#formModificar").serialize(), function(res){
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
            
            function eliminarProducto(idProducto){
                $.post("eliminaProducto.jsp",{idProducto: idProducto},function (res){
                    if(res.exito !== undefined) {
                        catalogo();
                        $("#mensaje").html(res.exito);      
                    }
                    else{
                        $("#mensaje").html(res.error);
                    }
                },"json");
            }
            function llenaFormulario(idProducto,codigo,descripcion,proveedor,categoria,marca,precioVenta,precioMayoreo){
                $("#idProductom").val(idProducto);
                $("#codigom").val(codigo);
                $("#descripcionm").val(descripcion);
                $("#proveedorm").val(proveedor);
                $("#categoriam").val(categoria);
                $("#marcam").val(marca);
                $("#precioVentam").val(precioVenta);
                $("#precioMayoreom").val(precioMayoreo);
            }
 
            //Llamo a la funcion catalogo para cargar la tabla.
            catalogo(); 
            var idProductoEliminar = "";
        </script>            
    </body>
</html>
<%
    }
%>