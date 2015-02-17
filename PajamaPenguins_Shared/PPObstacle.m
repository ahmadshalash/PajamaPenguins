//
//  PPObstacle.m
//  PajamaPenguins
//
//  Created by Skye on 2/12/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPObstacle.h"

@interface PPObstacle()
@property (nonatomic) NSArray *textureFrames;
@end

@implementation PPObstacle

- (instancetype)initWithTexturesFromArray:(NSArray*)array {
    self = [super init];
    if (self) {
        self.textureFrames = [NSArray arrayWithArray:array];
        NSLog(@"%@",self.textureFrames);
    }
    return self;
}

@end
