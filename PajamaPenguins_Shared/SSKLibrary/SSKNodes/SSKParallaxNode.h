//
//  SSKParallaxNode.h
//  PajamaPenguins
//
//  Created by Skye on 2/24/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSInteger, MoveState) {
    MoveStateMoving,
    MoveStateStopped,
};

@interface SSKParallaxNode : SKSpriteNode

@property (nonatomic) CGPoint moveSpeed;
@property (nonatomic) MoveState moveState;

// Create a parallax node with a given size, array of nodes, speed of parallax (in pixels per second) and the number of frames to duplicate
+ (instancetype)nodeWithSize:(CGSize)size attachedNodes:(NSArray*)nodes moveSpeed:(CGPoint)moveSpeed;

// Update method is required in scene
- (void)update:(NSTimeInterval)dt;

@end
