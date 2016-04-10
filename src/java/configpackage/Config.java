/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package configpackage;
import java.io.IOException;
import java.io.Serializable;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import org.jboss.weld.context.http.HttpRequestContext;

/**
 *
 * @author ricesqgue
 */
public class Config implements Serializable{
    private String tema;
    private String nombreProyecto;
    private String nombreEmpresa;
    private String ruta;

    public String getRuta() {
        return ruta;
    }

    public void setRuta(HttpServletRequest request) {
        String relativePath = "/index.jsp";
        ServletContext sc = request.getServletContext();
        String realPath = sc.getRealPath(relativePath);
        String [] rutaArray = realPath.split("/"); 
        this. ruta = "";
        for(int i =0; i< rutaArray.length-3;i++){
            this.ruta += (rutaArray[i]+"/");
        }
        this.ruta += "puntoDeVenta.config";   
        
    }

    
    public Config (){
        
    }    
    
    public String getTema() {
        return tema;
    }

    public void setTema(String tema) {
        this.tema = tema;
    }

    public String getNombreProyecto() {
        return nombreProyecto;
    }

    public void setNombreProyecto(String nombreProyecto) {
        this.nombreProyecto = nombreProyecto;
    }

    public String getNombreEmpresa() {
        return nombreEmpresa;
    }

    public void setNombreEmpresa(String nombreEmpresa) {
        this.nombreEmpresa = nombreEmpresa;
    }

    
    public void carga(){
        ConfigRead read = new ConfigRead();
        try{   
            read.abrir(this.ruta);
            Config aux = read.leer();
            this.tema = aux.getTema();
            this.nombreEmpresa = aux.getNombreEmpresa();
            this.nombreProyecto  = aux.getNombreProyecto();
            read.cerrar();
            System.out.println(ruta);
        }catch(Exception e){
            Config aux = new Config();
            aux.setNombreEmpresa("Punto de venta");
            aux.setNombreProyecto("Punto de venta");
            aux.setTema("Classic/bootstrap.min.css");
            ConfigWrite write = new ConfigWrite();
            try{
                write.abrir(this.ruta);
                write.escribir(aux);
                write.cerrar();
            }catch(Exception r){}
        }
    }
}
    
    
