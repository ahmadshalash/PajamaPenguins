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
    MainMenu,
    Playing,
}GameState;

typedef enum {
    backgroundLayer = 0,
    playerLayer,
    menuLayer,
}Layers;

@interface PPGameScene()
@property (nonatomic) GameState gameState;

@property (nonatomic) SKNode *playerLayerNode;
@property (nonatomic) SKNode *menuLayerNode;
@end

@implementation PPGameScene

- (id)initWithSize:(CGSize)size {
    return [super initWithSize:size];
}

- (void)didMoveToView:(SKView *)view {
    self.gameState = MainMenu;
    
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
    
    SKLabelNode *startLabel = [self createNewLabelWithText:@"Tap to start!"];
    [startLabel setPosition:CGPointMake(self.size.width/2, self.size.height/6)];
    [self.menuLayerNode addChild:startLabel];
    
    SKSpriteNode *startIcon = [SKSpriteNode spriteNodeWithTexture:[sTextures objectAtIndex:17]];
    [startIcon setScale:5];
    [startIcon setPosition:CGPointMake(startLabel.position.x, startLabel.position.y + startIcon.size.height)];
    [self.menuLayerNode addChild:startIcon];
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

#pragma mark - Game Start
- (void)prepareGameStart {
    SKNode *player = [self.playerLayerNode childNodeWithName:@"player"];
    [player runAction:[self moveToStartPositionWithNode:player]];
    
    SKNode *platform = [self.playerLayerNode childNodeWithName:@"platform"];
    [platform runAction:[self moveToStartPositionWithNode:platform]];
    
    SKNode *menu = [self childNodeWithName:@"menu"];
    [menu runAction:[SKAction fadeOutWithDuration:.5]];
}

#pragma mark - Button Methods

#pragma mark - Actions
- (SKAction*)floatAction {
    SKAction *down = [SKAction moveByX:0 y:-25 duration:2];
    [down setTimingMode:SKActionTimingEaseInEaseOut];
    SKAction *up = [down reversedAction];
    return [SKAction sequence:@[down,up]];
}

- (SKAction*)moveToStartPositionWithNode:(SKNode*)node {
    CGPoint destination = CGPointMake(self.size.width/4, node.position.y);
    CGPoint newDestination = [self convertPoint:destination toNode:node.parent];
    SKAction *move = [SKAction moveTo:newDestination duration:1];
    [move setTimingMode:SKActionTimingEaseInEaseOut];
    return move;
}

#pragma mark - Convenience
- (SKLabelNode *)createNewLabelWithText:(NSString*)text {
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Verdana"];
    [label setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
    [label setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    [label setFontColor:[SKColor blackColor]];
    [label setText:text];
    [label setFontSize:35];
    return label;
}

#pragma mark - Screen input interactions
- (void)interactionBeganAtPosition:(CGPoint)position {
    if (self.gameState == MainMenu) {
        self.gameState = Playing;
        [self prepareGameStart];
    }
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
