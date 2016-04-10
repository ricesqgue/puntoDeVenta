/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package configpackage;

import java.io.EOFException;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.ObjectInputStream;

/**
 *
 * @author ricesqgue
 */
public class ConfigRead {
    private FileInputStream file;
    private ObjectInputStream input;

    public ConfigRead() {
         
    }
            
    public void abrir(String ruta) throws IOException{
        file = new FileInputStream(ruta);
        input = new ObjectInputStream(file); 
    }
    public void cerrar() throws IOException{
        if(input!=null)
            input.close();
    }
    
    public Config leer() throws IOException, ClassNotFoundException{
        Config con = null;        
        if (input!=null){
            try{
               con=(Config) input.readObject();
            }catch(EOFException eof){
                //fin
            }
        }
        return con;
    }    
}
