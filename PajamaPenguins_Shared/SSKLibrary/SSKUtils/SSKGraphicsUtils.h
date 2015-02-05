//
//  PGraphicsUtilities.h
//
//  Created by Skye on 1/5/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface SSKGraphicsUtils : NSObject

+ (SKTexture*)createPixelTexture:(SKTexture*)texture;
+ (SKTexture*)createPixelTextureWithName:(NSString*)name inAtlas:(SKTextureAtlas*)atlas;

//Load Pixel
+ (NSArray*)loadPixelAnimationFromAtlas:(SKTextureAtlas*)atlas
                           fromBaseFile:(NSString*)baseFileName
                         withFrameCount:(NSUInteger)count;

@end
