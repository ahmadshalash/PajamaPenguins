//
//  PPPlayer.h
//  PajamaPenguins
//
//  Created by Skye on 2/8/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPSimpleAnimatedSprite.h"

@interface PPPlayer : PPSimpleAnimatedSprite

@property (nonatomic) BOOL playerShouldDive;
- (void)update:(NSTimeInterval)dt;

@end
