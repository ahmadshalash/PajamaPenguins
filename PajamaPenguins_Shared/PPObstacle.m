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
    bottomShort,
    leftTopThin,
    rightTopThin,
    leftTopThick,
    rightTopThick,
    leftBottomThick,
    rightBottomThick,
    leftBottomThin,
    rightBottomThin,
    bottomLong,
}ObstacleFrameIndex;

CGFloat const kTileWidth = 15.0;

@interface PPObstacle()
@property (nonatomic) NSArray *textureFrames;
@property (nonatomic) SKNode *obstacle;
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
        _obstacle = [SKNode new];
        
        [self addChild:[self frameAtIndex:center] atGridX:0 atGridY:0];
        [self addChild:[self frameAtIndex:center] atGridX:0 atGridY:-1];
        [self addChild:[self frameAtIndex:center] atGridX:0 atGridY:-2];
        [self addChild:[self frameAtIndex:top] atGridX:0 atGridY:1];
        [self addChild:[self frameAtIndex:leftTop] atGridX:-1 atGridY:0];
        [self addChild:[self frameAtIndex:leftBottomThick] atGridX:-1 atGridY:-1];
        [self addChild:[self frameAtIndex:leftBottomThin] atGridX:-1 atGridY:-2];
        [self addChild:[self frameAtIndex:bottomLong] atGridX:0 atGridY:-3];
        [self addChild:[self frameAtIndex:rightBottomThin] atGridX:1 atGridY:-2];
        [self addChild:[self frameAtIndex:rightBottomThick] atGridX:1 atGridY:-1];
        [self addChild:[self frameAtIndex:rightTop] atGridX:1 atGridY:0];

        [self addChild:self.obstacle];
        
        NSMutableArray *tempPoints = [NSMutableArray new];
        [tempPoints addObject:[NSValue valueWithCGPoint:CGPointMake(0, kTileWidth)]];
        [tempPoints addObject:[NSValue valueWithCGPoint:CGPointMake(-kTileWidth - kTileWidth/2, -kTileWidth/2)]];
        [tempPoints addObject:[NSValue valueWithCGPoint:CGPointMake(0, -kTileWidth*3.5)]];
        [tempPoints addObject:[NSValue valueWithCGPoint:CGPointMake(kTileWidth + kTileWidth/2, -kTileWidth/2)]];

        self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:[self pathFromPoints:tempPoints]];
        [self.physicsBody setAffectedByGravity:NO];
        [self.physicsBody setAllowsRotation:NO];
        
        [self setName:@"obstacle"];
    }
    return self;
}

#pragma mark - Obstacle Frames
- (SKSpriteNode*)frameAtIndex:(NSUInteger)index {
    return [SKSpriteNode spriteNodeWithTexture:[self.textureFrames objectAtIndex:index]];
}

#pragma mark - Creating a path
- (CGPathRef)pathFromPoints:(NSArray*)points {
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, nil, [(NSValue*)[points objectAtIndex:0] CGPointValue].x, [(NSValue*)[points objectAtIndex:0] CGPointValue].y);
    
    for (NSValue *point in points) {
        CGPathAddLineToPoint(path, nil, [point CGPointValue].x, [point CGPointValue].y);
        NSLog(@"%fl %fl",[point CGPointValue].x,[point CGPointValue].y);
    }
    CGPathCloseSubpath(path);
    
    return path;
}

#pragma mark - Convenience
- (void)addChild:(SKSpriteNode *)node atGridX:(CGFloat)gridX atGridY:(CGFloat)gridY {
    [node setPosition:CGPointMake(kTileWidth * gridX, kTileWidth * gridY)];
    
    if (!_obstacle) {
        NSLog(@"Obstacle node does not exist");
        return;
    }
    [_obstacle addChild:node];
}

@end
