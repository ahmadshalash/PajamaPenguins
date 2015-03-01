//
//  SSKDynamicColorNode.m
//
//  Created by Skye on 2/27/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "SSKDynamicColorNode.h"

NSString * const kCrossFadeForeverKey = @"crossFadeForeverKey";

@interface SSKDynamicColorNode()
//Fade index counter
@property (nonatomic) int fadeIndex;
@property (nonatomic) BOOL fadeForeverActive;

//For initial grouping
@property (nonatomic) int shiftCounter;
@property (nonatomic) BOOL insertMaxColor;

@end

@implementation SSKDynamicColorNode

/*
 001
 
 101
 100
 110
 010
 011
 001
 repeat
 
 */
#pragma mark - Start And Stop Crossfading
- (void)startCrossfadeForeverWithMax:(int)maxColor min:(int)minColor interval:(NSTimeInterval)interval {
    if ([self hasActions]) {
        NSLog(@"%@ cannot perform color animation, performing an action.", [self class]);
        return;
    }

    //Pack and sort color sequence
    NSMutableArray *redGroup = [self shiftColorSequenceBy:0 withMax:maxColor min:minColor];
    NSMutableArray *greenGroup = [self shiftColorSequenceBy:2 withMax:maxColor min:minColor];
    NSMutableArray *blueGroup = [self shiftColorSequenceBy:4 withMax:maxColor min:minColor];
    
    //Initialize counters
    self.fadeIndex = 0;
    self.fadeForeverActive = YES;
    
    //Start crossfade forever
    [self crossFadeForeverWithReds:redGroup greens:greenGroup blues:blueGroup interval:interval];
}

- (void)stopCrossfadeForever {
    self.fadeForeverActive = NO;
}

#pragma mark - Recursive crossfading
- (void)crossFadeForeverWithReds:(NSArray*)redGroup greens:(NSArray*)greenGroup blues:(NSArray*)blueGroup interval:(NSTimeInterval)interval {
    if (self.fadeForeverActive == NO) {
        NSLog(@"cross fade cancelled");
        return;
    }
    
    [self crossFadeToRed:[self fadeIndexInGroup:redGroup] green:[self fadeIndexInGroup:greenGroup] blue:[self fadeIndexInGroup:blueGroup] duration:interval completion:^{

        self.fadeIndex++;
        if (self.fadeIndex > 5) {
            self.fadeIndex = 0;
        }

        [self crossFadeForeverWithReds:redGroup greens:greenGroup blues:blueGroup interval:interval];
    }];
}

#pragma mark - Initial color sequence shift
- (NSMutableArray*)shiftColorSequenceBy:(int)shiftCount withMax:(int)maxColor min:(int)minColor {
    //Populate
    NSMutableArray *colorSeq = [NSMutableArray new];
    for (int i = 0 ; i < 6; i++) {
        if (self.insertMaxColor == NO) {
            [colorSeq insertObject:[NSNumber numberWithInt:minColor] atIndex:0];
        } else {
            [colorSeq insertObject:[NSNumber numberWithInt:maxColor] atIndex:0];
        }
        [self updateFlipInsertion];
    }
    
    //Now Shift
    for (int i = 0; i < shiftCount; i++) {
        if (self.insertMaxColor == NO) {
            [colorSeq insertObject:[NSNumber numberWithInt:minColor] atIndex:0];
        } else {
            [colorSeq insertObject:[NSNumber numberWithInt:maxColor] atIndex:0];
        }
        [colorSeq removeLastObject];
        [self updateFlipInsertion];
    }
    
    [self resetShift];
    
    return colorSeq;
}

- (void)updateFlipInsertion {
    self.shiftCounter++;
    if (self.shiftCounter == 3) {
        self.shiftCounter = 0;
        self.insertMaxColor = (self.insertMaxColor ? NO : YES);
    }
}

- (void)resetShift {
    self.shiftCounter = 0;
    self.insertMaxColor = NO;
}

#pragma mark - Convenience
- (int)fadeIndexInGroup:(NSArray*)group {
    return [[group objectAtIndex:self.fadeIndex] intValue];
}

@end
