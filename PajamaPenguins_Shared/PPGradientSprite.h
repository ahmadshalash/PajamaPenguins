//
//  PPGradientSprite.h
//  PajamaPenguins
//
//  Created by Skye on 2/26/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface PPGradientSprite : SKSpriteNode
- (instancetype)initWithTexture:(SKTexture *)texture blendedColor:(SKColor*)color;
@end
