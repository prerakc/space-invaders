/*
Author: Prerak Chaudhari
Date: May 1, 2017

This program is a remake of Space Invaders.
Kill all of the aliens before they reach the green line.
You have a limited number of lives.
Once you lose all your lives, it's game over.

The left and right arrow keys are used to move the player.
The spacebar is used to shoot bullets at the aliens.
*/

//Create object and arrays
Player player;
ArrayList<Bullet> bullets;
ArrayList<Bomb> bombs;
ArrayList<Enemy> enemies;
int[] enemyLives;

//Variables to hold statistics
int score, numLives, increaseSpeed;

//Varaibles to go to the main menu and play the game
boolean initalMenu;
boolean runGame;

void setup()
{ 
  //Menu menu can be accessed but the game can not be played
  initalMenu = true;
  runGame = false;
  
  //Screen size is set to 800x600 with a black background
  size(800,600);
  background(0,0,0);
  
  //Instantiate objects and arrays
  player = new Player();
  bullets = new ArrayList<Bullet>();
  bombs = new ArrayList<Bomb>();
  enemies = new ArrayList<Enemy>();
  enemyLives = new int[36];
  
  //Generate set of aliens
  generateAliens();
  
  //Set values to the statistic variables
  score = 0;
  numLives = 3;
  increaseSpeed = 0;
}

void draw()
{ 
  //If the game can be played
  if (runGame)
  {
    clear();
    
    fill(0,255,0);
    rect(0,500, width, 5);
    
    //If all the enemies are killed
    if (enemies.size() == 0)
    {
      //Give player one more life and increase alien movement speed
      numLives++;
      increaseSpeed += 0.1;
      
      //Generate new set of aliens
      generateAliens();
    }
 
    //Call functions to play game
    handleStats();
    handlePlayer();
    handleEnemies();
    handlePlayerBullets(); 
    handleEnemyBombs();
  }
  
  //If the game can not be played
  else
  {
    //If the main menu can be accessed
    if (initalMenu)
    { 
      //Go to the main menu
      mainMenu();
    }
    
    //If the player loses
    else
    {
      //Go to the game over screen
      clear();
      gameOver();
    }
  }
}

void keyPressed()
{
  //If LEFT ARROW is pressed
  if (keyCode == LEFT )
  {
    //Go left 5 pixels
    player.xModifier = -5;
  }
  
  //If RIGHT ARROW is pressed
  else if (keyCode == RIGHT)
  {
    //Go right 5 pixels
    player.xModifier = 5;
  }
  
  //If SPACE BAR is pressed
  else if (key == ' ')
  {
    //Make sure that a bullet does not already exsist
    if (bullets.size() == 0)
    {
      //Create a new bullet object
      bullets.add(new Bullet());
    }
  }
  
  //If ENTER is pressed
  else if (keyCode == ENTER)
  {
    //If user is at the main menu
    if (initalMenu == true)
    {
      //Allow the game to be run in the next loop iteration
      initalMenu = false;
      runGame = true;
    }
    
    //If player restarts the game at the game over screen
    else if (runGame == false)
    {
      //Go to the main menu in the next iteration
      clear();  
      initalMenu = true;
      
      //Remove any remaining enemies
      for (int i = enemies.size() - 1 ; i >= 0 ; i--)
      {
        enemies.remove(i);
      }
      
      //Reset values
      score = 0;
      numLives = 3;
      increaseSpeed = 0;
      
      //Generate new set of aliens
      generateAliens();
    }
  }
}

void keyReleased()
{
  /*
  Once the player stops pressing the LEFT or RIGHT ARROW keys,
  stop moving them
  */
  
  if (keyCode == LEFT || keyCode == RIGHT)
  {
    player.xModifier = 0;
  }
}

//Parent function to handle the player
void handlePlayer()
{
  //Move and draw player
  player.drawPlayer();
  player.movePlayer();
}

//Parent function to handle the player's bullets
void handlePlayerBullets()
{
  //Go through the bullet array and select the bullet object
  for (int i = 0 ; i < bullets.size() ; i++)
  {
    Bullet bullet = bullets.get(i);
    
    //Remove the bullet object once it goes off screen
    if (bullet.posY < -20)
    {
      bullets.remove(i);
    }
    
    //If the bullet is still on the screen then..
    else
    {
      //Draw and move the bullet
      bullet.drawBullet();
      bullet.moveBullet();
      
      //Run a for loop to check the bullet against every alien
      for (int j = 0 ; j < enemies.size(); j++)
      {
        //Check if the bullet hits an alien
        if (bullet.detectCollision(enemies.get(j)) == true)
        {
          
          /*
          Set a value in the bitmap array 'enemyLives' to zero,
          by using the index contained in the enemy object
          */
          
          enemyLives[enemies.get(j).index] = 0;
          
          //Remove the bullet and alien and give the player 1 point
          bullets.remove(i);
          enemies.remove(j);
          score++;
          break;
        }
      }
    }
  }
}

