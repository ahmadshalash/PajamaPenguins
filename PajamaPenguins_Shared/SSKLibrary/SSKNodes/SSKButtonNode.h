//
//  SSKButtonNode.h
//
//  Created by Skye Freeman on 12/22/14.
//  Copyright (c) 2014 skyefreeman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

/*
 
 NOTE: Button streching only works via setting xScale and yScale as of iOS 8.
 
 */

@interface SSKButtonNode : SKSpriteNode

@property (nonatomic, readonly) SEL SELTouchUpInside;
@property (nonatomic, readonly) SEL SELTouchUpOutside;
@property (nonatomic, readonly) SEL SELTouchDownInside;

@property (nonatomic, readonly, weak) id targetTouchUpInside;
@property (nonatomic, readonly, weak) id targetTouchUpOutside;
@property (nonatomic, readonly, weak) id targetTouchDownInside;

@property (nonatomic, readwrite) SKTexture *idleTexture;
@property (nonatomic, readwrite) SKTexture *selectedTexture;

@property (nonatomic, readwrite) SKColor *idleColor;
@property (nonatomic, readwrite) SKColor *selectedColor;

@property (nonatomic, readwrite) SKShapeNode *idleShape;
@property (nonatomic, readwrite) SKShapeNode *selectedShape;

@property (nonatomic, readwrite) SKLabelNode *label;

@property (nonatomic) BOOL isSelected;

// Create button with textures
+ (instancetype)buttonWithIdleTexture:(SKTexture*)idleTexture selectedTexture:(SKTexture*)selectedTexture;
+ (instancetype)buttonWithIdleImageName:(NSString*)idleImageName selectedImageName:(NSString*)selectedImageName;

- (instancetype)initWithIdleTexture:(SKTexture*)idleTexture selectedTexture:(SKTexture*)selectedTexture;
- (instancetype)initWithIdleImageName:(NSString*)idleImageName selectedImageName:(NSString*)selectedImageName;

// Create button with colors
+ (instancetype)buttonWithIdleColor:(SKColor*)idleColor selectedColor:(SKColor*)selectedColor size:(CGSize)size label:(SKLabelNode*)label;
+ (instancetype)buttonWithIdleColor:(SKColor*)idleColor selectedColor:(SKColor*)selectedColor size:(CGSize)size labelWithText:(NSString*)text;
+ (instancetype)buttonWithIdleColor:(SKColor*)idleColor selectedColor:(SKColor*)selectedColor size:(CGSize)size;

- (instancetype)initWithIdleColor:(SKColor*)idleColor selectedColor:(SKColor*)selectedColor size:(CGSize)size label:(SKLabelNode*)label;
- (instancetype)initWithIdleColor:(SKColor*)idleColor selectedColor:(SKColor*)selectedColor size:(CGSize)size labelWithText:(NSString*)text;
- (instancetype)initWithIdleColor:(SKColor*)idleColor selectedColor:(SKColor*)selectedColor size:(CGSize)size;

// Create button with shapes
+ (instancetype)buttonWithIdleShape:(SKShapeNode*)idleShape selectedShape:(SKShapeNode*)selectedShape;
+ (instancetype)buttonWithIdleCircleOfRadius:(CGFloat)idleRadius selectedCircleOfRadius:(CGFloat)selectedRadius fillColor:(SKColor*)fillColor;

- (instancetype)initWithIdleShape:(SKShapeNode*)idleShape selectedShape:(SKShapeNode*)selectedShape;
- (instancetype)initWithIdleCircleOfRadius:(CGFloat)idleRadius selectedCircleOfRadius:(CGFloat)selectedRadius fillColor:(SKColor*)fillColor;;

// Set responding selectors
- (void)setTouchUpInsideTarget:(id)theTarget selector:(SEL)theSelector;
- (void)setTouchDownInsideTarget:(id)theTarget selector:(SEL)theSelector;
- (void)setTouchUpOutsideTarget:(id)theTarget selector:(SEL)theSelector;

@end

@interface SKLabelNode (SFAdditions)
+ (SKLabelNode*)centeredLabelWithText:(NSString*)text;
+ (SKLabelNode*)centeredLabelWithLabel:(SKLabelNode*)label;
@end

@interface SKShapeNode (SFAdditions)
+ (SKShapeNode*)shapeNodeWithCircleOfRadius:(CGFloat)radius fillColor:(SKColor*)fillColor;
@end