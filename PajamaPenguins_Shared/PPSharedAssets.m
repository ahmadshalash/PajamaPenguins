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
        
        //Backgrounds
        sWaterGradient = [SKTexture textureWithImageNamed:@"WaterGradientBlue-iphone"];
        sIcebergTexture = [SKTexture textureWithImageNamed:@"platform_iceberg"];
        
        //Buttons
        sPlayButtonUpTexture = [atlas textureNamed:@"play_button_up"];
        sPlayButtonDownTexture = [atlas textureNamed:@"play_button_down"];
        sHomeButtonUpTexture = [atlas textureNamed:@"home_button_up"];
        sHomeButtonDownTexture = [atlas textureNamed:@"home_button_down"];
        
        //Penguins
        sPenguinNormalIdle = [atlas textureNamed:@"penguin_normal_1"];
        sPenguinNormalAnim = [atlas textureNamed:@"penguin_normal_2"];
        
        sPenguinGreyIdleFrames = [NSMutableArray new];
        sPenguinGreySwimFrames = [NSMutableArray new];
        sPenguinGreyFlyFrames = [NSMutableArray new];
        
        //Idle Textures
        for (int i = 0; i < 2; i++) {
            [sPenguinGreyIdleFrames addObject:[SKTexture loadPixelTexture:[atlas textureNamed:[NSString stringWithFileBase:@"penguin_grey_idle_" index:i]]]];
        }
        
        //Swim Textures
        for (int i = 0; i < 8; i++) {
            [sPenguinGreySwimFrames addObject:[SKTexture loadPixelTexture:[atlas textureNamed:[NSString stringWithFileBase:@"penguin_grey_swim_" index:i]]]];
        }
        
        //Fly Textures
        for (int i = 0; i < 6; i++) {
            [sPenguinGreyFlyFrames addObject:[SKTexture loadPixelTexture:[atlas textureNamed:[NSString stringWithFileBase:@"penguin_grey_fly_" index:i]]]];
        }
        
        //Misc.
        sFingerSprite = [atlas textureNamed:@"finger_sprite"];
        sFingerSpriteEffect = [atlas textureNamed:@"finger_sprite_effect"];
        
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

//Backgrounds
static SKTexture *sWaterGradient = nil;
+ (SKTexture*)sharedWaterGradient {
    return sWaterGradient;
}

static SKTexture *sIcebergTexture = nil;
+ (SKTexture*)sharedIcebergTexture {
    return sIcebergTexture;
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
static SKTexture *sPenguinNormalIdle = nil;
+ (SKTexture*)sharedPenguinNormalIdle {
    return sPenguinNormalIdle;
}

static SKTexture *sPenguinNormalAnim = nil;
+ (SKTexture*)sharedPenguinNormalAnim {
    return sPenguinNormalAnim;
}

static NSMutableArray *sPenguinGreyIdleFrames = nil;
+ (NSMutableArray*)sharedPenguinGreyIdleFrames {
    return sPenguinGreyIdleFrames;
}

static NSMutableArray *sPenguinGreySwimFrames = nil;
+ (NSMutableArray*)sharedPenguinGreySwimFrames {
    return sPenguinGreySwimFrames;
}

static NSMutableArray *sPenguinGreyFlyFrames = nil;
+ (NSMutableArray*)sharedPenguinGreyFlyFrames {
    return sPenguinGreyFlyFrames;
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

//Misc Menu Scene

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
