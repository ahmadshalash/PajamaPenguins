//
//  SKTexture+SFAdditions.m
//  PajamaPenguins
//
//  Created by Skye on 3/31/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "SKTexture+SFAdditions.h"

@implementation SKTexture (SFAdditions)
+ (SKTexture*)textureWithGradientOfSize:(CGSize)size
                             startColor:(SKColor*)startColor
                               endColor:(SKColor*)endColor
                              direction:(GradientDirection)direction
{
    //Define CI context and create CIFilter
    CIContext *coreImageContext = [CIContext contextWithOptions:nil];
    CIFilter *gradientFilter = [CIFilter filterWithName:@"CILinearGradient"];
    [gradientFilter setDefaults];

    //Convert colors to CIColors
    CIColor *CIStartColor = [CIColor colorWithSKColor:startColor];
    CIColor *CIEndColor = [CIColor colorWithSKColor:endColor];
    
    //Define gradient start and end positions
    CGPoint startPoint;
    CGPoint endPoint;
    
    switch (direction) {
        case GradientDirectionVertical:
            startPoint = CGPointMake(size.width/2, 0);
            endPoint = CGPointMake(size.width/2, size.height);
            break;
            
        case GradientDirectionHorizontal:
            startPoint = CGPointMake(0, size.height/2);
            endPoint = CGPointMake(size.width, size.height/2);
            break;
            
        case GradientDirectionDiagonalRight:
            startPoint = CGPointMake(0, 0);
            endPoint = CGPointMake(size.width, size.height);
            break;
            
        case GradientDirectionDiagonalLeft:
            startPoint = CGPointMake(size.width, 0);
            endPoint = CGPointMake(0, size.height);
            break;
            
        default:
            startPoint = CGPointMake(size.width/2, 0);
            endPoint = CGPointMake(size.width/2, size.height);
            break;
    }
    
    //Define vectors from start and end points
    CIVector *startVector = [CIVector vectorWithCGPoint:startPoint];
    CIVector *endVector = [CIVector vectorWithCGPoint:endPoint];

    [gradientFilter setValue:startVector forKey:@"inputPoint0"];
    [gradientFilter setValue:endVector forKey:@"inputPoint1"];
    [gradientFilter setValue:CIStartColor forKey:@"inputColor0"];
    [gradientFilter setValue:CIEndColor forKey:@"inputColor1"];
    
    CGImageRef cgImageRef = [coreImageContext createCGImage:[gradientFilter outputImage] fromRect:CGRectMake(0, 0, size.width, size.height)];
    
    return [SKTexture textureWithCGImage:cgImageRef];
}

#pragma mark - Pixel textures
+ (SKTexture*)loadPixelTexture:(SKTexture*)texture {
    texture.filteringMode = SKTextureFilteringNearest;
    return texture;
}

+ (SKTexture*)loadPixelTextureWithName:(NSString*)name {
    return [SKTexture loadPixelTexture:[SKTexture textureWithImageNamed:name]];
}

+ (SKTexture*)loadPixelTextureWithName:(NSString*)name inAtlas:(SKTextureAtlas*)atlas {
    return [SKTexture loadPixelTexture:[atlas textureNamed:name]];
}

@end

#pragma mark - CIColor
@implementation CIColor (Convenience)
+ (CIColor*)colorWithSKColor:(SKColor*)color {
    CGColorRef colorRef = [color CGColor];
    size_t numComponents = CGColorGetNumberOfComponents(colorRef);
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
    
    
    if (numComponents == 4) {
        const CGFloat *components = CGColorGetComponents(colorRef);
        red = components[0];
        green = components[1];
        blue = components[2];
        alpha = components[3];
    }
    return [CIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
@end