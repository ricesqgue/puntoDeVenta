<%-- 
    Document   : detalleAbono
    Created on : 10/12/2015, 08:27:53 PM
    Author     : ricesqgue
--%>

<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"/>
<%@page import="org.json.simple.JSONObject"%>

<%
    JSONObject json = new JSONObject();
    String idAbono = request.getParameter("id");
    String query = "select c.idCompratotal, c.folionota, concat('$',round(a.cantidad,2)) from abono a inner join compratotal c on a.idcompratotal = c.idcompratotal where a.idabono = "+idAbono+";";
    //String query = "call test();";
    objConn.Consult(query);
    int n = 0;
    try {
        if (objConn.rs != null) {
            objConn.rs.last();
            n = objConn.rs.getRow();
            objConn.rs.first();
        }
    } catch (Exception e) {
    }
    if (n > 0) {
        String tabla = "<div class='table-responsive datagrid '>"
                + "<table id='tablaDetalles' class='table table-striped table-bordered'>"
                + "<thead>"
                + "<tr class='success' >"
                + "<th>Folio</th>"
                + "<th>Folio nota</th>"
                + "<th>Cantidad</th>"
                + "</tr>"
                + "</thead>"
                + "<tbody>";
        for (int i = 0; i < n; i++) {
            tabla += "<tr id='row" + objConn.rs.getString(1) + "'>";
            for (int j = 1; j < 4; j++) {
                tabla += "<td>" + objConn.rs.getString(j) + "</td>";
            }            
            tabla += "</tr>";
            objConn.rs.next();
        }
        tabla += "</tbody>"
                + "</table>"
                + "</div>";
        json.put("exito", tabla);

    } else {
        json.put("error", "<div id='mensaje' class=' animated slideInRight'> "
                + "<div class='alert alert-warning' role='alert'>"
                + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                + "<span aria-hidden='true'> &times;</span></button>"
                + "<strong>No se encontraron resultados.</strong>"
                + "</div></div>");
    }
    objConn.desConnect();
    out.print(json);
    out.flush();

%>