int x1,y1,x2,y2;
boolean boxing = false;

void keyPressed(){
  //println(key);
  if (key == ' ') {
    started = true;
    paused=!paused;
  } else if (key == '-' || key == '_' || (key == CODED && keyCode == DOWN)) {
    mutationRate -= 0.01;
    if (mutationRate <= 0) mutationRate = 0.01;
  } else if (key == '+' || key == '=' || (key == CODED && keyCode == UP)) {
    mutationRate += 0.01;
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
  obsticles.add(o);
}
