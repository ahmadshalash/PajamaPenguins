//
//  PGraphicsUtilities.m
//
//  Created by Skye on 1/5/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "SSKGraphicsUtils.h"

@implementation SSKGraphicsUtils
+ (NSArray*)loadPixelAnimationFromAtlas:(SKTextureAtlas*)atlas
                           fromBaseFile:(NSString*)baseFileName
                         withFrameCount:(NSUInteger)count
{
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:count];
    for (int i = 1; i <= count; i++) {
        NSString *fileName = [NSString stringWithFormat:@"%@%d.png", baseFileName, i];
        SKTexture *texture = [atlas textureNamed:fileName];
        [SKTexture loadPixelTexture:texture];
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
    SKTexture *spriteSheet = [SKTexture loadPixelTextureWithName:name];
    
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

+ (void)runOneShotActionWithEmitter:(SKEmitterNode*)emitter duration:(CGFloat)duration {
    SKAction *wait = [SKAction waitForDuration:duration];
    SKAction *waitParticleLifetime = [SKAction waitForDuration:emitter.particleLifetime + emitter.particleLifetimeRange];
    SKAction *removeEmitter = [SKAction removeFromParent];
    SKAction *turnOffBirthRate = [SKAction runBlock:^{
        [emitter setParticleBirthRate:0];
    }];
    
    [emitter runAction:[SKAction sequence:@[wait, turnOffBirthRate, waitParticleLifetime, removeEmitter]]];
}

@end

@implementation SKTexture (SFAdditions)
+ (SKTexture*)loadPixelTexture:(SKTexture*)texture {
    texture.filteringMode = SKTextureFilteringNearest;
    return texture;
}

+ (SKTexture*)loadPixelTextureWithName:(NSString*)name {
    return [SKTexture loadPixelTexture:[SKTexture textureWithImageNamed:name]];
}

+ (SKTexture*)loadPixelTextureWithName:(NSString*)name inAtlas:(SKTextureAtlas*)atlas {
    return [SKTexture loadPixelTexture:[atlas textureNamed:name]];
}
@end

@implementation SKEmitterNode (SFAdditions)
+ (instancetype)emitterNodeWithFileNamed:(NSString*)emitterName {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:emitterName ofType:@"sks"]];
}
@end
