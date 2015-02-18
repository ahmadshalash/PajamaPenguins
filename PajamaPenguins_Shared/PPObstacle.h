//
//  PPObstacle.h
//  PajamaPenguins
//
//  Created by Skye on 2/12/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface PPObstacle : SKNode

- (instancetype)initWithTexturesFromArray:(NSArray*)array
                             textureWidth:(CGFloat)textureWidth
                    numHorizontalCells:(NSUInteger)gridWidth;
@end
