//
//  Wall.h
//  CellDefence
//
//  Created by Attila Csala on 12/10/13.
//  Copyright (c) 2013 Attila Csala. All rights reserved.
//

#import "Object.h"

@interface Wall : Object

-(Wall*)initWithPosition:(CGPoint)position
          withPictureName:(NSString*)pictureName
            withAnimation:(NSString*)animationPictureName
                 withName:(NSString*)name
                  andSize:(CGSize)size;

@end
