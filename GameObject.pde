class GameObject {
  //custom rectangle courtesy of Shiffman, henceforth will be called GameObject
  float x;
  float y;
  float w;
  float h;
  
  GameObject(float x, float y, float w, float h)
  {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  boolean intersects(GameObject other) {
    float left = x;
    float right = x + w;
    float top = y;
    float bottom = y + h;

    float otherLeft = other.x;
    float otherRight = other.x + other.w;
    float otherTop = other.y;
    float otherBottom = other.y + other.h;
    //function to check if any of the game object's sides are touching or intersecting another game object's sides
    return !(left >= otherRight || right <= otherLeft || top >= otherBottom || bottom <= otherTop);
  }
}
