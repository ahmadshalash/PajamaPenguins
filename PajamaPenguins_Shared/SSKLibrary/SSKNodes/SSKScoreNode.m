//
//  SSKScoreNode.m
//  PajamaPenguins
//
//  Created by Skye on 2/20/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "SSKScoreNode.h"

@interface SSKScoreNode()
@property (nonatomic, readwrite) NSInteger score;
@end

@implementation SSKScoreNode

- (instancetype)initWithFontNamed:(NSString*)fontName fontSize:(CGFloat)fontSize fontColor:(SKColor*)fontColor {
    self = [super initWithFontNamed:fontName];
    
    if (self) {
        self.fontSize = fontSize;
        self.fontColor = fontColor;
        
        [self updateTextWithCount:0];
    }
    
    return self;
}

+ (instancetype)scoreNodeWithFontNamed:(NSString*)fontName fontSize:(CGFloat)fontSize fontColor:(SKColor*)fontColor {
    return [[self alloc] initWithFontNamed:fontName fontSize:fontSize fontColor:fontColor];
}

- (instancetype)initWithFontNamed:(NSString *)fontName {
    return [self initWithFontNamed:fontName fontSize:20 fontColor:[SKColor blackColor]];
}

#pragma mark - Counter
- (void)increment {
    [self updateTextWithCount:self.score++];
}

- (void)decrement {
    [self updateTextWithCount:self.score--];
}

- (void)updateTextWithCount:(NSInteger)count {
    self.text = [NSString stringWithFormat:@"%lu",count];
}

@end
