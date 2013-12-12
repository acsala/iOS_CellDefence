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
#import "Wall.h"

#define NUMBER_OF_VIRUSES   10
#define NUMBER_OF_OBJECTS   0
#define NUMBER_OF_WALLS     0
#define NUMBER_OF_ACIDS     10
#define NUMBER_OF_VIRAL_DNA 10

@implementation Level{

        NSMutableArray *_virusesArray;
        NSMutableArray *_objectsArray;
        NSMutableArray *_acidsArray;
        NSMutableArray *_viralDNAArray;
        NSMutableArray *_wallsArray;

}

static inline CGFloat skRandf() {
    return rand() / (CGFloat) RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high) {
    return skRandf() * (high - low) + low;
}

-(NSMutableArray*) setUpViruses{
    
    _virusesArray = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_VIRUSES];
    for (int i = 0; i < NUMBER_OF_VIRUSES; ++i) {
        Microbe *virus = [[Microbe alloc] initWithPosition:(CGPointMake(200, 200))
                                           withPictureName:@"virus1"
                                             withAnimation:@"virus2"
                                                  withName:@"virus"
                                                   andSize:(CGSizeMake(50, 50))];
        virus.position = CGPointMake(skRand(0, virus.size.width), virus.size.height+50);
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
        Wall *wall = [[Wall alloc] initWithPosition:randomLocation
                                          withPictureName:@"wall"
                                            withAnimation:@"wall2"
                                                 withName:@"wall"
                                                  andSize:(CGSizeMake(15, 15))];
        
        [_wallsArray addObject:wall];
    }
    return _wallsArray;
    
}

-(NSMutableArray*) setUpAcids{
    
    _acidsArray = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_ACIDS];
    for (int i = 0; i < NUMBER_OF_ACIDS; ++i) {
        SKSpriteNode *acid = [SKSpriteNode spriteNodeWithImageNamed:@"acid_blue"];
        acid.hidden = YES;
        acid.size = CGSizeMake(10, 10);
        acid.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:acid.size.width * 0.2];
        acid.physicsBody.affectedByGravity = NO;
        acid.name = @"acid";
        
        [_acidsArray addObject:acid];
    }
    
    return _acidsArray;
    
}

-(NSMutableArray*) setUpViralDNA{
    
    _viralDNAArray = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_VIRAL_DNA];
    for (int i = 0; i < NUMBER_OF_VIRAL_DNA; ++i) {
        SKSpriteNode *viralDNA = [SKSpriteNode spriteNodeWithImageNamed:@"viralDNA"];
        viralDNA.hidden = YES;
        viralDNA.size = CGSizeMake(10, 10);
        viralDNA.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:viralDNA.size.width * 0.2];
        viralDNA.physicsBody.affectedByGravity = NO;
        viralDNA.name = @"viralDNA";
        
        [_viralDNAArray addObject:viralDNA];
    }
    
    return _viralDNAArray;
    
}

@end
