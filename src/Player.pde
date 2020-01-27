//Player class
class Player
{
  //Starting x and y coordinates of the player(they start at the middle of the screen)
  float posX= width/2 - 37.5;
  float posY = 575;
  
  float xModifier;
  
  //Draw the player
  void drawPlayer()
  {
    fill(255,255,255);
    
    rect(posX,posY,75,25);
  }
  
  //Move the player
  void movePlayer()
  {
    //Change the x position of the player to move them left or right
    posX += xModifier;
    
    /*
    These two if statements make sure the player
    does not go off the screen by creating boundries
    */
    
    //Right side boundry
    if (posX >= 725)
    {
      posX = 725;
    }
    
    //Left side boundry
    else if (posX <= 0)
    {
      posX = 0;
    }
  }
}