import java.util.*;

PImage surf; // imagen que entrega el fitness

// ===============================================================

List<Individuos> gen = new ArrayList<Individuos>();     // arreglo de todos los individuos
List<Individuos> parent  = new ArrayList<Individuos>(); // arreglo de los individuos seleccionados para cruzar
List<Individuos> newGen = new ArrayList<Individuos>();  // arreglo de los nuevos individuos


// Configuracion
int population = 50;          // cantidad de individuos ( debe ser par)
float radiacion = 40;         // prob. de mutar
float radio = 0.8;            // potencia de la mutacion max 5.12
float piedad = 15;            // prob. de que gane
float probCruzamientos = 50;  // probabilidad de que un individuo se cruze con otro

// Despliegue
float d = 15; // radio del círculo, solo para despliegue
float gbestx;
float gbesty; // posición y fitness del mejor global
float gbest = 1000000;


int cont = 1; // conteo de generaciones.
int evals_to_best; //Número de Generacioens, sólo para Display.

class Individuos{
  float x, y, fit; // current position(x-vector)  and fitness (x-fitness)
  
  // Constructor Base
  Individuos(){
    x = random(5.12*2) - 5.12; y = random(5.12*2) - 5.12;
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
    ellipse (x/5.12 * width/2 + width/2, y/5.12 * -height/2 + height/2, d, d);
  }
} //fin de la definición de la clase Particle


  
// FUNCIONES
  
  void seleccion(){
    Collections.shuffle(gen);
    for(int i = 0; i < population-1; i = i+2){
      
      if( random(100) <= piedad & gen.get(i).fit < gen.get(i+1).fit ){
        parent.add(gen.get(i+1));
        
      } else if( random(100) <= piedad & gen.get(i).fit > gen.get(i+1).fit ){
          parent.add(gen.get(i));
        
      } else if (gen.get(i).fit < gen.get(i+1).fit){
          parent.add(gen.get(i));
          
      } else {
          parent.add(gen.get(i+1));
      }
    }
  }
  
  // Listo
  void cruzamiento(){
    Collections.shuffle(parent);
    int i = 0;
    while( newGen.size() < population/2){
      for(int j = i+1; j <= population/2; j++){
        if(j == population/2)
          j = 0;
        if(i == j)
          j = (population/2)+1;
        else if(random(100) < probCruzamientos){
          mutacion(((parent.get(i).x + parent.get(j).x) / 2),((parent.get(i).y + parent.get(j).y) / 2));
          j = population/2+1;
        }
      i++;
      if (i >= population/2)
        i = 0;
      }
    } 
  }
  
  void mutacion(float x, float y){
    if(random(100) < radiacion){
      float varx = random(2*radio) - radio;
      float vary = random(2*radio) - radio;
      if (x + varx > 5.12)
        x = 5.12;
      else if (x + varx < -5.12)
        x = -5.12;
      else
        x += varx;
      if (y + vary > 5.12)
        y = 5.12;
      else if (y + vary < -5.12)
        y = -5.12;
      else
        y += vary;
    }
    newGen.add( new Individuos(x,y) );
  }
  
  
  void reinsercion(){
    for(int i = 0; i < population/2; i++)
      gen.set(i, parent.get(i));
    for(int j = 0; j < population/2; j++)
      gen.set(j + population/2, newGen.get(j));
  }
  
  void preparacion(){
    newGen.clear();
    parent.clear();
  }
  
  



// dibuja punto rojo en la mejor posición y despliega números
void despliegaBest(float med, float mejor){
  fill(#0000ff);
  ellipse(gbestx/5.12 * width/2 + width/2, gbesty/5.12 * -height/2 + height/2, d, d);
  PFont f = createFont("Arial",16,true);
  textFont(f,15);
  fill(#ff2020);
  print(str(cont)+";"+str(med)+";"+str(mejor)+"\n");
  text("Promedio de la Generacion: "+str(med)+"\nBest fitness: "+str(gbest)+"\nGeneracion del mejor: "+str(evals_to_best)+"\nGbestx: "+str(gbestx)+"\nGbesty: "+str(gbesty),10,20);
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
  for(int i =0; i < population; i++)
    gen.add(new Individuos());
}

void draw(){
  //background(200);
  //despliega mapa, posiciones  y otros
  
  image(surf,0,0);
  
  for(int i=0; i<population; i++){
    gen.get(i).display();
  }
  
  float med, valor, mejor;
  med = 0;
  mejor = 10000000;
  for(int i = 0;i<population;i++){
    valor = gen.get(i).Eval();
    med += valor;
    if(valor < mejor)
      mejor = valor;
  }
  
  despliegaBest(med/population, mejor);
  
  
  seleccion();
  
  cruzamiento();
  
  for(int i = 0; i < newGen.size(); i++)
    newGen.get(i).Eval();
  
  reinsercion();
  cont++;
  preparacion();
  try {
    Thread.sleep(100);
  } catch (InterruptedException e) {
    e.printStackTrace();
  }
}
