//
//  PPGradientSprite.h
//  PajamaPenguins
//
//  Created by Skye on 2/26/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface PPGradientSprite : SKSpriteNode
+ (instancetype)spriteNodeWithGradientTexture:(SKTexture *)texture
                                          red:(int)red
                                        green:(int)green
                                         blue:(int)blue;

- (instancetype)initWithGradientTexture:(SKTexture *)texture
                                    red:(int)red
                                  green:(int)green
                                   blue:(int)blue;

- (void)setColorWithRed:(int)red
                  green:(int)green
                   blue:(int)blue;

- (void)crossFadeToRed:(int)targetRed
                 green:(int)targetGreen
                  blue:(int)targetBlue
              duration:(NSTimeInterval)duration;

@property (nonatomic,readonly) int red;
@property (nonatomic,readonly) int green;
@property (nonatomic,readonly) int blue;

@end
