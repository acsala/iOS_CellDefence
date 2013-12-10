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

#define NUMBER_OF_VIRUSES   5
#define NUMBER_OF_OBJECTS   5
#define NUMBER_OF_ACIDS     5
#define NUMBER_OF_VIRAL_DNA 5

@implementation Level{

        NSMutableArray *_viruses;
        NSMutableArray *_objects;
        NSMutableArray *_acids;
        NSMutableArray *_viralDNA;

}

-(NSMutableArray*) setUpViruses{
    
    _viruses = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_VIRUSES];
    for (int i = 0; i < NUMBER_OF_VIRUSES; ++i) {
        Microbe *virus = [[Microbe alloc] initWithPosition:(CGPointMake(200, 200))
                                           withPictureName:@"virus1"
                                             withAnimation:@"virus2"
                                                  withName:@"virus"
                                                   andSize:(CGSizeMake(50, 50))];
        virus.color = [SKColor redColor];
        virus.colorBlendFactor = 0.5;
        [_viruses addObject:virus];
    }
    return _viruses;
}

-(NSMutableArray*) setUpObjects{
    
    _objects = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_OBJECTS];
    for (int i = 0; i < NUMBER_OF_OBJECTS; ++i) {
        CGPoint randomLocation = CGPointMake(arc4random() % 200, arc4random() % 400);
        Object *object = [[Object alloc] initWithPosition:randomLocation
                                          withPictureName:@"barrier"
                                            withAnimation:@"barrier"
                                                 withName:@"barrier"
                                                  andSize:(CGSizeMake(20, 20))];
        
        [_objects addObject:object];
    }
    return _objects;
}

-(NSMutableArray*) setUpAcids{
    
    _acids = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_ACIDS];
    for (int i = 0; i < NUMBER_OF_ACIDS; ++i) {
        SKSpriteNode *acid = [SKSpriteNode spriteNodeWithImageNamed:@"acid_blue"];
        acid.hidden = YES;
        acid.size = CGSizeMake(10, 10);
        acid.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:acid.size.width * 0.2];
        acid.physicsBody.affectedByGravity = NO;
        
        [_acids addObject:acid];
    }
    
    return _acids;
    
}

-(NSMutableArray*) setUpViralDNA{
    
    _viralDNA = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_VIRAL_DNA];
    for (int i = 0; i < NUMBER_OF_VIRAL_DNA; ++i) {
        SKSpriteNode *acid = [SKSpriteNode spriteNodeWithImageNamed:@"viralDNA"];
        acid.hidden = YES;
        acid.size = CGSizeMake(10, 10);
        acid.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:acid.size.width * 0.2];
        acid.physicsBody.affectedByGravity = NO;
        
        [_viralDNA addObject:acid];
    }
    
    return _viralDNA;
    
    
}

@end
