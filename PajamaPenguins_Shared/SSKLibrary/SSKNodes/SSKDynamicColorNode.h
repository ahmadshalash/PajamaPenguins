//
//  SSKDynamicColorNode.h
//
//  Created by Skye on 2/27/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "SSKColorNode.h"

@interface SSKDynamicColorNode : SSKColorNode

- (void)startCrossfadeForeverWithMax:(int)maxColor min:(int)minColor interval:(NSTimeInterval)interval;
- (void)stopCrossfadeForever;

@end
