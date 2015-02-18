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
@property (nonatomic) NSUInteger gridWidth;
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

- (instancetype)initWithTexturesFromArray:(NSArray*)array textureWidth:(CGFloat)textureWidth numHorizontalCells:(NSUInteger)gridWidth; {
    self = [super init];
    if (self) {
        self.textureFrames = [NSArray arrayWithArray:array];
        self.textureWidth = textureWidth;
        self.gridWidth = gridWidth;

        NSUInteger gridHeight = ceil(gridWidth * 1.5);
//        NSLog(@"%lu",gridHeight);
        
        TwoDimensionalArray *grid = [[TwoDimensionalArray alloc] initWithRows:gridWidth columns:gridHeight];
        [self populateGridArray:grid];
        [self placeGrid:grid];
    }
    return self;
}

#pragma mark - Grid Array
- (void)populateGridArray:(TwoDimensionalArray*)grid {
    NSUInteger topBoundary;
    if (grid.rowCount > 2) {
        topBoundary = floor(grid.rowCount/2);
    } else {
        topBoundary = 0;
    }
    NSLog(@"Top bounds %lu",topBoundary);
    
    CGPoint leftEdgeTracker, rightEdgeTracker = CGPointZero;
    
    //Start with custom tile placement for top and bottom
    if ([self numberIsEven:grid.rowCount]) {
        [grid insertObject:[self tileWithFrameAtIndex:leftTop] atRow:(grid.rowCount/2 - 1) atColumn:0]; //Top Left Cap
        [grid insertObject:[self tileWithFrameAtIndex:rightTop] atRow:(grid.rowCount/2) atColumn:0]; //Top Right Cap
        [grid insertObject:[self tileWithFrameAtIndex:leftBottomThin] atRow:(grid.rowCount/2 - 1) atColumn:grid.columnCount - 1]; //Bottom Left Cap
        [grid insertObject:[self tileWithFrameAtIndex:rightBottomThin] atRow:(grid.rowCount/2) atColumn:grid.columnCount - 1]; //Bottom Right Cap
        
        leftEdgeTracker = CGPointMake((grid.rowCount/2 - 1), 0);
        rightEdgeTracker = CGPointMake(grid.rowCount/2, 0);
    } else {
        [grid insertObject:[self tileWithFrameAtIndex:top] atRow:floor(grid.rowCount/2) atColumn:0]; //Top cap
        [grid insertObject:[self tileWithFrameAtIndex:bottomLong] atRow:floor(grid.rowCount/2) atColumn:grid.columnCount - 1]; //Bottom cap
        
        leftEdgeTracker = CGPointMake(floor(grid.rowCount/2), 0);
        rightEdgeTracker = leftEdgeTracker;
    }
    
    //First Pass
    for (int i = 1; i < grid.columnCount; i++) {
        if (i <= topBoundary) {
            leftEdgeTracker = CGPointMake(leftEdgeTracker.x - 1, leftEdgeTracker.y + 1);
            rightEdgeTracker = CGPointMake(rightEdgeTracker.x + 1, rightEdgeTracker.y + 1);
//            NSLog(@"Left Tracker: (%fl,%fl) Right Tracker: (%fl,%fl)",leftEdgeTracker.x,leftEdgeTracker.y,rightEdgeTracker.x,rightEdgeTracker.y);
        }
        
        for (int j = 0; j < grid.rowCount; j++) {
            if (j == leftEdgeTracker.x && i == leftEdgeTracker.y) {
                [grid insertObject:[self tileWithFrameAtIndex:leftTop] atRow:j atColumn:i];
                NSLog(@"Left: %d,%d",j,i);
            }
            else if (j == rightEdgeTracker.x && i == rightEdgeTracker.y) {
                NSLog(@"Right: %d,%d",j,i);
                [grid insertObject:[self tileWithFrameAtIndex:rightTop] atRow:j atColumn:i];
            }
        }
    }
    
    //Second Pass
    for (int i = 0; i < grid.columnCount; i++) {
        for (int j = 0; j < grid.rowCount; j++) {
        }
    }
}

- (void)placeGrid:(TwoDimensionalArray*)grid {
    for (int i = 0 ; i < grid.columnCount; i++) {
        for (int j = 0; j < grid.rowCount; j++) {
            [self addChild:[grid getObjectAtRow:j atColumn:i] atGridX:j atGridY:i];
        }
    }
}

#pragma mark - Obstacle Frames
- (SKSpriteNode*)tileWithFrameAtIndex:(NSUInteger)index {
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
    if ([node isKindOfClass:[SKNode class]]) {
        //    [node setPosition:CGPointMake(_textureWidth * gridX, -_textureWidth * gridY)];
        [node setPosition:CGPointMake(_textureWidth * gridX + (1 * gridX), -_textureWidth * gridY - (1 * gridY))]; // For Segment Testing
        [self addChild:node];
    }
}

- (BOOL)numberIsEven:(NSUInteger)num {
    return ((num % 2) == 0);
}
@end
