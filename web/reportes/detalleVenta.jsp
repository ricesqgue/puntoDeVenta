<%-- 
    Document   : detalleVenta
    Created on : 4/12/2015, 11:48:40 PM
    Author     : ricesqgue
--%>

<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"/>
<%@page import="org.json.simple.JSONObject"%>

<%
    JSONObject json = new JSONObject();
    String idVentaTotal = request.getParameter("id");
    String query = "select p.codigo, p.descripcion, m.marca, c.categoria, cp.cantidad, concat('$',round(cp.precioU * cp.cantidad,2)) from ventaproducto cp natural join producto p natural join marcas m natural join categorias c where p.activo = 1 and cp.idventatotal = " + idVentaTotal + ";";
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
                + "<th>Código</th>"
                + "<th>Producto</th>"
                + "<th>Marca</th>"
                + "<th>Categoría</th>"
                + "<th>Cantidad</th>"
                + "<th>Total</th>"
                + "</tr>"
                + "</thead>"
                + "<tbody>";
        for (int i = 0; i < n; i++) {
            tabla += "<tr id='row" + objConn.rs.getString(1) + "'>";
            for (int j = 1; j < 7; j++) {
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