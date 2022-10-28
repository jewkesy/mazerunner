int x1,y1,x2,y2;
boolean boxing = false;

void keyPressed(){
  println("Key: "+ key);
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
  } else if (key == 's') {
    saveObsticles();
  } else if (key == 'l' || key == 'L') {
    loadObsticles(key);
  } else if (key == 'C') {
    clearObsticles();
  }
  mutationRate = abs(mutationRate);
}

void mousePressed(){
  boxing = true;
  x1 = x2 = mouseX;
  y1 = y2 = mouseY; 
}

void mouseDragged(){
  x2 = mouseX;
  y2 = mouseY;
  
  if (x2 < 0) x2 = 0;
  if (y2 < 0) y2 = 0;
  
  if (x2 > width) x2 = width;
  if (y2 > height) y2 = height;  
}

void mouseReleased() {  
  // handled drawing backwards
  int topLeftX = x1;
  if (x1 > x2) {topLeftX = x2; x2 = x1; x1 = topLeftX;}
  int topLeftY = y1;
  if (y1 > y2) {topLeftY = y2; y2 = y1; y1 = topLeftY;}

  int w = x2-x1;
  int h = y2-y1;
    
  if (w < 2) return;
  if (h < 2) return;
  
  boxing = false;
  Obsticle o = new Obsticle("rect", x1, y1, w, h);
  println(x1, y1, w, h);
  obsticles.add(o);
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
