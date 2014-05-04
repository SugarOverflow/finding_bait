import processing.serial.*;
import ddf.minim.*;
Minim minim;
AudioPlayer player;
AudioPlayer player2;
AudioPlayer player3;
Serial myPort;
int val;

PImage pellet;
PImage bg;
PImage title;
PImage score;
PImage topScore;
PImage fish;

snake test;
food food1;
int highScore;

void setup() {
  //String portName = Serial.list()[1];
  //myPort = new Serial(this,portName,9600);
  size(1000, 600);
  frameRate(14);
  test = new snake();
  food1 = new food();
  rectMode(CENTER);
  textAlign(CENTER, CENTER); 
  highScore = 0;

  pellet = loadImage("pellet.png");
  bg = loadImage("fishtank.jpg");
  title = loadImage("title.png");
  score = loadImage("score.png");
  topScore = loadImage("topScore.png");
  fish = loadImage("fish.png");
  
  minim = new Minim(this);
  player = minim.loadFile("tank.mp3");
  player.loop();
}



void draw() {
  background(bg);
  image(title, 290, 40);

  stroke(179, 140, 198);
  fill(22, 242, 56);
  textSize(24);
  text(test.len, 110, 263);
  text(highScore, 170, 300);
  image(score, 5, 250);
  image(topScore, 5, 285);


  // move();//get the direction for the snake to go from the accellerometer
  test.move();//move the snake in that direction, do checks
  test.display();//display the snake
  food1.display();//display the food


  //IF THE SNAKE HITS THE FOOD, RESET NEW FOOD POSITION + ADD A LINK TO THE SNAKE
  if ( dist(food1.xpos, food1.ypos, test.xpos.get(0), test.ypos.get(0)) < 40) {//test.sidelen ){
    player.pause();
    player2 = minim.loadFile("bloop.wav");
    player2.play();
    player.loop();
    food1.reset();
    test.addLink();
  }

  //UPDATE THE HIGHSCORE IF A NEW LINK WAS ADDED ( GOT THE FOOD)
  if (test.len > highScore) {
    highScore= test.len;
  }
}


//void move(){
//  
//  val = myPort.read();
//  
//    if(val == 240){
//      test.dir = "left";
//    }
//    if(val == 241){
//      test.dir = "right";
//    }
//    if(val == 242){
//      test.dir = "down";
//    }
//    if(val == 243){
//      test.dir = "up";
//    }    
//}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      test.dir = "left";
    }
    if (keyCode == RIGHT) {
      test.dir = "right";
    }
    if (keyCode == UP) {
      test.dir = "up";
    }
    if (keyCode == DOWN) {
      test.dir = "down";
    }
  }
}


class food {

  //POSITION OF THE FOOD
  float xpos, ypos;

  food() {
    xpos = random(100, width - 100);
    ypos = random(100, height - 100);
  }

  void display() {

    fill(190, 0, 100);
    image(pellet, xpos-25, ypos-25, 50, 50);
    //ypos is set at the top
    //xpos is set at the left
  }

  void reset() {
    xpos = random(100, width - 100);
    ypos = random(100, height - 100);
  }
}

class snake {

  int len;
  float sidelen;
  String dir;
  String prevDir;
  ArrayList <Float> xpos, ypos;

  snake() {
    len = 1;
    sidelen = 25;
    dir = "right";
    prevDir = "right";
    xpos = new ArrayList();
    ypos = new ArrayList();
    xpos.add( random(width) );
    ypos.add( random(height) );
  }

  void move() {
    for (int i = len - 1; i > 0; i = i -1 ) {
      xpos.set(i, xpos.get(i - 1));
      ypos.set(i, ypos.get(i - 1));
    }
    if (dir == "left") {
      if (prevDir != "right") {
        xpos.set(0, xpos.get(0) - sidelen);
        prevDir = "left";
      }
      else {
        xpos.set(0, xpos.get(0) + sidelen);
      }
    }
    if (dir == "right") {
      if (prevDir != "left") {
        xpos.set(0, xpos.get(0) + sidelen);
        prevDir = "right";
      }
      else {
        xpos.set(0, xpos.get(0) - sidelen);
      }
    }

    if (dir == "up") {
      if (prevDir != "down") {
        ypos.set(0, ypos.get(0) - sidelen);
        prevDir = "up";
      }
      else {
        ypos.set(0, ypos.get(0) + sidelen);
      }
    }
    if (dir == "down") {
      if (prevDir != "up") {
        ypos.set(0, ypos.get(0) + sidelen);
        prevDir = "down";
      }
      else {
        ypos.set(0, ypos.get(0) - sidelen);
      }
    }
    xpos.set(0, (xpos.get(0) + width) % width);
    ypos.set(0, (ypos.get(0) + height) % height);

    // check if hit itself and if so cut off the tail
    if ( checkHit() == true) {
      player.pause();
      player2.pause();
      player3 = minim.loadFile("lose.wav");
      player3.play();
      player.loop();
      len = 1;
      float xtemp = xpos.get(0);
      float ytemp = ypos.get(0);
      xpos.clear();
      ypos.clear();
      xpos.add(xtemp);
      ypos.add(ytemp);
    }
  }



  void display() {

    image(fish, xpos.get(0)-35, ypos.get(0)-45, sidelen+25, sidelen+25);
    for (int i = 1; i <len; i++) {
      stroke(179, 140, 198);
      fill(20, 0, 100, map(i-1, 0, len-1, 250, 50));
      rect(xpos.get(i), ypos.get(i), sidelen, sidelen);
    }
  }

  void addLink() {
    xpos.add( xpos.get(len-1) + sidelen);
    ypos.add( ypos.get(len-1) + sidelen);
    len++;
  }

  boolean checkHit() {
    for (int i = 1; i < len; i++) {
      if ( dist(xpos.get(0), ypos.get(0), xpos.get(i), ypos.get(i)) < sidelen) {
        return true;
      }
    }
    return false;
  }
}

