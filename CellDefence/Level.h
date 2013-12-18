//
//  Level.h
//  CellDefence
//
//  Created by Attila Csala on 12/9/13.
//  Copyright (c) 2013 Attila Csala. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Level : SKSpriteNode{
    
    NSMutableArray *_viruses;
    NSMutableArray *_objects;
    NSMutableArray *_acids;
    NSMutableArray *_viralDNA;
    NSMutableArray *_walls;
    
}

-(NSMutableArray*) setUpVirusesWithLevel:(NSInteger)Level;
-(NSMutableArray*) setUpObjects;
-(NSMutableArray*) setUpAcids;
-(NSMutableArray*) setUpViralDNA;
-(NSMutableArray*) setUpCellsWithLevel:(NSInteger)Level;

@end