void handleEnemies()
{
  //Aliens can't shift down naturally
  boolean shiftDown = false;
  
  //Draw and move every alien using a foor loop
  for (int i = enemies.size()-1 ; i >= 0 ; i--)
  {
    Enemy enemy = enemies.get(i);
    enemy.drawEnemy();
    enemy.moveEnemy();
    
    /*
    
    */
    
    //If an alien gets too close
    if (enemy.posY >= 500)
    {
      /*
      Set runGame to false, calling the game over screen
      in the next iteration
      */
      
      clear();
      runGame = false;
      break;
    }
    
    //If an alien hits one of the horizontal boundries
    if (enemy.posX >= 750 || enemy.posX <= 50)
    {
      //Allow aliens to shift down
      shiftDown = true;
    }
  }
  
  //If aliens can shift down
  if (shiftDown)
  {
    //Shift every alien down using a for loop
    for (int i = enemies.size()-1 ; i >= 0 ; i--)
    {
      Enemy enemy = enemies.get(i);
      enemy.shiftDown();
    }
  }
}

//Parent function to handle alien bombs
void handleEnemyBombs()
{
  //If a bomb object does not already exist
  if (bombs.size() == 0)
  {
    //Create and instantiate an array to hold possible bitmap index values
    int[] possibleIndexs = new int[9];
    
    //Create a counter variable and set it to 0
    int counter = 0;
    
    //Check every alien object to see if it can shoot using a for loop
    for (int i = 0 ; i <= enemyLives.length - 1 ; i++)
    {   
      //If the alien is alive
      if (enemyLives[i] == 1)
      {
        //If the alien is in the first row
        if (i >= 0 && i <= 8 && enemyLives[i+9] == 0 && enemyLives[i+18] == 0 && enemyLives[i+27] == 0)
        {
          possibleIndexs[counter] = i;
          counter++;
        }
        
        //If the alien is in the second row
        else if (i >= 9 && i <= 17 && enemyLives[i+9] == 0 && enemyLives[i+18] == 0)
        {
          possibleIndexs[counter] = i;
          counter++;
        }
        
        //If the alien is in the third row
        else if (i >= 18 && i <= 26 && enemyLives[i+9] == 0)
        {
          possibleIndexs[counter] = i;
          counter++;
        }
        
        //If the alien is in the fourth row
        else if (i >= 27 && i <= 35)
        {
          possibleIndexs[counter] = i;
          counter++;
        }
      }
    }
    
    //Choose one of the possible indexs randomly
    int chosenIndex = possibleIndexs[int(random(0,9))];
    
    //Use a for loop to find the enemy object that contains the same index value
    for (int j = 0 ; j <= enemies.size() -1 ; j++)
    {
      //If the indexs are the same then generate a new bomb object
      if (enemies.get(j).index == chosenIndex)
      {
        bombs.add(new Bomb(enemies.get(j)));
        break;
      }
    }
  }
  
  //If there is already a bomb object
  else
  {
    //Go through the bomb array and select the bomb object
    for (int j = 0 ; j < bombs.size() ; j++)
    {
      Bomb bomb = bombs.get(j);
      
      //Remove the bomb object from the array if it is off the screen
      if (bomb.posY > 620)
      {
        bombs.remove(j);
      }
      
      else
      {
        //Draw and move bomb
        bomb.drawBomb();
        bomb.moveBomb();
        
        //Check to see if the bomb object collides with the player
        if (bomb.detectCollision(player) == true)
        {
          /*
          Remove the bomb object, decrease the number of lives by 1,
          and move the player to the middle of the screen
          */
          
          bombs.remove(j);
          numLives--;
          
          player.posX = width/2 - 37.5;
          
          //Check to see if the player has any remaining lives
          if (numLives == 0)
          {
            //Allow the game over screen to occur during the next iteration
            runGame = false;
          }
          
          //Delay the program by 1 second to allow the player to see what hit them
          delay(1000);
          
          break;
        }
      }
    }
  }
}

//Function to generate a complete set of aliens
void generateAliens()
{
  //Reset bitmap array and set every value to 1
  for (int i = 0 ; i <= 35 ; i++)
  {
    enemyLives[i] = 1;
  }
  
  //Counter used to store index value of each object for the bitmap array
  int counter = 0;
  
  //Double for loop to generate 36 aliens(9x4)
  for (int i = 0 ; i < 4 ; i++)
  {
    for (int j = 0 ; j < 9 ; j++)
    {
      enemies.add(new Enemy(j,i, counter, increaseSpeed));
      counter++;
    }
  }
}

//Function to display the score and number of lives
void handleStats()
{
  fill(255,255,255);
  textSize(20);
  text("Score: " + score, width-125,25);
  text("Lives: " + numLives, width-125,50);
}

//Function to display the main menu
void mainMenu()
{
  fill(255,0,0);
  textSize(72);
  text("SPACE INVADERS", width/2 - 289.5, height/2 - 100);
  
  fill(255,255,255);
  textSize(24);
  text("Use the left and right arrows to move", width/2 - 225, height/2);
  text("Use the spacebar to shoot", width/2 - 162.5, height/2 + 25);
  text("Press Enter to continue", width/2 - 145, height/2 + 150);
}

//Function to display the game over screen
void gameOver()
{
  fill(255,0,0);
  textSize(72);
  text("GAME OVER", width/2 - 212.5, height/2 - 100);
  
  fill(255,255,255);
  textSize(24);
  text("Score: " + score, width/2 - 62.5, height/2);
  text("Press Enter to restart", width/2 - 130, height/2 + 100);
}