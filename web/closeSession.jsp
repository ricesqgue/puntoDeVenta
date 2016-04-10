<%-- 
    Document   : closeSession
    Created on : 3/06/2015, 12:42:39 PM
    Author     : Ricardo
--%>

<%
    HttpSession sesion = request.getSession();
    if(sesion.getAttribute("nombre")==null){
        response.sendRedirect("index.jsp"); 
    }
    sesion.removeAttribute("nombre");
    sesion.invalidate();
    response.sendRedirect("index.jsp");
    
%>