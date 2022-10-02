class Dot {
  PVector pos;
  PVector vel;
  PVector acc;
  Brain brain;
  Collisions collision;

  ArrayList<PVector> route;
  ArrayList<PVector> furthestRoute;

  String id;
  boolean dead = false;
  boolean reachedGoal = false;
  boolean isBest = false; //true if this dot is the best dot from the previous generation
  boolean isTraveller = false; //true is this dot travelled the furthest from the previous generation
  float explorer = 0;
  float fitness = 0;
  int dotWidth = 4;
  
  /**
 * RandomStringFromSymbols
 * Create a random string from an explicit list of symbols
 * 2017-10-14 Jeremy Douglass - Processing 3.3.6
 * forum.processing.org/two/discussion/24536/creating-a-random-but-unique-string
 */
  StringList idList;
  int idLength = 10;
  char[] idSymbols = {
    '0','1','2','3','4','5','6','7','8','9',
    'a','b','c','d','e','f','g','h','i','j','k','l','m',
    'n','o','p','q','r','s','t','u','v','w','x','y','z',
    'A','B','C','D','E','F','G','H','I','J','K','L','M',
    'N','O','P','Q','R','S','T','U','V','W','X','Y','Z'
  };
  String createID(int length){
    String id = "";
    for (int i = 0; i < length - 1; i++){
      id = id + idSymbols[int(random(idSymbols.length))];
    }
    return id;
  }

  Dot() {
    brain = new Brain(brainSize); //new brain with 1000 instructions

    //start the dots at the bottom of the window with a no velocity or acceleration
    //pos = new PVector(width/2, height- 10);
    id = createID(idLength);
    pos = new PVector(750,750);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    route = new ArrayList<PVector>();
    furthestRoute = new ArrayList<PVector>();
  }

  //-----------------------------------------------------------------------------------------------------------------
  //draws the dot on the screen
  void show() {
    if (isBest) {
      //println("found best");
      fill(53, 249, 124); //if this dot is the best dot from the previous generation then draw it as a big green dot
      ellipse(pos.x, pos.y, dotWidth*2, dotWidth*2);
    } else if (isTraveller){ //<>//
      //println("found traveller");
      fill(249, 243, 152); //if this dot is the furthest dot from the start then draw it as a big yellow dot
      ellipse(pos.x, pos.y, dotWidth*2, dotWidth*2);
    } else {//all other dots are just smaller dots
      fill(10);
      ellipse(pos.x, pos.y, dotWidth, dotWidth);
    }
  }

  //-----------------------------------------------------------------------------------------------------------------------
  //moves the dot according to the brains directions
  void move(float bounceValX, float bounceValY) {

    if (brain.directions.length > brain.step) {//if there are still directions left then set the acceleration as the next PVector in the direcitons array
      acc = brain.directions[brain.step];
      brain.step++;
    } else {//if at the end of the directions array then the dot is dead
      dead = true;
    }

    //apply the acceleration and move the dot
    vel.add(acc);
    vel.limit(5);//not too fast
    vel.x = vel.x * bounceValX;
    vel.y = vel.y * bounceValY;
    pos.add(vel);
    route.add(new PVector(pos.x, pos.y));
    furthestRoute.add(new PVector(pos.x, pos.y));
    //println(vel.x, vel.y);
    //println("Dot.move", route.size(), route);
    //println("Dot.move", route.size());
  }
  
  // hit an obstacle, so bounce off
  void Bounce(float bounceValX, float bounceValY) {
    route.remove(route.size()-1);
    move(bounceValX, bounceValY);
  }

  //-------------------------------------------------------------------------------------------------------------------
  //calls the move function and check for collisions and stuff
  void update() {
    if (!dead && !reachedGoal) {
      move(1, 1);
      //if (pos.x < dotWidth || pos.y < dotWidth/2 || pos.x > width - dotWidth/2 || pos.y > height - dotWidth/2) { //if near the edges of the window then bounce off
      if (pos.x < dotWidth || pos.x > width - dotWidth) {
        //Bounce(-1, 1);
        dead = true;
      } else if (pos.y < dotWidth || pos.y > height - dotWidth) {
        dead = true;
        //Bounce(1, -1);
      } else if (collision.circleCircle(pos.x, pos.y, dotWidth/2, goal.x, goal.y, 10)) {
        reachedGoal = true;
      } else {
        for(Obsticle o : obsticles) {
          if (o.type == "rect")
            if (collision.circleRect(pos.x, pos.y, dotWidth, o.x, o.y, o.w, o.h)) {
              //Bounce(1, -1);
              dead = true;
            }
            if(pos.x > o.x && pos.x < o.x + o.w && pos.y > o.y && pos.y < o.y + o.h) {
              //the point is inside the rectangle
              dead = true;
            }
        
        }
      }
       
      if (pos.x > width || pos.x < 0) dead = true;
      if (pos.y > height || pos.y < 0) dead = true;
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
  
  void calculateExplorer() {
    float distanceFromStart = dist(pos.x, pos.y, 750, 750);
    explorer = distanceFromStart;
    //println(explorer);
  }

  //---------------------------------------------------------------------------------------------------------------------------------------
  //clone it 
  Dot gimmeBaby() {
    Dot baby = new Dot();
    baby.brain = brain.clone();//babies have the same brain as their parents
    return baby;
  }
}
