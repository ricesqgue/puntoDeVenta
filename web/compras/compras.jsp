<%-- 
    Document   : compras
    Created on : 13/11/2015, 09:51:28 AM
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
        <script>var numFilas = 0;</script>
    </head>
    <body>
	<navbar-principal ng-init="menu.usuario='<%=sesion.getAttribute("nombre")%>'"></navbar-principal>
	<div class="jumbotron">
            <div class="container">
                <h1>Compras</h1>
            </div>
	</div>
	
        <div class="container" id="wrap">
            <div class="bordeado">
                    
                <div class="form-inline">
                    <div class="form-group">
                        <label class="control-label">Proveedor</label>
                        <select id="proveedor" class="form-control" onchange="chechaProveedor()" name="proveedor">
                            <option selected value="--- Elegir proveedor ---">--- Elegir proveedor ---</option>
                            <%
                            objConn.Consult("select concat_ws(' ',nombre,apellidoPaterno,apellidoMaterno) as nombreFull, idProveedor from proveedor where activo = 1 order by nombreFull;");
                            int n=0;
                            if(objConn.rs != null){
                                try{
                                    objConn.rs.last();
                                    n=objConn.rs.getRow();
                                    objConn.rs.first();
                                }catch(Exception e){}
                            }
                            if(n>0){
                                for(int i=0;i<n;i++){
                            %>
                                    <option value="<%=objConn.rs.getString(2)%>"><%=objConn.rs.getString(1)%></option>                             
                                    <%
                                    objConn.rs.next();
                                }
                            }
                            %>
                        </select>
                    </div>
                    <div class="form-group">
                        <button disabled="disabled" type="button" title="Comenzar compra" onclick="comienzaCompra()" id="comienzaCompraBtn" class="btn btn-default" ><span class="icon-checkmark"></span></button>
                    </div>
                </div>
                        
                        
                <div class="row">
                    <br>
                    <form class="form-inline" id="formulario">
                                                     
                        <div class="form-group">
                            <label for="codigo">C&oacute;digo</label>
                            <input disabled="disabled" id="codigo" type="number" name="codigo" title="Introduce un codigo" class="form-control" placeholder="C&oacute;digo" required tabindex="1" 
                                   min="0" onkeypress="if(enter(event.keyCode) && $('#codigo').val()=== ''){foco('terminaCompraBtn');}else if(enter(event.keyCode) && $('#codigo').val() !== ''){foco('cantidad'); $('#cantidad').val(1).select();}">
                            <br>
                            <button type="button" title="Buscar producto" disabled="disabled" id="btnSearch" data-toggle="modal" href='#modal-buscar' class="btn btn-info"><span class="icon-search"> </span></button>
                        </div>
                        <div class="form-group" >
                            <label for="cantidad">Cantidad</label>
                            <input disabled="disabled" type="number" title="Introduce una cantidad" class="form-control" id="cantidad" name="cantidad" placeholder="Cantidad" required tabindex="2" 
                                   onkeypress="if(enter(event.keyCode)){foco('importe');}">
                        </div>
                        
                        <div class="form-group" >
                            <label for="importe">Importe</label>
                            <input disabled="disabled" type="number" title="Introduce el importe" class="form-control" id="importe" name="importe" placeholder="Importe total" required tabindex="3" 
                                   onkeypress="if(enter(event.keyCode)){$('#formulario').submit();}">
                        </div>
                        
                        <div class="form-group">
                            <button disabled="disabled" type="button" title="Agregar a la compra" onclick="$('#formulario').submit();" id="agregaProductoBtn" class="btn btn-default" tabindex="4" ><span class="icon-checkmark"></span></button>                             
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
                    <form id="formularioTabla" method="post">
                        <div class="table-responsive">
                            <table id ="filas" class="table table-striped table-bordered table-hover">
                                <tr class="info">
                                    <th >Codigo</th>
                                    <th>Descripcion</th>
                                    <th>Marca</th>
                                    <th>Catagoría</th>
                                    <th>Cantidad</th>
                                    <th>Precio unitario</th>
                                    <th>Importe</th>
                                    <th></th>
                                </tr>
                            </table>	
                        </div>
                        <input id="inputFilas2" type="hidden" name="numFilas" value="0">
                        <input id="idProveedor" type="hidden" name="idProveedor" value="">
                      </form>
                </div>
            </div>
            <button class="btn btn-success" id = "terminaCompraBtn" disabled="disabled" data-toggle="modal" href='#modal-terminaCompra' onclick="terminaCompra();">
                Realizar compra 
                <span class="icon-checkmark2"></span>
            </button> 
        </div>
                        
        <div class="modal fade" id="modal-buscar">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">Productos</h4>
                    </div>
                    <div class="modal-body">
                        <div id="modalProductos">

                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>                        
                    </div>
                </div>
            </div>
        </div>
      
    <div class="modal fade" id="modal-terminaCompra">
	<div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Verifique los datos de la compra</h4>
                </div>
                <div class="modal-body">
                    <div id="modalTerminaCompra"> </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                    <button type="button" id="btnTerminaModal" onclick="$('#btnTerminaModal').attr('disabled','disabled'); terminaCompraFinal();" class="btn btn-primary">Guardar compra</button>
                </div>
            </div>
	</div>
    </div>
                        
    <div class="modal fade" id="modal-msj">
	<div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Mensaje</h4>
                </div>
                <div class="modal-body">
                    <div id="modalMsj"></div>
                </div>
                <div class="modal-footer">
                    <button type="button" id="btnOk" class="btn btn-default" onclick="window.location.href='compras.jsp'" data-dismiss="modal">OK</button>                   
                </div>
            </div>
	</div>
    </div>
        
        <div id="footer">
            <div class="container">
                <br>
               
            </div>
        </div>
        
        <script type="text/javascript" src="../js/jquery.js"></script>        
        <script type="text/javascript" src="../js/angular.min.js"></script>        
        <script type="text/javascript" src ="../js/bootstrap.min.js"></script>
        <script type="text/javascript" src ="../js/jquery.validate.min.js"></script>
        <script type="text/javascript" src="../js/filtroTabla.js"></script>
        <script type="text/javascript" src = "../js/puntoDeVenta.js"></script>
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
                                $("#terminaCompraBtn").removeAttr("disabled");
                            }
                            else{                                                             
                                if(res.error !== undefined){
                                   var mensaje = "<div id='mensaje' class='col-md-12 animated slideInRight'> "
                                    + "<div class='alert alert-danger' role='alert'>"
                                    + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                                    + "<span aria-hidden='true'> &times;</span></button>"
                                    + ""+res.error
                                    + "</div></div>";
                                    $("#msj").html(mensaje);
                                    showMsj('msj');
                                    $("#formulario").reset();                                                   
                            }
                        }
                        },"json");
                    },                
                    rules: {  
                        codigo:  {required: true, digits: true, remote: {url: "validaCodigo.jsp", data:{ idProveedor:function(){ return $("#proveedor").val(); }}, type: "get"}},  
                        cantidad: {required: true, digits: true}
                    },  
                    messages: {  
                        codigo:   {           
                            remote:   "El codigo no existe y/o no pertenece al proveedor." 
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
                    input.eq(1).attr("name","codigo"+(i-1));
                    input.eq(2).attr("name","producto"+(i-1));
                    input.eq(3).attr("name","importe"+(i-1));
                    filas.eq(i).attr("id","f"+(i-1));
                    btnEliminar.eq(i-1).attr("onclick","$(\"#f"+(i-1)+"\").remove(); renombraFilas();");           
                }
                numFilas = filas.length-1;
                $("#inputFilas2").val(numFilas);
                $("#inputFilas").val(numFilas);
                if(numFilas === 0){
                    $("#terminaCompraBtn").attr("disabled","disabled");
                }
            }
            
            function comienzaCompra(){
                $.post("tablaProductos.jsp",{idProveedor: $("#proveedor").val()}, function(res){
                if(res.tabla  !== undefined){
                    $("#modalProductos").html(res.tabla);
                    $('#tabla').DataTable({paging: false, bInfo: false});
                }
                },"json");
                $("#proveedor").attr("disabled","disabled");
                $("#comienzaCompraBtn").attr("disabled","disabled");
                $("#codigo").removeAttr("disabled");
                $("#cantidad").removeAttr("disabled");
                $("#importe").removeAttr("disabled");
                $("#btnSearch").removeAttr("disabled");
                $("#agregaProductoBtn").removeAttr("disabled");
                $("#idProveedor").val($("#proveedor").val());
                foco("codigo");
                
            }
            
            function chechaProveedor(){
                if($("#proveedor").val() !== "--- Elegir proveedor ---"){
                    $("#comienzaCompraBtn").removeAttr("disabled");
                }
                else{
                    $("#comienzaCompraBtn").attr("disabled","disabled");
                }
            }
            
            function seleccionProducto(codigo){
                $("#modal-buscar").modal('toggle');
                $("#codigo").val(codigo);
                foco("cantidad");
            }
            
            function terminaCompra(){
                $.post("acomodaCompra.jsp",$("#formularioTabla").serialize(),function (res){
                    if(res.tabla !== undefined){ 
                        $("#modalTerminaCompra").html(res.tabla); 
                        foco("folioNota");
                    }
                },"json");
            }
            
            function terminaCompraFinal(){
                $.post("terminaCompra.jsp",$("#formTerminaCompra").serialize(), function(res){
                    if(res.exito !== undefined){
                        $("#modal-terminaCompra").modal("toggle");
                        $("#modalMsj").html("<h3>"+res.exito+"</h3>");
                        $("#modal-msj").modal("show");
                        foco("btnOk");
                        var delay=4000;   
                        setTimeout(function(){                    
                            window.location.href='compras.jsp';
                        }, delay); 
                    }
                    else if(res.error !== undefined){
                       $("#modal-terminaCompra").modal("toggle");
                       $("#modalMsj").html("<h3>"+res.error+"</h3>");
                       $("#modal-msj").modal("show");
                    }
                },"json");
            }
        </script>
        
        
    </body>
</html>

<%
    }
%>