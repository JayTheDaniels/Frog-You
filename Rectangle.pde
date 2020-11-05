class Rectangle {
  //custom rectangle courtesy of Shiffman
  float x;
  float y;
  float w;
  float h;

  Rectangle(float x, float y, float w, float h)
  {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  boolean intersects(Rectangle other) {
    float left = x;
    float right = x + w;
    float top = y;
    float bottom = y + h;

    float otherLeft = other.x;
    float otherRight = other.x + other.w;
    float otherTop = other.y;
    float otherBottom = other.y + other.h;
    //function to check if any of the rectangle's sides are touching or intersecting another rectangle's sides
    return !(left >= otherRight || right <= otherLeft || top >= otherBottom || bottom <= otherTop);
  }
}
