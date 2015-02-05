//
//  SSKGameScene.m
//
//  Created by Skye Freeman on 1/1/2015.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.

#import "SSKGameScene.h"

@implementation SSKGameScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        //Sets the screen background color
        self.backgroundColor = [SKColor lightGrayColor];
        
        //Creates a label
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        myLabel.text = @"Hello, World!";
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        myLabel.fontColor = [SKColor redColor];
        [self addChild:myLabel];
    }
    
    return self;
}

#pragma mark - Screen input interactions
- (void)interactionBeganAtPosition:(CGPoint)position {
    NSLog(@"Interaction started at: (%fl,%fl)", position.x, position.y);
}

- (void)interactionMovedAtPosition:(CGPoint)position {
    NSLog(@"Interaction moved to: (%fl,%fl)", position.x, position.y);
}

- (void)interactionEndedAtPosition:(CGPoint)position {
    NSLog(@"Interaction ended at: (%fl,%fl)", position.x, position.y);
}

#pragma mark - Update
- (void)update:(CFTimeInterval)currentTime {
}

@end
