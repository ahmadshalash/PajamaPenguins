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

CGFloat const kAirGravityStrength = -3;
CGFloat const kWaterGravityStrength = 6;

@interface PPGameScene()
@property (nonatomic) GameState gameState;

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
    
    [self createScene];
    [self startSceneAnimations];
}

#pragma mark - Creating scene layers
- (void)createScene {
    self.backgroundColor = SSKColorWithRGB(6, 220, 220);

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
    
    PPPlayer *player = [[PPPlayer alloc] initWithTexture:[sTextures objectAtIndex:0]
                                         atPosition:CGPointMake(self.size.width/4, self.size.height/2)];
    [player setScale:4];
    [player setName:@"player"];
    [player setZRotation:SSKDegreesToRadians(90)];
    [self.gameLayerNode addChild:player];
    
    SKSpriteNode *water = [SKSpriteNode spriteNodeWithColor:SSKColorWithRGB(85, 65, 50) size:CGSizeMake(self.size.width, self.size.height/2)];
    [water setPosition:CGPointMake(self.size.width/2, self.size.height/4)];
    [water setAlpha:0.5];
    [water setZPosition:1];
    [self.gameLayerNode addChild:water];
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

#pragma mark - Player
- (void)updatePlayer:(NSTimeInterval)dt {
    SKNode *player = (PPPlayer*)[self.gameLayerNode childNodeWithName:@"player"];
    [(PPPlayer*)player update:dt];
}

- (void)checkPlayerBoundaries {
    SKNode *player = (PPPlayer*)[self.gameLayerNode childNodeWithName:@"player"];
    
    if ((player.position.y > self.size.height/8 * 7) ||
        (player.position.y < self.size.height/8))
    {
        [player.physicsBody setVelocity:CGVectorMake(0, 0)];
    }
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

#pragma mark - Input
- (void)interactionBeganAtPosition:(CGPoint)position {
    if (self.gameState == MainMenu) {
        [self prepareGameStart];
    }
    
    if (self.gameState == Playing) {
        SKNode *player = [self.gameLayerNode childNodeWithName:@"player"];
        [(PPPlayer*)player setPlayerShouldDive:YES];
    }
}

- (void)interactionEndedAtPosition:(CGPoint)position {
    SKNode *player = [self.gameLayerNode childNodeWithName:@"player"];
    [(PPPlayer*)player setPlayerShouldDive:NO];
}

- (void)interactionMovedAtPosition:(CGPoint)position {
}

#pragma mark - Update
- (void)update:(NSTimeInterval)currentTime {
    [self updateGravity];
    [self updatePlayer:currentTime];
}

- (void)updateGravity {
    SKNode *player = [self.gameLayerNode childNodeWithName:@"player"];

    if (player.position.y > self.size.height/2) {
        [self.physicsWorld setGravity:CGVectorMake(0, kAirGravityStrength)];
    } else {
        [self.physicsWorld setGravity:CGVectorMake(0, kWaterGravityStrength)];
    }
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
