//
//  SSKDynamicColorSpriteNode.h
//  PajamaPenguins
//
//  Created by Skye on 2/26/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SSKDynamicColorSpriteNode : SKSpriteNode
+ (instancetype)nodeWithTexture:(SKTexture *)texture
                                          red:(int)red
                                        green:(int)green
                                         blue:(int)blue;

- (instancetype)initWithTexture:(SKTexture *)texture
                                    red:(int)red
                                  green:(int)green
                                   blue:(int)blue;

//Set New Color
- (void)setColorWithRed:(int)red
                  green:(int)green
                   blue:(int)blue;

//Fade To New Color
- (void)crossFadeToRed:(int)targetRed
                 green:(int)targetGreen
                  blue:(int)targetBlue
              duration:(NSTimeInterval)duration;

@property (nonatomic, readonly) int red;
@property (nonatomic, readonly) int green;
@property (nonatomic, readonly) int blue;

@end
