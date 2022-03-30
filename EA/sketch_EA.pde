import java.util.*;

PImage surf; // imagen que entrega el fitness

// ===============================================================
int poblacion = 20;
List<Individuos> gen = new ArrayList<Individuos>();  // arreglo de individuos
List<Individuos> newGen = new ArrayList<Individuos>();  // arreglo de individuos seleccionados

float d = 15; // radio del círculo, solo para despliegue

float radiacion = 25; // prob. de mutar
float radio = 25;   // potencia de la mutacion
float piedad = 25;  // prob. de que gane 

float gbestx;
float gbesty;// posición y fitness del mejor global
float gbest = 1000000;


int cont = 0; //Generaciones que han pasado.
int evals_to_best; //Número de Generacioens, sólo para Display.

class Individuos{
  float x, y, fit; // current position(x-vector)  and fitness (x-fitness)
  
  // Constructor Base
  Individuos(){
    x = random (width) - 512 ; y = random(height) - 512;
  }
  // Constructor hijos
  Individuos(float x,float y){
    this.x = x; this.y = y;
  }
  
  // Evalúa partícula
  float Eval(){
    fit = (float)(20 + (Math.pow(x,2) - 10 * Math.cos(2 * Math.PI * x)) + (Math.pow(y,2) - 10 * Math.cos(2 * Math.PI * y))); // obtiene valor de la funcion en posición (x,y)
    
    if (fit < gbest){ // actualiza global best
      gbest = fit;
      gbestx = x;
      gbesty = y;
      evals_to_best = cont;
    };
    return fit; //retorna la componente roja
  }
  
  // - despliega partícula
  void display(){
    fill(#e3cb2e);
    ellipse (x+512,y+512,d,d);
  }
} //fin de la definición de la clase Particle


  //  cruzamiento y mutacion
  void cruzamiento(){
    Collections.shuffle(gen);
    for(int z = 0; z < poblacion; z++){
      print("("+String.valueOf(gen.get(z).x) + "," + String.valueOf(gen.get(z).y) + ") ");
    }
    print("\n");
    for(int i = 0; i < poblacion-1; i++)
      mutacion(((gen.get(i).x + gen.get(i+1).x) / 2),((gen.get(i).y + gen.get(i+1).y) / 2), i);
    mutacion(((gen.get(poblacion-1).x + gen.get(0).x) / 2),((gen.get(poblacion-1).y + gen.get(0).y) / 2), poblacion-1);
  } 
  
  void mutacion(float x, float y, int n){
    if(random(100) < radiacion){
      float varx = random(2*radio) - radio;
      float vary = random(2*radio) - radio;
      if (x + varx > 512)
        x = 512;
      else if (x + varx < -512)
        x = -512;
      else
        x += varx;
      if (y + vary > 512)
        y = 512;
      else if (y + vary < -512)
        y = -512;
      else
        y += vary;
    }
    newGen.set(n, new Individuos(x,y) );
  }
    
  void seleccion(){
    for(int i = 0; i < poblacion; i++){
      if( random(100) <= piedad ){
        if (gen.get(i).fit > newGen.get(i).fit)
          gen.set(i, newGen.get(i));
      } else {
        if(gen.get(i).fit < newGen.get(i).fit)
          gen.set(i, newGen.get(i));
      }
    }
  }
  
  void seleccion2(){
  }


// dibuja punto rojo en la mejor posición y despliega números
void despliegaBest(){
  fill(#ff0000);
  ellipse(gbestx + 512,gbesty + 512,d,d);
  PFont f = createFont("Arial",16,true);
  textFont(f,15);
  fill(#ff2020);
  text("Best fitness: "+str(gbest)+"\nEvals to best: "+str(evals_to_best)+"\nGeneracion del mejor: "+str(evals_to_best)+"\nGbestx: "+str(gbestx)+"\nGbesty: "+str(gbesty),10,20);
}

// ===============================================================

void setup(){  
  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  //size(1440,720); //setea width y height
  //surf = loadImage("marscyl2.jpg");
  
  size(1024,1024); //setea width y height (de acuerdo al tamaño de la imagen)
  surf = loadImage("grande.jpg");
  
  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  smooth();
  // crea arreglo de objetos partículas

  for(int i =0; i < poblacion; i++){
    Individuos persona = new Individuos();
    gen.add(persona);
    newGen.add(persona);
  }
}

void draw(){
  //background(200);
  //despliega mapa, posiciones  y otros
  image(surf,0,0);
  for(int i=0;i<poblacion;i++){
    gen.get(i).display();
  }
  despliegaBest();
  for(int i = 0;i<poblacion;i++){
    gen.get(i).Eval();
  }
  cruzamiento();
  for(int i = 0;i<poblacion;i++){
    newGen.get(i).Eval();
  }
  seleccion();
  cont++;
  try {
    Thread.sleep(1000);
  } catch (InterruptedException e) {
    e.printStackTrace();
  }
}
