//
//  PPEmitters.m
//  PajamaPenguins
//
//  Created by Skye on 3/7/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPSharedAssets.h"
#import "SSKGraphicsUtils.h"
#import "SKTexture+SFAdditions.h"

@implementation PPSharedAssets
+ (void)loadSharedAssetsWithCompletion:(AssetCompletionHandler)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSDate *startTime = [NSDate date];

        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"pajama_penguins_assets"];
        
        //Backgrounds
        sWaterGradient = [SKTexture textureWithImageNamed:@"water"];
        sSkyGradient = [SKTexture textureWithImageNamed:@"sky"];
        sIcebergTexture = [SKTexture textureWithImageNamed:@"platform_iceberg"];
        
        //Buttons
        sPlayButtonUpTexture = [atlas textureNamed:@"play_button_up"];
        sPlayButtonDownTexture = [atlas textureNamed:@"play_button_down"];
        sHomeButtonUpTexture = [atlas textureNamed:@"home_button_up"];
        sHomeButtonDownTexture = [atlas textureNamed:@"home_button_down"];
        
        //Obstacles
        sObstacleLargeTexture = [SKTexture loadPixelTexture:[atlas textureNamed:@"iceberg_250x375"]];
        sObstacleMediumTexture = [SKTexture loadPixelTexture:[atlas textureNamed:@"iceberg_200x300"]];
        
        //Clouds
        sCloudAtlas = [SKTextureAtlas atlasNamed:@"clouds"];
        
        //Penguins
        sPenguinBlackTextures = [SKTextureAtlas atlasNamed:@"penguin_black"];

        //Misc.
        sFingerSprite = [SKTexture loadPixelTexture:[atlas textureNamed:@"finger_sprite"]];
        sFingerSpriteEffect = [SKTexture loadPixelTexture:[atlas textureNamed:@"finger_sprite_effect"]];

        sCloudBackgroundLowerTexture = [SKTexture loadPixelTexture:[atlas textureNamed:@"clouds_background_lower"]];
        sCloudBackgroundMiddleTexture = [SKTexture loadPixelTexture:[atlas textureNamed:@"clouds_background_middle"]];
        sCloudBackgroundUpperTexture = [SKTexture loadPixelTexture:[atlas textureNamed:@"clouds_background_upper"]];
        sCloudForegroundTexture = [SKTexture loadPixelTexture:[atlas textureNamed:@"clouds_foreground"]];
        
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

//Background Elements
static SKTexture *sWaterGradient = nil;
+ (SKTexture*)sharedWaterGradient {
    return sWaterGradient;
}

static SKTexture *sSkyGradient = nil;
+ (SKTexture*)sharedSkyGradient {
    return sSkyGradient;
}

static SKTexture *sIcebergTexture = nil;
+ (SKTexture*)sharedIcebergTexture {
    return sIcebergTexture;
}

//Clouds
static SKTextureAtlas *sCloudAtlas = nil;
+ (SKTextureAtlas*)sharedCloudAtlas {
    return sCloudAtlas;
}

static SKTexture *sCloudBackgroundLowerTexture = nil;
+ (SKTexture*)sharedCloudBackgroundLowerTexture {
    return sCloudBackgroundLowerTexture;
}

static SKTexture *sCloudBackgroundMiddleTexture = nil;
+ (SKTexture*)sharedCloudBackgroundMiddleTexture {
    return sCloudBackgroundMiddleTexture;
}

static SKTexture *sCloudBackgroundUpperTexture = nil;
+ (SKTexture*)sharedCloudBackgroundUpperTexture {
    return sCloudBackgroundUpperTexture;
}

static SKTexture *sCloudForegroundTexture = nil;
+ (SKTexture*)sharedCloudForegroundTexture {
    return sCloudForegroundTexture;
}

//Buttons
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

//Penguins
static SKTextureAtlas *sPenguinBlackTextures = nil;
+ (SKTextureAtlas*)sharedPenguinBlackTextures {
    return sPenguinBlackTextures;
}

//Obstacles
static SKTexture *sObstacleLargeTexture = nil;
+ (SKTexture*)sharedObstacleLargeTexture {
    return sObstacleLargeTexture;
}

static SKTexture *sObstacleMediumTexture = nil;
+ (SKTexture*)sharedObstacleMediumTexture {
    return sObstacleMediumTexture;
}

//Misc Game Scene
static SKTexture *sFingerSprite = nil;
+ (SKTexture*)sharedFingerSprite {
    return sFingerSprite;
}

static SKTexture *sFingerSpriteEffect = nil;
+ (SKTexture*)sharedFingerSpriteEffect {
    return sFingerSpriteEffect;
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
