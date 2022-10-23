// http://www.jeffreythompson.org/collision-detection/


static class Collisions {
  // CIRCLE/CIRCLE
  static boolean circleCircle(float c1x, float c1y, float c1r, float c2x, float c2y, float c2r) {
  
    // get distance between the circle's centers
    // use the Pythagorean Theorem to compute the distance
    float distX = c1x - c2x;
    float distY = c1y - c2y;
    float distance = sqrt( (distX*distX) + (distY*distY) );
  
    // if the distance is less than the sum of the circle's
    // radii, the circles are touching!
    if (distance <= c1r+c2r) {
      return true;
    }
    return false;
  }
  
  // CIRCLE/RETANGLE
  static boolean circleRect(float cx, float cy, float radius, float rx, float ry, float rw, float rh) {
  
    // temporary variables to set edges for testing
    float testX = cx;
    float testY = cy;
  
    // which edge is closest?
    if (cx < rx)         testX = rx;      // test left edge
    else if (cx > rx+rw) testX = rx+rw;   // right edge
    if (cy < ry)         testY = ry;      // top edge
    else if (cy > ry+rh) testY = ry+rh;   // bottom edge
  
    // get distance from closest edges
    float distX = cx-testX;
    float distY = cy-testY;
    float distance = sqrt( (distX*distX) + (distY*distY) );
  
    // if the distance is less than the radius, collision!
    if (distance <= radius) {
      return true;
    }
    return false;
  }
  
  // LINE/CIRCLE
  static boolean lineCircle(float x1, float y1, float x2, float y2, float cx, float cy, float r) {

    // is either end INSIDE the circle?
    // if so, return true immediately
    boolean inside1 = pointCircle(x1,y1, cx,cy,r);
    boolean inside2 = pointCircle(x2,y2, cx,cy,r);
    if (inside1 || inside2) return true;
    
    // get length of the line
    float distX = x1 - x2;
    float distY = y1 - y2;
    float len = sqrt( (distX*distX) + (distY*distY) );
  
    // get dot product of the line and circle
    float dot = ( ((cx-x1)*(x2-x1)) + ((cy-y1)*(y2-y1)) ) / pow(len,2);
  
    // find the closest point on the line
    float closestX = x1 + (dot * (x2-x1));
    float closestY = y1 + (dot * (y2-y1));
    
    // is this point actually on the line segment?
    // if so keep going, but if not, return false
    boolean onSegment = linePoint(x1,y1,x2,y2, closestX,closestY);
    if (!onSegment) return false;
  
    // optionally, draw a circle at the closest point on the line
    //fill(255,0,0);
    //noStroke();
    //ellipse(closestX, closestY, 20, 20);
  
    // get distance to closest point
    distX = closestX - cx;
    distY = closestY - cy;
    float distance = sqrt( (distX*distX) + (distY*distY) );
  
    if (distance <= r) {
      return true;
    }
    return false;
  }
  
  // POINT/CIRCLE
  static boolean pointCircle(float px, float py, float cx, float cy, float r) {
  
    // get distance between the point and circle's center
    // using the Pythagorean Theorem
    float distX = px - cx;
    float distY = py - cy;
    float distance = sqrt( (distX*distX) + (distY*distY) );
  
    // if the distance is less than the circle's
    // radius the point is inside!
    if (distance <= r) {
      return true;
    }
    return false;
  }
  
  // LINE/POINT
  static boolean linePoint(float x1, float y1, float x2, float y2, float px, float py) {
  
    // get distance from the point to the two ends of the line
    float d1 = dist(px,py, x1,y1);
    float d2 = dist(px,py, x2,y2);
  
    // get the length of the line
    float lineLen = dist(x1,y1, x2,y2);
  
    // since floats are so minutely accurate, add
    // a little buffer zone that will give collision
    float buffer = 0.1;    // higher # = less accurate
  
    // if the two distances are equal to the line's
    // length, the point is on the line!
    // note we use the buffer here to give a range,
    // rather than one #
    if (d1+d2 >= lineLen-buffer && d1+d2 <= lineLen+buffer) {
      return true;
    }
    return false;
  }
  
  // LINE/LINE
  static boolean lineLine(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {
  
    // calculate the distance to intersection point
    float uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
    float uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
  
    // if uA and uB are between 0-1, lines are colliding
    if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
  
      // optionally, draw a circle where the lines meet
      //float intersectionX = x1 + (uA * (x2-x1));
      //float intersectionY = y1 + (uA * (y2-y1));
      //fill(255,0,0);
      //noStroke();
      //ellipse(intersectionX,intersectionY, 20,20);
  
      return true;
    }
    return false;
  }
  
  // LINE/RECTANGLE
  static boolean lineRect(float x1, float y1, float x2, float y2, float rx, float ry, float rw, float rh) {
  
    // check if the line has hit any of the rectangle's sides
    // uses the Line/Line function below
    boolean left =   lineLine(x1,y1,x2,y2, rx,ry,rx, ry+rh);
    boolean right =  lineLine(x1,y1,x2,y2, rx+rw,ry, rx+rw,ry+rh);
    boolean top =    lineLine(x1,y1,x2,y2, rx,ry, rx+rw,ry);
    boolean bottom = lineLine(x1,y1,x2,y2, rx,ry+rh, rx+rw,ry+rh);
  
    // if ANY of the above are true, the line
    // has hit the rectangle
    if (left || right || top || bottom) {
      return true;
    }
    return false;
  }
  
  // POLYGON/POINT
  static boolean polyPoint(PVector[] vertices, float px, float py) {
    boolean collision = false;
  
    // go through each of the vertices, plus
    // the next vertex in the list
    int next = 0;
    for (int current=0; current<vertices.length; current++) {
  
      // get next vertex in list
      // if we've hit the end, wrap around to 0
      next = current+1;
      if (next == vertices.length) next = 0;
  
      // get the PVectors at our current position
      // this makes our if statement a little cleaner
      PVector vc = vertices[current];    // c for "current"
      PVector vn = vertices[next];       // n for "next"
  
      // compare position, flip 'collision' variable
      // back and forth
      if (((vc.y >= py && vn.y < py) || (vc.y < py && vn.y >= py)) &&
           (px < (vn.x-vc.x)*(py-vc.y) / (vn.y-vc.y)+vc.x)) {
              collision = !collision;
      }
    }
    return collision;
  }
  
  // POLYGON/CIRCLE
  static boolean polyCircle(PVector[] vertices, float cx, float cy, float r) {
  
    // go through each of the vertices, plus
    // the next vertex in the list
    int next = 0;
    for (int current=0; current<vertices.length; current++) {
  
      // get next vertex in list
      // if we've hit the end, wrap around to 0
      next = current+1;
      if (next == vertices.length) next = 0;
  
      // get the PVectors at our current position
      // this makes our if statement a little cleaner
      PVector vc = vertices[current];    // c for "current"
      PVector vn = vertices[next];       // n for "next"
  
      // check for collision between the circle and
      // a line formed between the two vertices
      boolean collision = lineCircle(vc.x,vc.y, vn.x,vn.y, cx,cy,r);
      if (collision) return true;
    }
  
    // the above algorithm only checks if the circle
    // is touching the edges of the polygon – in most
    // cases this is enough, but you can un-comment the
    // following code to also test if the center of the
    // circle is inside the polygon
  
    // boolean centerInside = polygonPoint(vertices, cx,cy);
    // if (centerInside) return true;
  
    // otherwise, after all that, return false
    return false;
  }

}
