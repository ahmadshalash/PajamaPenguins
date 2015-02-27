//
//  SSKDynamicColorSpriteNode.m
//  PajamaPenguins
//
//  Created by Skye on 2/26/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "SSKDynamicColorSpriteNode.h"

CGFloat const kMinColorValue = 0.0f;
CGFloat const kMaxColorValue = 255.0f;

@interface SSKDynamicColorSpriteNode()
@property (nonatomic, readwrite) int red;
@property (nonatomic, readwrite) int green;
@property (nonatomic, readwrite) int blue;
@end

@implementation SSKDynamicColorSpriteNode

+ (instancetype)nodeWithTexture:(SKTexture *)texture red:(int)red green:(int)green blue:(int)blue {
    return [[self alloc] initWithTexture:texture red:red green:green blue:blue];
}

- (instancetype)initWithTexture:(SKTexture *)texture red:(int)red green:(int)green blue:(int)blue {
    self = [super initWithTexture:texture];
    
    if (self) {
        /* 
         As of iOS 8.1 changing blendmode messes with zPositions. /sad
         
         self.blendMode = SKBlendModeAdd;
         */
        
        self.colorBlendFactor = 1.0;
        
        [self setColorWithRed:red green:green blue:blue];
    }
    
    return self;
}

#pragma mark - Changing Color
- (void)setColorWithRed:(int)red green:(int)green blue:(int)blue {
    if (red > kMaxColorValue || red < kMinColorValue) {
        NSLog(@"Red is out of color bounds");
    }
    else if (green > kMaxColorValue || green < kMinColorValue) {
        NSLog(@"Green is out of color bounds");
    }
    else if (blue > kMaxColorValue || blue < kMinColorValue) {
        NSLog(@"Blue is out of color bounds");
    }
    else {
        self.color = [SKColor colorWithRed:red/kMaxColorValue green:green/kMaxColorValue blue:blue/kMaxColorValue alpha:1];
        self.red = red;
        self.green = green;
        self.blue = blue;
    }
}

- (void)crossFadeToRed:(int)targetRed green:(int)targetGreen blue:(int)targetBlue duration:(NSTimeInterval)duration {
    int redRange = [self getRangeFrom:self.red to:targetRed];
    int greenRange = [self getRangeFrom:self.green to:targetGreen];
    int blueRange = [self getRangeFrom:self.blue to:targetBlue];
    
    NSArray *colorRanges = @[[NSNumber numberWithInt:redRange],[NSNumber numberWithInt:greenRange],[NSNumber numberWithInt:blueRange]];

    CGFloat minInterval = CGFLOAT_MAX;
    NSNumber *maxRange = 0;
    
    for (NSNumber *range in colorRanges) {
        NSNumber *currentRange = range;
        if (currentRange > maxRange) {
            maxRange = currentRange;
        }
        
        CGFloat currentInterval = duration / [range intValue];
        if (currentInterval < minInterval) {
            minInterval = currentInterval;
        }
    }
    
    SKAction *wait = [SKAction waitForDuration:minInterval];
    NSLog(@"Interval Time: %fl",wait.duration);
    SKAction *colorChange = [SKAction runBlock:^{
        int newRed = [self increment:self.red toTargetValue:targetRed];
        int newGreen = [self increment:self.green toTargetValue:targetGreen];
        int newBlue = [self increment:self.blue toTargetValue:targetBlue];
        [self setColorWithRed:newRed green:newGreen blue:newBlue];
    }];
    
    if (![self actionForKey:@"colorChanging"]) {
        [self runAction:[SKAction repeatAction:[SKAction sequence:@[wait,colorChange]]
                                         count:[maxRange intValue]] withKey:@"colorChanging"];
    }
}

#pragma mark - Convenience
- (int)increment:(int)colorValue toTargetValue:(int)targetValue {
    if (colorValue != targetValue) {
        int amount = 1;
        if (colorValue > targetValue) {
            amount = -1;
        }
        
        colorValue += amount;
    }
    return colorValue;
}

- (int)getRangeFrom:(int)firstNum to:(int)secondNum {
    return fabs(firstNum - secondNum);
}

@end
