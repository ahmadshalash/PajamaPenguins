//
//  SKTexture+SFAdditions.h
//  PajamaPenguins
//
//  Created by Skye on 3/31/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSUInteger, GradientDirection) {
    GradientDirectionVertical = 0,
    GradientDirectionHorizontal,
    GradientDirectionDiagonalRight,
    GradientDirectionDiagonalLeft,
};

@interface SKTexture (SFAdditions)
+ (SKTexture*)textureWithGradientOfSize:(CGSize)size
                             startColor:(SKColor*)startColor
                               endColor:(SKColor*)endColor
                              direction:(GradientDirection)direction;

+ (SKTexture*)loadPixelTexture:(SKTexture*)texture;
+ (SKTexture*)loadPixelTextureWithName:(NSString*)name;
+ (SKTexture*)loadPixelTextureWithName:(NSString*)name inAtlas:(SKTextureAtlas*)atlas;

@end

@interface CIColor (Convenience)
+ (CIColor*)colorWithSKColor:(SKColor*)color;
@end
