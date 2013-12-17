//
//  MyScene.h
//  CellDefence
//

//  Copyright (c) 2013 Attila Csala. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum {
    ENDING,
    STARTING,
    PLAYING
} GameState;

@interface InGameScene: SKScene{
    
    NSMutableArray *_viruses;
    NSMutableArray *_objects;
    NSMutableArray *_acids;
    NSMutableArray *_viralDNA;
    NSMutableArray *_walls;
    
    CGSize _sizeOfScene;
    
    GameState _gameState;
    
    int _nextAcid;
    int _nextViralDNA;
    int _playerLives;
    int _playerScore;
    int _totalNumberOfViruses;
    int _numberOfVirusesOnScreen;
    int _virusRespawnCounter;
    int _virusGotKilled;
    
    SKLabelNode *_scoreLabel;
    
}



@end
