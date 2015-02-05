//
//  SSKScene.m
//
//  Created by Skye Freeman on 1/1/2015.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.

/*
 
 This is a barebones subclass of SKScene that provides a cross-device (iOS and OS X)
 interface for screen input (touch and mouse clicks).
 
 */

#import <SpriteKit/SpriteKit.h>

@interface SSKScene : SKScene

// Mouse and touch input
- (void)interactionBeganAtPosition:(CGPoint)position;
- (void)interactionMovedAtPosition:(CGPoint)position;
- (void)interactionEndedAtPosition:(CGPoint)position;

// Keyboard input
#if !TARGET_OS_IPHONE
- (void)handleKeyEvent:(NSEvent*)theEvent keyDown:(BOOL)downOrUp;
#endif

@end
