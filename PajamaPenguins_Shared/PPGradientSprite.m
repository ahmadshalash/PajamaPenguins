//
//  PPGradientSprite.m
//  PajamaPenguins
//
//  Created by Skye on 2/26/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPGradientSprite.h"

@implementation PPGradientSprite

- (instancetype)initWithTexture:(SKTexture *)texture blendedColor:(SKColor*)color {
    self = [super initWithTexture:texture];
    if (self) {
        self.colorBlendFactor = 1.0;
        self.blendMode = SKBlendModeMultiplyX2;
        self.color = color;
    }
    
    return self;
}

@end
