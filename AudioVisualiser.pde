//The MIT License (MIT) - See Licence.txt for details

//Copyright (c) 2013 Mick Grierson, Matthew Yee-King, Marco Gillies


//When running on the iPad or iPhone, you won't see anything unless you tap the screen.
//If it doesn't appear to work first time, always try refreshing the browser.


Maxim maxim;
AudioPlayer player;

float magnify = 200; // This is how big we want the rose to be.
float phase = 0; // Phase Coefficient : this is basically how far round the circle we are going to go
float amp = 0; // Amp Coefficient : this is basically how far from the origin we are.
int elements = 128;// This is the number of points and lines we will calculate at once. 1000 is alot actually. 
float threshold = 0.35;// try increasing this if it jumps around too much
int wait=0;
boolean playit;


void setup() {
  //The size is iPad Portrait.
  //If you want landscape, you should swap the values.
  // comment out if you are on Android!
  size(1024, 768);
  maxim = new Maxim(this);
  player = maxim.loadFile("mybeat.wav");
  player.setLooping(true);
  player.volume(1.0);
  player.setAnalysing(true);
  rectMode(CENTER);
  background(0);
  colorMode(HSB);
}

void draw() {
  float power = 0;
  if (playit) {
    player.play();
    power = player.getAveragePower();
    //detect a beat
    if (power > threshold && wait<0) {
      //println("boom");
      //a beat was detected. Now we can do something about it
      amp+=power; // for example alter the animation
      phase+=power*10; 
      wait+=10; //let's wait a bit before we look for another beat
    }
    wait--;// counting down...
  }
  amp += 0.05;//get the mouse Y coordinate and use it to set the current amp coefficient
  float spacing = radians(30)/elements; // this is how far apart each 'node' will be - study it. 
  translate(width*0.5, height*0.5);// we translate the whole sketch to the centre of the screen, so 0,0 is in the middle.
  fill(0, 50);
  rect(0, 0, width, height);
  noFill();
  strokeWeight(2);
  for (int i = 0; i < elements;i++) {
    stroke(i*2, 255, 255, 50);
    pushMatrix();
    rotate(spacing*i*phase);
    translate(tan(spacing*amp*i)*magnify, (1/cos(spacing*amp*i)*magnify));//sin ki jagah tan.0 ki jagah 1/cos
    //rotate(-(spacing*i*phase));
    fill(i,i*40,i*30,i);//255*sin(i) in place of i(reversed)
    //line(0, i*(power*10)-(width/4),tan(i),i*(power*10)-(height/4));//rect in place of line.tan(i) in place of zero
    rotate(i);//multiplied by 2
    noStroke();
    fill(i*2,255,255,i);//i in place of 10
    //ellipse(0,0,tan(i*(power*10)),100*sin(i*(power*10)));//tan in place of nothing and 100*sin in place of nothing
    ellipse(0,0,10*(i),10*sin(i));//extra.0 in plae of (width/2)+i
    //line(0, i*(power*10)-200, 0, 0);
    rect((width/2)-i,0,tan(i)*10*power,10*power/cos(i));//extra.power is extra
    popMatrix();
    stroke(255, 0, 0);
  }
}

void mousePressed() {

  playit = !playit;

  if (playit) {

    player.play();
  } 
  else {

    player.stop();
  }
}


