//
//  PPSimpleAnimatedSprite.h
//  PajamaPenguins
//
//  Created by Skye on 2/24/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface PPSimpleAnimatedSprite : SKSpriteNode
@property (nonatomic) SKTexture *firstTexture;
@property (nonatomic) SKTexture *secondTexture;

+ (instancetype)spriteWithFirstTexture:(SKTexture*)firstTexture secondTexture:(SKTexture*)secondTexture;
- (instancetype)initWithFirstTexture:(SKTexture*)firstTexture secondTexture:(SKTexture*)secondTexture;

- (void)animateToFirstTexture;
- (void)animateToSecondTexture;
- (void)animateForeverWithDuration:(CGFloat)duration;

@end
