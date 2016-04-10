<%-- 
    Document   : cargaMunicipios
    Created on : 12/11/2015, 11:48:57 AM
    Author     : ricesqgue
--%>

<%@page import="org.json.simple.JSONObject" %>
<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"></jsp:useBean>

<%
 JSONObject json = new JSONObject(); 
 String estado = request.getParameter("estado");
 objConn.Consult("select municipio from municipios natural join estados where estado = '"+estado+"' order by municipio;");
 int n = 0;
 objConn.rs.last();
 n = objConn.rs.getRow();
 objConn.rs.first();
 String opciones = "";
 for(int i=0; i<n; i++){
     opciones += "<option value='"+objConn.rs.getString(1) +"'>"+objConn.rs.getString(1)+"</option>";
     objConn.rs.next();
 }
 json.put("opciones", opciones);
 objConn.desConnect();
 out.print(json);
 out.flush();
%>