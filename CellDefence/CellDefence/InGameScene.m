//
//  MyScene.m
//  CellDefence
//
//  Created by Attila Csala on 12/9/13.
//  Copyright (c) 2013 Attila Csala. All rights reserved.
//

#import "InGameScene.h"
#import "Microbe.h"
#import "Object.h"
#import "Level.h"
#import "LeaderboardViewController.h"

#define NUMBER_OF_VIRUSES   5
#define NUMBER_OF_OBJECTS   0
#define NUMBER_OF_ACIDS     5
#define PACE_OF_SPRITES     0.06f
#define PACE_OF_ACIDS       0.01f
#define PLAYER_LIVES        3


@implementation InGameScene{
    
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        // get the actual size of the scene
        _sizeOfScene = self.scene.size;
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    if (!_gameState == STARTING) {
        [self newGame];
    }
    
    _gameState = STARTING;
    
    // get the location of the touch
    CGPoint location = [[touches anyObject] locationInNode:self];
    // get the location of player
    SKNode *player = [self childNodeWithName:@"player"];
    
    // set moveSpeed to constant
    float moveSpeed = [self moveAtConstantSpeedFromSpritesLocation:player
                                                withLocationMoveTo:location
                                                          withPace:PACE_OF_SPRITES];
    // set and execute move action on player
    SKAction *move = [SKAction moveTo:location duration:moveSpeed];
    [player runAction:move];
    
    // rotate in the direction it moves
    double angle = atan2(location.y-player.position.y,location.x-player.position.x);
    [player runAction:[SKAction rotateToAngle:angle duration:.1]];
   
#pragma mark - Acid shoot
    
    // check if touch is on virus
    SKNode *node = [self nodeAtPoint:location];

    if (([node isKindOfClass:[Microbe class]] ||
         //[node isKindOfClass:[Object class]] ||
         [node.name isEqualToString:@"viralDNA"]) &&
        ![node.name isEqualToString:@"player"]){
        
        [self shootFromArrayOfObjects:_acids
                withNextElementCounter:_nextAcid
                withInitialPositionRelativeTo:player
                withPositionShootingAt:location
                         withVelocity:PACE_OF_ACIDS];
        _nextAcid++;

    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    // find player
    SKNode *player = [self childNodeWithName:@"player"];
    
    // find all the viruses
    for (SKSpriteNode *virus in _viruses){
        
        // random location on map
        CGPoint randomLocation = CGPointMake(arc4random() % (int)roundf(_sizeOfScene.width), arc4random() % (int)roundf(_sizeOfScene.height));

#pragma mark - Move viruses and make them shoot their DNA
        // move viruses randomly and shoot viral DNA
        if (!virus.hidden && [virus inParentHierarchy:self]) {
            if (![virus actionForKey:@"randomMove"]) {
                
                float moveSpeed = [self moveAtConstantSpeedFromSpritesLocation:virus
                                          withLocationMoveTo:randomLocation
                                                    withPace:PACE_OF_SPRITES];
                
                SKAction *randomMove = [SKAction moveTo:randomLocation duration:moveSpeed];
                [virus runAction:randomMove withKey:@"randomMove"];
                
                // rotate in the direction it moves
                double angle2 = atan2(randomLocation.y-virus.position.y, randomLocation.x-virus.position.x);
                [virus runAction:[SKAction rotateToAngle:angle2 duration:.1]];
                
                //NSLog([NSString stringWithFormat:@"x :%f",virus.position.x]);
                //NSLog([NSString stringWithFormat:@"y :%f",virus.position.y]);
                
                [self shootFromArrayOfObjects:_viralDNA
                        withNextElementCounter:_nextViralDNA
                        withInitialPositionRelativeTo:virus
                        withPositionShootingAt:randomLocation
                                     withVelocity:PACE_OF_ACIDS];
                _nextViralDNA++;
                
            }
            
        }
        
#pragma mark - Set up shoot-hit rules
        
        // detect shoots
        for (SKSpriteNode *acid in _acids){
            
            // check if virus got shoot
            if ([virus intersectsNode:acid] &&
                !virus.hidden && !acid.hidden &&
                [virus inParentHierarchy:self] &&
                [acid inParentHierarchy:self]&&
                // ending of a virus costs time due to animation, we dont want the give score to the player for shoting down an agonising virus multiple times
                ![virus actionForKey:@"microbeEnds"]){
                    
                [self microbeGotHit:virus];
                acid.hidden = YES;
                _playerScore = _playerScore + 20;
                _numberOfVirusesOnScreen--;
                _virusGotKilled++;
                [self updateDisplayWithScore:_playerScore andPLayerLives:_playerLives];
                
                NSLog([NSString stringWithFormat:@"virusOnScreen: %d,virusGotKilled: %d, virusTOtal: %d", _numberOfVirusesOnScreen, _virusGotKilled, _totalNumberOfViruses]);
                
                if (_virusGotKilled == _totalNumberOfViruses) {
                    [self gameEnded];
                }else{
                    [self addVirus];
                }
                
            }
            
            for (SKSpriteNode *viralDNA in _viralDNA){
                if ([viralDNA intersectsNode:acid] &&
                    [acid inParentHierarchy:self.scene] &&
                    [viralDNA inParentHierarchy:self.scene]) {
                    
                    [viralDNA removeFromParent];
                    [acid removeFromParent];
                    [viralDNA removeAllActions];
                    [acid removeAllActions];
                }
                
            }
            
            for (SKSpriteNode *wall in _cells){
            
                if ([wall intersectsNode:acid] &&
                    !wall.hidden &&
                    [wall inParentHierarchy:self] &&
                    [acid inParentHierarchy:self] &&
                    !acid.hidden) {
                    
                    // remove animation of motion
                    //[acid removeActionForKey:@"animationMotion"];
                    //[acid runAction:[SKAction removeFromParent]];
                    //[acid runAction:[SKAction fadeOutWithDuration:1]];
                    
                    //acid.hidden = YES;
                    //wall.hidden = YES;
                    //[wall runAction:[SKAction resizeToWidth:wall.size.width * 2 duration:1]];
                    //[wall runAction:[SKAction resizeToHeight:wall.size.height * 2 duration:1]];
                    //[wall removeFromParent];
                }
            
            }
        }

    }
    
    // find viralDNA
    for (SKSpriteNode *viralDNA in _viralDNA){
        
    // check if player got shoot
        if ([viralDNA intersectsNode:player]&& !viralDNA.hidden
            && [viralDNA inParentHierarchy:self]) {
            _playerLives--;
            [self updateDisplayWithScore:_playerScore andPLayerLives:_playerLives];
            viralDNA.hidden = YES;
            [player runAction:[SKAction rotateByAngle:10 duration:2]];
            [player runAction:[SKAction colorizeWithColor:[SKColor redColor] colorBlendFactor:1.0 duration:0.15]];
            
            if (_playerLives == 0) {
                _gameState = ENDING;
                [self gameEnded];
            }
            
        }
        
        // check if viralDNA intersects wall
        for (SKSpriteNode *cell in _cells){
            
            if ([cell intersectsNode:viralDNA] && !cell.hidden
                && [cell inParentHierarchy:self] && !viralDNA.hidden) {
                viralDNA.hidden = YES;
                [viralDNA removeActionForKey:@"fired"];
                
                SKAction *cellEnds = [SKAction sequence:
                                         @[[SKAction colorizeWithColor:[SKColor redColor] colorBlendFactor:1.0 duration:1.15],
                                           [SKAction rotateByAngle:1 duration:2],
                                           [SKAction resizeByWidth:30 height:30 duration:1],
                                           //[SKAction waitForDuration:0.5],
                                           //[SKAction colorizeWithColorBlendFactor:0.0 duration:0.15],
                                           //[SKAction moveTo:CGPointMake(0, -200) duration:0.001],
                                           [SKAction removeFromParent]]];
                
                [cell runAction:cellEnds withKey:@"microbeEnds"];
                _playerScore = _playerScore - 10;
                
                [self updateDisplayWithScore:_playerScore andPLayerLives:_playerLives];
                //[wall runAction:[SKAction fadeOutWithDuration:2]];
            }
            
        }
        
    }
}

#pragma mark - Set Up Sprite's attributes and abilities

// method to set up constant speed
-(float) moveAtConstantSpeedFromSpritesLocation:(SKNode*)spritesLocationMoveFrom
                             withLocationMoveTo:(CGPoint)locationMoveTo
                                       withPace:(float)pace{
    
    //get the distance between the destination position and the node's position
    double distance = sqrt(pow((locationMoveTo.x - spritesLocationMoveFrom.position.x), 2.0) + pow((locationMoveTo.y - spritesLocationMoveFrom.position.y), 2.0));
    
    //calculate your new duration based on the distance
    float moveSpeed = pace * distance;
    
    return moveSpeed;
}

-(void) shootFromArrayOfObjects:(NSMutableArray*)arrayOfObjects
              withNextElementCounter:(NSInteger)tracker
       withInitialPositionRelativeTo:(SKNode*)positionRelativeTo
              withPositionShootingAt:(CGPoint)positionShootingAt
                        withVelocity:(float)velocity{
    
    //Pick up a laser from one of your pre-made lasers.
    SKSpriteNode *shoot = [arrayOfObjects objectAtIndex:tracker];
    tracker++;
    //NSLog([NSString stringWithFormat:@"tracker: %d", tracker]);
    if (tracker >= arrayOfObjects.count) {
        _nextAcid = 0;
        _nextViralDNA =0;
    }
    
    if (!positionRelativeTo.hidden && ![shoot actionForKey:@"fired"]) {
        //Set the initial position of the laser to where your ship is positioned.
        
        if (![shoot inParentHierarchy:self]) {
            [self addChild:shoot];
        }
        
        shoot.speed = 1.0;
        shoot.hidden = NO;
        shoot.alpha = 0.8;
        [shoot removeAllActions];
        
        shoot.position = CGPointMake(positionRelativeTo.position.x, positionRelativeTo.position.y);
        
        
        float constantMovingSpeed = [self moveAtConstantSpeedFromSpritesLocation:shoot
                                                             withLocationMoveTo:positionShootingAt
                                                                       withPace:velocity];
    
        
        //CGVector _vectorToMoveBy = CGVectorMake(positionShootingAt.x - positionRelativeTo.physicsBody.velocity.dx, positionShootingAt.y - positionRelativeTo.physicsBody.velocity.dy);
        
        SKAction *shootMoveAction = [SKAction moveTo:positionShootingAt duration:constantMovingSpeed];
        SKAction *rotateShootAction = [SKAction rotateToAngle:20 duration:2];
        
        SKAction *slowDown = [SKAction speedTo:0.1 duration:2.8];
        SKAction *fadeOut = [SKAction fadeOutWithDuration:0.5];
        SKAction *removeNode = [SKAction removeFromParent];

        
        //Define a done action using a block that hides the laser when it hits the right edge.
        /*SKAction *laserDoneAction = [SKAction runBlock:(dispatch_block_t)^() {
            //NSLog(@"Animation Completed");
            shoot.hidden = YES;
        }];*/
        
        //Define a sequence action of the move and done actions
        SKAction *moveLaserActionWithDone = [SKAction sequence:@[shootMoveAction,
                                                                 fadeOut,
                                                                 removeNode
                                                                 ]];
        [shoot runAction:moveLaserActionWithDone withKey:@"fired"];
        [shoot runAction:rotateShootAction withKey:@"rotate"];
        [shoot runAction:slowDown];
    }
}

-(void) microbeGotHit:(SKNode*)nodeGotHit{
    
    SKAction *microbeEnds = [SKAction sequence:
                          @[[SKAction colorizeWithColor:[SKColor redColor] colorBlendFactor:1.0 duration:0.15],
                            [SKAction rotateByAngle:1 duration:2],
                            //[SKAction waitForDuration:0.5],
                            [SKAction colorizeWithColorBlendFactor:0.0 duration:0.15],
                            //[SKAction moveTo:CGPointMake(0, -200) duration:0.001],
                            [SKAction removeFromParent]]];
    
    
    [nodeGotHit runAction:microbeEnds withKey:@"microbeEnds"];
    [nodeGotHit runAction:[SKAction fadeOutWithDuration:2]];
    
}

#pragma mark - Start game

-(void) newGame{
    
    [self removeAllChildren];
    
    // add boundries so player / viruses don't get offscreen
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect: self.frame];
    self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:0.8];
    
    _numberOfVirusesOnScreen = 0;
    _virusRespawnCounter = 0;
    _virusGotKilled = 0;
    _nextAcid = 0;
    _nextViralDNA = 0;
    _totalNumberOfViruses = NUMBER_OF_VIRUSES + (_level*2);
    
    if (_gameState) {
        
    } else {
        _gameState = STARTING;
        [self gameStarted];
    }
    
    if(_level){
        
    } else {
        _level = 1;
    }
    
    if (_playerScore) {
        
    } else {
        _playerScore = 0;
    }
    
    if (_playerLives) {
        
    } else {
        _playerLives = PLAYER_LIVES;
    }
    
    
