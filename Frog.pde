class Frog extends Rectangle{
  //inheritence! Am I learning object-oriented programming?
  
  Log attached = null;
  
  Frog(float x, float y, float w, float h){
    super(x,y,w,h); //inherits the Rectangle's constructor 
  }
  
  void show(){
    fill(255);
    rect(x, y, w, h);
  }
  
  void attach(Log log){
   attached = log; 
  }
  
  void update(){
    if(attached != null){
      frog.x += attached.speed;
    }
    
    frog.x = constrain(x,0, width-w);
    
  }
  
  void move(float xdir, float ydir){
    //only need to modify it's left and top values to move the whole frog. Multiply by grid
    x += xdir * grid;
    y += ydir * grid;
  }
  
}
