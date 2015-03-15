//
//  SSKUtils.m
//  PajamaPenguins
//
//  Created by Skye on 3/14/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "SSKUtils.h"

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

@implementation SKNode (SFAdditions)
- (void)runAction:(SKAction *)action withKey:(NSString *)key completion:(void(^)(void))block {
    SKAction *completion = [SKAction runBlock:^{
        block();
    }];
    SKAction *sequence = [SKAction sequence:@[action,completion]];
    [self runAction:sequence withKey:key];
}
@end

@implementation SKScene (SFAdditions)
- (void)enumerateChilrenForChildNodesWithName:(NSString *)name usingBlock:(void (^)(SKNode *node, BOOL *stop))block {
    NSString *recursiveName = [NSString stringWithFormat:@"//%@",name];
    [self enumerateChildNodesWithName:recursiveName usingBlock:^(SKNode *node, BOOL *stop) {
        block(node,stop);
    }];
}
@end

@implementation SKAction (SFAdditions)
+ (SKAction*)moveDistance:(CGVector)distance fadeInWithDuration:(NSTimeInterval)duration {
    SKAction *fadeIn = [SKAction fadeInWithDuration:duration];
    SKAction *moveIn = [SKAction moveBy:distance duration:duration];
    return [SKAction group:@[fadeIn,moveIn]];
}

+ (SKAction*)moveDistance:(CGVector)distance fadeOutWithDuration:(NSTimeInterval)duration {
    SKAction *fadeOut = [SKAction fadeOutWithDuration:duration];
    SKAction *moveOut = [SKAction moveBy:distance duration:duration];
    return [SKAction group:@[fadeOut,moveOut]];
}

+ (SKAction*)moveTo:(CGPoint)location duration:(NSTimeInterval)duration timingMode:(SKActionTimingMode)timingMode {
    SKAction *move = [SKAction moveTo:location duration:duration];
    [move setTimingMode:timingMode];
    return move;
}
@end