//
//  SSKCameraNode.m
//
//  Created by Skye on 2/11/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "SSKCameraNode.h"

@implementation SSKCameraNode

#pragma mark - Camera Follow
- (void)centerOnNode:(SKNode*)node {
    CGPoint cameraPositionInScene = [node.scene convertPoint:node.position fromNode:node.parent];
    node.parent.position = CGPointMake(node.parent.position.x - cameraPositionInScene.x, node.parent.position.y - cameraPositionInScene.y);
}

- (void)centerVerticallyOnNode:(SKNode*)node {
    CGPoint cameraPositionInScene = [node.scene convertPoint:node.position fromNode:node.parent];
    node.parent.position = CGPointMake(node.parent.position.x, node.parent.position.y - cameraPositionInScene.y);
}

- (void)centerHorizontallyOnNode:(SKNode*)node {
    CGPoint cameraPositionInScene = [node.scene convertPoint:node.position fromNode:node.parent];
    node.parent.position = CGPointMake(node.parent.position.x - cameraPositionInScene.x, node.parent.position.y);
}

@end
