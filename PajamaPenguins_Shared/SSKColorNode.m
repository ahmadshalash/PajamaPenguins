//
//  SSKColorNode.m
//
//  Created by Skye on 2/26/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "SSKColorNode.h"
#import "SKNode+SFAdditions.h"

NSString * const kColorChangeKey = @"colorChangeKey";

CGFloat const kMinColorValue = 0.0f;
CGFloat const kMaxColorValue = 255.0f;

@interface SSKColorNode()
@end

@implementation SSKColorNode

#pragma mark - Init with color
+ (instancetype)nodeWithRed:(int)red green:(int)green blue:(int)blue size:(CGSize)size {
    return [[self alloc] initWithRed:red green:green blue:blue size:size];
}

- (instancetype)initWithRed:(int)red green:(int)green blue:(int)blue size:(CGSize)size {
    self = [super init];
    
    if (self) {
        self.size = size;
        [self setColorWithRed:red green:green blue:blue];
    }
    
    return self;
}

#pragma mark - Init with texture
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
    if (![self actionForKey:kColorChangeKey]) {
        [self runAction:[self crossFadeActionToRed:targetRed green:targetGreen blue:targetBlue duration:duration] withKey:kColorChangeKey];
    }
}

- (void)crossFadeToRed:(int)targetRed green:(int)targetGreen blue:(int)targetBlue duration:(NSTimeInterval)duration completion:(void(^)(void))block {
    if (![self actionForKey:kColorChangeKey]) {
        [self runAction:[self crossFadeActionToRed:targetRed green:targetGreen blue:targetBlue duration:duration] withKey:kColorChangeKey completion:^{
            [self removeActionForKey:kColorChangeKey];
            block();
        }];
    }
}

#pragma mark -
- (SKAction*)crossFadeActionToRed:(int)targetRed green:(int)targetGreen blue:(int)targetBlue duration:(NSTimeInterval)duration {
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

    SKAction *colorChange = [SKAction runBlock:^{
        int newRed = [self increment:self.red toTargetValue:targetRed];
        int newGreen = [self increment:self.green toTargetValue:targetGreen];
        int newBlue = [self increment:self.blue toTargetValue:targetBlue];
        [self setColorWithRed:newRed green:newGreen blue:newBlue];
    }];
    
    return [SKAction repeatAction:[SKAction sequence:@[wait,colorChange]] count:[maxRange intValue]];
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
