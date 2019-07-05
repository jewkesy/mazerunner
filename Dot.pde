class Dot {
  PVector pos;
  PVector vel;
  PVector acc;
  Brain brain;
  Collisions collision;

  ArrayList<PVector> route;

  boolean dead = false;
  boolean reachedGoal = false;
  boolean isBest = false;//true if this dot is the best dot from the previous generation
  boolean isTraveller = false; //true is this dot travelled the furthest from the previous generation

  float fitness = 0;

  Dot() {
    brain = new Brain(1000);//new brain with 1000 instructions

    //start the dots at the bottom of the window with a no velocity or acceleration
    //pos = new PVector(width/2, height- 10);
    pos = new PVector(750,750);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    route = new ArrayList<PVector>();
  }


  //-----------------------------------------------------------------------------------------------------------------
  //draws the dot on the screen
  void show() {
    //if this dot is the best dot from the previous generation then draw it as a big green dot
   
    if (isBest) {
      //println("found best");
      fill(53, 249, 124);
      ellipse(pos.x, pos.y, 8, 8);
    } else if (isTraveller){
      //println("found traveller");
      fill(249, 243, 152);
      ellipse(pos.x, pos.y, 8, 8);
    } else {//all other dots are just smaller black dots
      fill(0);
      ellipse(pos.x, pos.y, 4, 4);
    }
  }

  //-----------------------------------------------------------------------------------------------------------------------
  //moves the dot according to the brains directions
  void move() {
    if (brain.directions.length > brain.step) {//if there are still directions left then set the acceleration as the next PVector in the direcitons array
      acc = brain.directions[brain.step];
      brain.step++;
    } else {//if at the end of the directions array then the dot is dead
      dead = true;
    }

    //apply the acceleration and move the dot
    vel.add(acc);
    vel.limit(5);//not too fast
    pos.add(vel);
    route.add(pos);
    //println(route);
  }

  //-------------------------------------------------------------------------------------------------------------------
  //calls the move function and check for collisions and stuff
  void update() {
    if (!dead && !reachedGoal) {
      move();
      if (pos.x< 2|| pos.y<2 || pos.x>width-2 || pos.y>height -2) {//if near the edges of the window then kill it 
        dead = true;
      } else if (collision.circleCircle(pos.x, pos.y, 2, goal.x, goal.y, 5)) {
        reachedGoal = true;
      } else {
        for(Obstacle o : obsticles) {
          if (o.type == "rect")
            if (collision.circleRect(pos.x, pos.y, 4, o.x, o.y, o.w, o.h))
              dead = true;
        }
      }
    }
  }



  //--------------------------------------------------------------------------------------------------------------------------------------
  //calculates the fitness
  void calculateFitness() {
    if (reachedGoal) {//if the dot reached the goal then the fitness is based on the amount of steps it took to get there
      fitness = 1.0/16.0 + 10000.0/(float)(brain.step * brain.step);
    } else {//if the dot didn't reach the goal then the fitness is based on how close it is to the goal
      float distanceToGoal = dist(pos.x, pos.y, goal.x, goal.y);
      fitness = 1.0/(distanceToGoal * distanceToGoal);
    }
  }

  //---------------------------------------------------------------------------------------------------------------------------------------
  //clone it 
  Dot gimmeBaby() {
    Dot baby = new Dot();
    baby.brain = brain.clone();//babies have the same brain as their parents
    return baby;
  }
}
