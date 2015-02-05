//
//  SSKButton.m
//
//  Created by Skye on 12/22/14.
//  Copyright (c) 2014 skyefreeman. All rights reserved.
//

#import "SSKButton.h"

@interface SSKButton()
@end

@implementation SSKButton

#pragma mark - Texture initializer
- (id)initWithIdleTexture:(SKTexture*)idleTexture selectedTexture:(SKTexture*)selectedTexture {
    self = [super initWithTexture:idleTexture color:[SKColor clearColor] size:idleTexture.size];
    if (self) {
        [self setIdleTexture:idleTexture];
        [self setSelectedTexture:selectedTexture];
        
        [self setIsSelected:NO];

        //TODO : For Button Resizing, make a subclass?
//        self.centerRect = CGRectMake(12.0/34.0, 12/34.0, 5.0/34.0, 5.0/34.0);
        
        [self setUserInteractionEnabled:YES];
    }
    return self;
}

#pragma mark - Image name initializer
- (id)initWithIdleImageName:(NSString*)idleImageName selectedImageName:(NSString*)selectedImageName {
    SKTexture *idleTexture = nil;
    if (idleImageName) {
        idleTexture = [SKTexture textureWithImageNamed:idleImageName];
    }
    
    SKTexture *selectedTexture = nil;
    if (selectedImageName) {
        selectedTexture = [SKTexture textureWithImageNamed:selectedImageName];
    }
    
    return [self initWithIdleTexture:idleTexture selectedTexture:selectedTexture];
}

#pragma mark - Super class initialization override
- (id)initWithImageNamed:(NSString *)name {
    return [self initWithIdleImageName:name selectedImageName:nil];
}

- (id)initWithTexture:(SKTexture *)texture {
    return [self initWithIdleTexture:texture selectedTexture:nil];
}

- (id)initWithTexture:(SKTexture *)texture color:(SKColor*)color size:(CGSize)size {
    return [self initWithIdleTexture:texture selectedTexture:nil];
}

#pragma mark - Setter Overrides
- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (_selectedTexture) {
        if (_isSelected) {
            [self setTexture:_selectedTexture];
        } else {
            [self setTexture:_idleTexture];
        }
    }
}

#pragma mark - Setting Target-Action Pairs
- (void)setTouchUpInsideTarget:(id)theTarget selector:(SEL)theSelector {
    _targetTouchUpInside = theTarget;
    _SELTouchUpInside = theSelector;
}

- (void)setTouchUpOutsideTarget:(id)theTarget selector:(SEL)theSelector {
    _targetTouchUpOutside = theTarget;
    _SELTouchUpOutside = theSelector;
}

- (void)setTouchDownInsideTarget:(id)theTarget selector:(SEL)theSelector {
    _targetTouchDownInside = theTarget;
    _SELTouchDownInside = theSelector;
}

#pragma mark - Handling user node input

#if TARGET_OS_IPHONE
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self interactionBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self interactionMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self interactionEnded:touches withEvent:event];
}

#else
- (void)mouseDown:(NSEvent *)theEvent {
    [self interactionBegan:nil withEvent:theEvent];
}

- (void)mouseMoved:(NSEvent *)theEvent {
    [self interactionMoved:nil withEvent:theEvent];
}

- (void)mouseUp:(NSEvent *)theEvent {
    [self interactionEnded:nil withEvent:theEvent];
}
#endif

- (void)interactionBegan:(NSSet *)interactions withEvent:(id)event {
    [self setIsSelected:YES];
    [self runAction:[SKAction performSelector:_SELTouchDownInside onTarget:_targetTouchDownInside]];
}

- (void)interactionMoved:(NSSet *)interactions withEvent:(id)event {
    CGPoint location = [self getLocationWithInteractions:interactions withEvent:event];

    if (CGRectContainsPoint(self.frame, location)) {
        [self setIsSelected:YES];
    } else {
        [self setIsSelected:NO];
    }
}

- (void)interactionEnded:(NSSet *)interactions withEvent:(id)event {
    CGPoint location = [self getLocationWithInteractions:interactions withEvent:event];
    
    if (CGRectContainsPoint(self.frame, location)) {
        [self runAction:[SKAction performSelector:_SELTouchUpInside onTarget:_targetTouchUpInside]];
    } else {
        [self runAction:[SKAction performSelector:_SELTouchUpOutside onTarget:_targetTouchUpOutside]];
    }
    [self setIsSelected:NO];
}

#pragma mark - Convenience
- (CGPoint)getLocationWithInteractions:(NSSet*)interactions withEvent:(id)event {
    CGPoint location;
    
#if TARGET_OS_IPHONE
    UITouch *touch = [interactions anyObject];
    location = [touch locationInNode:self.parent];
#else
    location = [event locationInNode:self.parent];
#endif
    return location;
}
@end