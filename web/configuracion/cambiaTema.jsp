<%-- 
    Document   : cambiaTema
    Created on : 7/12/2015, 12:58:46 AM
    Author     : ricesqgue
--%>

<%@page import="org.json.simple.JSONObject"%>
<jsp:useBean id="conf" class="configpackage.Config"/>
<jsp:useBean id="confWrite" class="configpackage.ConfigWrite"/> 
<%        
    JSONObject json = new JSONObject();
    String tema = request.getParameter("tema");
    try{
        conf.setRuta(request);
        conf.carga();         
        conf.setTema(tema);        
        confWrite.abrir(conf.getRuta());
        confWrite.escribir(conf);
        confWrite.cerrar();
        json.put("exito", "exito");
    }catch(Exception e){
        System.out.print(e.getCause());
        json.put("error", "<br><div class='row animated slideInLeft'> <div class='col-md-4 col-md-offset-3'>"
                + "<div class='alert alert-danger' role='alert'>"
                + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                + "<span aria-hidden='true'>&times;</span></button>"
                + "<strong>Error. </strong> No se pudo cambiar el tema."
                + "</div></div></div>" );          
    }    
    out.print(json);
    out.flush();
    
    
%>