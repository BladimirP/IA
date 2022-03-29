// PSO de acuerdo a Talbi (p.247 ss)

PImage surf; // imagen que entrega el fitness

// ===============================================================
int puntos = 10;
Particle[] fl; // arreglo de partículas
float d = 15; // radio del círculo, solo para despliegue
float gbestx = 512;
float gbesty = 512;// posición y fitness del mejor global
float gbest = 100000;
float w = 1000; // inercia: baja (~50): explotación, alta (~5000): exploración (2000 ok)
float C1 = 30, C2 =  10; // learning factors (C1: own, C2: social) (ok)
int evals = 0, evals_to_best = 0; //número de evaluaciones, sólo para despliegue
float maxv = 3; // max velocidad (modulo)

class Particle{
  float x, y, fit; // current position(x-vector)  and fitness (x-fitness)
  float px, py, pfit; // position (p-vector) and fitness (p-fitness) of best solution found by particle so far
  float vx, vy; //vector de avance (v-vector)
  
  // ---------------------------- Constructor
  Particle(){
    x = random (width); y = random(height);
    vx = random(-1,1) ; vy = random(-1,1);
    pfit = -1; fit = -1; //asumiendo que no hay valores menores a -1 en la función de evaluación
  }
  
  // ---------------------------- Evalúa partícula
  float Eval(PImage surf){ //recibe imagen que define función de fitness
    evals++;
    fit = 20 + (float)((Math.pow((x-512),2) - 10*Math.cos(2*Math.PI*(x-512))) + (Math.pow((y-512),2) - 10*Math.cos(2*Math.PI*(y-512)))); // obtiene valor de la funcion en posición (x,y)
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
  
  // ------------------------------ mueve la partícula
  void move(){
    //actualiza velocidad (fórmula con factores de aprendizaje C1 y C2)
    //vx = vx + random(0,1)*C1*(px - x) + random(0,1)*C2*(gbestx - x);
    //vy = vy + random(0,1)*C1*(py - y) + random(0,1)*C2*(gbesty - y);
    //actualiza velocidad (fórmula con inercia, p.250)
    vx = w * vx + random(0,1)*(px - x) + random(0,1)*(gbestx - x);
    vy = w * vy + random(0,1)*(py - y) + random(0,1)*(gbesty - y);
    //actualiza velocidad (fórmula mezclada)
    //vx = w * vx + random(0,1)*C1*(px - x) + random(0,1)*C2*(gbestx - x);
    //vy = w * vy + random(0,1)*C1*(py - y) + random(0,1)*C2*(gbesty - y);
    // trunca velocidad a maxv
    float modu = sqrt(vx*vx + vy*vy);
    if (modu > maxv){
      vx = vx/modu*maxv;
      vy = vy/modu*maxv;
    }
    // update position
    x = x + vx;
    y = y + vy;
    // rebota en murallas
    if (x > width || x < 0) vx = - vx;
    if (y > height || y < 0) vy = - vy;
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
    fl[i].move();
    fl[i].Eval(surf);
  }
  
}
