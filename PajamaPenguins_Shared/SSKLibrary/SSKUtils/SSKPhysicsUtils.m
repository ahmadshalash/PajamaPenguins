//
//  SSKPhysicsUtils.m
//
//  Created by Skye on 1/7/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "SSKPhysicsUtils.h"

@implementation SSKPhysicsUtils

+ (CGVector)accelerateWithRate:(CGFloat)rate currentVelocity:(CGVector)currentVelocity targetVelocity:(CGVector)targetVelocity {
    CGFloat updatedDX, updatedDY;
    
    //Horizontal Acceleration
    updatedDX = targetVelocity.dx - currentVelocity.dx;
    
    //Vertical Acceleration
    updatedDY = targetVelocity.dy - currentVelocity.dy;
    
    return CGVectorMake(currentVelocity.dx + updatedDX * rate, currentVelocity.dy + updatedDY * rate);
}

+ (CGVector)decelerateWithRate:(CGFloat)rate currentVelocity:(CGVector)currentVelocity stopThreshhold:(CGFloat)stopThreshold {
    CGFloat updatedDX, updatedDY;
    
    updatedDX = currentVelocity.dx - currentVelocity.dx * rate;
    updatedDY = currentVelocity.dy - currentVelocity.dy * rate;
    
    //Horizontal stop
    if ((currentVelocity.dx > 0.0 && currentVelocity.dx < stopThreshold) ||
        (currentVelocity.dx < 0.0 && currentVelocity.dx >= -stopThreshold))
    {
        updatedDX = 0;
    }
    
    //Vertical stop
    if ((currentVelocity.dy > 0.0 && currentVelocity.dy < stopThreshold) ||
        (currentVelocity.dy < 0.0 && currentVelocity.dy >= -stopThreshold))
    {
        updatedDY = 0;
    }
    
    return CGVectorMake(updatedDX, updatedDY);
}

+ (CGVector)horizontallyDecelerateWithRate:(CGFloat)rate currentVelocity:(CGVector)currentVelocity stopThreshhold:(CGFloat)stopThreshold {
    CGFloat updatedDX;
    
    updatedDX = currentVelocity.dx - currentVelocity.dx * rate;
    
    //Horizontal stop
    if ((currentVelocity.dx > 0.0 && currentVelocity.dx < stopThreshold) ||
        (currentVelocity.dx < 0.0 && currentVelocity.dx >= -stopThreshold))
    {
        updatedDX = 0;
    }

    return CGVectorMake(updatedDX, currentVelocity.dy);
}

@end
