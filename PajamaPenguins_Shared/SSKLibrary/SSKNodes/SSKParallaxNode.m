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
@property (nonatomic) NSMutableArray *allAttachedNodes;
@property (nonatomic) SKNode *firstNode;
@property (nonatomic) SKNode *secondNode;
@end

@implementation SSKParallaxNode

+ (instancetype)nodeWithSize:(CGSize)size attachedNodes:(NSArray*)nodes moveSpeed:(CGPoint)moveSpeed {
    return [[self alloc] initWithSize:size attachedNodes:nodes moveSpeed:moveSpeed];
}

- (instancetype)initWithSize:(CGSize)size attachedNodes:(NSArray*)nodes moveSpeed:(CGPoint)moveSpeed {
    self = [super initWithColor:[SKColor clearColor] size:size];
    if (self) {
        self.moveSpeed = moveSpeed;
        self.moveState = MoveStateMoving;
        
        self.allAttachedNodes = [NSMutableArray new];
        
        //Pack nodes into container
        for (id node in nodes) {
            if ([node isKindOfClass:[SKNode class]]) {
                [self.allAttachedNodes addObject:node];
            }
        }
        
        //Place nodes
        for (int i = 0; i < self.allAttachedNodes.count; i++) {
            SKNode *attachedNode = [self.allAttachedNodes objectAtIndex:i];
            [attachedNode setName:@"parallaxNode"];
            [attachedNode setPosition:CGPointMake((self.size.width * i) - (1 * i), 0)];
            [self addChild:attachedNode];
        }

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
                [node setPosition:CGPointMake(self.size.width - 2, 0)];
            }
        }];
    }
}

@end
