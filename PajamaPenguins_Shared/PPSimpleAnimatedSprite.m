//
//  PPSimpleAnimatedSprite.m
//  PajamaPenguins
//
//  Created by Skye on 2/24/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPSimpleAnimatedSprite.h"

@implementation PPSimpleAnimatedSprite
+ (instancetype)spriteWithFirstTexture:(SKTexture*)firstTexture secondTexture:(SKTexture*)secondTexture {
    return [[self alloc] initWithFirstTexture:firstTexture secondTexture:secondTexture];
}

- (instancetype)initWithFirstTexture:(SKTexture*)firstTexture secondTexture:(SKTexture*)secondTexture {
    self = [super initWithTexture:firstTexture];
    if (self) {
        self.firstTexture = firstTexture;
        self.secondTexture = secondTexture;
    }
    return self;
}

#pragma mark - Animation
- (void)animateToFirstTexture {
    [self setTexture:self.firstTexture];
}

- (void)animateToSecondTexture {
    [self setTexture:self.secondTexture];
}

- (void)animateForeverWithDuration:(CGFloat)duration {
    if (![self actionForKey:@"animating"]) {
        SKAction *firstTexture = [SKAction performSelector:@selector(animateToFirstTexture) onTarget:self];
        SKAction *secondTexture = [SKAction performSelector:@selector(animateToSecondTexture) onTarget:self];
        SKAction *wait = [SKAction waitForDuration:duration];
        SKAction *sequence = [SKAction sequence:@[wait,secondTexture,wait,firstTexture]];
        [self runAction:[SKAction repeatActionForever:sequence] withKey:@"animating"];
    }
}

@end
