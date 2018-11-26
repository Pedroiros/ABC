
import de.voidplus.leapmotion.*;
LeapMotion leap;
Table tabla;


void setup() {
  frameRate(60);
  background(0);
  fullScreen();
//  size(800,800);
  leap = new LeapMotion(this);
  tabla=new Table();
  tabla.addColumn("Datos");
  tabla.addColumn("Control");
}

void   inicio(char aux) {
      textSize(60);                                                   // #0 Titulo 
      fill(255);
      textAlign(CENTER);
      switch(aux) {
      case 'P': 
        text("Flexión - Extensión", width/2, height/10);
        break;
      case 'R': 
        text("Pronación - Supinación", width/2, height/10);
        break;
      case 'Y':             
        text("Desviación radial - cubital", width/2, height/10);
        break;
      default:
        text("Iniciar", width/2, height/10);
        break;
      }
                     
      noStroke();
      fill(255, 0, 0);                                                  // #1  Circulos indicadores de detecccion de mano
      ellipse(width/15, height/10, 150, 150);                         //Rojo no detecta, verde si
      ellipse(width*14/15, height/10, 150, 150);
      textSize(25);
      fill(255);
      textAlign(CENTER);
      text("Izquierda", width/15, height/10 + 100);
      text("Derecha", width*14/15, height/10 + 100);
      
      String s= "Controles: \n p: Flexión/Extensión \n r: Pronación/Supinación \n y: Desviación radial/cubital \n 1 2 3 4 5: Dificultad \n a, s, d: Velocidad \n n: Ocultar guía";
      textAlign(LEFT);
      textSize(20);
      text(s, width*.05, height*0.7);
}                                                                 //Fin funcion inicio



void   circuloVerde(Hand hand) {                                  //Circulo verde cuando detecta una mano
  if (hand.isLeft()) {                                          
    fill(0, 255, 0);
  } else {
    fill(255, 0, 0);
  }
  ellipse(width/15, height/10, 150, 150);    
  textSize(25);
  fill(255);
  textAlign(CENTER);
  text("Izquierda", width/15, height/10 + 100);

  if (hand.isRight()) {
    fill(0, 255, 0);
  } else {
    fill(255, 0, 0);
  }
  ellipse(width*14/15, height/10, 150, 150);
  textSize(25);
  fill(255);
  textAlign(CENTER);
  text("Derecha", width*14/15, height/10 + 100);
}                                                                         //Fin funcion circuloVerde


void   lineasVertical(float reloj, float velocidad, float data_mov) {        //Para pitch (flexion extension)
  //A esta funcion le voy a pasar los datos del reloj para que oscile,
  //un parametro para variar la velocidad (del oscilador) y el valor del movimiento ( data de pitch) 


  float fnorm=75*dificultad;                                          //75 es la media maxima
  float posY_circ1=0;
  float posY_circ2=0;
  stroke(255);                                                        // Lineas sobre las que van a pasar los circulos 
  strokeWeight(2);

  fill(255);
  line(width*2/3, height*2/10, width*2/3, height*9/10 );    
  if (mostrar) {                                                       //Mostrar o no la pelotita guia
    line(width/3, height*2/10, width/3, height*9/10 );
    posY_circ1= height*0.55+0.35*height*sin(reloj*velocidad);           //Circulo que se mueve sobre la linea segun el tiempo (punto central + altura/2 * sin() )
    ellipse(width/3, posY_circ1, 50, 50);
  }

  fill(255, 255, 0); noStroke();
  posY_circ2= height*0.55-0.35*height*sin(  (data_mov/fnorm)*PI/2  );                      
  ellipse(width*2/3, posY_circ2, 50, 50);
  text(data_mov, width*14/15, height/2);
}

