//
//  SSKCameraNode.h
//
//  Created by Skye on 2/11/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

/* 
 
 A basic 2D camera implementation for Spritekit. 
 
 NOTE: Requires parent scene's anchorpoint to be centered (0.5, 0.5).
 
 */

@interface SSKCameraNode : SKNode

//Follow
- (void)centerOnNode:(SKNode*)node;
- (void)centerVerticallyOnNode:(SKNode*)node;
- (void)centerHorizontallyOnNode:(SKNode*)node;

@end
