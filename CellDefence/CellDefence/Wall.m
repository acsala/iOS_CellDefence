//
//  Wall.m
//  CellDefence
//
//  Created by Attila Csala on 12/10/13.
//  Copyright (c) 2013 Attila Csala. All rights reserved.
//

#import "Wall.h"

@implementation Wall

-(Wall*)initWithPosition:(CGPoint)position
         withPictureName:(NSString*)pictureName
           withAnimation:(NSString*)animationPictureName
                withName:(NSString*)name
                 andSize:(CGSize)size{
    

    self = [super initWithImageNamed:pictureName];
    
    if (self) {
        
        SKSpriteNode *node = self;
        
        node.size = size;
        node.position = position;
        node.name  = [NSString stringWithFormat:@"%@", name];
        
        node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(node.size.width * 0.8, node.size.height * 0.8 )];
        node.physicsBody.affectedByGravity = NO;
        node.physicsBody.dynamic = NO;
        
    }
    
    return self;
    
}

@end
