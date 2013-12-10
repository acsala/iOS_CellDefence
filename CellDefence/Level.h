//
//  Level.h
//  CellDefence
//
//  Created by Attila Csala on 12/9/13.
//  Copyright (c) 2013 Attila Csala. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Level : SKSpriteNode

-(NSMutableArray*) setUpViruses;
-(NSMutableArray*) setUpObjects;
-(NSMutableArray*) setUpAcids;
-(NSMutableArray*) setUpViralDNA;



@end
