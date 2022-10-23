int x1,y1,x2,y2;
boolean boxing = false;

void keyPressed(){
  println(key);
  if (key == ' ') {
    started = true;
    paused=!paused;
  }
}

void mousePressed(){
  boxing = true;
  x1 = x2 = mouseX;
  y1 = y2 = mouseY; 
}
void mouseDragged(){
  x2 = mouseX;
  y2 = mouseY;
}
void mouseReleased() {  
  // handled drawing backwards
  int topLeftX = x1;
  if (x1 > x2) {topLeftX = x2; x2 = x1; x1 = topLeftX;}
  int topLeftY = y1;
  if (y1 > y2) {topLeftY = y2; y2 = y1; y1 = topLeftY;}
    
  boxing = false;
  Obsticle o = new Obsticle("rect", x1, y1, x2-x1, y2-y1);
  obsticles.add(o);
}