#pragma mark - Set Up Objects
    // create array for objects
    _objects = [[Level alloc] setUpObjects];
    for (SKSpriteNode *object in _objects){
        object.color = [UIColor blackColor];
        [self addChild:object];
        
    }
    
#pragma mark - Set Up Cells
    
    _cells = [[Level alloc] setUpCellsWithLevel:_level];
    for (SKSpriteNode *wall in _cells){
        
        wall.position = CGPointMake(arc4random() % (int)roundf(_sizeOfScene.width), arc4random() % (int)roundf(_sizeOfScene.height - 10));
        
        //[wall runAction:[SKAction resizeToWidth:wall.size.width * 1.2 duration:0.01]];
        //[wall runAction:[SKAction resizeToHeight:wall.size.height * 1.2 duration:0.01]];
        
        
        [self addChild:wall];
    }
    
#pragma mark - Set Up Viruses
    
    
    //create array for viruses
    _viruses = [[Level alloc] setUpVirusesWithLevel:_level];
    
    SKAction *makeVirus = [SKAction sequence: @[
                                                [SKAction performSelector:@selector(addVirus) onTarget:self],
                                                [SKAction waitForDuration:5.0 withRange:0.15]
                                                ]];
    [self runAction: [SKAction repeatAction:makeVirus count:_totalNumberOfViruses]];
    
