//
//  SSKMathUtils.h
//
//  Created by Skye on 1/8/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKMath.h>

#define ARC4RANDOM_MAX 0xFFFFFFFFu
#define SSK_INLINE static __inline__

SSK_INLINE CGFloat SSKRandomFloatInRange(CGFloat min, CGFloat max) {
    return floorf(((double)arc4random() / ARC4RANDOM_MAX) * (max - min) + min);
}

SSK_INLINE CGFloat SSKDegreesToRadians(CGFloat degrees) {
    return M_PI/(180/-degrees);
}

SSK_INLINE CGFloat SSKSubtractNumbers(CGFloat first, CGFloat second) {
    return (first - second);
}

SSK_INLINE CGFloat SSKSquareNumber(CGFloat num) {
    return (num * num);
}

SSK_INLINE CGVector SSKDistanceBetweenPoints(CGPoint first, CGPoint second) {
    return CGVectorMake(SSKSubtractNumbers(second.x, first.x), SSKSubtractNumbers(second.y, first.y));
}

