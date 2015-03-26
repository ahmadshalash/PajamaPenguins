//
//  SSKButtonNode.m
//
//  Created by Skye on 12/22/14.
//  Copyright (c) 2014 skyefreeman. All rights reserved.
//

#import "SSKButtonNode.h"

@interface SSKButtonNode()
@end

@implementation SSKButtonNode

#pragma mark - Init with textures
- (instancetype)initWithIdleTexture:(SKTexture*)idleTexture selectedTexture:(SKTexture*)selectedTexture {
    self = [super initWithTexture:idleTexture color:[SKColor clearColor] size:idleTexture.size];
    if (self) {
        if (idleTexture) {
            [self setIdleTexture:idleTexture];
        }
        
        if (selectedTexture) {
            [self setSelectedTexture:selectedTexture];
        }
        
        [self setIsSelected:NO];
        [self setUserInteractionEnabled:YES];
    }
    return self;
}

- (instancetype)initWithTexture:(SKTexture *)texture {
    return [self initWithIdleTexture:texture selectedTexture:nil];
}

- (instancetype)initWithTexture:(SKTexture *)texture color:(SKColor*)color size:(CGSize)size {
    return [self initWithIdleTexture:texture selectedTexture:nil];
}

#pragma mark - Init with images named
- (instancetype)initWithIdleImageName:(NSString*)idleImageName selectedImageName:(NSString*)selectedImageName {
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

- (instancetype)initWithImageNamed:(NSString *)name {
    return [self initWithIdleImageName:name selectedImageName:nil];
}

#pragma mark - Init with colors
- (instancetype)initWithIdleColor:(UIColor *)idleColor selectedColor:(UIColor *)selectedColor size:(CGSize)size labelWithText:(NSString*)text {
    self = [super initWithColor:idleColor size:size];
    if (self) {
        self.size = size;
        
        if (idleColor) {
            [self setIdleColor:idleColor];
        }
        
        if (selectedColor) {
            [self setSelectedColor:selectedColor];
        }
        
        if (text) {
            self.label = [SKLabelNode centeredLabelWithText:text];
            [self addChild:self.label];
        }
        
        [self setIsSelected:NO];
        [self setUserInteractionEnabled:YES];
    }
    return self;
}

- (instancetype)initWithIdleColor:(SKColor*)idleColor selectedColor:(SKColor*)selectedColor size:(CGSize)size {
    return [self initWithIdleColor:idleColor selectedColor:selectedColor size:size labelWithText:nil];
}

- (instancetype)initWithColor:(UIColor *)color size:(CGSize)size {
    return [self initWithIdleColor:color selectedColor:color size:size];
}

#pragma mark - Init with shape
- (instancetype)initWithIdleShape:(SKShapeNode*)idleShape selectedShape:(SKShapeNode*)selectedShape {
    return nil;
}

#pragma mark - Convenience initializers
+ (instancetype)buttonWithIdleImageName:(NSString*)idleImageName selectedImageName:(NSString*)selectedImageName {
    return [[self alloc] initWithIdleImageName:idleImageName selectedImageName:selectedImageName];
}

+ (instancetype)buttonWithIdleTexture:(SKTexture*)idleTexture selectedTexture:(SKTexture*)selectedTexture {
    return [[self alloc] initWithIdleTexture:idleTexture selectedTexture:selectedTexture];
}

+ (instancetype)buttonWithIdleColor:(SKColor*)idleColor selectedColor:(SKColor*)selectedColor size:(CGSize)size labelWithText:(NSString*)text {
    return [[self alloc] initWithIdleColor:idleColor selectedColor:selectedColor size:size labelWithText:text];
}

+ (instancetype)buttonWithIdleColor:(SKColor*)idleColor selectedColor:(SKColor*)selectedColor size:(CGSize)size {
    return [[self alloc] initWithIdleColor:idleColor selectedColor:selectedColor size:size];
}

#pragma mark - Setter Overrides
- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (_isSelected) {
        if (_selectedColor) [self setColor:_selectedColor];
        if (_selectedTexture)[self setTexture:_selectedTexture];
    } else {
        if (_idleColor) [self setColor:_idleColor];
        if (_idleTexture)[self setTexture:_idleTexture];
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
    CGPoint location = [self getLocationWithInteractions:interactions withEvent:event];
    if (CGRectContainsPoint(self.frame, location)) {
        [self setIsSelected:YES];
        [self runAction:[SKAction performSelector:_SELTouchDownInside onTarget:_targetTouchDownInside]];
    }
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

@implementation SKLabelNode (SFAdditions)
+ (SKLabelNode*)centeredLabelWithText:(NSString*)text {
    SKLabelNode *label = [SKLabelNode labelNodeWithText:text];
    [label setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
    [label setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    return label;
}

@end