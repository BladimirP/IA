import java.util.*;

PImage surf; // imagen que entrega el fitness

// ===============================================================
int poblacion = 10;
Individuos[] gen;  // arreglo de individuos
Individuos[] newGen;  // arreglo de individuos seleccionados


float d = 15; // radio del círculo, solo para despliegue

float radiacion = 50; // prob. de mutar
float radio = 5;   // potencia de la mutacion
float piedad = 30;  // prob. de que gane 

float gbestx;
float gbesty;// posición y fitness del mejor global
float gbest = 100000;


int evals, evals_to_best; //número de evaluaciones, sólo para despliegue

class Individuos{
  float x, y, fit; // current position(x-vector)  and fitness (x-fitness)
  
  // Constructor Base
  Individuos(){
    x = random (width); y = random(height);
  }
  // Constructor hijos
  Individuos(int x,int y){
    this.x = x; this.y = y;
  }
  
  // ---------------------------- Evalúa partícula
  float Eval(PImage surf){ //recibe imagen que define función de fitness
    evals++;
    fit = 20 + (Math.pow(x,2) - 10*Math.cos(2*Math.PI*x)) + (Math.pow(y,2) - 10*Math.cos(2*Math.PI*y))); // obtiene valor de la funcion en posición (x,y)
    if(fit < pfit){ // actualiza local best si es mejor
      pfit = fit;
      px = x+512;
      py = y+512;
    }
    if (fit < gbest){ // actualiza global best
      gbest = fit;
      gbestx = x+512;
      gbesty = y+512;
      evals_to_best = evals;
      println(str(gbest));
    };
    return fit; //retorna la componente roja
  }
  
  // ------------------------------ despliega partícula
  void display(){
    color c=surf.get(int(x),int(y)); 
    fill(c);
    ellipse (x,y,d,d);
    // dibuja vector
    stroke(#ff0000);
    line(x,y,x-10*vx,y-10*vy);
  }
} //fin de la definición de la clase Particle


  //  cruzamiento + mutación
  void cruzamiento(){
  
    for(int i = 0; i < 2;i++){
      
      Collections.shuffle(gen);
      for(int j=0;j < poblacion/2; j++){
        
        // Cruzamiento
        int x = (int)((gen[i].x + gen[poblacion-i].x) / 2);
        int y = (int)((gen[i].y + gen[i+1].y) / 2);
           
        // Mutacion
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
        newGen[(poblacion * i) + j] = new Individuos(x ,y);
      }
    }
  }
    
  void seleccion(){
    for(int i = 0; i < poblacion; i++){
      if( random(100) <= piedad ){
        if (gen[i].fit > newGen[i].fit)
          gen[i] = newGen[i];
      } else {
        if(gen[i].fit < newGen[i].fit)
          gen[i] = newGen[i];
      }
    }
  }
  
  void seleccion2(){
  }
  


// dibuja punto rojo en la mejor posición y despliega números
void despliegaBest(){
  fill(#ff0000);
  ellipse(gbestx-512,gbesty-512,d,d);
  PFont f = createFont("Arial",16,true);
  textFont(f,15);
  fill(#ff2020);
  text("Best fitness: "+str(gbest)+"\nEvals to best: "+str(evals_to_best)+"\nEvals: "+str(evals)+"\nGbestx: "+str(gbestx)+"\nGbesty: "+str(gbesty),10,20);
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
  fl = new Particle[puntos];
  for(int i =0;i<puntos;i++)
    fl[i] = new Particle();
}

void draw(){
  //background(200);
  //despliega mapa, posiciones  y otros
  image(surf,0,0);
  for(int i = 0;i<puntos;i++){
    fl[i].display();
  }
  despliegaBest();
  //mueve puntos
  for(int i = 0;i<puntos;i++){
    reproducir(fl);
    fl[i].Eval(surf);
  }
  
}
