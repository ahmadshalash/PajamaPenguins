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
@property (nonatomic, readonly) MoveState moveState;

- (instancetype)initWithSize:(CGSize)size attachNode:(SKNode*)node withMoveSpeed:(CGPoint)moveSpeed;

- (void)update:(NSTimeInterval)dt;
- (void)startMovement;
- (void)stopMovement;

@end
