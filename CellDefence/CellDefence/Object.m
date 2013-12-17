//
//  Object.m
//  CellDefence
//
//  Created by Attila Csala on 12/9/13.
//  Copyright (c) 2013 Attila Csala. All rights reserved.
//

#import "Object.h"

@implementation Object

-(Object*) initWithPosition:(CGPoint)position
            withPictureName:(NSString*)pictureName
              withAnimation:(NSString*)animationPictureName
                   withName:(NSString*)name
                    andSize:(CGSize)size{
    
    NSArray *barrierPictures = @[@"barrier1", @"barrier2", @"barrier3", @"barrier4", @"barrier5", @"barrier6" ];
    
    NSInteger randomObjectOfArrayPictures = arc4random() % [barrierPictures count];
    
    self = [super initWithImageNamed:barrierPictures[randomObjectOfArrayPictures]];
    
    if (self) {
        
        SKSpriteNode *node = self;;
        
        node.size = size;
        node.position = position;
        node.name  = [NSString stringWithFormat:@"%@", name];
        
        node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(node.size.width * 0.8, node.size.height * 0.8 )];
        node.physicsBody.affectedByGravity = NO;
        node.alpha = 0.8;
        
    }
    
    return self;
    
}

@end
