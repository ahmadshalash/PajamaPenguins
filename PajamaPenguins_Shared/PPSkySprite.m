//
//  PPSkySprite.m
//  PajamaPenguins
//
//  Created by Skye on 4/4/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPSkySprite.h"
#import "SKTexture+SFAdditions.h"
#import "SKColor+SFAdditions.h"

#define skyColorDayStart [SKColor colorWithR:172 g:213 b:206]
#define skyColorDayEnd [SKColor colorWithR:46 g:91 b:169]

@implementation PPSkySprite
+ (instancetype)spriteWithSize:(CGSize)size skyType:(SkyType)skyType {
    return [[self alloc] initWithSize:size skyType:skyType];
}

- (instancetype)initWithSize:(CGSize)size skyType:(SkyType)skyType {
    self = [super initWithTexture:[self textureForSkyType:skyType size:size]];
    
    if (self) {
        self.anchorPoint = CGPointMake(0.5, 0);
    }
    
    return self;
}

#pragma mark - Convenience
- (SKTexture*)textureForSkyType:(SkyType)skyType size:(CGSize)size {
    SKTexture *skyTexture;
    
    switch (skyType) {
        case SkyTypeDay:
            skyTexture = [SKTexture textureWithGradientOfSize:size startColor:skyColorDayStart endColor:skyColorDayEnd direction:GradientDirectionVertical];
            break;
            
        default:
            break;
    }

    return skyTexture;
}

@end
