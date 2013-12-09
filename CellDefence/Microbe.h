//
//  Microbe.h
//  CellDefence
//
//  Created by Attila Csala on 12/9/13.
//  Copyright (c) 2013 Attila Csala. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Microbe : SKSpriteNode

// create initialization method for microbe with position and size
-(Microbe*) initWithPosition:(CGPoint)position
             withPictureName:(NSString*)pictureName
                    withName:(NSString*)name
                     andSize:(CGSize)size;

@end
