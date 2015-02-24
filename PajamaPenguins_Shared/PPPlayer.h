//
//  PPPlayer.h
//  PajamaPenguins
//
//  Created by Skye on 2/8/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface PPPlayer : SKSpriteNode

@property (nonatomic) BOOL playerShouldDive;

- (instancetype)initWithIdleTexture:(SKTexture *)idleTexture activeTexture:(SKTexture*)activeTexture atPosition:(CGPoint)position;
- (void)update:(NSTimeInterval)dt;

@end
