Population test;
PVector goal  = new PVector(750, 50);
PVector nearest = new PVector(-1, -1);
ArrayList<PVector> bestRoute = new ArrayList<PVector>();
ArrayList<PVector> furthestRoute = new ArrayList<PVector>();
int generationVal = 1;
int bestStepCount = -1;

ArrayList<PVector> graveyard = new ArrayList<PVector>();

void setup() {
  size(800, 800); //size of the window
  frameRate(100);//increase this to make the dots go faster, default is 100
  test = new Population(2500);//create a new population with 1000 members
}

Obstacle[] obsticles = new Obstacle[] {
  // without gaps
  //new Obstacle("rect", 0, 300, 600, 10), 
  //new Obstacle("rect", 200, 500, 600, 10),
  //new Obstacle("rect", 200, 100, 700, 10), 
  
  // with gaps
  new Obstacle("rect", 200, 100, 300, 10),
  new Obstacle("rect", 550, 100, 250, 10), 
  
  new Obstacle("rect", 0, 300, 300, 10), 
  new Obstacle("rect", 350, 300, 250, 10), 
  
  new Obstacle("rect", 200, 500, 600, 10),
  
} ;

void draw() { 
  background(255);
  stroke(0,0,0);
  
  //draw generation info
  textSize(32);
  fill(0, 102, 153);
  if (bestStepCount == -1) text("Generation: " + generationVal, 20, height-20);
  else text("Generation: " + generationVal + " (" + bestStepCount + ")", 20, height-20);
  
  //draw goal
  fill(249, 83, 53);
  ellipse(goal.x, goal.y, 15, 15);
  //println(nearest);

  
  //draw obstacle(s)
  fill(233, 233, 233);
  for(Obstacle o : obsticles) {
    if (o.type == "rect") rect(o.x, o.y, o.w, o.h);
  }

  if (nearest.x != -1 && nearest.y != -1) {
    noFill();
    stroke(222, 224, 227);
    ellipse(goal.x, goal.y, dist(nearest.x, nearest.y, goal.x, goal.y)*2, dist(nearest.x, nearest.y, goal.x, goal.y)*2);
    //text(dist(nearest.x, nearest.y, goal.x, goal.y)*2,700, 25); 
  }
  
  stroke(50, 50, 50);
  for(PVector p : bestRoute){
    //println("MazeRunner.draw", p, bestRoute.size()); //<>//
    point(p.x, p.y);
  }
  stroke(255, 87, 51);
  for(PVector p : furthestRoute){
    //println("MazeRunner.draw", p, furthestRoute.size());
    point(p.x, p.y);
  }
  
  stroke(0,0,0);

  if (test.allDotsDead()) {
    //genetic algorithm
    test.calculateFitness();
    test.naturalSelection();
    test.mutateDemBabies();
  } else {
    //if any of the dots are still alive then update and then show them
    test.update();
    test.show();
  }
}
