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
    backgroundLayer,
    playerLayer,
    menuLayer,
}Layers;

@interface PPGameScene()
@property (nonatomic) SKNode *playerLayerNode;
@property (nonatomic) SKNode *menuLayerNode;
@end

@implementation PPGameScene

- (id)initWithSize:(CGSize)size {
    return [super initWithSize:size];
}

- (void)didMoveToView:(SKView *)view {
    [self createScene];
    [self startSceneAnimations];
}

#pragma mark - Creating scene layers
- (void)createScene {
    self.backgroundColor = SKColorWithRGB(6, 220, 220);

    [self createBackgroundLayer];
    [self createPlayerLayer];
    [self createMenuLayer];
}

- (void)createMenuLayer {
    self.menuLayerNode = [SKNode node];
    [self.menuLayerNode setZPosition:menuLayer];
    [self.menuLayerNode setName:@"menu"];
    [self addChild:self.menuLayerNode];
    
    SKNode *startButtonNode = [SKNode node];
    [startButtonNode setName:@"startButtonNode"];
    [self.menuLayerNode addChild:startButtonNode];
    
    SSKButton *startButton = [[SSKButton alloc] initWithIdleTexture:[sTextures objectAtIndex:15] selectedTexture:[sTextures objectAtIndex:16]];
    [startButton setTouchUpInsideTarget:self selector:@selector(startButtonTouchUpInside)];
    [startButton setName:@"startButton"];
    [startButton setPosition:CGPointMake(self.size.width/2, self.size.height/4)];
    [startButton setXScale:10];
    [startButton setYScale:6];
    [startButtonNode addChild:startButton];
    
    SKLabelNode *startButtonLabel = [self createNewLabelWithText:@"Start"];
    [startButtonLabel setPosition:startButton.position];
    [startButtonNode addChild:startButtonLabel];
}

- (void)createBackgroundLayer {
}

- (void)createPlayerLayer {
    self.playerLayerNode = [SKNode node];
    [self.playerLayerNode setZPosition:playerLayer];
    [self.playerLayerNode setName:@"playerLayer"];
    [self addChild:self.playerLayerNode];
    
    SKSpriteNode *platform = [SKSpriteNode spriteNodeWithTexture:[sTextures objectAtIndex:1]];
    [platform setScale:10];
    [platform setPosition:CGPointMake(self.size.width/2, self.size.height/2)];
    [platform setName:@"platform"];
    [self.playerLayerNode addChild:platform];
    
    SKSpriteNode *player = [SKSpriteNode spriteNodeWithTexture:[sTextures objectAtIndex:0]];
    [player setScale:5];
    [player setPosition:CGPointMake(platform.position.x, platform.position.y + player.size.height)];
    [player setName:@"player"];
    [player setZPosition:playerLayer];
    [self.playerLayerNode addChild:player];
}

#pragma mark - Initial scene animations
- (void)startSceneAnimations {
    //Slight Wait to prevent initial animation glitchyness
    [self runAction:[SKAction waitForDuration:.5] completion:^{
        [self.playerLayerNode runAction:[SKAction repeatActionForever:[self floatAction]] withKey:@"float"];
    }];
}

#pragma mark - Button Methods
- (void)startButtonTouchUpInside {
    SKNode *menu = [self childNodeWithName:@"menu"];
    SKNode *buttonNode = [menu childNodeWithName:@"startButtonNode"];
    SKNode *button = [buttonNode childNodeWithName:@"startButton"];
    
    if (!menu.hasActions) {
        [button setUserInteractionEnabled:NO];
        [menu runAction:[SKAction fadeOutWithDuration:.5] completion:^{
            [menu removeFromParent];
        }];
    }
}

#pragma mark - Actions
- (SKAction*)floatAction {
    SKAction *down = [SKAction moveByX:0 y:-35 duration:2];
    [down setTimingMode:SKActionTimingEaseInEaseOut];
    SKAction *up = [down reversedAction];
    return [SKAction sequence:@[down,up]];
}

#pragma mark - Convenience
- (SKLabelNode *)createNewLabelWithText:(NSString*)text {
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Verdana"];
    [label setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
    [label setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    [label setText:text];
    [label setFontSize:35];
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
