final float OFFSET_X = 80;
final float OFFSET_Y = 80;

final int GAME_START = 0;
final int GAME_RUN = 1;
final int GAME_OVER = 2;
int gameState = GAME_START;

final int BOTTON_NORMAL = 0;
final int BOTTON_DOWN = 1;
final int BOTTON_LEFT = 2;
final int BOTTON_RIGHT = 3;
int bottonState = BOTTON_NORMAL;

final float BUTTON_W = 144;
final float BUTTON_H = 60;
final float BUTTON_TOP = 360;
final float BUTTON_BOTTOM = 360 + BUTTON_H;
final float BUTTON_LEFT = 248;
final float BUTTON_RIGHT = 248 + BUTTON_W;

final float LIFE_SPACE = 70;
final float LIFE_Y = 10;
final float LIFE_X = 10;

final float SOLDIER_W = 80;
final float SOLDIER_H = 80;
final float SOLDIER_SPEED = 5;

final float CABBAGE_W = 80;
final float CABBAGE_H = 80;

final float GROUNDHOG_INIT_X = OFFSET_X*4;
final float GROUNDHOG_INIT_Y = OFFSET_Y;
final float GROUNDHOG_W = 80;
final float GROUNDHOG_H = 80;
final float GROUNDHOG_SPEED = round(80/15);

PImage bg, soil, life, soldier, cabbage;
PImage groundhogIdle, groundhogDown, groundhogLeft, groundhogRight;
PImage title, startNormal, startHovered;
PImage gameover, restartNormal, restartHovered;

float cabbageX;
float cabbageY;

float soldierX, soldierY;

float groundhogX = OFFSET_X*4;
float groundhogY = OFFSET_Y;

float lifeInitial = 80;
float y = 0;
float count = 0;

void setup() {
  size(640, 480, P2D);
  
  bg = loadImage("img/bg.jpg");
  soil = loadImage("img/soil.png");
  life = loadImage("img/life.png");
  soldier = loadImage("img/soldier.png");
  cabbage = loadImage("img/cabbage.png");
  
  groundhogIdle = loadImage("img/groundhogIdle.png");
  groundhogDown = loadImage("img/groundhogDown.png");
  groundhogRight = loadImage("img/groundhogRight.png");
  groundhogLeft = loadImage("img/groundhogLeft.png");
  
  title = loadImage("img/title.jpg");
  startNormal = loadImage("img/startNormal.png");
  startHovered = loadImage("img/startHovered.png");
  
  gameover = loadImage("img/gameover.jpg");
  restartNormal = loadImage("img/restartNormal.png");
  restartHovered = loadImage("img/restartHovered.png");
  
  soldierX = -80;
  soldierY = (OFFSET_Y*2 + floor(random(4)) * OFFSET_Y);
  
  cabbageX = floor(random(0,7)) * OFFSET_X;
  cabbageY = OFFSET_Y*2 + floor(random(4)) * OFFSET_Y;
}

