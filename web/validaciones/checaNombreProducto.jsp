<%-- 
    Document   : checaNombreCarne
    Created on : 24/05/2015, 03:43:52 PM
    Author     : Ricardo
--%>
<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"></jsp:useBean>
<%
    /*****Sesion*****/

    /****************/
    String codigo = request.getParameter("codigo");
    String query = "select descripcion from producto where codigo = "+codigo+" and activo = 1;";
    objConn.Consult(query);
    int n = 0;
    String desc = "";
    try{
        objConn.rs.last();
        n = objConn.rs.getRow();
    }
    catch(Exception ex){}
    if(n>0){
       desc = objConn.rs.getString(1);
       String mensaje = "<br><div class='row animated slideInLeft'> <div class='col-md-4 col-md-offset-3'>"
                + "<div class='alert alert-info' role='alert'>"
                + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                + "<span aria-hidden='true'>&times;</span></button>"
                + "<strong>Producto:</strong> " + desc +" "
                + "</div></div></div>";     
        desc = mensaje;
    }
    
    out.print(desc);
    objConn.desConnect(); 
%>
