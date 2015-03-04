//
//  PGraphicsUtilities.h
//
//  Created by Skye on 1/5/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface SSKGraphicsUtils : NSObject


//Load a Pixel Animation
+ (NSArray*)loadPixelAnimationFromAtlas:(SKTextureAtlas*)atlas
                           fromBaseFile:(NSString*)baseFileName
                         withFrameCount:(NSUInteger)count;

//Load tiles from a single sprite sheet
+ (NSArray*)loadFramesFromSpriteSheetNamed:(NSString*)name
                                 frameSize:(CGSize)frameSize
                                    origin:(CGPoint)origin
                                 gridWidth:(NSUInteger)width
                                gridHeight:(NSUInteger)height;

//One shot particle action
+ (void)runOneShotActionWithEmitter:(SKEmitterNode*)emitter duration:(CGFloat)duration;

@end

@interface SKTexture (SFAdditions)
+ (SKTexture*)loadPixelTexture:(SKTexture*)texture;
+ (SKTexture*)loadPixelTextureWithName:(NSString*)name;
+ (SKTexture*)loadPixelTextureWithName:(NSString*)name inAtlas:(SKTextureAtlas*)atlas;
@end

@interface SKEmitterNode (SFAdditions)
+ (instancetype)emitterNodeWithFileNamed:(NSString*)emitterName;
@end
