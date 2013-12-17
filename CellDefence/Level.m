//
//  Level.m
//  CellDefence
//
//  Created by Attila Csala on 12/9/13.
//  Copyright (c) 2013 Attila Csala. All rights reserved.
//

#import "Level.h"
#import "Microbe.h"
#import "Object.h"
#import "Cell.h"

#define NUMBER_OF_VIRUSES   5
#define NUMBER_OF_OBJECTS   0
#define NUMBER_OF_WALLS     30
#define NUMBER_OF_ACIDS     3
#define NUMBER_OF_VIRAL_DNA 10

@implementation Level{

        NSMutableArray *_virusesArray;
        NSMutableArray *_objectsArray;
        NSMutableArray *_acidsArray;
        NSMutableArray *_viralDNAArray;
        NSMutableArray *_wallsArray;

}

-(NSMutableArray*) setUpViruses{
    
    _virusesArray = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_VIRUSES];
    for (int i = 0; i < NUMBER_OF_VIRUSES; ++i) {
        Microbe *virus = [[Microbe alloc] initWithPosition:(CGPointMake(200, 200))
                                           withPictureName:@"virus1"
                                             withAnimation:@"virus2"
                                                  withName:@"virus"
                                                   andSize:(CGSizeMake(47, 22))];
        virus.color = [SKColor redColor];
        virus.colorBlendFactor = 0.5;
        [_virusesArray addObject:virus];
    }
    return _virusesArray;
}

-(NSMutableArray*) setUpObjects{
    
    _objectsArray = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_OBJECTS];
    for (int i = 0; i < NUMBER_OF_OBJECTS; ++i) {
        CGPoint randomLocation = CGPointMake(arc4random() % 320, arc4random() % 480);
        Object *object = [[Object alloc] initWithPosition:randomLocation
                                          withPictureName:@"barrier"
                                            withAnimation:@"barrier"
                                                 withName:@"barrier"
                                                  andSize:(CGSizeMake(20, 20))];
        
        [_objectsArray addObject:object];
    }
    return _objectsArray;
}

-(NSMutableArray*) setUpWalls{
    _wallsArray = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_WALLS];
    for (int i = 0; i < NUMBER_OF_WALLS; ++i) {
        CGPoint randomLocation = CGPointMake(arc4random() % 278, arc4random() % 495);
        Cell *wall = [[Cell alloc] initWithPosition:randomLocation
                                          withPictureName:@"wall1"
                                            withAnimation:@"wall2"
                                                 withName:@"wall"
                                                  andSize:(CGSizeMake(32, 29))];
        
        [_wallsArray addObject:wall];
    }
    return _wallsArray;
    
}

-(NSMutableArray*) setUpAcids{
    
    _acidsArray = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_ACIDS];
    for (int i = 0; i < NUMBER_OF_ACIDS; ++i) {
        SKSpriteNode *acid = [SKSpriteNode spriteNodeWithImageNamed:@"acid"];
        acid.hidden = YES;
        acid.size = CGSizeMake(15, 15);
        acid.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:acid.size.width * 0.3];
        acid.physicsBody.affectedByGravity = NO;
        acid.name = @"acid";
        acid.alpha = 0.8;
        
        [_acidsArray addObject:acid];
    }
    
    return _acidsArray;
    
}

-(NSMutableArray*) setUpViralDNA{
    
    _viralDNAArray = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_VIRAL_DNA];
    for (int i = 0; i < NUMBER_OF_VIRAL_DNA; ++i) {
        SKSpriteNode *viralDNA = [SKSpriteNode spriteNodeWithImageNamed:@"viralDNA"];
        viralDNA.hidden = YES;
        viralDNA.size = CGSizeMake(15, 15);
        viralDNA.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:viralDNA.size.width * 0.3];
        viralDNA.physicsBody.affectedByGravity = NO;
        viralDNA.name = @"viralDNA";
        viralDNA.alpha = 0.8;
        
        [_viralDNAArray addObject:viralDNA];
    }
    
    return _viralDNAArray;
    
}

@end
