//
//  SSKParallaxNode.m
//  PajamaPenguins
//
//  Created by Skye on 2/24/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "SSKParallaxNode.h"

NSString * const kParallaxNode = @"parallaxNode";

@interface SSKParallaxNode()
@property (nonatomic) NSMutableArray *allAttachedNodes;
@property (nonatomic) SKSpriteNode *firstNode;
@property (nonatomic) SKSpriteNode *secondNode;
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
        
        //First parallax frame
        self.firstNode = [self parallaxFrame:size];
        [self.firstNode setName:kParallaxNode];
        [self addChild:self.firstNode];

        for (int i = 0; i < self.allAttachedNodes.count; i++) {
            SKSpriteNode *attachedNode = [self.allAttachedNodes objectAtIndex:i];
            [self.firstNode addChild:attachedNode];
        }
        
        //Second parallax frame
        self.secondNode = self.firstNode.copy;
        [self.secondNode setPosition:CGPointMake(size.width, 0)];
        [self addChild:self.secondNode];
    }
    return self;
}

- (SKSpriteNode*)parallaxFrame:(CGSize)size {
    SKSpriteNode *frame = [SKSpriteNode new];
    frame.size = size;
    return frame;
}

#pragma mark - Update
- (void)update:(NSTimeInterval)dt {
    if (self.moveState == MoveStateMoving) {
        CGPoint amountToMove = CGPointMake(self.moveSpeed.x * dt, self.moveSpeed.y * dt);
        [self enumerateChildNodesWithName:kParallaxNode usingBlock:^(SKNode *node, BOOL *stop) {
            node.position = CGPointMake(node.position.x + amountToMove.x, node.position.y + amountToMove.y);
            if (node.position.x <= -self.size.width) {
                [node setPosition:CGPointMake(self.size.width, node.position.y)];
            }
        }];
    }
}

@end
