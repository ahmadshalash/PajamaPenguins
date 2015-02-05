//
//  SSKPhysicsUtils.h
//
//  Created by Skye on 1/7/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSKPhysicsUtils : NSObject

//Provides calculations for acceleration
+ (CGVector)accelerateWithRate:(CGFloat)rate currentVelocity:(CGVector)currentVelocity targetVelocity:(CGVector)targetVelocity;

//Provides calculations for deceleration
+ (CGVector)decelerateWithRate:(CGFloat)rate currentVelocity:(CGVector)currentVelocity stopThreshhold:(CGFloat)stopThreshold;

//Provides horizontal calculations only for deceleration
+ (CGVector)horizontallyDecelerateWithRate:(CGFloat)rate currentVelocity:(CGVector)currentVelocity stopThreshhold:(CGFloat)stopThreshold;

@end
