//
//  Wall.m
//  CellDefence
//
//  Created by Attila Csala on 12/10/13.
//  Copyright (c) 2013 Attila Csala. All rights reserved.
//

#import "Cell.h"

@implementation Cell

-(Cell*)initWithPosition:(CGPoint)position
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
        
        node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:node.size.height * 0.3];
        node.physicsBody.affectedByGravity = NO;
        node.alpha = 0.8;
        
        NSLog([NSString stringWithFormat:@"%f", node.size.height]);
        
        //node.physicsBody.dynamic = NO;
        
    }
    
    return self;
    
}

@end
