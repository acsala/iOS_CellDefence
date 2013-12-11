//
//  MyScene.m
//  CellDefence
//
//  Created by Attila Csala on 12/9/13.
//  Copyright (c) 2013 Attila Csala. All rights reserved.
//

#import "MyScene.h"
#import "Microbe.h"
#import "Object.h"
#import "Level.h"

#define NUMBER_OF_VIRUSES   5
#define NUMBER_OF_OBJECTS   0
#define NUMBER_OF_ACIDS     5
#define PACE_OF_SPRITES     0.06f
#define PACE_OF_ACIDS       0.01f
#define PLAYER_LIVES        3


@implementation MyScene{
    
    NSMutableArray *_viruses;
    NSMutableArray *_objects;
    NSMutableArray *_acids;
    NSMutableArray *_viralDNA;
    NSMutableArray *_walls;
    
    SKLabelNode *_scoreLabel;
    
    int _nextAcid;
    int _nextViralDNA;
    int _playerLives;
    int _playerScore;
    int _numberOfViruses;
    
    
}


static inline CGFloat skRandf() {
    return rand() / (CGFloat) RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high) {
    return skRandf() * (high - low) + low;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        [self newGame];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
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

    if ([node isKindOfClass:[Microbe class]] || [node isKindOfClass:[Object class]]) {
        
        [self shootFromArrayOfObjects:_acids withNextElementCounter:_nextAcid withInitialPositionRelativeTo:player withPositionShootingAt:location withVelocity:PACE_OF_ACIDS];
        
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    // find player
    SKNode *player = [self childNodeWithName:@"player"];
    
    // find all the viruses
    for (SKSpriteNode *virus in _viruses){
        
        // random location on map
        CGPoint randomLocation = CGPointMake(arc4random() % 300, arc4random() % 500);

#pragma mark - Move viruses and make them shoot their DNA
        // move viruses randomly and shoot viral DNA
        if (!virus.hidden && [virus inParentHierarchy:self]) {
            if (![virus actionForKey:@"randomMove"]) {
                
                float moveSpeed = [self moveAtConstantSpeedFromSpritesLocation:virus
                                          withLocationMoveTo:randomLocation
                                                    withPace:PACE_OF_SPRITES];
                
                SKAction *randomMove = [SKAction moveTo:randomLocation duration:moveSpeed];
                [virus runAction:randomMove withKey:@"randomMove"];
                
                [self shootFromArrayOfObjects:_viralDNA
                        withNextElementCounter:_nextViralDNA
                        withInitialPositionRelativeTo:virus
                        withPositionShootingAt:randomLocation
                                     withVelocity:PACE_OF_ACIDS];
                    
                
            }
            
        }
        
#pragma mark - Set up shoot-hit rules
        
        // detect shoots
        for (SKSpriteNode *acid in _acids){
            
            // check if virus got shoot
            if ([virus intersectsNode:acid] &&
                !virus.hidden && !acid.hidden &&
                [virus inParentHierarchy:self] &&
                // ending of a virus costs time due to animation, we dont want the give score to the player for shoting down an agonising virus multiple times
                ![virus actionForKey:@"microbeEnds"]){
                    
                [self microbeGotHit:virus];
                acid.hidden = YES;
                _playerScore++;
                _numberOfViruses--;
                [self updateDisplayWithScore:_playerScore andPLayerLives:_playerLives];
                
                if (_numberOfViruses == 0) {
                    [self gameEnded];
                }
                
            }
            
            for (SKSpriteNode *wall in _walls){
            
                if ([wall intersectsNode:acid] && !wall.hidden && [wall inParentHierarchy:self]) {
                    acid.hidden = YES;
                    wall.hidden = YES;
                    [wall removeFromParent];
                    [acid runAction:[SKAction moveTo:CGPointMake(0, -200) duration:0.001]];
                }
            
            }
        }

    }
    
    // find viralDNA
    for (SKSpriteNode *viralDNA in _viralDNA){
        
    // check if player got shoot
        if ([viralDNA intersectsNode:player]&& !viralDNA.hidden) {
            _playerLives--;
            [self updateDisplayWithScore:_playerScore andPLayerLives:_playerLives];
            viralDNA.hidden = YES;
            [player runAction:[SKAction rotateByAngle:10 duration:2]];
            [player runAction:[SKAction colorizeWithColor:[SKColor redColor] colorBlendFactor:1.0 duration:0.15]];
            
            if (_playerLives == 0) {
                [self gameEnded];
            }
            
        }
        
        // check if viralDNA intersects wall
        for (SKSpriteNode *wall in _walls){
            
            if ([wall intersectsNode:viralDNA] && !wall.hidden
                && [wall inParentHierarchy:self] && !viralDNA.hidden) {
                viralDNA.hidden = YES;
                wall.hidden = YES;
                [wall removeFromParent];
                [viralDNA runAction:[SKAction moveTo:CGPointMake(0, -200) duration:0.001]];
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
    if (tracker >= arrayOfObjects.count) {
        _nextAcid = 0;
    }
    
    if (![shoot actionForKey:@"fired"] && !positionRelativeTo.hidden) {
        //Set the initial position of the laser to where your ship is positioned.
        shoot.position = CGPointMake(positionRelativeTo.position.x + shoot.size.width/2, positionRelativeTo.position.y+0);
        
        shoot.hidden = NO;
        [shoot removeAllActions];
        
        float contantMovingSpeed = [self moveAtConstantSpeedFromSpritesLocation:shoot
                                                             withLocationMoveTo:positionShootingAt
                                                                       withPace:velocity];
        
        SKAction *shootMoveAction = [SKAction moveTo:positionShootingAt duration:contantMovingSpeed];
        SKAction *rotateShootAction = [SKAction repeatActionForever:[SKAction rotateToAngle:20 duration:1]];
        
        //Define a done action using a block that hides the laser when it hits the right edge.
        SKAction *laserDoneAction = [SKAction runBlock:(dispatch_block_t)^() {
            //NSLog(@"Animation Completed");
            shoot.hidden = YES;
        }];
        
        //Define a sequence action of the move and done actions
        SKAction *moveLaserActionWithDone = [SKAction sequence:@[shootMoveAction,
                                                                 laserDoneAction]];
        [shoot runAction:moveLaserActionWithDone withKey:@"fired"];
        [shoot runAction:rotateShootAction];
    }
}

-(void) microbeGotHit:(SKNode*)nodeGotHit{
    
    SKAction *microbeEnds = [SKAction sequence:
                          @[[SKAction colorizeWithColor:[SKColor redColor] colorBlendFactor:1.0 duration:0.15],
                            [SKAction rotateByAngle:10.0f duration:2],
                            //[SKAction waitForDuration:0.5],
                            [SKAction colorizeWithColorBlendFactor:0.0 duration:0.15],
                            [SKAction fadeOutWithDuration:0.5],
                            [SKAction moveTo:CGPointMake(0, -200) duration:0.001],
                            [SKAction removeFromParent]]];
    
    
    [nodeGotHit runAction:microbeEnds withKey:@"microbeEnds"];
    
    NSLog(@"shoot hit hit");
    
}

#pragma mark - Start game

- (void)addRock
{
    SKSpriteNode *rock = [[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:CGSizeMake(8,8)];
    rock.position = CGPointMake(skRand(0, self.size.width), self.size.height-50);
    rock.name = @"rock";
    rock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rock.size];
    rock.physicsBody.usesPreciseCollisionDetection = YES;
    [self addChild:rock];
}

-(void) newGame{
    
    [self removeAllChildren];
    
    SKAction *makeRocks = [SKAction sequence: @[
                                                [SKAction performSelector:@selector(addRock) onTarget:self],
                                                [SKAction waitForDuration:2.10 withRange:0.15]
                                                ]];
    [self runAction: [SKAction repeatAction:makeRocks count:10]];
    
    // add boundries so player / viruses don't get offscreen
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect: self.frame];
    self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
    
    _playerLives = PLAYER_LIVES;
    _playerScore = 0;
    _numberOfViruses = NUMBER_OF_VIRUSES;
    
#pragma mark - Set Up Objects
    // create array for objects
    _objects = [[Level alloc] setUpObjects];
    for (SKSpriteNode *object in _objects){
        object.color = [UIColor blackColor];
        [self addChild:object];
        
    }
    
#pragma mark - Set Up Walls
    
    _walls = [[Level alloc] setUpWalls];
    for (SKSpriteNode *wall in _walls){
        [self addChild:wall];
    }
    
#pragma mark - Set Up Viruses
    
    
    //create array for viruses
    _viruses = [[Level alloc] setUpViruses];
    for (SKSpriteNode *virus in _viruses){
    
        [self addChild:virus];
        
    }
    
#pragma mark - Set Up Acids and Viral DNAs
    
    _acids = [[Level alloc] setUpAcids];
    for (SKSpriteNode *acid in _acids) {
        [self addChild:acid];
    }
    
    _viralDNA = [[Level alloc] setUpViralDNA];
    for (SKSpriteNode *viralDNA in _viralDNA){
        [self addChild:viralDNA];
    }
    
    
#pragma mark - Set Up Player
    // create sprite for player
    Microbe *player = [[Microbe alloc] initWithPosition:(CGPointMake(100, 100))
                                        withPictureName:@"player1"
                                          withAnimation:@"player2"
                                               withName:@"player"
                                                andSize:(CGSizeMake(50, 50))];
    player.color = [UIColor blackColor];
    
    [self addChild:player];
    
#pragma mark - Set Up Scoring
    
    // initialize _scoreLabel
    _scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    _scoreLabel.text = [NSString stringWithFormat:@"Score: 0 Lives: %d", _playerLives];
    _scoreLabel.fontColor = [UIColor whiteColor];
    _scoreLabel.fontSize = 24.0f;
    _scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    _scoreLabel.position = CGPointMake(10, 10);
    
    [self.scene addChild:_scoreLabel];
    
}

-(void) gameEnded{
    
    NSString *message = [NSString stringWithFormat:@"You scored %d this time", _playerScore];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Game over!"
                                                 message:message delegate:self
                                       cancelButtonTitle:@"New Game"
                                       otherButtonTitles:nil];
    
    [av show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    // when the user accepts the dialog we begin a new game
    if(buttonIndex == 0)
    {
        
        [self newGame];
    }
    
    
}

-(void) updateDisplayWithScore:(NSInteger)playerScore andPLayerLives:(NSInteger)playerLives{
    
    _scoreLabel.text = [NSString stringWithFormat:@"Score: %d Lives: %d", playerScore, playerLives];
    
}

@end
