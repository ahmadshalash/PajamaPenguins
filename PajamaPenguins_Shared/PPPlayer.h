//
//  PPPlayer.h
//  PajamaPenguins
//
//  Created by Skye on 2/8/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPSimpleAnimatedSprite.h"

typedef NS_ENUM(NSUInteger, PlayerState) {
    PlayerStateIdle = 0,
    PlayerStateSwim,
    PlayerStateFly,
};

@interface PPPlayer : PPSimpleAnimatedSprite

+ (instancetype)playerWithIdleTextures:(NSArray*)idleTextures swimTextures:(NSArray*)swimTextures flyTextures:(NSArray*)flyTextures;
- (instancetype)initWithIdleTextures:(NSArray*)idleTextures swimTextures:(NSArray*)swimTextures flyTextures:(NSArray*)flyTextures;
- (void)update:(NSTimeInterval)dt;

@property (nonatomic) PlayerState playerState;
@property (nonatomic) BOOL playerShouldDive;
@end
