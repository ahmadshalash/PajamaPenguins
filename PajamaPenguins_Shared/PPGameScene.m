//
//  PPGameScene.m
//
//  Created by Skye Freeman on 1/1/2015.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.

#import "PPGameScene.h"
#import "PPPlayer.h"
#import "SSKColor+Additions.h"
#import "SSKButton.h"
#import "SSKCamera.h"
#import "SSKGraphicsUtils.h"

typedef enum {
    MainMenu,
    Playing,
}GameState;

typedef enum {
    backgroundLayer = 0,
    playerLayer,
    foregroundLayer,
    menuLayer,
}Layers;

CGFloat const kAirGravityStrength = -3;
CGFloat const kWaterGravityStrength = 6;
CGFloat const kEdgePadding = 50;

@interface PPGameScene()
@property (nonatomic) GameState gameState;

@property (nonatomic) SKNode *worldNode;
@property (nonatomic) SKNode *menuNode;

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

    [self createWorld];
    [self createPlayer];
    [self createMenu];
}

- (void)createWorld {
    self.worldNode = [SKNode node];
    [self.worldNode setName:@"world"];
    [self addChild:self.worldNode];
    
    SKSpriteNode *water = [SKSpriteNode spriteNodeWithColor:SSKColorWithRGB(85, 65, 50) size:CGSizeMake(self.size.width * 1.5, self.size.height/2 * 1.5)];
    [water setPosition:CGPointMake(self.size.width/2, self.size.height/2)];
    [water setAnchorPoint:CGPointMake(0.5, 1)];
    [water setAlpha:0.5];
    [water setName:@"water"];
    [water setZPosition:foregroundLayer];
    [self.worldNode addChild:water];
}

- (void)createMenu {
    self.menuNode = [SKNode node];
    [self.menuNode setZPosition:menuLayer];
    [self.menuNode setName:@"menu"];
    [self addChild:self.menuNode];
    
    SKLabelNode *titleLabel = [self createNewLabelWithText:@"Pajama Penguins" withFontSize:50];
    [titleLabel setPosition:CGPointMake(self.size.width/2, self.size.height/6 * 5)];
    [self.menuNode addChild:titleLabel];
    
    SKLabelNode *startLabel = [self createNewLabelWithText:@"Tap to start!" withFontSize:30];
    [startLabel setPosition:CGPointMake(self.size.width/2, self.size.height/6)];
    [self.menuNode addChild:startLabel];

    SKSpriteNode *startIcon = [SKSpriteNode spriteNodeWithTexture:[sTextures objectAtIndex:17]];
    [startIcon setScale:5];
    [startIcon setPosition:CGPointMake(startLabel.position.x, startLabel.position.y + startIcon.size.height)];
    [self.menuNode addChild:startIcon];
}

- (void)createPlayer {
    PPPlayer *player = [[PPPlayer alloc] initWithTexture:[sTextures objectAtIndex:0]
                                              atPosition:CGPointMake(self.size.width/4, self.size.height/2)];
    [player setScale:4];
    [player setName:@"player"];
    [player setZRotation:SSKDegreesToRadians(90)];
    [player setZPosition:playerLayer];
    [self addChild:player];
}
#pragma mark - Initial scene animations
- (void)startSceneAnimations {
}

#pragma mark - Game Start
- (void)prepareGameStart {
    SKNode *menu = [self childNodeWithName:@"menu"];
    [menu runAction:[SKAction fadeOutWithDuration:.5]];
    
    self.gameState = Playing;
}

#pragma mark - Player
- (void)updatePlayer:(NSTimeInterval)dt {
    SKNode *player = (PPPlayer*)[self childNodeWithName:@"player"];
    [(PPPlayer*)player update:dt];
}

- (void)checkPlayerBoundaries {
    SKNode *player = (PPPlayer*)[self childNodeWithName:@"player"];
    
    if ((player.position.y > self.size.height/8 * 7) ||
        (player.position.y < self.size.height/8))
    {
        [player.physicsBody setVelocity:CGVectorMake(0, 0)];
    }
}

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
        SKNode *player = [self childNodeWithName:@"player"];
        [(PPPlayer*)player setPlayerShouldDive:YES];
    }
}

- (void)interactionEndedAtPosition:(CGPoint)position {
    SKNode *player = [self childNodeWithName:@"player"];
    [(PPPlayer*)player setPlayerShouldDive:NO];
}

- (void)interactionMovedAtPosition:(CGPoint)position {
}

#pragma mark - Scene Processing
- (void)update:(NSTimeInterval)currentTime {
    [self updateGravity];
    [self updatePlayer:currentTime];
}

- (void)didEvaluateActions {
}

- (void)didSimulatePhysics {
}

- (void)didFinishUpdate {
    SKNode *player = [self childNodeWithName:@"player"];
    if (player.position.y >= self.size.height - 50) {
        
    }
}

#pragma mark - Updates
- (void)updateGravity {
    SKNode *player = [self childNodeWithName:@"player"];
    
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