void draw() {
  // Switch Game State
  switch(gameState){
    // Game Start
    case GAME_START:
      background(title); 
      // botton hover 
      if(mouseX > BUTTON_LEFT && mouseX < BUTTON_RIGHT
      && mouseY > BUTTON_TOP && mouseX < BUTTON_BOTTOM){
        image(startHovered, BUTTON_LEFT, BUTTON_TOP);
        if(mousePressed){
          gameState = GAME_RUN;
        }
      }else{
        image(startNormal, BUTTON_LEFT, BUTTON_TOP);
      }
      break;
    
    // Game Run
    case GAME_RUN:
      background(bg);
      image(soil, 0, OFFSET_Y*2, width, 320);
      
      // grass
      noStroke();
      fill(124, 204, 25);
      rect(0, OFFSET_Y*2 - 15, width, 15);
      
      // sun 
      stroke(255, 255, 0);
      strokeWeight(5);
      fill(253, 184, 19);
      ellipse(width - 50, 50, 120, 120);
      
      image(soldier, soldierX, soldierY, SOLDIER_W, 80);
      // soldier move
      soldierX += SOLDIER_SPEED;
      // soldier loop
      if(soldierX > SOLDIER_W + width ){
        soldierX = -80;
      }
      // soldier hit detection
      if(groundhogX < soldierX + SOLDIER_W
      && groundhogX + GROUNDHOG_W > soldierX
      && groundhogY < soldierY + SOLDIER_H
      && groundhogY + GROUNDHOG_H > soldierY){
        lifeInitial -= LIFE_SPACE;
        if(lifeInitial < 10){
          gameState = GAME_OVER;
        }
        groundhogX = GROUNDHOG_INIT_X;
        groundhogY = GROUNDHOG_INIT_Y;
        count = 0;
        bottonState = BOTTON_NORMAL;
      }else{
        switch(bottonState){
          case BOTTON_NORMAL:
            image(groundhogIdle, groundhogX, groundhogY);
            break;
          case BOTTON_DOWN:
              if(count < OFFSET_Y){
                count += GROUNDHOG_SPEED;
                groundhogY += GROUNDHOG_SPEED;
                if(groundhogY + GROUNDHOG_H > height){
                  groundhogY = height - GROUNDHOG_H;
                }
                image(groundhogDown, groundhogX, groundhogY);
              }else{
                image(groundhogIdle, groundhogX, groundhogY);
                count = 0;
                bottonState = BOTTON_NORMAL;
              }
            break;
          case BOTTON_LEFT:
            if(count < OFFSET_X){
              count += GROUNDHOG_SPEED;
              groundhogX -= GROUNDHOG_SPEED;
              if(groundhogX < 0){
                groundhogX = 0;
              }
              image(groundhogLeft, groundhogX, groundhogY);
            }else{
              image(groundhogIdle, groundhogX, groundhogY);
              bottonState = BOTTON_NORMAL;
              count = 0;
            }
            break;
          case BOTTON_RIGHT:
            if(count < OFFSET_X){
              count += GROUNDHOG_SPEED;
              groundhogX += GROUNDHOG_SPEED;
              if(groundhogX + GROUNDHOG_W > width){
                groundhogX = width - GROUNDHOG_W;
              }
              image(groundhogRight, groundhogX, groundhogY);
            }else{
              image(groundhogIdle, groundhogX, groundhogY);
              bottonState = BOTTON_NORMAL;
              count = 0;
            }
            break; 
         }  
       }
      // cabbage hit detection
      if(groundhogX < cabbageX + CABBAGE_W
      && groundhogX + GROUNDHOG_W > cabbageX
      && groundhogY < cabbageY + CABBAGE_H
      && groundhogY + GROUNDHOG_H > cabbageY){
        lifeInitial += LIFE_SPACE;
        cabbageY = -80;
      }else{
        image(cabbage, cabbageX, cabbageY);
      }  
      // life
      for(float i = LIFE_X; i <= lifeInitial; i += LIFE_SPACE){
        image(life, i, LIFE_Y);
      }
      break;
      
    // Game Over
    case GAME_OVER:
      background(gameover);
      
      // botton hover 
      if(mouseX > BUTTON_LEFT && mouseX < BUTTON_RIGHT
      && mouseY > BUTTON_TOP && mouseX < BUTTON_BOTTOM){
        image(restartHovered, BUTTON_LEFT, BUTTON_TOP);
        if(mousePressed){
          // reset
          bottonState = BOTTON_NORMAL;
          
          groundhogX = GROUNDHOG_INIT_X;
          groundhogY = GROUNDHOG_INIT_Y;
          
          soldierY = (OFFSET_Y*2 + floor(random(4)) * OFFSET_Y);
          
          cabbageX = floor(random(0,7)) * OFFSET_X;
          cabbageY = OFFSET_Y*2 + floor(random(4)) * OFFSET_Y;
          
          lifeInitial = 80;
          
          gameState = GAME_RUN;
        }
      }else{
        image(restartNormal, BUTTON_LEFT, BUTTON_TOP);
      }
      break;
  }
}

void keyPressed(){
  if(key == CODED){
    if(bottonState == BOTTON_NORMAL){  
      switch(keyCode){
        case DOWN:
            bottonState = BOTTON_DOWN;
          break;
        case RIGHT:
            bottonState = BOTTON_RIGHT;
          break;
        case LEFT:
            bottonState = BOTTON_LEFT;
          break;
      }
    }    
  }     
}
