//
//  SKAction+SFAdditions.m
//  PajamaPenguins
//
//  Created by Skye on 3/6/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "SKAction+SFAdditions.h"

@implementation SKAction (SFAdditions)
+ (SKAction*)moveDistance:(CGVector)distance andFadeInWithDuration:(NSTimeInterval)duration {
    SKAction *fadeIn = [SKAction fadeInWithDuration:duration];
    SKAction *moveIn = [SKAction moveBy:distance duration:duration];
    return [SKAction group:@[fadeIn,moveIn]];
}

+ (SKAction*)moveDistance:(CGVector)distance andFadeOutWithDuration:(NSTimeInterval)duration {
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
