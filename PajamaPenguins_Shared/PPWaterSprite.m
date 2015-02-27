//
//  PPWaterSprite.m
//  PajamaPenguins
//
//  Created by Skye on 2/24/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPWaterSprite.h"

@implementation PPWaterSprite

- (instancetype)initWithTexture:(SKTexture *)texture {
    self = [super initWithTexture:texture];
    if (self) {
        self.anchorPoint = CGPointMake(0, 0);
    }
    return self;
}

@end
