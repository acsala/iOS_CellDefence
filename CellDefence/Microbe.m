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
               withAnimation:(NSString*)animationPictureName
                    withName:(NSString*)name
                     andSize:(CGSize)size{
    
    self = [super initWithImageNamed:pictureName];
    
    if (self) {
        
        SKSpriteNode *node = self;;
        
        node.size = size;
        node.position = position;
        node.name  = [NSString stringWithFormat:@"%@", name];
        
        node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:node.size.height * 0.2];
        node.physicsBody.affectedByGravity = NO;
        
        SKTexture *animationTexture1 = [SKTexture textureWithImageNamed:
                                        [NSString stringWithFormat:@"%@", pictureName]];
        SKTexture *animationTexture2 = [SKTexture textureWithImageNamed:
                                        [NSString stringWithFormat:@"%@", animationPictureName]];
        
        SKAction *motion = [SKAction animateWithTextures:@[animationTexture1,animationTexture2] timePerFrame:.2];
        [node runAction:[SKAction repeatActionForever:motion] withKey:@"animationMotion"];
        
        
    }
    
    return self;
}

@end
