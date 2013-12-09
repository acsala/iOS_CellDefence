//
//  MyScene.m
//  CellDefence
//
//  Created by Attila Csala on 12/9/13.
//  Copyright (c) 2013 Attila Csala. All rights reserved.
//

#import "MyScene.h"
#import "Microbe.h"
#define NUMBER_OF_VIRUSES   3

@implementation MyScene{
    
    NSMutableArray *_viruses;
    
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        _viruses = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_VIRUSES];
        
        for (int i = 0; i < NUMBER_OF_VIRUSES; ++i) {
            Microbe *virus = [[Microbe alloc] initWithPosition:(CGPointMake(100, 100))
                                               withPictureName:@"Spaceship"
                                                      withName:@"virus"
                                                       andSize:(CGSizeMake(50, 50))];

            [_viruses addObject:virus];
            [self addChild:virus];
        }

        Microbe *player = [[Microbe alloc] initWithPosition:(CGPointMake(200, 100))
                                             withPictureName:@"Spaceship"
                                                    withName:@"player"
                                                     andSize:(CGSizeMake(50, 50))];
        
        NSLog([NSString stringWithFormat:@"%@",player.name]);
        
        [self addChild:player];

        
        // add boundries so player / viruses don't get offscreen
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect: self.frame];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    CGPoint location = [[touches anyObject] locationInNode:self];
    SKNode *player = [self childNodeWithName:@"player"];
    SKAction *move = [SKAction moveTo:location duration:1.0f];
    [player runAction:move];
    
    // rotate in the direction it moves
    double angle = atan2(location.y-player.position.y,location.x-player.position.x);
    [player runAction:[SKAction rotateToAngle:angle duration:.1]];
    
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    
    SKNode *player = [self childNodeWithName:@"player"];
    
    for (SKSpriteNode *virus in _viruses){
        
        // move viruses randomly
        if (![virus hasActions]) {
            if (!virus.hidden == YES) {
                SKAction *randomMove = [SKAction moveTo:CGPointMake(arc4random() % 200, arc4random() % 400) duration:1.0f];
                [virus runAction:randomMove];
            }
            
        }
        
        // detect collision
        if ([player intersectsNode:virus]) {
            [virus removeAllActions];
            virus.hidden = YES;
            virus.position = (CGPointMake(0, -100));
        }
    }
    
}


@end
