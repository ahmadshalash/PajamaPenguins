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
@property (nonatomic) CGFloat currentVelocity;

- (instancetype)initWithTexture:(SKTexture *)texture atPosition:(CGPoint)position;

- (void)update:(NSTimeInterval)dt;


@end
