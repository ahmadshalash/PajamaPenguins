//
//  PPGameScene.m
//
//  Created by Skye Freeman on 1/1/2015.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.

#import "PPGameScene.h"
#import "SSKColor+Additions.h"
#import "SSKButton.h"
#import "SSKGraphicsUtils.h"

typedef enum {
    menuLayer,
}Layers;

@interface PPGameScene()
@property (nonatomic) SKNode *menuNode;
@end

@implementation PPGameScene

- (id)initWithSize:(CGSize)size {
    return [super initWithSize:size];
}

- (void)didMoveToView:(SKView *)view {
    [self createScene];
}

- (void)createScene {
    self.backgroundColor = SKColorWithRGB(6, 220, 220);
    [self createMenu];
}

- (void)createMenu {
    self.menuNode = [SKNode new];
    [self.menuNode setZPosition:menuLayer];
    [self.menuNode setName:@"menu"];
    [self addChild:self.menuNode];
    
    SKNode *startButtonNode = [SKNode new];
    [startButtonNode setName:@"startButtonNode"];
    [self.menuNode addChild:startButtonNode];
    
    SSKButton *startButton = [[SSKButton alloc] initWithIdleTexture:[sTextures objectAtIndex:15] selectedTexture:[sTextures objectAtIndex:16]];
    [startButton setTouchUpInsideTarget:self selector:@selector(startButtonTouchUpInside)];
    [startButton setName:@"startButton"];
    [startButton setPosition:CGPointMake(self.size.width/2, self.size.height/4)];
    [startButton setXScale:8];
    [startButton setYScale:4];
    [startButtonNode addChild:startButton];
//    
//    SKLabelNode *startButtonLabel = [self createNewLabelWithText:@"Dive !"];
//    [startButtonLabel setPosition:startButton.position];
//    [startButtonNode addChild:startButtonLabel];
}

#pragma mark - Button Methods
- (void)startButtonTouchUpInside {
//    SKNode *menu = [self childNodeWithName:@"menu"];
//    SKNode *buttonNode = [menu childNodeWithName:@"startButtonNode"];
//    SKNode *button = [buttonNode childNodeWithName:@"startButton"];
//    
//    if (!menu.hasActions) {
//        [button setUserInteractionEnabled:NO];
//        [menu runAction:[SKAction fadeOutWithDuration:.5] completion:^{
//            [menu removeFromParent];
//        }];
//    }
}

#pragma mark - Convenience
- (SKLabelNode *)createNewLabelWithText:(NSString*)text {
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"ChalkDuster"];
    [label setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
    [label setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    [label setText:text];
    [label setFontSize:25];
    return label;
}

#pragma mark - Screen input interactions
- (void)interactionBeganAtPosition:(CGPoint)position {
}

- (void)interactionMovedAtPosition:(CGPoint)position {
}

- (void)interactionEndedAtPosition:(CGPoint)position {
}

#pragma mark - Update
- (void)update:(CFTimeInterval)currentTime {
}

#pragma mark - Loading Assets
+ (void)loadSceneAssets {
    NSDate *startTime = [NSDate date];
    
    sTextures = [SSKGraphicsUtils loadFramesFromSpriteSheetNamed:@"PajamaPenguinsSpriteSheet"
                                                       frameSize:CGSizeMake(15, 15)
                                                          origin:CGPointMake(0, 225)
                                                       gridWidth:15
                                                      gridHeight:15];
    
    NSLog(@"Scene loaded in %f seconds",[[NSDate date] timeIntervalSinceDate:startTime]);
}

static NSArray *sTextures = nil;
- (NSArray*)sharedTextures {
    return sTextures;
}

@end
