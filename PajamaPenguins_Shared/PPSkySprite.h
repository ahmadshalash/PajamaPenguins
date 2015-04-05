//
//  PPSkySprite.h
//  PajamaPenguins
//
//  Created by Skye on 4/4/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSUInteger, SkyType) {
    SkyTypeDay = 0,
};

@interface PPSkySprite : SKSpriteNode
@property (nonatomic) SkyType skyType;

+ (instancetype)spriteWithSize:(CGSize)size skyType:(SkyType)skyType;

@end
