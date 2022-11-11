Population swarm;
PVector goal = new PVector(750, 50, 15);
PVector startingLine = new PVector(50, 750);
PVector nearest = new PVector(-1, -1);
ArrayList<PVector> firstRoute = new ArrayList<PVector>();
ArrayList<PVector> bestRoute = new ArrayList<PVector>();
ArrayList<PVector> furthestRoute = new ArrayList<PVector>();
int generationVal = 1;
int bestStepCount = -1;
int brainSize = 2500;
int currBrainSize = brainSize;
int population = 2000;
boolean started = false;
boolean paused = true;
boolean dotPoV = false;
float mutationRate = 0.03;

int noImprovementCounter = 0;
int prevBestStepCount = bestStepCount;

ArrayList<Obsticle> obsticles = new ArrayList<Obsticle>();
ArrayList<PVector> graveyard = new ArrayList<PVector>();

void setup() {
  surface.setTitle("MazeRunner!");
  //surface.setResizable(true);
  size(800, 800); //size of the window
  frameRate(60); //increase this to make the dots go faster, default is 100
  swarm = new Population(population);//create a new population with 1000 members
  createRandomObsticles();
}


void draw() { 
  background(255);

  //draw obstacle(s)
  for(Obsticle o : obsticles) {
    fill(233, 233, 233);
    stroke(153);
    if (dotPoV) {fill(255, 255, 255);stroke(255);}
    
    if (o.type.equals("rect")) {
      if (Collisions.circleRect(mouseX, mouseY, 1, o.x, o.y, o.w, o.h)) fill(233, 0, 0);
      rect(o.x, o.y, o.w, o.h);
    } else if (o.type.equals("circle")) {
      if (Collisions.circleCircle(mouseX, mouseY, 1, o.x, o.y, o.w/2)) fill(233, 0, 0);
      circle(o.x, o.y, o.w);
    }
  }

  if (boxing) {
    fill(133, 133, 133);
    if (kShift) {
      circle(x1, y1, x2-x1);
    } else {
      rect(x1, y1, x2-x1, y2-y1);
    }
  }

  if (nearest.x != -1 && nearest.y != -1) {
    noFill();
    stroke(222, 224, 227);
    ellipse(goal.x, goal.y, dist(nearest.x, nearest.y, goal.x, goal.y)*2, dist(nearest.x, nearest.y, goal.x, goal.y)*2);
  }
  
  stroke(255, 165, 0);
  for(PVector p : firstRoute){
    point(p.x, p.y);
  }
  stroke(0, 0, 0);
  for(PVector p : bestRoute){ //<>//
    point(p.x, p.y);
  }
  //stroke(255, 87, 51);
  //for(PVector p : furthestRoute){
  //  point(p.x, p.y);
  //}
  
  stroke(0,0,0);
  
  //draw goal
  fill(249, 83, 53);
  ellipse(goal.x, goal.y, goal.z, goal.z);
  
  if (started) {
    if (swarm.allDotsDead()) {
      //genetic algorithm
      swarm.calculateFitness();
      swarm.naturalSelection();
      swarm.mutateDemBabies();
      
      if (bestStepCount == prevBestStepCount) noImprovementCounter++;
      else if (bestStepCount < prevBestStepCount) {
        noImprovementCounter = 0;
        mutationRate += 0.005;
        prevBestStepCount = bestStepCount;
      }
      else prevBestStepCount = bestStepCount;
      
      if (noImprovementCounter > 10) {
        noImprovementCounter = 0;
        mutationRate -= 0.005;
        if (mutationRate < 0) mutationRate = 0.01;
      }
      println(noImprovementCounter);
    } else {
      //if any of the dots are still alive then update and then show them
      if (paused) { 
        fill(0, 102, 153); textSize(48); textAlign(CENTER); text("PRESS SPACE TO CONTINUE", width/2, height/2); 
      } else swarm.update();
      swarm.show();
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
    textSize(18);
    text("PRESS 'UP' OR 'DOWN' TO ADJUST MUTATION RATE", width/2, height/2 + 25);
    text("PRESS 's' TO SAVE OBSTICLES", width/2, height/2 + 45);
    text("PRESS 'L' TO LOAD OBSTICLES", width/2, height/2 + 65);
    text("PRESS 'l' TO LOAD OBSTICLES, PRESERVING NEW ONES", width/2, height/2 + 85);
    text("PRESS 'C' TO CLEAR OBSTICLES", width/2, height/2 + 105);
    text("PRESS 'SPACE' TO PAUSE", width/2, height/2 + 125);
    
    text("USE MOUSE TO DRAW OBSTICLES", width/2, height/2 + 145);
    text("HOLD SHIFT TO DRAW CIRCLE OBSTICLES", width/2, height/2 + 165);
    
  }
}
