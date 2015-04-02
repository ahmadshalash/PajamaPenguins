//
//  SSKParallaxNode.m
//  PajamaPenguins
//
//  Created by Skye on 2/24/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "SSKParallaxNode.h"

@interface SSKParallaxNode()
@property (nonatomic) NSMutableArray *allAttachedNodes;
@property (nonatomic) SKNode *firstNode;
@property (nonatomic) SKNode *secondNode;
@property (nonatomic) NSUInteger frameCount;
@end

@implementation SSKParallaxNode

+ (instancetype)nodeWithSize:(CGSize)size attachedNodes:(NSArray*)nodes moveSpeed:(CGPoint)moveSpeed numFrames:(NSUInteger)frames {
    return [[self alloc] initWithSize:size attachedNodes:nodes moveSpeed:moveSpeed numFrames:frames];
}

- (instancetype)initWithSize:(CGSize)size attachedNodes:(NSArray*)nodes moveSpeed:(CGPoint)moveSpeed numFrames:(NSUInteger)frames {
    self = [super initWithColor:[SKColor clearColor] size:size];
    if (self) {
        self.moveSpeed = moveSpeed;
        self.moveState = MoveStateMoving;
        self.frameCount = frames;
        
        self.allAttachedNodes = [NSMutableArray new];
        
        //Pack nodes into container
        for (id node in nodes) {
            if ([node isKindOfClass:[SKNode class]]) {
                [self.allAttachedNodes addObject:node];
            }
        }
        
        //Duplicate nodes
        NSMutableArray *tempDuplicates = [NSMutableArray new];
        for (int i = 0; i < self.allAttachedNodes.count; i++) {
            for (int j = 1; j < self.frameCount; j++) {
                SKSpriteNode *originalNode = [self.allAttachedNodes objectAtIndex:i];
                SKSpriteNode *duplicateNode = [originalNode copy];
                [duplicateNode setPosition:CGPointMake(self.size.width * j, duplicateNode.position.y)];
                [tempDuplicates addObject:duplicateNode];
            }
        }
        [self.allAttachedNodes addObjectsFromArray:tempDuplicates];
        
        //Place nodes
        for (int i = 0; i < self.allAttachedNodes.count; i++) {
            SKSpriteNode *attachedNode = [self.allAttachedNodes objectAtIndex:i];
            [attachedNode setName:@"parallaxNode"];
            [self addChild:attachedNode];
        }
        
    }
    return self;
}

#pragma mark - Update
- (void)update:(NSTimeInterval)dt {
    if (self.moveState == MoveStateMoving) {
        CGPoint amountToMove = CGPointMake(self.moveSpeed.x * dt, self.moveSpeed.y * dt);
        [self enumerateChildNodesWithName:@"parallaxNode" usingBlock:^(SKNode *node, BOOL *stop) {
            node.position = CGPointMake(node.position.x + amountToMove.x, node.position.y + amountToMove.y);
            if (node.position.x <= -self.size.width) {
                [node setPosition:CGPointMake(self.size.width * (self.frameCount-1), node.position.y)];
            }
        }];
    }
}

@end
