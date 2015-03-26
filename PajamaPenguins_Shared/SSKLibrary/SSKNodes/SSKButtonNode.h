//
//  SSKButtonNode.h
//
//  Created by Skye on 12/22/14.
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

@property (nonatomic, readwrite) SKLabelNode *label;

@property (nonatomic) BOOL isSelected;

//Textured Button
+ (instancetype)buttonWithIdleTexture:(SKTexture*)idleTexture selectedTexture:(SKTexture*)selectedTexture;
- (instancetype)initWithIdleTexture:(SKTexture*)idleTexture selectedTexture:(SKTexture*)selectedTexture;

+ (instancetype)buttonWithIdleImageName:(NSString*)idleImageName selectedImageName:(NSString*)selectedImageName;
- (instancetype)initWithIdleImageName:(NSString*)idleImageName selectedImageName:(NSString*)selectedImageName;

//Colored Button
+ (instancetype)buttonWithIdleColor:(SKColor*)idleColor selectedColor:(SKColor*)selectedColor size:(CGSize)size;
- (instancetype)initWithIdleColor:(SKColor*)idleColor selectedColor:(SKColor*)selectedColor size:(CGSize)size;

//Color Button with Label
+ (instancetype)buttonWithIdleColor:(SKColor*)idleColor selectedColor:(SKColor*)selectedColor size:(CGSize)size labelWithText:(NSString*)text;
- (instancetype)initWithIdleColor:(UIColor *)idleColor selectedColor:(UIColor *)selectedColor size:(CGSize)size labelWithText:(NSString*)text;

//Set responding selectors
- (void)setTouchUpInsideTarget:(id)theTarget selector:(SEL)theSelector;
- (void)setTouchDownInsideTarget:(id)theTarget selector:(SEL)theSelector;
- (void)setTouchUpOutsideTarget:(id)theTarget selector:(SEL)theSelector;

@end

@interface SKLabelNode (SFAdditions)
+ (SKLabelNode*)centeredLabelWithText:(NSString*)text;
@end