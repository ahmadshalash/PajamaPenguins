//
//  PPEmitters.h
//  PajamaPenguins
//
//  Created by Skye on 3/7/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface PPEmitters : NSObject
+ (void)loadSharedEmitters;

//Shared Emitters
+ (SKEmitterNode*)sharedSnowEmitter;
+ (SKEmitterNode*)sharedBubbleEmitter;
+ (SKEmitterNode*)sharedPlayerSplashDownEmitter;
+ (SKEmitterNode*)sharedPlayerSplashUpEmitter;
+ (SKEmitterNode*)sharedObstacleSplashEmitter;

@end
