<%-- 
    Document   : index
    Created on : 3/06/2015, 11:20:41 AM
    Author     : Ricardo
--%>

<%@page import="java.io.InputStream"%>
<%@page import="java.util.Properties"%>
<%@page import="java.net.URL"%>
<jsp:useBean id="conf" class="configpackage.Config"/>
<%   
    HttpSession sesion = request.getSession();
    if(sesion.getAttribute("nombre")!=null){
        response.sendRedirect("puntoDeVenta.jsp"); 
    }
    conf.setRuta(request);
    conf.carga(); 
    String nombreEmpresa = conf.getNombreEmpresa();
    String tema = conf.getTema();
    

%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Punto de venta</title>
        <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
	<link rel="stylesheet" href="/puntoDeVenta/css/<%=tema%>">
	<link rel="stylesheet" href="/puntoDeVenta/css/puntoDeVenta.css">
	<link rel="stylesheet" href="/puntoDeVenta/css/icons.css">
        <link rel="stylesheet" href="/puntoDeVenta/css/animate.css">
        <link rel="stylesheet" href="/puntoDeVentacss/jquery-ui.min.css">
        <title><%=nombreEmpresa %></title>   
    </head>
    <body>
        <header>
            <nav class="navbar navbar-inverse navbar-static-top" role="navigation"> 
                <div class="container"> 
                    <div class="navbar-header">
                        <span class="navbar-brand">Punto de venta</span>
                    </div>
                    <!--Inicia Menu-->
                </div>
            </nav>
        </header>	
        <br><br><br>
        <div class="container" id="wrap">
            <div class="row">
                <form class="form-group" id="formulario" method="post" autocomplete="off"> 
                    <div class="col-md-6 col-md-offset-3 bordeado">
                        <div class="jumbotron titleInicioSesion">                           
                            <h3>Inicio de sesión</h3>                           
                        </div>
                        <label for="usuario">Usuario</label>
                        <div class="input-group">
                            <input class="form-control" type="text" name="usuario" id="usuario">
                            <span class="input-group-addon icon-user"></span>
                        </div>
                        <br>
                        <label for="password">Contraseña</label>
                        <div class="input-group">
                            <input class ="form-control" type="password" id="password" name="password">
                            <span class="input-group-addon icon-key"></span>
                        </div>
                        <br>
                        <button class="btn btn-success" type="button" onclick="enviaFormulario()" id="boton">Entrar</button>
                    </div>
                </form>
            </div>
            <div id="mensaje"></div>
        </div>        
        <div id="footer">
            <div class="container">
                <p class="text-muted credit"> </p>
            </div>
        </div>




        <script type="text/javascript" src="js/jquery.js"></script>
        <script type="text/javascript" src="js/jquery.validate.min.js"></script>
        <script type="text/javascript" src ="js/bootstrap.min.js"></script>
        <script type="text/javascript">
            function enviaFormulario(){                
                $.post("checkLogin.jsp",$("#formulario").serialize(),function(res){                    
                if(res.respuesta === "1"){
                    window.location.href="puntoDeVenta.jsp";
                }
                else{
                    document.getElementById("mensaje").innerHTML = res.respuesta;
                }
                },"json");
            }                   
        </script>
    </body>
</html>