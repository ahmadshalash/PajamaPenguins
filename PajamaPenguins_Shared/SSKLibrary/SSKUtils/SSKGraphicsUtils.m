//
//  PGraphicsUtilities.m
//
//  Created by Skye on 1/5/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "SSKGraphicsUtils.h"

@implementation SSKGraphicsUtils

//Designated
+ (SKTexture*)createPixelTexture:(SKTexture*)texture {
    texture.filteringMode = SKTextureFilteringNearest;
    return texture;
}

// Redirected class methods
+ (SKTexture*)createPixelTextureWithName:(NSString*)name inAtlas:(SKTextureAtlas*)atlas {
    return [SSKGraphicsUtils createPixelTexture:[atlas textureNamed:name]];
}

+ (NSArray*)loadPixelAnimationFromAtlas:(SKTextureAtlas*)atlas
                           fromBaseFile:(NSString*)baseFileName
                         withFrameCount:(NSUInteger)count
{
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:count];
    for (int i = 1; i <= count; i++) {
        NSString *fileName = [NSString stringWithFormat:@"%@%d.png", baseFileName, i];
        SKTexture *texture = [atlas textureNamed:fileName];
        [SSKGraphicsUtils createPixelTexture:texture];
        if (texture) {
            [frames addObject:texture];
        } else {
            NSLog(@"Error loading filename: %@",fileName);
        }
    }
    
    return frames;
}

@end
