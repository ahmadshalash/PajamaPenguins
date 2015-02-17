//
//  PPObstacle.m
//  PajamaPenguins
//
//  Created by Skye on 2/12/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPObstacle.h"

typedef enum {
    center = 0,
    top,
    leftTop,
    rightTop,
    leftBottom,
    rightBottom,
    bottom,
    leftTopThin,
    rightTopThin,
    leftTopThick,
    rightTopThick,
    leftBottomThick,
    rightBottomThick,
    leftBottomThin,
    rightBottomThin,
}ObstacleFrameIndex;

CGFloat const kTileWidth = 15.0;

@interface PPObstacle()
@property (nonatomic) NSArray *textureFrames;
@end

@implementation PPObstacle

/* 
  _____________________
 |_|_|_|_|_|_|_|_|_|_|_|
 |_|_|_|_|_|_|_|_|_|_|_|
 |_|_|_|_|_|^|_|_|_|_|_|
 |_|_|_|_|/|M|\|_|_|_|_|
 |_|_|_|_|\|M|/|_|_|_|_|
 |_|_|_|_|_|v|_|_|_|_|_|
 |_|_|_|_|_|_|_|_|_|_|_|
 |_|_|_|_|_|_|_|_|_|_|_|
 
 */

- (instancetype)initWithTexturesFromArray:(NSArray*)array {
    self = [super init];
    if (self) {
        self.textureFrames = [NSArray arrayWithArray:array];
        
        //Test Node
        [self addChild:[self frameAtIndex:center]];
        [self addChild:[self frameAtIndex:center] atGridX:0 atGridY:-1];
        [self addChild:[self frameAtIndex:top] atGridX:0 atGridY:1];
        [self addChild:[self frameAtIndex:leftTop] atGridX:-1 atGridY:0];
        [self addChild:[self frameAtIndex:leftBottom] atGridX:-1 atGridY:-1];
        [self addChild:[self frameAtIndex:bottom] atGridX:0 atGridY:-2];
        [self addChild:[self frameAtIndex:rightBottom] atGridX:1 atGridY:-1];
        [self addChild:[self frameAtIndex:rightTop] atGridX:1 atGridY:0];
    }
    return self;
}

#pragma mark - Obstacle Frames
- (SKSpriteNode*)frameAtIndex:(NSUInteger)index {
    return [SKSpriteNode spriteNodeWithTexture:[self.textureFrames objectAtIndex:index]];
}

#pragma mark - Convenience
- (void)addChild:(SKNode *)node atGridX:(CGFloat)gridX atGridY:(CGFloat)gridY  {
    [node setPosition:CGPointMake(kTileWidth * gridX, kTileWidth * gridY)];
    [self addChild:node];
}

@end
