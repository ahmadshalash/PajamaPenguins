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

typedef void (^AssetCompletionHandler)(void);
+ (void)loadSharedAssetsWithCompletion:(AssetCompletionHandler)completion;

//Shared Background Textures
+ (SKTexture*)sharedWaterGradient;
+ (SKTexture*)sharedIcebergTexture;

+ (SKTexture*)sharedCloudBackgroundLowerTexture;
+ (SKTexture*)sharedCloudBackgroundMiddleTexture;
+ (SKTexture*)sharedCloudBackgroundUpperTexture;
+ (SKTexture*)sharedCloudForegroundTexture;

//Shared Obstacle Textures
+ (SKTexture*)sharedObstacleLargeTexture;
+ (SKTexture*)sharedObstacleMediumTexture;

//Shared Misc. Textures
+ (SKTexture*)sharedFingerSprite;
+ (SKTexture*)sharedFingerSpriteEffect;

//Shared Button Textures
+ (SKTexture*)sharedPlayButtonUpTexture;
+ (SKTexture*)sharedPlayButtonDownTexture;

+ (SKTexture*)sharedHomeButtonUpTexture;
+ (SKTexture*)sharedHomeButtonDownTexture;

//Shared Penguins Textures
+ (SKTextureAtlas*)sharedPenguinBlackTextures;

+ (NSMutableArray*)sharedPenguinGreyIdleFrames;
+ (NSMutableArray*)sharedPenguinGreySwimFrames;
+ (NSMutableArray*)sharedPenguinGreyFlyFrames;

//Shared Emitters
+ (SKEmitterNode*)sharedSnowEmitter;
+ (SKEmitterNode*)sharedBubbleEmitter;
+ (SKEmitterNode*)sharedPlayerSplashDownEmitter;
+ (SKEmitterNode*)sharedPlayerSplashUpEmitter;
+ (SKEmitterNode*)sharedObstacleSplashEmitter;

@end
