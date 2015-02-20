//
//  SKPhysicsBody+SFAdditions.m
//  PajamaPenguins
//
//  Created by Skye on 2/19/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "SKPhysicsBody+SFAdditions.h"

@implementation SKPhysicsBody (SFAdditions)

+ (SKPhysicsBody*)bodyWithEdgeLoopPathFromPoints:(NSArray*)points {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, [(NSValue*)[points objectAtIndex:0] CGPointValue].x, [(NSValue*)[points objectAtIndex:0] CGPointValue].y);
    
    for (NSValue *point in points) {
        CGPathAddLineToPoint(path, nil, [point CGPointValue].x, [point CGPointValue].y);
    }
    CGPathCloseSubpath(path);

    return [SKPhysicsBody bodyWithEdgeLoopFromPath:path];
}

@end
