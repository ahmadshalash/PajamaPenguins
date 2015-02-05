//
//  SSKScene.m
//
//  Created by Skye Freeman on 1/1/2015.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.

#import "SSKScene.h"

@implementation SSKScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Overridden by subclasses */
    }
    return self;
}

#pragma mark - iOS touch interaction

#if TARGET_OS_IPHONE
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint position = [touch locationInNode:self];
    [self interactionBeganAtPosition:position];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint position = [touch locationInNode:self];
    [self interactionMovedAtPosition:position];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint position = [touch locationInNode:self];
    [self interactionEndedAtPosition:position];
}

#else

#pragma mark - Mac mouse click interaction
- (void)mouseDown:(NSEvent *)theEvent {
    CGPoint position = [theEvent locationInNode:self];
    [self interactionBeganAtPosition:position];
}

- (void)mouseDragged:(NSEvent *)theEvent {
    CGPoint position = [theEvent locationInNode:self];
    [self interactionMovedAtPosition:position];
}

- (void)mouseUp:(NSEvent *)theEvent {
    CGPoint position = [theEvent locationInNode:self];
    [self interactionEndedAtPosition:position];
}

#pragma mark - Mac key interaction
- (void)keyDown:(NSEvent *)theEvent {
    [self handleKeyEvent:theEvent keyDown:YES];
}

- (void)keyUp:(NSEvent *)theEvent {
    [self handleKeyEvent:theEvent keyDown:NO];
}
#pragma mark - Overriden interaction methods
- (void)handleKeyEvent:(NSEvent*)theEvent keyDown:(BOOL)downOrUp {
    /* Overridden by subclasses */
}
#endif

- (void)interactionBeganAtPosition:(CGPoint)position {
    /* Overridden by subclasses */
}

- (void)interactionMovedAtPosition:(CGPoint)position {
    /* Overridden by subclasses */
}

- (void)interactionEndedAtPosition:(CGPoint)position {
    /* Overridden by subclasses */
}

@end