#pragma mark - Set Up Acids and Viral DNAs
    
    _acids = [[Level alloc] setUpAcids];
    
    _viralDNA = [[Level alloc] setUpViralDNA];
    
    
#pragma mark - Set Up Player
    // create sprite for player
    Microbe *player = [[Microbe alloc] initWithPosition:(CGPointMake(300, 300))
                                        withPictureName:@"player1"
                                          withAnimation:@"player2"
                                               withName:@"player"
                                                andSize:(CGSizeMake(43, 46))];
    player.color = [UIColor greenColor];
    
    [self addChild:player];
    
#pragma mark - Set Up Scoring
    
    // initialize _scoreLabel
    _scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    _scoreLabel.fontColor = [UIColor whiteColor];
    _scoreLabel.fontSize = 24.0f;
    _scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    _scoreLabel.position = CGPointMake(10, 10);
    
    [self.scene addChild:_scoreLabel];
    
}

- (void)addVirus
{
    if (_numberOfVirusesOnScreen < _totalNumberOfViruses && (_virusGotKilled+_numberOfVirusesOnScreen) < _totalNumberOfViruses) {
    
        if (_numberOfVirusesOnScreen < 5) {
            SKSpriteNode *virus = _viruses[_virusRespawnCounter];
            
            // set up viruses at random x cordinates at the top of the screen
            virus.position = CGPointMake(arc4random() % (int)roundf(_sizeOfScene.width), (int)roundf(_sizeOfScene.height - 10));
            
            [self addChild:virus];
            
            _numberOfVirusesOnScreen++;
            _virusRespawnCounter++;
            
            //NSLog([NSString stringWithFormat:@"%d",_numberOfVirusesOnScreen]);
            //NSLog([NSString stringWithFormat:@"%d",_totalNumberOfViruses]);
        }
        
        
    }
    
}

