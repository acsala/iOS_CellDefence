//
//  Microbe.h
//  CellDefence
//
//  Created by Attila Csala on 12/9/13.
//  Copyright (c) 2013 Attila Csala. All rights reserved.
//

#import "Object.h"

@interface Microbe : Object

// create initialization method for microbe with position and size
-(Microbe*) initWithPosition:(CGPoint)position
             withPictureName:(NSString*)pictureName
               withAnimation:(NSString*)animationPictureName
                    withName:(NSString*)name
                     andSize:(CGSize)size;

@end
