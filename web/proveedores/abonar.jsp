<%-- 
    Document   : abonar
    Created on : 26/11/2015, 01:46:55 AM
    Author     : ricesqgue
--%>

<jsp:useBean id="objConn" class="mysqlpackage.MySqlConn"/>
<%@page import="org.json.simple.JSONObject"%>

<%    
    JSONObject json = new JSONObject(); 
    HttpSession sesion = request.getSession();
    String idUsuario = ""+sesion.getAttribute("idUsuario");                       
    String query = "select idAbono from abono order by idAbono desc limit 1;";
    objConn.Consult(query);
    int n = 0;
    int idAbono = 0;
    try{
        idAbono = objConn.rs.getInt(1);
        idAbono++;
    }catch(Exception e){
        idAbono = 1;
    }
    n = Integer.parseInt(request.getParameter("numFilas"));  
    System.out.print("Num filas: " + n); 
    for (int i=0;i<=n;i++){
        if( !request.getParameter("a"+i).equals("0")){ 
            query = "insert into abono values("+idAbono+","+ request.getParameter("idCompraTotal"+i) +",round("+request.getParameter("a"+i)+",2),now(),"+idUsuario+");";            
            if(objConn.Update(query)!=1){                
                objConn.Update("delete from abono where idabono = " + idAbono+";");
                i=n+2;//Para terminar el for
                json.put("error", "<div id='mensaje' class='col-sm-4 col-sm-offset-4 animated slideInRight'> "
                    + "<div class='alert alert-danger' role='alert'>"
                    + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                    + "<span aria-hidden='true'> &times;</span></button>"
                    + "<strong>Error.</strong> No se pudo realizar el abono." 
                    + "</div></div>");
            }
        }
    }
    json.put("exito","<div id='mensaje' class='col-sm-4 col-sm-offset-4 animated slideInRight'> "
                    + "<div class='alert alert-success' role='alert'>"
                    + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
                    + "<span aria-hidden='true'> &times;</span></button>"
                    + "<strong>Éxito.</strong> Abono realizado correctamente." 
                    + "</div></div>");
    objConn.desConnect();
    out.print(json);
    out.flush();       
   %>   
       