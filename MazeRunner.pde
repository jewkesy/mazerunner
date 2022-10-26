Population test;
PVector goal  = new PVector(750, 50);
PVector nearest = new PVector(-1, -1);
ArrayList<PVector> bestRoute = new ArrayList<PVector>();
ArrayList<PVector> furthestRoute = new ArrayList<PVector>();
int generationVal = 1;
int bestStepCount = -1;
int brainSize = 2500;
int currBrainSize = brainSize;
int population = 2000;
boolean started = false;
boolean paused = true;
float mutationRate = 0.03;

ArrayList<PVector> graveyard = new ArrayList<PVector>();

void setup() {
  surface.setTitle("MazeRunner!");
  //surface.setResizable(true);
  size(800, 800); //size of the window
  frameRate(60); //increase this to make the dots go faster, default is 100
  test = new Population(population);//create a new population with 1000 members
}
ArrayList<Obsticle> obsticles = new ArrayList<Obsticle>();

void draw() { 
  background(255);

  //draw obstacle(s)
  for(Obsticle o : obsticles) {
    fill(233, 233, 233);
    if (Collisions.circleRect(mouseX, mouseY, 1, o.x, o.y, o.w, o.h)) fill(233, 0, 0);
    if (o.type == "rect") rect(o.x, o.y, o.w, o.h);
  }

  if (boxing) {
    fill(133, 133, 133);
    rect(x1, y1, x2-x1, y2-y1);
  }

  if (nearest.x != -1 && nearest.y != -1) {
    noFill();
    stroke(222, 224, 227);
    ellipse(goal.x, goal.y, dist(nearest.x, nearest.y, goal.x, goal.y)*2, dist(nearest.x, nearest.y, goal.x, goal.y)*2);
  }
  
  stroke(50, 50, 50);
  for(PVector p : bestRoute){ //<>//
    point(p.x, p.y);
  }
  stroke(255, 87, 51);
  for(PVector p : furthestRoute){
    point(p.x, p.y);
  }
  
  stroke(0,0,0);
  
  //draw goal
  fill(249, 83, 53);
  ellipse(goal.x, goal.y, 15, 15);
  
  if (started) {
    if (test.allDotsDead()) {
      //genetic algorithm
      test.calculateFitness();
      test.naturalSelection();
      test.mutateDemBabies();
    } else {
      //if any of the dots are still alive then update and then show them
      if (paused) { 
        fill(0, 102, 153); textSize(48); textAlign(CENTER); text("PRESS SPACE TO CONTINUE", width/2, height/2); 
      } else test.update();
      test.show();
    }
  }
  
  fill(0, 102, 153);

  if (started) {
    textSize(32);
    textAlign(LEFT);
    if (bestStepCount == -1) text("Generation: " + generationVal, 20, height-20);
    else text("Generation: " + generationVal + " (" + bestStepCount + ")", 20, height-20);
    
    textAlign(RIGHT);
    text("Mutation Rate: " + mutationRate, width-20, height-20); 
  } else {
    textSize(48);
    textAlign(CENTER);
    text("PRESS SPACE TO START", width/2, height/2);
  }
}
