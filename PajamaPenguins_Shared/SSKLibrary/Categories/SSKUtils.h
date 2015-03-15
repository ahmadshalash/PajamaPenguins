//
//  SSKUtils.h
//  PajamaPenguins
//
//  Created by Skye on 3/14/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKPhysicsBody (SFAdditions)
+ (SKPhysicsBody*)bodyWithEdgeLoopPathFromPoints:(NSArray*)points;
@end

@interface SKNode (SFAdditions)
- (void)runAction:(SKAction *)action withKey:(NSString *)key completion:(void(^)(void))block;
@end

@interface SKScene (SFAdditions)
- (void)enumerateChilrenForChildNodesWithName:(NSString *)name usingBlock:(void (^)(SKNode *node, BOOL *stop))block;
@end

@interface SKAction (SFAdditions)
+ (SKAction*)moveDistance:(CGVector)distance fadeInWithDuration:(NSTimeInterval)duration;
+ (SKAction*)moveDistance:(CGVector)distance fadeOutWithDuration:(NSTimeInterval)duration;
+ (SKAction*)moveTo:(CGPoint)location duration:(NSTimeInterval)duration timingMode:(SKActionTimingMode)timingMode;
@end
