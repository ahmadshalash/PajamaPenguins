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

@property (nonatomic) BOOL isSelected;

+ (instancetype)buttonWithIdleTexture:(SKTexture*)idleTexture selectedTexture:(SKTexture*)selectedTexture;
- (instancetype)initWithIdleTexture:(SKTexture*)idleTexture selectedTexture:(SKTexture*)selectedTexture;

+ (instancetype)buttonWithIdleImageName:(NSString*)idleImageName selectedImageName:(NSString*)selectedImageName;
- (instancetype)initWithIdleImageName:(NSString*)idleImageName selectedImageName:(NSString*)selectedImageName;

+ (instancetype)buttonWithIdleColor:(SKColor*)idleColor selectedColor:(SKColor*)selectedColor size:(CGSize)size;
- (instancetype)initWithIdleColor:(SKColor*)idleColor selectedColor:(SKColor*)selectedColor size:(CGSize)size;

- (void)setTouchUpInsideTarget:(id)theTarget selector:(SEL)theSelector;
- (void)setTouchDownInsideTarget:(id)theTarget selector:(SEL)theSelector;
- (void)setTouchUpOutsideTarget:(id)theTarget selector:(SEL)theSelector;

@end
