//
//  SSKColor+Additions.m
//
//  Created by Skye on 1/5/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <SpriteKit/SpriteKit.h>

#define SSK_INLINE static __inline__

SSK_INLINE SKColor *SKColorWithRGB(int r, int g, int b) {
    return [SKColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f];
}

SSK_INLINE SKColor *SKColorWithRGBA(int r, int g, int b, int a) {
    return [SKColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a/255.0f];
}
