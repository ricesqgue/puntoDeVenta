<%-- 
    Document   : productosFallados
    Created on : 30/11/2015, 01:00:53 PM
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
        <title><%=nombreEmpresa %></title>
    </head>
    <body>
	<navbar-principal ng-init="menu.usuario='<%=sesion.getAttribute("nombre")%>'"></navbar-principal>
	<div class="jumbotron">
            <div class="container">
                <h1>Productos fallados</h1>
            </div>
	</div>
        <div class="container">
            <div id="wrap" ></div>
            <div><button class="btn btn-success icon-plus" data-toggle="modal" href="#modal-agregar"></button></div>
            <div id='mensaje'></div>
        </div>
        <div class="container">
        <br>                
        <div class="modal fade" id="modal-agregar">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">Producto fallado</h4>
                    </div>
                    <div class="modal-body">
                        <form class="form-group" id="formAgregar">
                            <label for="codigo">Código</label>
                            <div class="input-group">
                                <input type="text" readonly="true" class="form-control pointer" data-toggle="modal" href='#modal-busqueda' name="codigo" id="codigo">
                              <div class="input-group-addon">
                                  <span class="icon-search pointer" data-toggle="modal" href='#modal-busqueda' onclick="foco('codigo')"></span>
                              </div>
                            </div>
                            
                            <label for="producto">Producto</label>
                            <input type="text" name="producto" id="producto" readonly="true" class="form-control">
                            <label for="proveedor">Proveedor</label>
                            <input type="text" name="proveedor" id="proveedor" readonly="true" class="form-control">
                            <label for="defecto">Defecto</label>
                            <input type="text" class="form-control"name="defecto" id="defecto">  
                            <input type="hidden" name="id" id="id">
                            <sub>*Se descontará el producto del stock.</sub>
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
				<h4 class="modal-title">Eliminar producto fallado</h4>
                            </div>
                            <div class="modal-body">
                                <label>Se eliminará el producto seleccionado</label><br>
                                <label>Desea continuar?</label><br>
                                <sub>*No se agregará el producto al stock.</sub>
                            </div>
                            <div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Cancelar</button>
                                <button type="button" class="btn btn-danger" data-dismiss="modal" onclick="eliminarProducto(idProductoEliminar)">Eliminar</button>
                            </div>
                        </div>
                    </div>                    
                </div>
            
            
                <div class="modal fade" id="modal-busqueda">
                    <div class="modal-dialog">
                    	<div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                <h4 class="modal-title">Búsqueda de productos</h4>
                            </div>
                            <div class="modal-body">
                                <%
                                String query = "select idproducto, codigo,descripcion, marca, categoria , concat_ws(' ',nombre,apellidoPaterno,apellidoMaterno) from producto natural join marcas natural join categorias natural join proveedor where producto.activo = 1 and stock>0";
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
                                %>
                                <div class='table-responsive datagrid'>
                                    <table class='table table-striped' id='tablaBusqueda'> 
                                        <thead>
                                            <tr class='info'>
                                                <th>Codigo</th>
                                                <th>Producto</th>
                                                <th>Marca</th>
                                                <th>Categoría</th>
                                                <th>Proveedor</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        <%
                                        for (int i = 0; i < n; i++) {
                                            %> <tr>
                                            <%
                                            for (int j = 2; j < 7; j++) {
                                                %>
                                                <td style='cursor:pointer' onclick="seleccionProducto('<%=objConn.rs.getString(1)%>','<%=objConn.rs.getString(2)%>','<%=objConn.rs.getString(3)%>','<%=objConn.rs.getString(6)%>')"><%=objConn.rs.getString(j)%></td>
                                            <%
                                            }
                                            %>
                                            </tr>
                                            <%
                                            objConn.rs.next();
                                        }
                                        %>
                                        </tbody>
                                    </table>
                                </div>    
                                <%
                                }else{
                                %>
                                    <center><h2>No hay productos.</h2></center>
                                    <%
                                }
                                %>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
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
            $('document').ready(function(){
                 $('#tablaBusqueda').DataTable({paging:false,bInfo: false});
            });
               
                        
            function catalogo(){
                $.post("catalogoProductosFallados.jsp",function(res){
                    $("#wrap").html(res.tabla);
                    $('#tablaProductos').DataTable({paging:false,bInfo: false});
                },"json");                    
            }
            
            function agregarProducto(){
                var codigo = $("#codigo").val();
                var producto = $("#producto").val();
                var proveedor = $("#proveedor").val();               
                var defecto = $("#defecto").val();
                var error = "";
                if(codigo === "" || isNaN(codigo)){
                    error = "Ingrese un código válido.";
                }
                else if (producto === ""){
                    error = "Ingrese un producto.";
                }
                else if(proveedor === ""){
                    error = "Ingrese un proveedor.";
                }
                else if(defecto === ""){
                    error = "Ingrese el defecto del producto.";
                }    
                if(error !== ""){
                    $("#mensaje").html("<br><div class='row animated slideInLeft'> <div class='col-md-4 col-md-offset-3'>"
                        + "<div class='alert alert-danger' role='alert'>"
                        + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                        + "<span aria-hidden='true'>&times;</span></button>"
                        + "<strong>Error. </strong>" + error +""
                        + "</div></div></div>");
                }else{                
                    $.post("agregaProductoFallado.jsp",$("#formAgregar").serialize(), function(res){ 
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
            
            
            function eliminarProducto(idProducto){
                $.post("eliminaProductoFallado.jsp",{idProducto: idProducto},function (res){
                    if(res.exito !== undefined) {
                        catalogo();
                        $("#mensaje").html(res.exito);      
                    }
                    else{
                        $("#mensaje").html(res.error);
                    }
                },"json");
            }       
            
            function seleccionProducto(id,codigo,producto,proveedor){
               
                $("#codigo").val(codigo);
                $("#producto").val(producto);
                $("#proveedor").val(proveedor);
                $("#id").val(id);
                $("#modal-busqueda").modal("toggle");
                foco("defecto");
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