- (void) gameStarted{
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Cell Defence"
                                                 message:nil delegate:self
                                       cancelButtonTitle:@"New Game"
                                       otherButtonTitles:@"Instructins" ,nil];
    _level = 1;
    _playerScore = 0;
    [av show];
    
}

-(void) gameEnded{
    
    NSString *message = [NSString stringWithFormat:@"Your score: %d", _playerScore];
    
    if (_gameState == ENDING) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Game over!"
                                                     message:message delegate:self
                                           cancelButtonTitle:@"New Game"
                                           otherButtonTitles:@"Leaderboard", nil];
        
        
        [KTLoader showLoader:@"Uploading the score"];
        
        // KiiObject is JSON style dictionary, bucket is a container for these objects
        KiiObject *scoreObject = [[Kii bucketWithName:@"scores"] createObject];
        [scoreObject setObject:[NSNumber numberWithInt:_playerScore] forKey:@"scores"];
        [scoreObject setObject:[KiiUser currentUser].username forKey:@"userName"];
        [scoreObject saveWithBlock:^(KiiObject *object, NSError *error) {
            
            if (error == nil) {
                [self showLeaderBoard];
                
            } else {
                [KTLoader showLoader:@"Error Saving"
                            animated:TRUE
                       withIndicator:KTLoaderIndicatorSuccess
                     andHideInterval:KTLoaderDurationAuto];
                
            }
            
        }];
        
        [av show];
        
        
    } else {
        
         _level = _level + 1;
        UIAlertView *av = [[UIAlertView alloc]
                           initWithTitle:[NSString stringWithFormat:@"End of Level: %d", _level-1]
                           message:[NSString stringWithFormat:@"In this game you control a cell. Your objective is to stop viruses infect other cells. Your score is decreased by every cell that is destroyed by viruses and increase by every eliminated viruses. You have to avoid being infected by viruses. "]
                            delegate:self
                            cancelButtonTitle:[NSString stringWithFormat:@"Start Level: %d", _level]
                            otherButtonTitles:@"Instructions", nil];
        
        _gameState = PLAYING;
        [av show];
    }

}

-(void) showLeaderBoard{
    LeaderboardViewController *leaderBoardVC = [[LeaderboardViewController alloc] init];
    
    leaderBoardVC.bucket = [Kii bucketWithName:@"scores"];
    leaderBoardVC.playerScore = _playerScore;
    
    KiiQuery *query = [KiiQuery queryWithClause:nil];
    [query sortByDesc:@"scores"];
    [query setLimit:20];
    
    leaderBoardVC.query = query;
    
    [self.parentViewController presentViewController:leaderBoardVC animated:TRUE completion:nil];
    
    [leaderBoardVC refreshQuery];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    // when the user accepts the dialog we begin a new game
    if(buttonIndex == 0)
    {
        if (_gameState == ENDING) {
            // reset the score here
            _level = 1;
            _playerScore = 0;
        }
        _gameState = PLAYING;
        
        [self newGame];
    }
    
    if(buttonIndex == 1){
        
        [self showLeaderBoard];
        
    }
    
    
}

-(void) updateDisplayWithScore:(NSInteger)playerScore andPLayerLives:(NSInteger)playerLives{
    
    _scoreLabel.text = [NSString stringWithFormat:@"Score: %d Lives: %d Level: %d", playerScore, playerLives, _level];
    
}

@end
