//Bomb class
class Bomb
{
  float posX;
  float posY;
  
  //Constructor to create the object
  Bomb(Enemy enemy)
  {
    //The x and y coordinates of the Bomb object are the same as those of the alien that is shooting
    posX = enemy.posX;
    posY = enemy.posY;
  }
  
  //Draw a bomb
  void drawBomb()
  {
    fill(0,0,255);
    ellipse(posX,posY, 20, 20);
  }
  
  //Move a bomb down a screen
  void moveBomb()
  {
    posY += 5;
  }
  
  /*
  Function that returns a boolean value when checking to see
  if collision occurs between an alien bomb and the player
  */
  
  boolean detectCollision(Player player)
  {
    if (posY == player.posY && posX >= player.posX  && posX <= player.posX + 75)
    {
      return true;
    }
    
    else
    {
      return false;
    }
  }
}