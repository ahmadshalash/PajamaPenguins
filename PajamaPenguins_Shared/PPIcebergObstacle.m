//
//  PPIcebergObstacle.m
//  PajamaPenguins
//
//  Created by Skye on 2/21/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPIcebergObstacle.h"

@implementation PPIcebergObstacle

- (instancetype)initWithWidth:(CGFloat)width {
    self = [PPIcebergObstacle shapeNodeWithPath:[self pathFromPoints:[self cornerPointsWithWidth:width]]];

    if (self) {
        [self setFillColor:[SKColor whiteColor]];
        [self setStrokeColor:[SKColor blackColor]];
        [self setLineWidth:2];
        
        
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:self.path];
        self.physicsBody.restitution = 0;
        self.physicsBody.friction = 0;
    }
    return self;
}

- (NSArray*)cornerPointsWithWidth:(CGFloat)width {
    CGPoint topPoint = CGPointMake(0, width/2);
    CGPoint leftPoint = CGPointMake(-width/2, 0);
    CGPoint bottomPoint = CGPointMake(0, -width);
    CGPoint rightPoint = CGPointMake(width/2, 0);
    
    NSArray *pointsArray = [NSArray arrayWithObjects:
                            [NSValue valueWithCGPoint:topPoint],
                            [NSValue valueWithCGPoint:leftPoint],
                            [NSValue valueWithCGPoint:bottomPoint],
                            [NSValue valueWithCGPoint:rightPoint],
                            nil];
    return pointsArray;
}

- (CGPathRef)pathFromPoints:(NSArray*)points {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, [(NSValue*)[points objectAtIndex:0] CGPointValue].x, [(NSValue*)[points objectAtIndex:0] CGPointValue].y);
    
    for (NSValue *point in points) {
        CGPathAddLineToPoint(path, nil, [point CGPointValue].x, [point CGPointValue].y);
    }
    CGPathCloseSubpath(path);
    return path;
}

@end
