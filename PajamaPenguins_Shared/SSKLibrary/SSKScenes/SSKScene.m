//
//  SSKScene.m
//
//  Created by Skye Freeman on 1/1/2015.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.

#import "SSKScene.h"

@implementation SSKScene {
    NSTimeInterval _lastUpdateTime;
}

- (id)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if (self) {
        self.anchorPoint = CGPointMake(0.5, 0.5);
        self.physicsWorld.contactDelegate = self;
    }
    return self;
}

#pragma mark - Scene Asset Preloading
+ (void)loadSceneAssetsWithCompletionHandler:(AssetCompletionHandler)handler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        [self loadSceneAssets]; //Loads subclasses assets on a background thread
        
        if (!handler) {
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            handler();  //Calls the handler on the main thread once assets are ready.
        });
    });
}

+ (void)loadSceneAssets {
    //Overridden by subclasses
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

#pragma mark - Input Abstraction
- (void)interactionBeganAtPosition:(CGPoint)position {
    /* Overridden by subclasses */
}

- (void)interactionMovedAtPosition:(CGPoint)position {
    /* Overridden by subclasses */
}

- (void)interactionEndedAtPosition:(CGPoint)position {
    /* Overridden by subclasses */
}

#pragma mark - Collision Detection
- (void)didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *firstBody;
    SKPhysicsBody *secondBody;
    
    if (contact.bodyA.contactTestBitMask < contact.bodyB.contactTestBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    [self resolveCollisionFromFirstBody:firstBody secondBody:secondBody];
}

- (void)resolveCollisionFromFirstBody:(SKPhysicsBody*)firstBody secondBody:(SKPhysicsBody*)secondBody {
    /* Overridden by subclasses */
}

#pragma mark - Update
- (void)update:(NSTimeInterval)currentTime {
    self.deltaTime = currentTime - _lastUpdateTime;
    _lastUpdateTime = currentTime;
    
    if (self.deltaTime > 1) {
        self.deltaTime = 0;
    }
}

@end
