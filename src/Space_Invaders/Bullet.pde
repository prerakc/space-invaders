//Bullet class
class Bullet
{
  //The x and y coordinates of the Bullet object are the same as those of the player when they shoot
  float posX = player.posX + 37.5;
  float posY = player.posY + 37.5;
  
  //Draw a bullet
  void drawBullet()
  {
    fill(0,0,255);
    ellipse(posX,posY, 20, 20);
  }
  
  //Move a bullet up the screen
  void moveBullet()
  {
    posY -= 5;
  }
  
  /*
  Function that returns a boolean value when checking to see
  if collision occurs between a player bullet and an alien
  */
  
  boolean detectCollision(Enemy enemy)
  {
    float distance = dist(posX, posY, enemy.posX, enemy.posY);
    
    if (distance <= 35)
    {
      return true;
    }
    
    else
    {
      return false;
    }
  }
}