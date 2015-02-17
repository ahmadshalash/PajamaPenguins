//
//  PPObstacle.m
//  PajamaPenguins
//
//  Created by Skye on 2/12/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPObstacle.h"
#import "TwoDimensionalArray.h"

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

@interface PPObstacle()
@property (nonatomic) NSArray *textureFrames;
@property (nonatomic) SKNode *obstacle;

@property (nonatomic) CGFloat textureWidth;
@property (nonatomic) CGFloat gridWidth;
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

- (instancetype)initWithTexturesFromArray:(NSArray*)array textureWidth:(CGFloat)textureWidth gridWidth:(CGFloat)gridWidth {
    self = [super init];
    if (self) {
        self.textureFrames = [NSArray arrayWithArray:array];
        self.textureWidth = textureWidth;
        self.gridWidth = gridWidth;

        self.obstacle = [SKNode new];
        
        TwoDimensionalArray *grid = [[TwoDimensionalArray alloc] initWithRows:3 columns:5];
    }
    return self;
}

//- (NSMutableArray*)newGridWithWidth:(CGFloat)width height:(CGFloat)height {
//    NSMutableArray *row = [NSMutableArray arrayWithCapacity:width];
//    for (int i = 0; i < width; i++) {
//        NSMutableArray *row = [NSMutableArray arrayWithCapacity:height];
//    }
//}

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
    [node setPosition:CGPointMake(_textureWidth * gridX, _textureWidth * gridY)];
    
    if (!_obstacle) {
        NSLog(@"Obstacle node does not exist");
        return;
    }
    [_obstacle addChild:node];
}

@end
