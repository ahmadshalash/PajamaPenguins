//
//  PPEmitters.m
//  PajamaPenguins
//
//  Created by Skye on 3/7/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPSharedAssets.h"
#import "SSKGraphicsUtils.h"

@implementation PPSharedAssets
+ (void)loadSharedAssetsWithCompletion:(AssetCompletionHandler)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSDate *startTime = [NSDate date];

        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"pajama_penguins_assets"];
        
        //Textures
        sWaterGradient = [SKTexture textureWithImageNamed:@"WaterGradientBlue-iphone"];
        sIcebergTexture = [SKTexture textureWithImageNamed:@"platform_iceberg"];
        
        sPlayButtonUpTexture = [atlas textureNamed:@"play_button_up"];
        sPlayButtonDownTexture = [atlas textureNamed:@"play_button_down"];
        sHomeButtonUpTexture = [atlas textureNamed:@"home_button_up"];
        sHomeButtonDownTexture = [atlas textureNamed:@"home_button_down"];
        
        //Sprite Sheets
        sSmallTextures = [SSKGraphicsUtils loadFramesFromSpriteSheetNamed:@"PajamaPenguinsSmallSheet"
                                                                frameSize:CGSizeMake(15, 15)
                                                                   origin:CGPointMake(0, 225)
                                                                gridWidth:15
                                                               gridHeight:15];
        
        sLargeTextures = [SSKGraphicsUtils loadFramesFromSpriteSheetNamed:@"PajamaPenguinsLargeSheet"
                                                                frameSize:CGSizeMake(30, 30)
                                                                   origin:CGPointMake(0, 280)
                                                                gridWidth:10
                                                               gridHeight:10];
        
        //Emitters
        sSnowEmitter = [SKEmitterNode emitterNodeWithFileNamed:@"SnowEmitter"];
        sBubbleEmitter = [SKEmitterNode emitterNodeWithFileNamed:@"BubbleEmitter"];
        sObstacleSplashEmitter = [SKEmitterNode emitterNodeWithFileNamed:@"ObstacleSplashEmitter"];
        sPlayerSplashDownEmitter = [SKEmitterNode emitterNodeWithFileNamed:@"PlayerSplashDownEmitter"];
        sPlayerSplashUpEmitter = [SKEmitterNode emitterNodeWithFileNamed:@"PlayerSplashUpEmitter"];
        
        NSLog(@"Scene loaded in %f seconds",[[NSDate date] timeIntervalSinceDate:startTime]);
        
        if (!completion) {
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion();  //Calls the handler on the main thread once assets are ready.
        });
    });
}

#pragma mark - Shared Textures
static SKTexture *sWaterGradient = nil;
+ (SKTexture*)sharedWaterGradient {
    return sWaterGradient;
}

static SKTexture *sIcebergTexture = nil;
+ (SKTexture*)sharedIcebergTexture {
    return sIcebergTexture;
}

static SKTexture *sPlayButtonUpTexture = nil;
+ (SKTexture*)sharedPlayButtonUpTexture {
    return sPlayButtonUpTexture;
}

static SKTexture *sPlayButtonDownTexture = nil;
+ (SKTexture*)sharedPlayButtonDownTexture {
    return sPlayButtonDownTexture;
}

static SKTexture *sHomeButtonUpTexture = nil;
+ (SKTexture*)sharedHomeButtonUpTexture {
    return sHomeButtonUpTexture;
}

static SKTexture *sHomeButtonDownTexture = nil;
+ (SKTexture*)sharedHomeButtonDownTexture {
    return sHomeButtonDownTexture;
}

#pragma mark - Sprite sheets
static NSArray *sSmallTextures = nil;
+ (NSArray*)sharedSmallTextures {
    return sSmallTextures;
}

static NSArray *sLargeTextures = nil;
+ (NSArray*)sharedLargeTextures {
    return sLargeTextures;
}

#pragma mark - Shared Emitters
static SKEmitterNode *sSnowEmitter = nil;
+ (SKEmitterNode*)sharedSnowEmitter {
    return sSnowEmitter;
}

static SKEmitterNode *sBubbleEmitter = nil;
+ (SKEmitterNode*)sharedBubbleEmitter {
    return sBubbleEmitter;
}

static SKEmitterNode *sPlayerSplashDownEmitter = nil;
+ (SKEmitterNode*)sharedPlayerSplashDownEmitter {
    return sPlayerSplashDownEmitter;
}

static SKEmitterNode *sPlayerSplashUpEmitter = nil;
+ (SKEmitterNode*)sharedPlayerSplashUpEmitter {
    return sPlayerSplashUpEmitter;
}

static SKEmitterNode *sObstacleSplashEmitter = nil;
+ (SKEmitterNode*)sharedObstacleSplashEmitter {
    return sObstacleSplashEmitter;
}

@end
