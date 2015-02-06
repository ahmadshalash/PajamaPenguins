//
//  PGraphicsUtilities.m
//
//  Created by Skye on 1/5/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "SSKGraphicsUtils.h"

@implementation SSKGraphicsUtils

//Designated
+ (SKTexture*)loadPixelTexture:(SKTexture*)texture {
    texture.filteringMode = SKTextureFilteringNearest;
    return texture;
}

+ (SKTexture*)loadPixelTextureWithName:(NSString*)name {
    return [SSKGraphicsUtils loadPixelTexture:[SKTexture textureWithImageNamed:name]];
}

+ (SKTexture*)loadPixelTextureWithName:(NSString*)name inAtlas:(SKTextureAtlas*)atlas {
    return [SSKGraphicsUtils loadPixelTexture:[atlas textureNamed:name]];
}

+ (NSArray*)loadPixelAnimationFromAtlas:(SKTextureAtlas*)atlas
                           fromBaseFile:(NSString*)baseFileName
                         withFrameCount:(NSUInteger)count
{
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:count];
    for (int i = 1; i <= count; i++) {
        NSString *fileName = [NSString stringWithFormat:@"%@%d.png", baseFileName, i];
        SKTexture *texture = [atlas textureNamed:fileName];
        [SSKGraphicsUtils loadPixelTexture:texture];
        if (texture) {
            [frames addObject:texture];
        } else {
            NSLog(@"Error loading filename: %@",fileName);
        }
    }
    
    return frames;
}

+ (NSArray*)loadFramesFromSpriteSheetNamed:(NSString*)name
                                 frameSize:(CGSize)frameSize
                                    origin:(CGPoint)origin
                                 gridWidth:(NSUInteger)gridWidth
                                gridHeight:(NSUInteger)gridHeight
{
    NSMutableArray *images = [NSMutableArray array];
    SKTexture *spriteSheet = [SSKGraphicsUtils loadPixelTextureWithName:name];
    
    for (int y = 0; y < gridHeight; y++) {
        for (int x = 0; x < gridWidth; x++) {
            SKTexture *tile = [SKTexture textureWithRect:CGRectMake(origin.x/spriteSheet.size.width,
                                                                    origin.y/spriteSheet.size.height,
                                                                    frameSize.width/spriteSheet.size.width,
                                                                    frameSize.height/spriteSheet.size.height)
                                               inTexture:spriteSheet];
            tile.filteringMode = SKTextureFilteringNearest;
            [images addObject:tile];
            
            origin.x += frameSize.width + 1;
        }
        origin.x = 0;
        origin.y -= frameSize.height + 1;
    }

    return [NSArray arrayWithArray:images];
}

@end
