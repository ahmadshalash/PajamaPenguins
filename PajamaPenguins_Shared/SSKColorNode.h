//
//  SSKColorNode.h
//
//  Created by Skye on 2/26/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

/*
 
 This is a SKSpriteNode subclass that allows for easier manipulation of color values. Including:
 
 - Setting the color value of a sprite with/without a texture.
 - Cross fading to a new color value over a given duration.
 - Color values work on the RGB Color Model with int values from 0 - 255.
 
 */

@interface SSKColorNode : SKSpriteNode

//Initializing with only color
+ (instancetype)nodeWithRed:(int)red green:(int)green blue:(int)blue size:(CGSize)size;
- (instancetype)initWithRed:(int)red green:(int)green blue:(int)blue size:(CGSize)size;

//Initializing with texture blended with color
+ (instancetype)nodeWithTexture:(SKTexture *)texture red:(int)red green:(int)green blue:(int)blue;
- (instancetype)initWithTexture:(SKTexture *)texture red:(int)red green:(int)green blue:(int)blue;

//Set new color
- (void)setColorWithRed:(int)red green:(int)green blue:(int)blue;

//Fade to new color
- (void)crossFadeToRed:(int)targetRed green:(int)targetGreen blue:(int)targetBlue duration:(NSTimeInterval)duration;
- (void)crossFadeToRed:(int)targetRed green:(int)targetGreen blue:(int)targetBlue duration:(NSTimeInterval)duration completion:(void(^)(void))block;

//Color values from 0 - 255
@property (nonatomic) int red;
@property (nonatomic) int green;
@property (nonatomic) int blue;

@end
