//
//  PPObstacle.m
//  PajamaPenguins
//
//  Created by Skye on 2/12/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPObstacle.h"
#import "TwoDimensionalArray.h"
#import "SKPhysicsBody+SFAdditions.h"

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
@property (nonatomic) CGFloat textureWidth;
@property (nonatomic) NSUInteger gridWidth;

@property (nonatomic) SKSpriteNode *obstacle;
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
        CGFloat actualObstacleWidth = gridWidth * textureWidth;
        CGFloat actualObstacleHeight = actualObstacleWidth * 1.5;
        
        self.obstacle = [SKSpriteNode new];
        [self.obstacle setPosition:CGPointMake(-actualObstacleWidth/2, actualObstacleHeight/3)]; //Center obstacle within node
        [self addChild:self.obstacle];

        //Populate iceberg grid
        TwoDimensionalArray *grid = [[TwoDimensionalArray alloc] initWithRows:gridWidth columns:gridHeight];
        [self populateGridArray:grid];
        [self addGrid:grid toNode:self.obstacle];
        
        //Adding a physics body to the iceberg
//        CGFloat tileOffset = textureWidth/2;
        
        CGPoint topPoint = CGPointMake(actualObstacleWidth/2, 0);
        CGPoint leftPoint = CGPointMake(0, -actualObstacleHeight/3);
        CGPoint rightPoint = CGPointMake(actualObstacleWidth, -actualObstacleHeight/3);
        CGPoint bottomPoint = CGPointMake(actualObstacleWidth/2, -actualObstacleHeight);
        
        NSArray *pointsForPhysicsPath = [NSArray arrayWithObjects:
                                         [NSValue valueWithCGPoint:topPoint],
                                         [NSValue valueWithCGPoint:leftPoint],
                                         [NSValue valueWithCGPoint:bottomPoint],
                                         [NSValue valueWithCGPoint:rightPoint], nil];
        
        self.obstacle.physicsBody = [SKPhysicsBody bodyWithEdgeLoopPathFromPoints:pointsForPhysicsPath];
    }
    
    return self;
}

#pragma mark - Grid Array
- (void)populateGridArray:(TwoDimensionalArray*)grid {
    BOOL gridWidthEven = [self numberIsEven:grid.rowCount];
    CGPoint leftEdgeTracker, rightEdgeTracker = CGPointZero;
    NSUInteger topBoundary;
    
    if (grid.rowCount > 2) {
        if (gridWidthEven) {
            topBoundary = (grid.rowCount/2) - 1;
        } else {
            topBoundary = grid.rowCount/2;
        }
    } else {
        topBoundary = 0;
    }
    
    //Start with custom tile placement for top and bottom
    if (gridWidthEven) {
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
    NSUInteger bottomSectionRow = 0;
    
    for (int i = 1; i < grid.columnCount; i++) {
        if (i <= topBoundary) {
            leftEdgeTracker = CGPointMake(leftEdgeTracker.x - 1, leftEdgeTracker.y + 1);
            rightEdgeTracker = CGPointMake(rightEdgeTracker.x + 1, rightEdgeTracker.y + 1);
        }
        else if (i > topBoundary && i < (grid.columnCount - 1)){
            bottomSectionRow++;
            if (bottomSectionRow < 3) {
                leftEdgeTracker = CGPointMake(leftEdgeTracker.x, leftEdgeTracker.y + 1);
                rightEdgeTracker = CGPointMake(rightEdgeTracker.x, rightEdgeTracker.y + 1);
            } else {
                leftEdgeTracker = CGPointMake(leftEdgeTracker.x + (bottomSectionRow % 2), leftEdgeTracker.y + 1);
                rightEdgeTracker = CGPointMake(rightEdgeTracker.x - (bottomSectionRow % 2), rightEdgeTracker.y + 1);
            }
        }
        
        for (int j = 0; j < grid.rowCount; j++) {
            ObstacleFrameIndex leftFrameType, rightFrameType;
            if (i <= topBoundary) {
                leftFrameType = leftTop;
                rightFrameType = rightTop;
            } else {
                if ([self numberIsEven:bottomSectionRow]) {
                    leftFrameType = leftBottomThin;
                    rightFrameType = rightBottomThin;
                } else {
                    leftFrameType = leftBottomThick;
                    rightFrameType = rightBottomThick;
                }
            }

            //Left edge tiles
            if (j == leftEdgeTracker.x && i == leftEdgeTracker.y) {
                [grid insertObject:[self tileWithFrameAtIndex:leftFrameType] atRow:j atColumn:i];
            }
            //Right edge tiles
            else if (j == rightEdgeTracker.x && i == rightEdgeTracker.y) {
                [grid insertObject:[self tileWithFrameAtIndex:rightFrameType] atRow:j atColumn:i];
            }
            //Center tiles
            else if (j > leftEdgeTracker.x && j < rightEdgeTracker.x && i > 0 && i < (grid.columnCount - 1)) {
                [grid insertObject:[self tileWithFrameAtIndex:center] atRow:j atColumn:i];
            }
        }
    }
}

- (void)addGrid:(TwoDimensionalArray*)grid toNode:(SKNode*)parent {
    for (int i = 0 ; i < grid.columnCount; i++) {
        for (int j = 0; j < grid.rowCount; j++) {
            [self addChild:[grid getObjectAtRow:j atColumn:i] toNode:parent atGridX:j atGridY:i];
        }
    }
}

#pragma mark - Obstacle Frames
- (SKSpriteNode*)tileWithFrameAtIndex:(NSUInteger)index {
    return [SKSpriteNode spriteNodeWithTexture:[self.textureFrames objectAtIndex:index]];
}

#pragma mark - Convenience
- (void)addChild:(SKSpriteNode *)node toNode:(SKNode*)parent atGridX:(CGFloat)gridX atGridY:(CGFloat)gridY {
    if ([node isKindOfClass:[SKNode class]]) {
        //    [node setPosition:CGPointMake(_textureWidth * gridX, -_textureWidth * gridY)];
        [node setPosition:CGPointMake(_textureWidth * gridX + (1 * gridX), -_textureWidth * gridY - (1 * gridY))]; // For Segment Testing
        [parent addChild:node];
    }
}

- (BOOL)numberIsEven:(NSUInteger)num {
    return ((num % 2) == 0);
}
@end
