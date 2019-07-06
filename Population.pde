class Population {
  Dot[] dots;

  float fitnessSum;
  int gen = 1;

  int bestDot = 0;//the index of the best dot in the dots[]
  int travellerDot = 0; // the index of the furthest travelling dot

  int minStep = 1000;

  Population(int size) {
    dots = new Dot[size];
    for (int i = 0; i< size; i++) {
      dots[i] = new Dot();
    }
  }


  //------------------------------------------------------------------------------------------------------------------------------
  //show all dots
  void show() {
    for (int i = 1; i< dots.length; i++) {
      dots[i].show();
    }
    dots[0].show();
  }

  //-------------------------------------------------------------------------------------------------------------------------------
  //update all dots 
  void update() {
    for (int i = 0; i< dots.length; i++) {
      if (dots[i].brain.step > (minStep)) {//if the dot has already taken more steps than the best dot has taken to reach the goal
        dots[i].dead = true;//then it dead
      } else {
        //println(dots[i].dead);
        //if (dots[i].dead){
        //  for (int j = 0; j< dots.length; j++) {
        //    println(dots[i].id, dots[j].id);
        //    if (dots[i].id == dots[j].id) continue;
        //    if (!dots[j].dead) continue;
        //    if (dots[i].dead && dots[j].dead) {
        //      //dots[i].dead = false;
        //    }
        //  }
        //}
        dots[i].update();
      }
    }
  }

  boolean corpseHere(int x, int y) {
    return false;
  }

  //-----------------------------------------------------------------------------------------------------------------------------------
  //calculate all the fitnesses
  void calculateFitness() {
    for (int i = 0; i< dots.length; i++) {
      dots[i].calculateFitness();
    }
  }

  //------------------------------------------------------------------------------------------------------------------------------------
  //returns whether all the dots are either dead or have reached the goal
  boolean allDotsDead() {
    for (int i = 0; i< dots.length; i++) {
      if (!dots[i].dead && !dots[i].reachedGoal) { 
        return false;
      }
    }
    return true;
  }

  //gets the next generation of dots
  void naturalSelection() {
    Dot[] newDots = new Dot[dots.length];//next gen
    setBestDot();
    calculateFitnessSum();

    newDots[0] = dots[bestDot].gimmeBaby(); //the champion lives on 
    newDots[0].isBest = true;
    newDots[1] = dots[travellerDot].gimmeBaby(); //the traveller lives on 
    newDots[1].isTraveller = true;

    for (int i = 2; i< newDots.length; i++) {
      //select parent based on fitness
      Dot parent = selectParent();

      //get baby from them
      newDots[i] = parent.gimmeBaby();
    }

    dots = newDots.clone();
    gen ++;
    //if (gen > 2) {exit();}
    generationVal = gen;
  }

  //--------------------------------------------------------------------------------------------------------------------------------------
  //you get it
  void calculateFitnessSum() {
    fitnessSum = 0;
    for (int i = 0; i< dots.length; i++) {
      fitnessSum += dots[i].fitness;
    }
  }

  //-------------------------------------------------------------------------------------------------------------------------------------

  //chooses dot from the population to return randomly(considering fitness)

  //this function works by randomly choosing a value between 0 and the sum of all the fitnesses
  //then go through all the dots and add their fitness to a running sum and if that sum is greater than the random value generated that dot is chosen
  //since dots with a higher fitness function add more to the running sum then they have a higher chance of being chosen
  Dot selectParent() {
    float rand = random(fitnessSum);
    float runningSum = 0;

    for (int i = 0; i< dots.length; i++) {
      runningSum+= dots[i].fitness;
      if (runningSum > rand) {
        return dots[i];
      }
    }

    //should never get to this point
    return null;
  }

  //------------------------------------------------------------------------------------------------------------------------------------------
  //mutates all the brains of the babies
  void mutateDemBabies() {
    for (int i = 1; i< dots.length; i++) {
      dots[i].brain.mutate();
    }
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------
  //finds the dot with the highest fitness and sets it as the best dot
  //finds the dot who like to travel and puts that into the genetic pool
  void setBestDot() {
    float max = 0;
    int maxIndex = 0;
    float traveller = 0;
    int travellerIndex = 0;
    
    for (int i = 0; i< dots.length; i++) {
      if (dots[i].fitness > max) {
        max = dots[i].fitness;
        maxIndex = i;
      }
      
      if (dots[i].route.size() > traveller) {
        traveller = dots[i].route.size();
        travellerIndex = i;
      }
    }

    bestDot = maxIndex;
    travellerDot = travellerIndex;
    //Dot d = dots[bestDot];
    //Dot t = dots[travellerDot];
    bestRoute = dots[bestDot].route;
    furthestRoute = dots[travellerDot].furthestRoute;
    //println("Population.setBestDot", bestRoute.size()); //<>//
    
    nearest.x = dots[bestDot].pos.x;
    nearest.y = dots[bestDot].pos.y;
    bestStepCount = dots[bestDot].brain.step;
    //if this dot reached the goal then reset the minimum number of steps it takes to get to the goal
    if (dots[bestDot].reachedGoal) {
      minStep = dots[bestDot].brain.step;
      
      //println("Generation: ", gen+1, "step:", minStep);
    } else {
      //println("Generation: ", gen+1);
    }
  }
}
