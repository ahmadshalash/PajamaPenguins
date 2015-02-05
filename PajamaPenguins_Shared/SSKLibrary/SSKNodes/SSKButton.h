//
//  SSKButton.h
//
//  Created by Skye on 12/22/14.
//  Copyright (c) 2014 skyefreeman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface SSKButton : SKSpriteNode

@property (nonatomic, readonly) SEL SELTouchUpInside;
@property (nonatomic, readonly) SEL SELTouchUpOutside;
@property (nonatomic, readonly) SEL SELTouchDownInside;

@property (nonatomic, readonly, weak) id targetTouchUpInside;
@property (nonatomic, readonly, weak) id targetTouchUpOutside;
@property (nonatomic, readonly, weak) id targetTouchDownInside;

@property (nonatomic) BOOL isSelected;

@property (nonatomic, readwrite, strong) SKTexture *idleTexture;
@property (nonatomic, readwrite, strong) SKTexture *selectedTexture;

- (id)initWithIdleTexture:(SKTexture*)idleTexture selectedTexture:(SKTexture*)selectedTexture;
- (id)initWithIdleImageName:(NSString*)idleImageName selectedImageName:(NSString*)selectedImageName;

- (void)setTouchUpInsideTarget:(id)theTarget selector:(SEL)theSelector;
- (void)setTouchDownInsideTarget:(id)theTarget selector:(SEL)theSelector;
- (void)setTouchUpOutsideTarget:(id)theTarget selector:(SEL)theSelector;

@end
