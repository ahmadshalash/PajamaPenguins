//
//  SSKParallaxNode.m
//  PajamaPenguins
//
//  Created by Skye on 2/24/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "SSKParallaxNode.h"

@interface SSKParallaxNode()
@property (nonatomic, readwrite) MoveState moveState;
@property (nonatomic) SKNode *firstNode;
@property (nonatomic) SKNode *secondNode;
@end

@implementation SSKParallaxNode

- (instancetype)initWithSize:(CGSize)size attachNode:(SKNode*)node withMoveSpeed:(CGPoint)moveSpeed  {
    self = [super initWithColor:[SKColor clearColor] size:size];
    if (self) {
        self.moveSpeed = moveSpeed;
        self.moveState = MoveStateMoving;
        
        self.firstNode = node;
        [self.firstNode setName:@"parallaxNode"];
        [self.firstNode setPosition:CGPointMake(0, 0)];
        [self addChild:self.firstNode];
        
        self.secondNode = node.copy;
        [self.secondNode setName:@"parallaxNode"];
        [self.secondNode setPosition:CGPointMake(self.size.width, 0)];
        [self addChild:self.secondNode];
    }
    return self;
}

- (void)startMovement {
    self.moveState = MoveStateMoving;
}

- (void)stopMovement {
    self.moveState = MoveStateStopped;
}

- (void)update:(NSTimeInterval)dt {
    if (self.moveState == MoveStateMoving) {
        CGPoint amountToMove = CGPointMake(self.moveSpeed.x * dt, self.moveSpeed.y * dt);
        [self enumerateChildNodesWithName:@"parallaxNode" usingBlock:^(SKNode *node, BOOL *stop) {
            node.position = CGPointMake(node.position.x + amountToMove.x, node.position.y + amountToMove.y);
            if (node.position.x <= -self.size.width) {
                [node setPosition:CGPointMake(self.size.width, 0)];
            }
        }];
    }
}

@end
