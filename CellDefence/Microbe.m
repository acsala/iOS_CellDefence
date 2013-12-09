//
//  Microbe.m
//  CellDefence
//
//  Created by Attila Csala on 12/9/13.
//  Copyright (c) 2013 Attila Csala. All rights reserved.
//

#import "Microbe.h"

@implementation Microbe

-(Microbe*) initWithPosition:(CGPoint)position
             withPictureName:(NSString*)pictureName
                    withName:(NSString*)name
                     andSize:(CGSize)size{
    
    self = [super initWithImageNamed:pictureName];
    
    if (self) {
        
        SKSpriteNode *node = self;;
        
        node.size = size;
        node.position = position;
        node.name  = [NSString stringWithFormat:@"%@", name];
        
        node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:node.size.width * 0.5];
        node.physicsBody.affectedByGravity = NO;
        
    }
    
    return self;
}

@end
