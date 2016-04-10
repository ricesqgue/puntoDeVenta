/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */ 


function foco (id){
    document.getElementById(id).focus();
}

function enter (tecla){
    if(tecla === 13){
        return true;
    }
    return false;
}

function checaCambio(){
    var total = $("#total").val();
    var recibida = $("#cantidadRecibida").val();
    recibida = parseFloat(recibida); 
    if($.isNumeric(recibida)){
        if(recibida>=total){
            var cambio = recibida-total;
            $("#cambio").val(cambio);
             document.getElementById("btnTermina").disabled = false;
              document.getElementById("btnTarjeta").disabled = true;
             return true;
        }
        else{
            document.getElementById("btnTarjeta").disabled = false;
            document.getElementById("btnTermina").disabled = true;
            return false;
        }
    }
    else{
        document.getElementById("btnTermina").disabled = true;
        return false;
    }
}

function desactivaTerminaVenta(){
    document.getElementById("btnTermina").disabled = true;
}
            
function descuenta (total){
    if(isNaN($("#descuento").val())){
        $("#descuento").val("0");
    }
    if($("#descuento").val()>total){
        $("#descuento").val("0");
        foco("descuento");
        var mensaje = "<div id='mensaje' class='col-md-12 animated slideInRight'> "
            + "<div class='alert alert-danger' role='alert'>"
            + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>"
            + "<span aria-hidden='true'> &times;</span></button>"
            + "<strong>Error.</strong> Descuento no v&aacute;lido."
            + "</div></div>";
    $("#msj").html(mensaje);
    }else{
        var totalFinal = total - $("#descuento").val();
        $("#total").val(totalFinal);
        $("#cantidadRecibida").attr("min", totalFinal);
    }
}

function catalogoModificarProducto(codigo){
    $("#codigo").attr("value",codigo);
    $("#formulario").submit();
} 

function catalogoModificarProveedor(proveedor){
    $("#proveedor").attr("value",proveedor);
    $("#formulario").submit();
} 

//Funciones para mostrar y ocultar el mensaje de producto sin existencias.
function showMsj (){
    $("#msj").show("");
    
 }
 
 function hideMsj (){
     $("#msj").hide("slow");

 }
 
 function bloqueaForm(form){
     $("#"+form).keypress(function(e) {
        if (e.which === 13) {
            return false;
        }
    });
 }

//Resetear formularios
 jQuery.fn.reset = function () {
  $(this).each (function() { this.reset(); });
};


//Validar formato de fecha YYYY/MM/DD
function isDate(txtDate)
{
    var currVal = txtDate;
    if(currVal === '')
        return false;

    var rxDatePattern = /^(\d{1,2})(\/|-)(\d{1,2})(\/|-)(\d{4})$/; //Declare Regex
    var dtArray = currVal.match(rxDatePattern); // is format OK?

    if (dtArray === null) 
        return false;

    //Checks for mm/dd/yyyy format.
    dtMonth = dtArray[1];
    dtDay= dtArray[3];
    dtYear = dtArray[5];        

    if (dtMonth < 1 || dtMonth > 12) 
        return false;
    else if (dtDay < 1 || dtDay> 31) 
        return false;
    else if ((dtMonth===4 || dtMonth===6 || dtMonth===9 || dtMonth===11) && dtDay===31) 
        return false;
    else if (dtMonth === 2) 
    {
        var isleap = (dtYear % 4 === 0 && (dtYear % 100 !== 0 || dtYear % 400 === 0));
        if (dtDay> 29 || (dtDay ===29 && !isleap)) 
                return false;
    }
    return true;
}
// ****************************---------------------empieza lo perronononnn----------------****************************************************************
    var app=angular.module('puntoDeVenta',[]);    
    app.directive("navbarPrincipal",function(){
       return{
           restrict:'E',
           templateUrl:'/puntoDeVenta/navbar-principal.html',
           controller: function(){
               
           },
           controllerAs:"menu"           
       };
    });

// ****************************-------------------------ANGULAR JS----------------****************************************************************
   