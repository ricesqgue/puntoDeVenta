<%-- 
    Document   : configuracion
    Created on : 7/12/2015, 12:11:01 AM
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
	<link rel="stylesheet" href="/puntoDeVenta/css/puntoDeVenta.css">
	<link rel="stylesheet" href="/puntoDeVenta/css/icons.css">
        <link rel="stylesheet" href="/puntoDeVenta/css/animate.css">
        <link rel="stylesheet" href="/puntoDeVentacss/jquery-ui.min.css">
        <title><%=nombreEmpresa %></title>
    </head>
    <body>
    <navbar-principal ng-init="menu.usuario='<%=sesion.getAttribute("nombre")%>'"></navbar-principal>
	<div class="jumbotron">
            <div class="container">
                <h1>Configuración</h1>
            </div>
	</div>
	
       <div class="container">                         
            <div class="row">
                <div class="col-md-6 col-md-offset-3">
                    <hr>
                    <center>
                        <h2>
                            <span class="icon-paint-format"> Tema </span><span id="totalVentas"></span>
                        </h2>
                        <br>
                        <select class="selectpicker form-control" name="tema" id="tema" onchange='checaTema()'>
                            <optgroup label="Tema actual">
                                <option value='<%=tema%>'><%=tema.split("/")[0]%></option>
                            </optgroup>
                            <optgroup label="Temas">
                                <option value="Cerulean/bootstrap.min.css">Cerulean</option>
                                <option value="Classic/bootstrap.min.css">Classic</option>
                                <option value="Cosmo/bootstrap.min.css">Cosmo</option>
                                <option value="Cyborg/bootstrap.min.css">Cyborg</option>
                                <option value="Darkly/bootstrap.min.css">Darkly</option>
                                <option value="Flatly/bootstrap.min.css">Flatly</option>
                                <option value="Journal/bootstrap.min.css">Journal</option>
                                <option value="Lumen/bootstrap.min.css">Lumen</option>
                                <option value="Paper/bootstrap.min.css">Paper</option>
                                <option value="Readable/bootstrap.min.css">Readable</option>
                                <option value="Sandstone/bootstrap.min.css">Sandstone</option>
                                <option value="Simplex/bootstrap.min.css">Simplex</option>
                                <option value="Slate/bootstrap.min.css">Slate</option>
                                <option value="Spacelab/bootstrap.min.css">Spacelab</option>
                                <option value="SuperHero/bootstrap.min.css">SuperHero</option>
                                <option value="United/bootstrap.min.css">United</option>
                                <option value="Yeti/bootstrap.min.css">Yeti</option>
                            </optgroup>
                        </select>
                        <br>
                        <br>
                        <button class="btn btn-primary" type="button" id="btnTema" disabled='disabled'  onclick="cambiaTema()">Aplicar</button>
                    </center>
                    <hr>
                </div>
            </div>                                         
                             
        </div>           
    
    
        <script type="text/javascript" src="/puntoDeVenta/js/jquery.js"></script>
        <script type="text/javascript" src="/puntoDeVenta/js/angular.min.js"></script>                
        <script type="text/javascript" src ="/puntoDeVenta/js/bootstrap.min.js"></script>
        <script type="text/javascript" src ="/puntoDeVenta/js/jquery.validate.min.js"></script>
        <script type="text/javascript" src = "/puntoDeVenta/js/puntoDeVenta.js"></script>
        <script>
            var tema = "<%=tema.split("/")[0]%>";
            function cambiaTema(){  
                $.post("cambiaTema.jsp",{tema : $("#tema").val()}, function (res){
                    if(res.exito !== undefined){
                        setTimeout(function (){
                            window.location.href="configuracion.jsp";
                        },100);
                    }
                    else if(res.error !== undefined){
                        alert(res.error);
                    }
                },"json");
            }       
            
            function checaTema(){
                if(tema === $("#tema").val()){
                    $("#btnTema").attr("disabled","disabled");                    
                }else{
                    $("#btnTema").removeAttr("disabled");
                }
            }
        </script>
    </body>
</html>
<%
    }
%>