void   lineasHorizontal(float reloj, float velocidad, float data_mov) {  //Para yaw (desviacion radial cubital)

  float fnorm=35*dificultad;                                     //Factor de normalizacion. Para que el maximo valor de ROM coincida con el maximo de la linea
  float posX_circ1=0;
  float posX_circ2=0;
  stroke(255);                                                         
  strokeWeight(2);
  line(width*2/10, height*6/10, width*8/10, height*6/10 );
  fill(255);
  if(mostrar){                                                  //Mostrar o no la pelotita guia
    line(width*2/10, height*4/10, width*8/10, height*4/10 );
    posX_circ1= width/2+0.3*width*sin(reloj*velocidad);           
    ellipse(posX_circ1, height*4/10, 50, 50);
  }

  fill(255, 255, 0); noStroke();
  posX_circ2= width/2+0.3*width*sin( (data_mov/fnorm)*PI/2 ) ;                      
  ellipse(posX_circ2, height*6/10, 50, 50);
  text(data_mov, width*14/15, height/2);
}
 
 
void lineasElipse(float reloj, float velocidad, float data_mov, boolean bool_derecha ){     //Para roll (pronacion supinacion)
                                                                                            //Agregar para variar la velocidad

  float posX_circ1=0, posY_circ1=0;;
  float posX_circ2=0, posY_circ2=0;
  float fnorm=75*dificultad;                                        //75 es la media maxima * dificultad
  
  noFill();
  stroke(255);
  strokeWeight(2);
  //arc(alto, ancho, )

  arc(width/2, height*2/3, 800, 400, PI, TWO_PI);
    
  if(mostrar){                                                            //Mostrar o no la pelotita guia
    arc(width/2, height/2, 800, 400, PI, TWO_PI);
    fill(255);
    posX_circ1=width/2+400*cos(reloj*velocidad);
    posY_circ1=height/2+200*(-1)*abs(sin(reloj*velocidad));
    ellipse(posX_circ1, posY_circ1, 50, 50);
  }
  fill(255, 255, 0); noStroke();
        if(  bool_derecha  ){                                              //bool_derecha = true si la mano es la derecha
        
            posX_circ2=width/2-400*cos( (data_mov+fnorm)*PI/(fnorm*2)   );
            posY_circ2=height*2/3+200*(-1)*abs(sin( (data_mov+fnorm)*PI/(fnorm*2) ));
            ellipse(posX_circ2, posY_circ2, 50, 50);
      }   else{
              posX_circ2=width/2+400*cos( (data_mov+fnorm)*PI/(fnorm*2)   );
              posY_circ2=height*2/3+200*(-1)*abs(sin( (data_mov+fnorm)*PI/(fnorm*2) ));
              ellipse(posX_circ2, posY_circ2, 50, 50);
            }
      
  text(data_mov, width*14/15, height/2);
  
}



float getData(char aux, Hand hand) {
  float data=0;
  switch(aux) {
  case 'P': 
    data=hand.getPitch();
    break;
  case 'R': 
    data=hand.getRoll();
    if (hand.isLeft()){
        data=(-1)*data;
    }
    
    if (data< (-50) ){                // Cuando la mano esta en supinacion, a veces pasa de 180 a -180, por eso el if     
        data=data+360;
    }
    data=data-90;                                //Para que 0 sea la posicion neutra
    break;
  case 'Y':             
    data=hand.getYaw();
    break;
  }

  return data;
}


void saveData(char aux, float data){          
//Aux es un char para saber que movimiento es y data es el dato a guardar

  TableRow newRow = tabla.addRow();
  newRow.setFloat("Datos", data );
  
  switch(aux) {
  case 'P': 
      newRow.setInt("Control", 1 );
    
    break;
  case 'R': 
      newRow.setInt("Control", 2 );
    
    break;
  case 'Y':        
      newRow.setInt("Control", 3 );
    
    break;
  }

}





void draw() {
  background(0);
  float reloj=millis()/1000.0;                                    //Reloj
  text("Tiempo: "+reloj, width/15, height/2);
  float velocidad = vel;                                          //Se ingresa por teclado

  inicio(char_mov);

    for (Hand hand : leap.getHands()) {                             // #2 Arranco el for cuando detecta las manos      
          float data_mov = getData(char_mov, hand);
          circuloVerde(hand);
          switch(char_mov){
            case 'Y':
              lineasHorizontal(reloj, velocidad, data_mov);
            break;
            case 'P':
              lineasVertical(reloj, velocidad, data_mov);
            break;
            case 'R':
              lineasElipse(reloj, velocidad, data_mov, hand.isRight() );
            break;
          }          
          saveData(char_mov, data_mov);
    }                                                                  // #2
}



char char_mov=' ';
float dificultad=1;        //Es 1 por defecto
boolean mostrar=true;      //Es verdadero por defecto -> muestra la pelotita guia
float vel=1;
void  keyPressed(){
    
      switch (key) {
        case ENTER:
          String nom_tabla = ("Registros/rangeRAW.csv");
          saveTable(tabla, nom_tabla);
          exit();      
        break;      
        
        //Seleccion de movimiento:
        case 'p': 
          char_mov='P';
        break;
        case 'r': 
          char_mov='R';
        break;
        case 'y': 
          char_mov='Y';
        break;
        
        //No mostrar la pelotita guia:
        case 'n':
          mostrar=false;
        break;
         
        //Seleccion de dificultad:
        case '1':
            dificultad=0.4;
        break;
        case '2':
            dificultad=0.6;
        break;
        case '3':
            dificultad=0.8;
        break;
        case '4':
            dificultad=1;
        break;
        case '5':
            dificultad=1.2;
        break;
        
        //Velocidad de la pelotita 
        case 'a':
          vel=0.5;
        break;
        case 's':
          vel=1;
        break;
        case 'd':
          vel=1.5;
        break;
       
      }

}
