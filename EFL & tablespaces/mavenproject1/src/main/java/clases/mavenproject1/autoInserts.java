/*
    TRABAJO: Practica 2
    ASIGNATURA: Sistemas de Gestion de Bases de Datos
    AUTOR: Mario Ventura Burgos
    FECHA: 1-11-2023
*/

package clases.mavenproject1;
import java.util.Random;

public class autoInserts {
    // ---> ATRIBUTOS Y CONSTANTES
    private static final int NUM_INSERTS = 1500; // Numero de iteraciones que se haran
    private static final int NUM_INICIO = 1;    // Numero del cual se parte en las iteraciones
    private static int randomInteger;           // Para generar aleatorios
    private static final int MAX_ALEATORIO = 100;   // Numero maximo aleatorio

    
    // ---> METODOS 
    // Metodo main
    public static void main (String[] args) {
        // Llamadas a los metodos de generacion de inserts
        generate_inserts_aliment();
        System.out.println("");
        generate_inserts_proveidor();
        System.out.println("");
        generate_inserts_albara();
        System.out.println("");
        generate_inserts_linia_albara();
        System.out.println("");
        generate_inserts_venda();
    }

    // Generacion de inserts para aliment
    public static void generate_inserts_aliment() {
        System.out.println("INSERT INTO ALIMENT (REFERENCIA, NOM, PREU) VALUES");
        Random r = new Random();
        int i;
        
        // Generacion de los inserts
        for(i = NUM_INICIO; i<NUM_INSERTS; i++) {
            // Precio aleatorio
            randomInteger = r.nextInt(MAX_ALEATORIO)+1;
            // Impresion del insert
            System.out.println("('REF"+i+"', 'ALI"+i+"', "+randomInteger+"),");
        }
        // Precio aleatorio
        randomInteger = r.nextInt(MAX_ALEATORIO)+1;
        // Impresion del insert
        System.out.println("('REF"+i+"', 'ALI"+i+"', "+randomInteger+");");
    }
    
    // Para proveidor
    public static void generate_inserts_proveidor() {
        System.out.println("INSERT INTO PROVEIDOR (NIF, NOM) VALUES");
        int i;
        
        // Generacion de los inserts
        for(i = NUM_INICIO; i<NUM_INSERTS; i++) {
            // Impresion del insert
            System.out.println("('NIF"+i+"', 'Proveedor"+i+"'),");
        }
        // Impresion del insert
        System.out.println("('NIF"+i+"', 'Proveedor"+i+"');");
    }
    
    // Para albara
    public static void generate_inserts_albara() {
        System.out.println("INSERT INTO ALBARA (CODI, NIF_PRO, DATA, FACTURAT) VALUES");
        Random r = new Random();
        int i,randomDay,randomMonth;
        String facturat;
        
        // Generacion de los inserts
        for(i = NUM_INICIO; i<NUM_INSERTS; i++) {
            // random date
            randomDay = r.nextInt(28)+1;
            randomMonth = r.nextInt(12)+1;
            //facturat
            randomInteger = r.nextInt(100);
            if (randomInteger%2 == 0) {
                facturat = "S";
            } else {
                facturat = "N";
            }
            // Impresion del insert
            System.out.println("("+i+", 'NIF"+i+"', '2023-"+randomMonth+"-"+randomDay+"', '"+facturat+"'),");
        }
        // Precio aleatorio
        randomDay = r.nextInt(28)+1;
        randomMonth = r.nextInt(12)+1;
        //facturat
        randomInteger = r.nextInt(100);
        if (randomInteger%2 == 0) {
            facturat = "S";
        } else {
            facturat = "N";
        }
        // Impresion del insert
        System.out.println("("+i+", 'NIF"+i+"', '2023-"+randomMonth+"-"+randomDay+"', '"+facturat+"');");
    }
            
    // Para linia_albara
    public static void generate_inserts_linia_albara() {
        System.out.println("INSERT INTO LINIA_ALBARA (CODI_ALB, REFERENCIA, QUILOGRAMS, PREU) VALUES");
        Random r = new Random();
        int i,randomKG,randomPrice;
        
        for(i = NUM_INICIO; i<NUM_INSERTS; i++) {
            // Random KG
            randomKG = r.nextInt(100)+1;
            // Random price
            randomPrice = r.nextInt(50)+1;
            // Show insert
            System.out.println("("+i+", 'REF"+i+"', "+randomKG+", "+randomPrice+"),");
        }
        // Random KG
        randomKG = r.nextInt(100)+1;
        // Random price
        randomPrice = r.nextInt(50)+1;
        // Show insert
        System.out.println("(" + i + ", 'REF" + i + "', " + randomKG + ", " + randomPrice + ");");
    }
            
    // Para venda
    public static void generate_inserts_venda() {
        System.out.println("INSERT INTO VENDA (CODI, REFERENCIA, DATA, QUILOGRAMS, PREU) VALUES");
        Random r = new Random();
        int i,randomDay,randomMonth,randomKG,randomPrice;
        
        // Generacion de los inserts
        for(i = NUM_INICIO; i<NUM_INSERTS; i++) {
            // Random date
            randomDay = r.nextInt(28)+1;
            randomMonth = r.nextInt(12)+1;
            // Random KG
            randomKG = r.nextInt(100)+1;
            // Random price
            randomPrice = r.nextInt(50)+1;
            // Impresion del insert
            System.out.println("("+i+", 'REF"+i+"', '2023-"+randomMonth+"-"+randomDay+"', "+randomKG+", "+randomPrice+"),");
        }
        
        // Random date
        randomDay = r.nextInt(28) + 1;
        randomMonth = r.nextInt(12) + 1;
        // Random KG
        randomKG = r.nextInt(100) + 1;
        // Random price
        randomPrice = r.nextInt(50) + 1;
        // Impresion del insert
        System.out.println("(" + i + ", 'REF" + i + "', '2023-" + randomMonth + "-" + randomDay + "', " + randomKG + ", " + randomPrice + ");");
    }
}
