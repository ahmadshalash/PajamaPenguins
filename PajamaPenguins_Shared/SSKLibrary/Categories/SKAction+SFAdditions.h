//
//  SKAction+SFAdditions.h
//  PajamaPenguins
//
//  Created by Skye on 3/6/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKAction (SFAdditions)
+ (SKAction*)moveDistance:(CGVector)distance andFadeInWithDuration:(NSTimeInterval)duration;
+ (SKAction*)moveDistance:(CGVector)distance andFadeOutWithDuration:(NSTimeInterval)duration;
+ (SKAction*)moveTo:(CGPoint)location duration:(NSTimeInterval)duration timingMode:(SKActionTimingMode)timingMode;
@end
