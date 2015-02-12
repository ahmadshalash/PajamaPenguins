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

#pragma mark - Camera Zoom
- (void)zoomToScale:(CGFloat)scale duration:(NSTimeInterval)duration onPosition:(CGPoint)position {
    CGPoint cameraPositionInScene = [self.scene convertPoint:self.position fromNode:self.parent];

    [self runAction:[SKAction scaleTo:scale duration:duration]];
}

//SKNode *player = [self.worldNode childNodeWithName:@"player"];
//
//CGFloat topBoundary = self.size.height/4;
//CGFloat bottomBoundary = -topBoundary;
//
//CGFloat maxDistance = self.size.height/2 - topBoundary;
//CGFloat currentDistanceFromTop = SSKSubtractNumbers(player.position.y, topBoundary);
//CGFloat currentDistanceFromBottom = SSKSubtractNumbers(player.position.y, bottomBoundary);
//
//CGFloat ratio = 0.125;
//CGFloat topRatio = fabsf((currentDistanceFromTop/maxDistance) * ratio);
//CGFloat botRatio = fabsf((currentDistanceFromBottom/maxDistance) * ratio);
//
//CGFloat distance = SSKDistanceBetweenPoints(CGPointZero, CGPointMake(self.size.width/2, self.size.height/2));
//
//CGFloat amtToMoveTop = distance*topRatio;
//CGFloat amtToMoveBottom = distance*botRatio;
//
//if (player.position.y > topBoundary)
//{
//    [self.worldNode setScale:1 - topRatio];
//    [self.worldNode setPosition:CGPointMake(-(amtToMoveTop/2), -(amtToMoveTop/2))];
//    
//    if (self.worldNode.xScale <= kWorldScaleCap) {
//        [self.worldNode setScale:kWorldScaleCap];
//        [self.worldNode setPosition:CGPointMake(-(distance/2) * (1 - kWorldScaleCap), -(distance/2)*(1 - kWorldScaleCap))];
//    }
//}
//
//else if (player.position.y <= bottomBoundary) {
//    [self.worldNode setScale:1 - botRatio];
//    [self.worldNode setPosition:CGPointMake(-(amtToMoveBottom/2), amtToMoveBottom/2)];
//    
//    if (self.worldNode.xScale <= kWorldScaleCap) {
//        [self.worldNode setScale:kWorldScaleCap];
//        [self.worldNode setPosition:CGPointMake(-(distance/2) * (1 - kWorldScaleCap), (distance/2) * (1 - kWorldScaleCap))];
//    }
//}
//
//else {
//    [self.worldNode setScale:1];
//    [self.worldNode setPosition:CGPointZero];
//}


@end
