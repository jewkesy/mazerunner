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
}
