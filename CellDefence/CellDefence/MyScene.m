//
//  MyScene.m
//  CellDefence
//
//  Created by Attila Csala on 12/9/13.
//  Copyright (c) 2013 Attila Csala. All rights reserved.
//

#import "MyScene.h"
#import "Microbe.h"

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        

        Microbe *player = [[Microbe alloc] initWithPosition:(CGPointMake(200, 100))
                                             withPictureName:@"Spaceship"
                                                    withName:@"player"
                                                     andSize:(CGSizeMake(50, 50))];
        
        NSLog([NSString stringWithFormat:@"%@",player.name]);
        
        Microbe *virus = [[Microbe alloc] initWithPosition:(CGPointMake(100, 100))
                                            withPictureName:@"Spaceship"
                                                   withName:@"virus"
                                                    andSize:(CGSizeMake(50, 50))];
        
        [self addChild:player];
        [self addChild:virus];
        
        
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
    
    
}

@end
