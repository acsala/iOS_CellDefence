iOS_CellDefence
===============

The player, controlling an immune cell, must engulf infester viruses (by shooting acid at them),
which enter the playfield from the top of the screen. The viruses attempt to insert their DNA into
the cell in the organism. The viruses can destroy the immune cell as well.
A level is completed when the player destroys all viruses,
but the game ends if the immune cell is corrupted.

List of features:
<ul><i>
<li>player has to register and log in to use the game (no email address is neaded)</li>
<li>user has to control an unite of immune cell by tapping on the screen</li>
<li>user has to try to destroy the viruses by firing on them</li>
<li>viruses move around the screen and trying to insert their viral DNA into cells</li>
<li>user loses life if a virus hits the lysosome</li>
<li>player scores by destroying viruses</li>
<li>player lose score if virus destroys a cell</li>
<li>in the end of the game, high score is available</li>
<li>high score is implemented in the cloud, player can compete with other players</li>
</ul>

Technologies implemented:
<ul><i>
<li>iOS 7, XCode 5</li>
<li>SpriteKit</li>
<li>KiiCloud</li>
</ul>

Mockup:
<img src="/image.jpg" alt="Mockup">

Design document of Hangman
=============

- a list of database tables and fields (and their types) that you’ve decided to implement;

- a list of classes and methods (and their return types and/or arguments) that you’ve decided to implement;

- photos of whiteboard drawings;

- more advanced sketches of UIs.

# Section 1 – Purpose of project/sub-system
The app has to implement all the features that the player could encounter during playing Cell Defence.
<br>About the game:
The player, controlling a lysosome, must engulf infester viruses (by shooting at them),
which enter the playfield from the top of the screen.
The viruses attempt to insert their DNA into other cells.
The viruses can destroy the lysosome as well. A level is completed when the player destroys all viruses.

# Section 2 – List of database tables and fields

No databases are going to be implemented, scores and settings are going to be stored in the cloud via KiiCloud.
    
# Section 3 – A list of models and actions

The view of the game is going to be built in a storyboard. Two viewcontrollers are plant to be implemented;
one for the leaderboard, and one for the gameplay. The lysosome, controlled by the player,
and the viruses will have similar properties, they will be able to move around a map in vertical and
horizontal directions, able to shoot at other objects, and can be destroyed by other objects by got hit.
Therefor these attributes are going to implemented in a separate model. Futhermore the attributes of the map will be
placed in a model. These models will communicate with the view through viewcontrollers.

<ul>
<li>Storyboard</li>
<li>GameViewController</li>
<li>LeaderboardViewController</li>
<li>InGameScreen</li>
<li>Microbe</li>
<li>Level</li>
<li>Object</li>
<li>Cell</li>
</ul>

GameViewController
<ul>
<li>View controller for main menu, gameplay will be embedded here. DidLoad envokes the login screen where a player can log in so the highscores can be updated accordingly.</li>
</ul>

InGameScreen
<ul>
<li>Sprite Kit class, it will make properties of models Microbe and Level as sprites, take care of the physics and animation of the game plus the gameplay logic will be placed here as well</li>
</ul>


Microbe
<ul>
<li>Class for the player and the opponents, methodes for moving, shooting, keeping track of the position etc</li>
</ul>

Level
<ul>
<li>Class for Levels, represents the map on methodes in it to build up a level from objects</li>
</ul>

Cell
<ul>
<li>Class for cells that can be placed on the map, the player has to protect these cells from the viruses</li>
</ul>

# Style guide

Commenting & Documentation

    Preferebly comment on each function, short descreption about it's purpose (I'm not going to comment out
    code that is generated with scaffolds though)

Indentation

    Preferred identation style:

    - (IBAction)lengthIncrement:(id)sender
    {
      // updates textField to match stepper
      self.length.text = [NSString stringWithFormat: @"%.0f", self.lengthStepper.value];
    
      // save value
      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
      [defaults setObject:self.length.text forKey:@"length"];
      [defaults synchronize];    
    }

Code Grouping

    Code lines that are that are suppose to serve the same task are going to be arringed in blocks and these
    blocks will be separated with spaces.

Naming Scheme
    
    Prefer usage of camelCase, such as: NewObjec, PriceIndex etc..
    
DRY Principle

    The same piece of code should not be repeated over and over again.

No Deep Nesting

    Preferablu reduce level of nesting, 

Limited Line Length

    Avoid writing horizontally long lines of code.

Capitalize SQL Special Words

    Capitalize SQL special words and function names to to distinguish them from your table and column names.
    
Source for style document:
<a href='http://net.tutsplus.com/tutorials/html-css-techniques/top-15-best-practices-for-writing-super-readable-code/'>
Top 15+ Best Practices for Writing Super Readable Code</a>
