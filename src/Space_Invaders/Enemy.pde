//Enemy Class
class Enemy
{
  int index;
  
  float posX, posY;
  float xModifier;
  
  //Constructor used to create the object
  Enemy(float xMultiple, float yMultiple, int index, int speed)
  {
    //Store the index value so the bitmap array can be used
    this.index = index;
    
    /*
    The enemy's starting x and y position is calculated using these two equations
    This creates 4 rows with 9 aliens in each row
    */
    
    posX = 50 + 75*xMultiple;
    posY = 100 + 75*yMultiple;
    
    //Increase the movement speed of the aliens as the game progresses
    xModifier = 0.25 + speed;
  }
  
  //Draw an alien
  void drawEnemy()
  {
    fill(255,0,0);
    ellipse(posX,posY, 50, 50);
  }
  
  //Move an alien
  void moveEnemy()
  {
    posX += xModifier;
  }
  
  //Shift an alien down the screen
  void shiftDown()
  {
    xModifier *= -1;
    posY += 75;
  }
}