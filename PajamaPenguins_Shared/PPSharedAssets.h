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

//Shared Textures
+ (SKTexture*)sharedWaterGradient;
+ (SKTexture*)sharedIcebergTexture;

+ (SKTexture*)sharedPlayButtonUpTexture;
+ (SKTexture*)sharedPlayButtonDownTexture;

+ (SKTexture*)sharedHomeButtonUpTexture;
+ (SKTexture*)sharedHomeButtonDownTexture;

+ (NSArray*)sharedSmallTextures;
+ (NSArray*)sharedLargeTextures;

//Shared Emitters
+ (SKEmitterNode*)sharedSnowEmitter;
+ (SKEmitterNode*)sharedBubbleEmitter;
+ (SKEmitterNode*)sharedPlayerSplashDownEmitter;
+ (SKEmitterNode*)sharedPlayerSplashUpEmitter;
+ (SKEmitterNode*)sharedObstacleSplashEmitter;

@end
