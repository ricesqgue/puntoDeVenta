<%-- 
    Document   : abonoProveedor
    Created on : 24/11/2015, 11:30:26 AM
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
                <h1>Pago a proveedores</h1>
            </div>
	</div>
                        
        <div class="container">  
            <div class="form-inline">
                <div class="form-group">
                    <label class="control-label" for="proveedor">Proveedor </label>
                        <%
                        objConn.Consult("select idProveedor,concat_ws(' ',nombre,apellidoPaterno,apellidoMaterno) as nombre from proveedor where activo = 1 order by nombre;");
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
                        <select class="form-control" id="proveedor"  name="proveedor" onchange="activaBtnBusca();">
                            <option value="--- Elegir proveedor ---" selected>--- Elegir proveedor ---</option>
                            <%
                            for(int i=0; i<n; i++){
                            %>
                                <option value="<%=objConn.rs.getString(1)%>"><%=objConn.rs.getString(2)%></option>
                            <%                                
                                objConn.rs.next();
                            }
                            %>
                        </select>
                        <%                        
                        }
                        else{
                        %>
                        <select name="proveedor" id="proveedor">
                            <option value="--- Elegir proveedor ---" selected>--- Elegir proveedor ---</option>
                        </select>
                        <%
                        }
                        %>
                </div>                       

                <div class="form-group">                    
                    <button disabled="disabled" id="btnBusca" class="btn btn-info" onclick="$('#btnBusca').attr('disabled','disabled'); consultaDeudas();"><span class="icon-search"></span></button>
                </div>                                
            </div>
            <br>
            
            <div class="row" id="contenido"></div>            
            
            <div id="divFormAbonar"></div>
            
            <div class='row' id='contenidoAbonar'></div><br><br>
            
            <div class="row" id='barraProgreso'></div>
            
            <div class="row" id="msj"></div>
            <br>
            <br>
            
        </div>
              
        <div class="modal fade" id="modal-detalle">
            <div class="modal-dialog">
		<div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h3 class="modal-title">Detalle de compra</h3>
                    </div>
                    <div class="modal-body" id="detalle">
	    		
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" data-dismiss="modal">Cerrar</button>
                    </div>
		</div>
            </div>
        </div>
                
        <div class="modal fade" id="modal-confirmaAbono">
            <div class="modal-dialog">
		<div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h3 class="modal-title">Abono</h3>
                    </div>
                    <div class="modal-body" id="detalle">
                        <h4 id="msjConfirmar"></h4>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Cancelar</button>
                        <button type="button" class="btn btn-success" onclick='realizaAbono()' data-dismiss="modal">Continuar</button>
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
            function activaBtnBusca(){         
                var proveedor = $("#proveedor").val();
                if(proveedor !== "--- Elegir proveedor ---"){
                    $("#btnBusca").removeAttr('disabled');
                }else{
                    $("#btnBusca").attr('disabled','disabled');
                }
            }
            
            function consultaDeudas(){
                $("#barraProgreso").html("<div class='col-md-4 col-md-offset-4'>"
                    +"<div class='progress'>"
                    +"<div class='progress-bar  progress-bar-striped active' role='progressbar'"
                    +" aria-valuenow='100' aria-valuemin='0' aria-valuemax='100' style='width:100%'>"
                    +" Cargando..."
                    +"</div>"
                    +"</div>"
                    +"</div>");
                var proveedor = $("#proveedor").val();
                if(proveedor !== "--- Elegir proveedor ---"){
                    $.post("listaDeudas.jsp",{proveedor: proveedor}, function(res){
                        if(res.tabla !== undefined){
                            $("#contenido").html(res.tabla);
                            $("#divFormAbonar").html(res.form);
                            $("#contenidoAbonar").html(res.tablaAbonar);
                            $("#contenidoAbonar").hide();
                            $('#tablaDeudas').DataTable({paging:false,bInfo: false,bFilter: false});
                            $('#tablaAbonos').DataTable({paging:false,bInfo: false,bFilter: false});
                            $("#mensaje").html("");
                            bloqueaForm("formTablaAbonar");    
                            bloqueaForm("formAbonar");
                            $("#barraProgreso").html("");
                        }
                        else if(res.error !== undefined){
                            $("#barraProgreso").html("");
                            $("#divFormAbonar").html("");
                            $("#contenido").html("");
                            $("#msj").html(res.error);
                            
                        }
                    },"json");
                    
                }else{
                    $("#msj").html("<div id='mensaje' class='col-sm-4 col-sm-offset-4 animated slideInRight'> "
                        + "<div class='alert alert-danger' role='alert'>"
                        + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                        + "<span aria-hidden='true'> &times;</span></button>"
                        + "<strong>Error.</strong> Introduce un proveedor válido."
                        + "</div></div>");
                }
            }
            
            function detalleCompra(id){
                $.post("detalleCompra.jsp",{id: id}, function(res){
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
            
            function cantidadAbonar(){
                var cantidad = Math.round($("#cantidad").val()*100)/100;
                var deuda = $("#totalDeuda").html();
                if(isNaN(cantidad) || cantidad === "" || cantidad <= 0){
                    $("#msj").html("<div id='mensaje' class='col-sm-4 col-sm-offset-4 animated slideInRight'> "
                            + "<div class='alert alert-danger' role='alert'>"
                            + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                            + "<span aria-hidden='true'> &times;</span></button>"
                            + "<strong>Error.</strong> Ingrese una cantidad válida."
                            + "</div></div>");
                }else if(cantidad > deuda){
                     $("#msj").html("<div id='mensaje' class='col-sm-4 col-sm-offset-4 animated slideInRight'> "
                            + "<div class='alert alert-danger' role='alert'>"
                            + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                            + "<span aria-hidden='true'> &times;</span></button>"
                            + "<strong>Error.</strong> No puedes abonar más de $"+deuda 
                            + "</div></div>");
                }
                else{
                    var cantidadRestante = cantidad;
                    $("#msj").html("");
                    $("#proveedor").attr('disabled','disabled');
                    $("#contenido").hide("fast");
                    $("#divFormAbonar").hide("fast");
                    $("#contenidoAbonar").show("fast");
                    $("#abono").html(cantidadRestante);
                }
            }
            
            function abona(i){
                var a,d,abono;
                //a = Cantidad a abonar.
                //d = Deuda
                //abono = abono general
                a = parseFloat($("#a"+i).val());                
                a = Math.round(a*100)/100;
                d = parseFloat($("#d"+i).html());
                d = Math.round(d*100)/100;
                abono = parseFloat($("#abono").html());                                
                abono = Math.round(abono*100)/100;
               
                if($("#c"+i).is(':checked')) {
                    //Activo la casilla                  
                    abono = Math.round((abono + a)*100)/100;                    
                    a = 0;
                    if(abono === 0){
                        $("#msj").html("<div id='mensaje' class='col-sm-4 col-sm-offset-4 animated slideInRight'> "
                            + "<div class='alert alert-danger' role='alert'>"
                            + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                            + "<span aria-hidden='true'> &times;</span></button>"
                            + "<strong>Error.</strong> No hay cantidad a abonar."
                            + "</div></div>");
                        $("#c"+i).attr("checked",false);
                        a = 0;                      
                    }
                    else{
                        if(abono<d){                            
                            a = abono;                            
                            abono = Math.round((abono - a)*100)/100;                            
                        }
                        else{                            
                            a = d;                            
                            abono = Math.round((abono - a)*100)/100;
                            $("#tr"+i).attr("style"," background-color: rgba(122, 211, 107, 0.5)");
                        }
                        if(abono === 0){
                            $("#btnAbonar").removeAttr('disabled');
                        }
                        else{
                            $("#btnAbonar").attr("disabled","disabled");
                        }
                    }
                }
                else{
                    //Desactivo la casilla
                    abono = Math.round((abono + a)*100)/100;
                    a = 0;
                    $("#tr"+i).removeAttr("style");
                    if(abono === 0){
                        $("#btnAbonar").removeAttr("disabled");
                    }
                    else{
                        $("#btnAbonar").attr("disabled","disabled");
                    }
                }   
                
                $("#a"+i).val(a);
                $("#abono").html(abono);
            }
            
            function borraCantidad(i){
                var a = parseFloat($("#a"+i).val());
                a = Math.round(a*100)/100;
                var abono = parseFloat($("#abono").html());
                abono = Math.round(abono*100)/100;
                abono = Math.round((abono + a)*100)/100;
                a = 0;                
                $("#a"+i).val(a);
                $("#abono").html(abono);
                $("#tr"+i).removeAttr("style");
                $("#c"+i).attr("checked",false);
                $("#a"+i).select();
                if(abono === 0){
                    $("#btnAbonar").removeAttr("disabled");
                }
                else{
                    $("#btnAbonar").attr("disabled","disabled");
                }
                return 0;
            }
            
            function checaCantidad(i){
                var a,d,abono;
                a = parseFloat($("#a"+i).val());
                a = Math.round(a*100)/100;
                d = parseFloat($("#d"+i).html());
                d = Math.round(d*100)/100;
                abono = parseFloat($("#abono").html());
                abono = Math.round(abono*100)/100;
                if(abono === 0){
                    $("#msj").html("<div id='mensaje' class='col-sm-4 col-sm-offset-4 animated slideInRight'> "
                            + "<div class='alert alert-danger' role='alert'>"
                            + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                            + "<span aria-hidden='true'> &times;</span></button>"
                            + "<strong>Error.</strong> No hay cantidad a abonar."
                            + "</div></div>");
                    a = 0;
                }
                else{
                    if(isNaN(a) || a < 0 || a > d){
                        a = 0;
                    }
                    else{
                        if(a > abono){
                            $("#msj").html("<div id='mensaje' class='col-sm-4 col-sm-offset-4 animated slideInRight'> "
                            + "<div class='alert alert-danger' role='alert'>"
                            + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                            + "<span aria-hidden='true'> &times;</span></button>"
                            + "<strong>Error.</strong> No se completa la cantidad."
                            + "</div></div>");
                            a = 0;
                        }else{
                            abono = abono - a;
                            if(a === d){
                                $("#tr"+i).attr("style"," background-color: rgba(122, 211, 107, 0.5)");
                            }
                        }
                        
                        if(abono === 0){
                            $("#btnAbonar").removeAttr("disabled");
                        }
                        else{
                            $("#btnAbonar").attr("disabled","disabled");
                        }                      
                    }
                    $("#a"+i).val(a);
                    $("#abono").html(Math.round(abono*100)/100);
                }                
            }
            
            function regresarAContenido(){
                $("#msj").html("");
                $("#contenidoAbonar").hide("fast");
                var inputsCantidad = $("#contenidoAbonar").find("input");
                var tr = $("#contenidoAbonar").find("tr");
                for(var i = 0; i<inputsCantidad.length; i++){
                    if((i%2) === 0){
                        inputsCantidad.eq(i).val("0");
                    }
                    else{
                        inputsCantidad.eq(i).attr("checked",false);
                    }
                    tr.eq(i).removeAttr("style");
                }
                $("#contenido").show("slow");
                $("#divFormAbonar").show("slow");
                $("#cantidad").val("");
                $("#proveedor").removeAttr("disabled");
            }
            
            function confirmaAbono(){
                $("#msjConfirmar").html("Se abonarán $"+$("#cantidad").val()+ " al proveedor "+ $("#proveedor option:selected").html()
                +"<br><br>¿Desea continuar?");
                $("#modal-confirmaAbono").modal("toggle");
            }
            
            function realizaAbono(){
                $.post("abonar.jsp",$("#formTablaAbonar").serialize(),function (res){
                    regresarAContenido();
                    consultaDeudas();
                    $("#contenido").html("");
                    $("#divFormAbonar").html("");
                    if(res.error !== undefined){
                        $("#msj").html(res.error);
                    }else{
                         $("#msj").html(res.exito);
                    }
                },"json");
            }
            
        </script>
    </body>
</html>
<%
    }
%>