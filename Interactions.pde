int x1,y1,x2,y2;
boolean mPressed = false;
boolean kShift = false;
boolean boxing = false;

void keyPressed(){
  println("Key: "+ key + " " + keyCode);
  if (key == ' ') {
    started = true;
    paused=!paused;
  } else if (key == '-' || key == '_' || (key == CODED && keyCode == DOWN)) {
    if (mutationRate <= 0.01) {
      mutationRate -= 0.0025;
    } else {
      mutationRate -= 0.01;
    }
    if (mutationRate <= 0) mutationRate = 0.01;
  } else if (key == '+' || key == '=' || (key == CODED && keyCode == UP)) {
    mutationRate += 0.01;
  } else if (key == 'p') {
    dotPoV = !dotPoV;
  } else if (key == 'r') {
     createRandomObsticles();
  } else if (key == 's') {
    saveObsticles();
  } else if (key == 'l' || key == 'L') {
    loadObsticles(key);
  } else if (key == 'C') {
    clearObsticles();
  } else if (key == CODED && keyCode == SHIFT) {
    kShift = true;
  }
  mutationRate = abs(mutationRate);
}

void keyReleased() {
  if (key == CODED && keyCode == SHIFT) kShift = false;
}


void mousePressed(){
  mPressed = true;
  boxing = true;
  x1 = x2 = mouseX;
  y1 = y2 = mouseY; 
}

void mouseDragged(){
  println("Key: "+ key + " " + keyCode);
  x2 = mouseX;
  y2 = mouseY;
  
  if (x2 < 0) x2 = 0;
  if (y2 < 0) y2 = 0;
  
  if (x2 > width) x2 = width;
  if (y2 > height) y2 = height;  
}

void mouseReleased() {
  mPressed = false;
  // handled drawing backwards
  int topLeftX = x1;
  if (x1 > x2) {topLeftX = x2; x2 = x1; x1 = topLeftX;}
  int topLeftY = y1;
  if (y1 > y2) {topLeftY = y2; y2 = y1; y1 = topLeftY;}

  int w = x2-x1;
  int h = y2-y1;
    
  if (w < 2) return;
  if (h < 2) return;
  println("mouseReleased", x1, y1, w, h);
  
  boxing = false;
  
  if (kShift) obsticles.add(new Obsticle("circle", x1, y1, w, h));
  else obsticles.add(new Obsticle("rect", x1, y1, w, h));

}

void createRandomObsticles() {
  clearObsticles();

  ArrayList<Obsticle> circles = new ArrayList<Obsticle>();
  ArrayList<PVector> points = new ArrayList<PVector>();

  circles.add(new Obsticle("circle", (int)goal.x, (int)goal.y, (int)goal.z*4, (int)goal.z*4));
  circles.add(new Obsticle("circle", (int)startingLine.x, (int)startingLine.y, (int)goal.z*4, (int)goal.z*4));
  points.add(new PVector(goal.x, goal.y, goal.z*4));
  points.add(new PVector(startingLine.x, startingLine.y, goal.z*4));
  var o = ceil(random(50, 120));
  var buffer = ceil(random(2, 5));
  var protection = 0;
  
  while (points.size() < o) {
    int x = (int)random(width);
    int y = (int)random(height);
    int r = (int)random(6, 72);

    Obsticle circle = new Obsticle("circle", x, y, r*2, r*2);
    PVector point = new PVector(x, y, r);
    var overlapping = false;

    for(PVector p : points) {
      var d = dist(point.x, point.y, p.x, p.y);
      if (d < (r + p.z + buffer)) overlapping = true;
    }
    if (!overlapping) {
        points.add(point);
        obsticles.add(circle);
      }
    
    protection++;
    if (protection > 10000) break;
  }
}

void saveObsticles() {
  if (obsticles.size() == 0) return;
  JSONArray values = new JSONArray();
  
  int idx = 0;
  for(Obsticle o : obsticles) {
    JSONObject ob = new JSONObject();
    ob.setString("type", o.type);
    ob.setInt("x", o.x);
    ob.setInt("y", o.y);
    ob.setInt("w", o.w);
    ob.setInt("h", o.h);
    values.setJSONObject(idx, ob);
    idx++;
  }
  saveJSONArray(values, "data/obsticles.json");
  println("Saved!");
}

void loadObsticles(char keyP) {
  if (keyP == 'L') clearObsticles();
  
  JSONArray values = loadJSONArray("data/obsticles.json");

  for (int i = 0; i < values.size(); i++) {
    JSONObject ob = values.getJSONObject(i); 
    Obsticle o = new Obsticle(ob.getString("type"), ob.getInt("x"), ob.getInt("y"), ob.getInt("w"), ob.getInt("h"));
    obsticles.add(o);
  }
  println("Loaded!");
}

void clearObsticles() {
  obsticles = new ArrayList<Obsticle>();
}
