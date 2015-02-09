//
//  PPGameScene.m
//
//  Created by Skye Freeman on 1/1/2015.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.

#import "PPGameScene.h"
#import "PPPlayer.h"
#import "SSKColor+Additions.h"
#import "SSKButton.h"
#import "SSKGraphicsUtils.h"

typedef enum {
    MainMenu,
    Playing,
}GameState;

typedef enum {
    backgroundLayer = 0,
    gameLayer,
    menuLayer,
}Layers;

@interface PPGameScene()
@property (nonatomic) GameState gameState;
@property (nonatomic) PPPlayer *player;

@property (nonatomic) SKNode *gameLayerNode;
@property (nonatomic) SKNode *menuLayerNode;

@property (nonatomic) NSTimeInterval lastUpdateTime;
@end

@implementation PPGameScene

- (id)initWithSize:(CGSize)size {
    return [super initWithSize:size];
}

- (void)didMoveToView:(SKView *)view {
    self.gameState = MainMenu;
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.scene.frame];
    [self.physicsWorld setGravity:CGVectorMake(0, 9.8)];
    
    [self createScene];
    [self startSceneAnimations];
}

#pragma mark - Creating scene layers
- (void)createScene {
    self.backgroundColor = SKColorWithRGB(6, 220, 220);

    [self createBackgroundLayer];
    [self createGameLayer];
    [self createMenuLayer];
}

- (void)createMenuLayer {
    self.menuLayerNode = [SKNode node];
    [self.menuLayerNode setZPosition:menuLayer];
    [self.menuLayerNode setName:@"menu"];
    [self addChild:self.menuLayerNode];
    
    SKLabelNode *titleLabel = [self createNewLabelWithText:@"Pajama Penguins" withFontSize:50];
    [titleLabel setPosition:CGPointMake(self.size.width/2, self.size.height/6 * 5)];
    [self.menuLayerNode addChild:titleLabel];
    
    SKLabelNode *startLabel = [self createNewLabelWithText:@"Tap to start!" withFontSize:30];
    [startLabel setPosition:CGPointMake(self.size.width/2, self.size.height/6)];
    [self.menuLayerNode addChild:startLabel];

    SKSpriteNode *startIcon = [SKSpriteNode spriteNodeWithTexture:[sTextures objectAtIndex:17]];
    [startIcon setScale:5];
    [startIcon setPosition:CGPointMake(startLabel.position.x, startLabel.position.y + startIcon.size.height)];
    [self.menuLayerNode addChild:startIcon];
}

- (void)createBackgroundLayer {
}

- (void)createGameLayer {
    self.gameLayerNode = [SKNode node];
    [self.gameLayerNode setName:@"gameLayer"];
    [self.gameLayerNode setZPosition:gameLayer];
    [self addChild:self.gameLayerNode];
    
    self.player = [[PPPlayer alloc] initWithTexture:[sTextures objectAtIndex:0]
                                         atPosition:CGPointMake(self.size.width/4, self.size.height/2)];
    [self.player setScale:4];
    [self.player setName:@"player"];
    [self.player setZRotation:90];
    [self.gameLayerNode addChild:self.player];
}

#pragma mark - Initial scene animations
- (void)startSceneAnimations {
}

#pragma mark - Game Start
- (void)prepareGameStart {
    SKNode *gameLayer = [self childNodeWithName:@"gameLayer"];
    [gameLayer removeAllActions];
    
    SKNode *menu = [self childNodeWithName:@"menu"];
    [menu runAction:[SKAction fadeOutWithDuration:.5]];
    
    self.gameState = Playing;
}

#pragma mark - Button Methods

#pragma mark - Actions
- (SKAction*)floatAction {
    SKAction *down = [SKAction moveByX:0 y:-25 duration:2];
    [down setTimingMode:SKActionTimingEaseInEaseOut];
    SKAction *up = [down reversedAction];
    return [SKAction sequence:@[down,up]];
}

#pragma mark - Convenience
- (SKLabelNode *)createNewLabelWithText:(NSString*)text withFontSize:(CGFloat)fontSize {
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Verdana"];
    [label setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
    [label setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    [label setFontColor:[SKColor blackColor]];
    [label setText:text];
    [label setFontSize:fontSize];
    return label;
}

- (SKAction*)moveTo:(CGPoint)point duration:(NSTimeInterval)duration {
    SKAction *move = [SKAction moveTo:point duration:duration];
    [move setTimingMode:SKActionTimingEaseInEaseOut];
    return move;
}
#pragma mark - Screen input interactions
- (void)interactionBeganAtPosition:(CGPoint)position {
    if (self.gameState == MainMenu) {
        [self prepareGameStart];
    }
    
    if (self.gameState == Playing) {
        [self.player setPlayerShouldDive:YES];
    }
}

- (void)interactionMovedAtPosition:(CGPoint)position {
}

- (void)interactionEndedAtPosition:(CGPoint)position {
    [self.player setPlayerShouldDive:NO];
}

#pragma mark - Update
- (void)update:(NSTimeInterval)currentTime {
    [self.player update:currentTime];
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
