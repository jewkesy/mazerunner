Population test;
PVector goal  = new PVector(750, 50);
PVector nearest = new PVector(-1, -1);

void setup() {
  size(800, 800); //size of the window
  frameRate(100);//increase this to make the dots go faster, default is 100
  test = new Population(2000);//create a new population with 1000 members
}

Obstacle[] obsticles = new Obstacle[] {
  new Obstacle("rect", 0, 300, 600, 10), 
  new Obstacle("rect", 200, 500, 600, 10),
  new Obstacle("rect", 200, 100, 700, 10), 
} ;

void draw() { 
  background(255);
  stroke(0,0,0);
  //draw goal
  fill(249, 83, 53);
  ellipse(goal.x, goal.y, 10, 10);
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
