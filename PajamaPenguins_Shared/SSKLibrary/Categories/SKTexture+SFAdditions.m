//
//  SKTexture+SFAdditions.m
//  PajamaPenguins
//
//  Created by Skye on 3/31/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "SKTexture+SFAdditions.h"

@implementation SKTexture (SFAdditions)
+ (SKTexture*)textureWithGradientOfSize:(CGSize)size startColor:(CIColor*)startColor endColor:(CIColor*)endColor direction:(GradientDirection)direction {
    CIContext *coreImageContext = [CIContext contextWithOptions:nil];
    CIFilter *gradientFilter = [CIFilter filterWithName:@"CILinearGradient"];
    if (!gradientFilter) {
        NSLog(@"No gradient of name: %@", gradientFilter.name);
        return nil;;
    }
    [gradientFilter setDefaults];
    
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

    CIVector *startVector = [CIVector vectorWithCGPoint:startPoint];
    CIVector *endVector = [CIVector vectorWithCGPoint:endPoint];

    [gradientFilter setValue:startVector forKey:@"inputPoint0"];
    [gradientFilter setValue:endVector forKey:@"inputPoint1"];
    [gradientFilter setValue:startColor forKey:@"inputColor0"];
    [gradientFilter setValue:endColor forKey:@"inputColor1"];
    
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
