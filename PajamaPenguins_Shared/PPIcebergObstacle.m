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
//    self = [SKShapeNode shape];
//    
//    if (self) {
//    }
    return self;
}

- (SKShapeNode*)testShape {
    CGPoint topPoint = CGPointMake(0, 50);
    CGPoint leftPoint = CGPointMake(-50, 0);
    CGPoint bottomPoint = CGPointMake(0, -50);
    CGPoint rightPoint = CGPointMake(50, 0);
    
    NSArray *pointsArray = [NSArray arrayWithObjects:
                            [NSValue valueWithCGPoint:topPoint],
                            [NSValue valueWithCGPoint:leftPoint],
                            [NSValue valueWithCGPoint:bottomPoint],
                            [NSValue valueWithCGPoint:rightPoint],
                            nil];
    
    SKShapeNode *shape = [SKShapeNode shapeNodeWithPath:[self pathFromPoints:pointsArray] centered:NO];
    shape.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:shape.path];
    [shape.physicsBody setAffectedByGravity:YES];
    [shape setFillColor:[SKColor whiteColor]];
    [shape setScale:5];
    return shape;
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
