/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package configpackage;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectOutputStream;
/**
 *
 * @author ricesqgue
 */
public class ConfigWrite {
    private FileOutputStream file;
    private ObjectOutputStream output;

    public ConfigWrite() {
    }
    
    
    
    public void abrir(String ruta) throws IOException{
        File archivo = new File(ruta);
        if(!archivo.exists()) {
            archivo.createNewFile();
        } 
        file = new FileOutputStream(archivo,false);        
        output = new ObjectOutputStream(file);
    }
    
    public void cerrar() throws IOException{
        if(output!=null)
            output.close();
    }
    
    public void escribir(Config con) throws IOException{
        if(output != null){
            this.output.writeObject(con);
        }
    }    
}
