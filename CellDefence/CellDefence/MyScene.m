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

#define NUMBER_OF_VIRUSES   5
#define NUMBER_OF_OBJECTS   20
#define PACE_OF_SPRITES     0.04f

@implementation MyScene{
    
    NSMutableArray *_viruses;
    NSMutableArray *_objects;
    
    SKLabelNode *_scoreLabel;
    
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        // add boundries so player / viruses don't get offscreen
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect: self.frame];
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        #pragma mark - Set Up Objects
        // create array for objects
        _objects = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_OBJECTS];
        for (int i = 0; i < NUMBER_OF_OBJECTS; ++i) {
            CGPoint randomLocation = CGPointMake(arc4random() % 200, arc4random() % 400);
            Object *object = [[Object alloc] initWithPosition:randomLocation
                                               withPictureName:@"barrier"
                                                 withAnimation:@"barrier"
                                                      withName:@"barrier"
                                                       andSize:(CGSizeMake(50, 50))];
            
            [_objects addObject:object];
            [self addChild:object];
        }
        
        #pragma mark - Set Up Viruses
        // create array for viruses
        _viruses = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_VIRUSES];
        for (int i = 0; i < NUMBER_OF_VIRUSES; ++i) {
            Microbe *virus = [[Microbe alloc] initWithPosition:(CGPointMake(300, 500))
                                               withPictureName:@"virus1"
                                                 withAnimation:@"virus2"
                                                      withName:@"virus"
                                                       andSize:(CGSizeMake(50, 50))];

            [_viruses addObject:virus];
            [self addChild:virus];
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
        
        // initialize _scoreLabel
        _scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        _scoreLabel.text = @"Score: 0";
        _scoreLabel.fontColor = [UIColor whiteColor];
        _scoreLabel.fontSize = 24.0f;
        _scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        _scoreLabel.position = CGPointMake(10, 10);
        
        [self.scene addChild:_scoreLabel];
        
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
    
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    // find player
    SKNode *player = [self childNodeWithName:@"player"];
    
    // find all the viruses
    for (SKSpriteNode *virus in _viruses){
        
        // move viruses randomly
        if (![virus actionForKey:@"randomMove"]) {
            if (!virus.hidden == YES) {
                
                // random location on map
                CGPoint randomLocation = CGPointMake(arc4random() % 300, arc4random() % 500);
                
                float moveSpeed = [self moveAtConstantSpeedFromSpritesLocation:virus
                                          withLocationMoveTo:randomLocation
                                                    withPace:PACE_OF_SPRITES];
                
                SKAction *randomMove = [SKAction moveTo:randomLocation duration:moveSpeed];
                [virus runAction:randomMove withKey:@"randomMove"];
            }
            
        }
        
        // detect collision
        if ([player intersectsNode:virus]) {
            [virus removeAllActions];
            virus.hidden = YES;
            virus.position = (CGPointMake(0, -100));
        }
        
        for (SKSpriteNode *object in _objects){
            
            if (([player intersectsNode:object]||[virus intersectsNode:object])&&![object hasActions]) {
                double randomAngle = atan2(arc4random() % 20, arc4random() % 20);
                
                //SKAction *rotate = [SKAction rotateByAngle:randomAngle duration:0.5f];
                //[object runAction:[SKAction repeatActionForever:rotate]];
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


@end
