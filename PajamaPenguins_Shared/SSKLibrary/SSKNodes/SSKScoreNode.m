//
//  SSKScoreNode.m
//  PajamaPenguins
//
//  Created by Skye on 2/20/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "SSKScoreNode.h"

@interface SSKScoreNode()
@property (nonatomic) NSInteger counter;
@end

@implementation SSKScoreNode

- (instancetype)initWithFontNamed:(NSString *)fontName fontSize:(CGFloat)fontSize fontColor:(SKColor*)fontColor {
    self = [super initWithFontNamed:fontName];
    
    if (self) {
        self.fontSize = fontSize;
        self.fontColor = fontColor;
        
        [self updateTextWithCount:0];
    }
    
    return self;
}

#pragma mark - Counter
- (void)increment {
    [self updateTextWithCount:self.counter++];
}

- (void)decrement {
    [self updateTextWithCount:self.counter--];
}

- (void)updateTextWithCount:(NSInteger)count {
    self.text = [NSString stringWithFormat:@"%lu",count];
}

@end
