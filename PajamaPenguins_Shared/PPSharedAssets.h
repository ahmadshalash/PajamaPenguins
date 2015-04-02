//
//  PPEmitters.h
//  PajamaPenguins
//
//  Created by Skye on 3/7/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface PPSharedAssets : NSObject

// Preloading
typedef void (^AssetCompletionHandler)(void);
+ (void)loadSharedAssetsWithCompletion:(AssetCompletionHandler)completion;

// Background Textures
+ (SKTexture*)sharedWaterGradient;
+ (SKTexture*)sharedSkyGradient;
+ (SKTexture*)sharedIcebergTexture;

+ (SKTexture*)sharedCloudBackgroundLowerTexture;
+ (SKTexture*)sharedCloudBackgroundMiddleTexture;
+ (SKTexture*)sharedCloudBackgroundUpperTexture;
+ (SKTexture*)sharedCloudForegroundTexture;

// Clouds
+ (SKTextureAtlas*)sharedCloudAtlas;

// Obstacle Textures
+ (SKTexture*)sharedObstacleLargeTexture;
+ (SKTexture*)sharedObstacleMediumTexture;

// Misc. Textures
+ (SKTexture*)sharedFingerSprite;
+ (SKTexture*)sharedFingerSpriteEffect;

// Button Textures
+ (SKTexture*)sharedPlayButtonUpTexture;
+ (SKTexture*)sharedPlayButtonDownTexture;

+ (SKTexture*)sharedHomeButtonUpTexture;
+ (SKTexture*)sharedHomeButtonDownTexture;

// Penguins Textures
+ (SKTextureAtlas*)sharedPenguinBlackTextures;

// Emitters
+ (SKEmitterNode*)sharedSnowEmitter;
+ (SKEmitterNode*)sharedBubbleEmitter;
+ (SKEmitterNode*)sharedPlayerSplashDownEmitter;
+ (SKEmitterNode*)sharedPlayerSplashUpEmitter;
+ (SKEmitterNode*)sharedObstacleSplashEmitter;

@end
