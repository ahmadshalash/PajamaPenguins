//
//  PPGameScene.m
//
//  Created by Skye Freeman on 1/1/2015.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.

#import "PPGameScene.h"
#import "PPPlayer.h"
#import "PPIcebergObstacle.h"
#import "SKColor+SFAdditions.h"
#import "SKNode+SFAdditions.h"
#import "SSKCameraNode.h"
#import "SSKButtonNode.h"
#import "SSKScoreNode.h"
#import "SSKGraphicsUtils.h"

typedef enum {
    MainMenu,
    Playing,
    GameOver,
}GameState;

typedef enum {
    backgroundLayer = 0,
    playerLayer,
    foregroundLayer,
    hudLayer,
    menuLayer,
    fadeOutLayer,
}Layers;

//Physics Constants
static const uint32_t playerCategory   = 0x1 << 0;
static const uint32_t obstacleCategory = 0x1 << 1;
static const uint32_t edgeCategory     = 0x1 << 2;

CGFloat const kAirGravityStrength = -3;
CGFloat const kWaterGravityStrength = 6;
CGFloat const kGameOverGravityStrength = -9.8;

//Clamped Constants
CGFloat const kWorldScaleCap = 0.70;
CGFloat const kWorldZoomSpeed = 0.15;

CGFloat const kPlayerUpperVelocityLimit = 600.0;
CGFloat const kPlayerLowerAirVelocityLimit = -600.0;
CGFloat const kPlayerLowerWaterVelocityLimit = -550.0;

//Name Constants
NSString * const kPixelFontName = @"Fipps-Regular";

@interface PPGameScene()
@property (nonatomic) GameState gameState;
@property (nonatomic) SKNode *worldNode;
@property (nonatomic) SKNode *menuNode;
@property (nonatomic) SKNode *hudNode;
@property (nonatomic) SKNode *gameOverNode;
@end

@implementation PPGameScene {
    NSTimeInterval _lastUpdateTime;
}

- (id)initWithSize:(CGSize)size {
    return [super initWithSize:size];
}

- (void)didMoveToView:(SKView *)view {
    self.backgroundColor = SKColorWithRGB(6, 220, 220);
    self.anchorPoint = CGPointMake(0.5, 0.5);
    
    [self createNewGame];
    [self testStuff];
}

#pragma mark - Test Stuff
- (void)testStuff {
}

#pragma mark - Creating scene layers
- (void)createNewGame {
    [self createWorldLayer];
    [self gameMenu];
}

- (void)createWorldLayer {
    self.worldNode = [SSKCameraNode node];
    [self.worldNode setName:@"world"];
    [self addChild:self.worldNode];
    
    PPPlayer *player = [[PPPlayer alloc] initWithTexture:[sTextures objectAtIndex:0]
                                              atPosition:CGPointMake(-self.size.width/4, 150)];
    [player setScale:2];
    [player setName:@"player"];
    [player setZRotation:SSKDegreesToRadians(90)];
    [player setZPosition:playerLayer];
    [player.physicsBody setCategoryBitMask:playerCategory];
    [player.physicsBody setCollisionBitMask:obstacleCategory | edgeCategory];
    [player.physicsBody setContactTestBitMask:obstacleCategory];
    [self.worldNode addChild:player];
    
    SKSpriteNode *water = [SKSpriteNode spriteNodeWithColor:SKColorWithRGB(85, 65, 50) size:CGSizeMake(self.size.width * 3, self.size.height * 3)];
    [water setAnchorPoint:CGPointMake(.5, 1)];
    [water setPosition:CGPointMake(self.size.width/2, 0)];
    [water setAlpha:0.5];
    [water setName:@"water"];
    [water setZPosition:foregroundLayer];
    [self.worldNode addChild:water];
    
    SKSpriteNode *boundary = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(water.size.width, water.size.height)];
    boundary.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:boundary.frame];
    [boundary.physicsBody setFriction:0];
    [boundary.physicsBody setRestitution:0];
    [boundary.physicsBody setCategoryBitMask:edgeCategory];
    [self.worldNode addChild:boundary];
}

- (void)createMenuLayer {
    self.menuNode = [SKNode node];
    [self.menuNode setZPosition:menuLayer];
    [self.menuNode setName:@"menu"];
    [self addChild:self.menuNode];
    
    SKLabelNode *titleLabel = [self createNewLabelWithText:@"Pajama Penguins" withFontSize:18];
    [titleLabel setPosition:CGPointMake(0, self.size.height/6 * 2)];
    [self.menuNode addChild:titleLabel];

    SKSpriteNode *startFinger = [SKSpriteNode spriteNodeWithTexture:[sTextures objectAtIndex:120]];
    [startFinger setScale:5];
    [startFinger setPosition:CGPointMake(0, -self.size.height/3)];
    [startFinger setName:@"finger"];
    [self.menuNode addChild:startFinger];
    
    SKSpriteNode *startFingerEffect = [SKSpriteNode spriteNodeWithTexture:[sTextures objectAtIndex:121]];
    [startFingerEffect setScale:5];
    [startFingerEffect setPosition:CGPointMake(startFinger.position.x - startFinger.size.width/8, startFinger.position.y + startFinger.size.height/6 * 4)];
    [startFingerEffect setAlpha:0];
    [startFingerEffect setName:@"fingerEffect"];
    [self.menuNode addChild:startFingerEffect];
}

- (void)createHudLayer {
    self.hudNode = [SKNode node];
    [self.hudNode setZPosition:hudLayer];
    [self.hudNode setName:@"hud"];
    [self.hudNode setAlpha:0];
    [self addChild:self.hudNode];
    
    SSKScoreNode *scoreCounter = [SSKScoreNode scoreNodeWithFontNamed:kPixelFontName fontSize:12 fontColor:[SKColor blackColor]];
    [scoreCounter setName:@"scoreCounter"];
    [scoreCounter setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeLeft];
    [scoreCounter setVerticalAlignmentMode:SKLabelVerticalAlignmentModeBottom];
    [scoreCounter setPosition:CGPointMake(-self.size.width/2 + 5, -self.size.height/2 + 5)];
    [self.hudNode addChild:scoreCounter];
    
    CGFloat moveDistance = 5;
    [self.hudNode setPosition:CGPointMake(0, -moveDistance)];
    [self.hudNode runAction:[self moveDistance:CGVectorMake(0, moveDistance) andFadeInWithDuration:.2]];
}

- (void)createGameOverLayer {
    self.gameOverNode = [SKNode node];
    [self.gameOverNode setZPosition:menuLayer];
    [self.gameOverNode setName:@"gameOver"];
    [self.gameOverNode setAlpha:0];
    [self addChild:self.gameOverNode];
    
    SKLabelNode *gameOverLabel = [self createNewLabelWithText:@"Game Over" withFontSize:30];
    [gameOverLabel setFontColor:SKColorWithRGB(150, 5, 5)];
    [gameOverLabel setPosition:CGPointMake(0, self.size.height/4)];
    [self.gameOverNode addChild:gameOverLabel];
    
    NSString *currentScore = [(SSKScoreNode*)[self.hudNode childNodeWithName:@"scoreCounter"] text];
    NSString *currentScoreWithMeters = [NSString stringWithFormat:@"%@ meters.",currentScore];

    SKLabelNode *scoreLabel = [self createNewLabelWithText:currentScoreWithMeters withFontSize:20];
    [scoreLabel setPosition:CGPointMake(gameOverLabel.position.x, gameOverLabel.position.y - 50)];
    [self.gameOverNode addChild:scoreLabel];
    
    SSKButtonNode *restartButton = [[SSKButtonNode alloc] initWithIdleTexture:[sTextures objectAtIndex:135] selectedTexture:[sTextures objectAtIndex:136]];
    [restartButton setScale:6];
    [restartButton setPosition:CGPointMake(0, -self.size.height/4)];
    [restartButton setTouchUpInsideTarget:self selector:@selector(resetGame)];
    [self.gameOverNode addChild:restartButton];
    
    CGFloat moveDistance = 30;
    [self.gameOverNode setPosition:CGPointMake(-moveDistance, 0)];
    [self.gameOverNode runAction:[self moveDistance:CGVectorMake(moveDistance, 0) andFadeInWithDuration:.35]];
}

#pragma mark - GameState MainMenu
- (void)gameMenu {
    self.gameState = MainMenu;

    [self createMenuLayer];
    [self startMenuAnimations];
}

- (void)startMenuAnimations {
    [self runAction:[SKAction waitForDuration:.5] completion:^{
        [self runMenuFingerAction];
    }];
}

- (void)runMenuFingerAction {
    SKNode *finger = [self.menuNode childNodeWithName:@"finger"];
    SKNode *fingerEffect = [self.menuNode childNodeWithName:@"fingerEffect"];
    
    SKAction *fingerFloatUp = [SKAction moveByX:0 y:10 duration:.5];
    fingerFloatUp.timingMode = SKActionTimingEaseInEaseOut;
    SKAction *fingerFloatDown = fingerFloatUp.reversedAction;
    SKAction *effectOn = [SKAction runBlock:^{
        [fingerEffect setAlpha:1];
    }];
    SKAction *effectOff = [SKAction runBlock:^{
        [fingerEffect setAlpha:0];
    }];
    SKAction *effectWait = [SKAction waitForDuration:.25];
    SKAction *sequence = [SKAction sequence:@[fingerFloatUp,effectOn,effectWait,effectOff,fingerFloatDown]];
    
    [finger runAction:[SKAction repeatActionForever:sequence]];
}

#pragma mark - GameState Playing
- (void)gameStart {
    self.gameState = Playing;

    [self runAction:[SKAction fadeOutWithDuration:.5] onNode:[self childNodeWithName:@"menu"]];
    [self createHudLayer];
    [self startObstacleSpawnSequence];
    [self startScoreCounter];
}

#pragma mark - GameState GameOver
- (void)gameEnd {
    self.gameState = GameOver;
    
    [self stopScoreCounter];
    [self stopObstacleSpawnSequence];
    [self stopObstacleMovement];
    [self runGameOverSequence];
}

- (void)runGameOverSequence {
    [self setGravity:kGameOverGravityStrength];
    [self playerGameOverCatapult];
    [self createGameOverLayer];
}

- (void)resetGame {
    SKSpriteNode *fadeNode = [SKSpriteNode spriteNodeWithColor:[SKColor blackColor] size:self.size];
    [fadeNode setZPosition:fadeOutLayer];
    [fadeNode setAlpha:0];
    [self addChild:fadeNode];
    
    [fadeNode runAction:[SKAction fadeInWithDuration:.5] completion:^{
        [self.worldNode removeFromParent];
        [self.menuNode removeFromParent];
        [self.hudNode removeFromParent];
        [self.gameOverNode removeFromParent];
        [self createNewGame];
        [fadeNode runAction:[SKAction fadeOutWithDuration:.5] completion:^{
            [fadeNode removeFromParent];
        }];
    }];
}

#pragma mark - Player
- (void)startPlayerDive {
    [[self currentPlayer] setPlayerShouldDive:YES];
}

- (void)stopPlayerDive {
    [[self currentPlayer] setPlayerShouldDive:NO];
}

- (void)clampPlayerVelocity {
    PPPlayer *player = [self currentPlayer];
    
    if (player.physicsBody.velocity.dy >= kPlayerUpperVelocityLimit) {
        [player.physicsBody setVelocity:CGVectorMake(player.physicsBody.velocity.dx, kPlayerUpperVelocityLimit)];
    }
    
    if (player.position.y > [self childNodeWithName:@"water"].position.y) {
        if (player.physicsBody.velocity.dy <= kPlayerLowerAirVelocityLimit) {
            [player.physicsBody setVelocity:CGVectorMake(player.physicsBody.velocity.dx, kPlayerLowerAirVelocityLimit)];
        }
    } else {
        if (player.physicsBody.velocity.dy <= kPlayerLowerWaterVelocityLimit) {
            [player.physicsBody setVelocity:CGVectorMake(player.physicsBody.velocity.dx, kPlayerLowerWaterVelocityLimit)];
        }
    }
}

- (void)playerGameOverCatapult {
    PPPlayer *player = (PPPlayer*)[self.worldNode childNodeWithName:@"player"];
    [player.physicsBody setVelocity:CGVectorMake(0, 0)];
    [player.physicsBody setCollisionBitMask:0x0];
    [player.physicsBody setContactTestBitMask:0x0];
    
    [player.physicsBody applyImpulse:CGVectorMake(.5, 6.5)];
    [player.physicsBody applyAngularImpulse:-.00015];
}

#pragma mark - Obstacles
- (PPIcebergObstacle*)newIceBergAtPosition:(CGPoint)position withWidth:(CGFloat)width {
    PPIcebergObstacle *obstacle = [[PPIcebergObstacle alloc] initWithWidth:width];
    [obstacle setPosition:position];
    [obstacle setName:@"obstacle"];
    [obstacle.physicsBody setCategoryBitMask:obstacleCategory];
    return obstacle;
}

- (SKNode*)generateNewObstacleWithRandomSize {
    CGFloat randomNum = SSKRandomFloatInRange(15, 225);
    CGPoint spawnPoint = CGPointMake(self.size.width * 1.5, 0);
    return [self newIceBergAtPosition:spawnPoint withWidth:randomNum];
}

#pragma mark - Obstacle Spawn Sequence
- (void)startObstacleSpawnSequence {
    SKAction *wait = [SKAction waitForDuration:1.5];
    SKAction *spawnFloatMove = [SKAction runBlock:^{
        SKNode *obstacle = [self generateNewObstacleWithRandomSize];
        [self.worldNode addChild:obstacle];
        [obstacle runAction:[SKAction repeatActionForever:[self floatAction]]];
        [obstacle runAction:[SKAction moveToX:-self.size.width duration:4] withKey:@"moveObstacle" completion:^{
            [obstacle removeFromParent];
        }];
    }];
    SKAction *sequence = [SKAction sequence:@[wait,spawnFloatMove]];
    [self runAction:[SKAction repeatActionForever:sequence] withKey:@"gamePlaying"];
}

- (void)stopObstacleSpawnSequence {
    [self removeActionForKey:@"gamePlaying"];
}

- (void)stopObstacleMovement {
    [self.worldNode enumerateChildNodesWithName:@"obstacle" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeActionForKey:@"moveObstacle"];
    }];
}

#pragma mark - Score Tracking
- (void)startScoreCounter {
    SKAction *timerDelay = [SKAction waitForDuration:.25];
    SKAction *incrementScore = [SKAction runBlock:^{
        [(SSKScoreNode*)[self.hudNode childNodeWithName:@"scoreCounter"] increment];
    }];
    SKAction *sequence = [SKAction sequence:@[timerDelay,incrementScore]];
    [self runAction:[SKAction repeatActionForever:sequence] withKey:@"scoreKey"];
}

- (void)stopScoreCounter {
    [self removeActionForKey:@"scoreKey"];
}

#pragma mark - World Gravity
- (void)setGravity:(CGFloat)gravity {
    [self.physicsWorld setGravity:CGVectorMake(0, gravity)];
}

#pragma mark - Actions
- (SKAction*)floatAction {
    SKAction *down = [SKAction moveByX:0 y:-25 duration:2];
    [down setTimingMode:SKActionTimingEaseInEaseOut];
    SKAction *up = [down reversedAction];
    return [SKAction sequence:@[down,up]];
}

- (SKAction*)moveObstacleWithDuration:(NSTimeInterval)duration {
    return [SKAction moveToX:-self.size.width duration:duration];
}

- (SKAction*)moveDistance:(CGVector)distance andFadeInWithDuration:(NSTimeInterval)duration {
    SKAction *fadeIn = [SKAction fadeInWithDuration:duration];
    SKAction *moveIn = [SKAction moveBy:distance duration:duration];
    return [SKAction group:@[fadeIn,moveIn]];
}

#pragma mark - Convenience
- (SKLabelNode *)createNewLabelWithText:(NSString*)text withFontSize:(CGFloat)fontSize {
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:kPixelFontName];
    [label setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
    [label setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    [label setFontColor:[SKColor blackColor]];
    [label setText:text];
    [label setFontSize:fontSize];
    return label;
}

- (void)runAction:(SKAction*)action onNode:(SKNode*)node {
    [node runAction:action];
}

- (PPPlayer*)currentPlayer {
    return (PPPlayer*)[self.worldNode childNodeWithName:@"player"];
}

#pragma mark - Collisions
- (void)resolveCollisionFromFirstBody:(SKPhysicsBody *)firstBody secondBody:(SKPhysicsBody *)secondBody {
    if (self.gameState == Playing) {
        [self gameEnd];
    }
}

#pragma mark - Input
- (void)interactionBeganAtPosition:(CGPoint)position {
    if (self.gameState == MainMenu) {
        [self gameStart];
    }
    
    if (self.gameState == Playing) {
        if (self.worldNode.xScale >= kWorldScaleCap) {
            [self startPlayerDive];
        }
    }
}

- (void)interactionEndedAtPosition:(CGPoint)position {
    [self stopPlayerDive];
}

#pragma mark - Scene Processing
- (void)update:(NSTimeInterval)currentTime {
    NSTimeInterval deltaTime = currentTime - _lastUpdateTime;
    _lastUpdateTime = currentTime;
    
    if (deltaTime > 1) {
        deltaTime = 0;
    }

    if (!(self.gameState == GameOver)) {
        [self updatePlayingGravity];
        [[self currentPlayer] update:deltaTime];
        [self clampPlayerVelocity];
    }
}

- (void)didEvaluateActions {
    if (!(self.gameState == GameOver)) {
    }
}

- (void)didSimulatePhysics {
    if (!(self.gameState == GameOver)) {
        [self updateWorldZoom];
    }
}

#pragma mark - Updated Per Frame
- (void)updatePlayingGravity {
    if ([self currentPlayer].position.y > [self.worldNode childNodeWithName:@"water"].position.y) {
        [self setGravity:kAirGravityStrength];
    } else {
        [self setGravity:kWaterGravityStrength];
    }
}

#pragma mark - World Zoom
- (void)updateWorldZoom {
    if ([self playerIsAboveTopBoundary]) {
        [self.worldNode setScale:(1 - [self topZoomRatio])];
        [self.worldNode setPosition:CGPointMake(-[self amountToZoomTop].dx, -[self amountToZoomTop].dy)];
        
        if ([self worldIsBelowMinZoom]) {
            [self capMaxZoom];
        }
    }
    
    else if ([self playerIsBelowBottomBoundary]) {
        [self.worldNode setScale:1 - [self bottomZoomRatio]];
        [self.worldNode setPosition:CGPointMake(-[self amountToZoomBottom].dx, [self amountToZoomBottom].dy)];
        
        if ([self worldIsBelowMinZoom]) {
            [self capMaxZoom];
        }
    }
}

- (void)capMaxZoom {
    CGFloat horizontalOffsetCap = -[self distanceFromCenterToTopRight].dx * (1 - kWorldScaleCap);
    CGFloat verticalOffsetCap = [self distanceFromCenterToTopRight].dy * (1 - kWorldScaleCap);
    
    if ([self playerIsAboveTopBoundary]) {
        verticalOffsetCap = verticalOffsetCap * -1;
    }
    
    [self.worldNode setScale:kWorldScaleCap];
    [self.worldNode setPosition:CGPointMake(horizontalOffsetCap,verticalOffsetCap)];
}

- (void)resetWorldZoom {
    [self.worldNode setScale:1];
    [self.worldNode setPosition:CGPointZero];
}

- (CGVector)amountToZoomTop {
    return CGVectorMake([self distanceFromCenterToTopRight].dx * [self topZoomRatio], [self distanceFromCenterToTopRight].dy * [self topZoomRatio]);
}

- (CGVector)amountToZoomBottom {
    return CGVectorMake([self distanceFromCenterToTopRight].dx * [self bottomZoomRatio], [self distanceFromCenterToTopRight].dy * [self bottomZoomRatio]);
}

- (CGFloat)topZoomRatio {
    return (fabsf(([self currentPlayerDistanceFromSceneTop]/[self distanceFromBoundaryToEdge]) * kWorldZoomSpeed));
}

- (CGFloat)bottomZoomRatio {
    return (fabsf(([self currentPlayerDistanceFromSceneBottom]/[self distanceFromBoundaryToEdge]) * kWorldZoomSpeed));
}

- (CGVector)distanceFromCenterToTopRight {
    return SSKDistanceBetweenPoints(CGPointZero, CGPointMake(self.size.width/2, self.size.height/2));
}

- (CGFloat)currentPlayerDistanceFromSceneTop {
    return ([self currentPlayer].position.y - [self topZoomBoundary]);
}

- (CGFloat)currentPlayerDistanceFromSceneBottom {
    return ([self currentPlayer].position.y - [self bottomZoomBoundary]);
}

- (CGFloat)distanceFromBoundaryToEdge {
    return (self.size.height/2 - [self topZoomBoundary]);
}

- (CGFloat)topZoomBoundary {
    return self.size.height/5;
}

- (CGFloat)bottomZoomBoundary {
    return -self.size.height/5;
}

- (BOOL)worldIsBelowMinZoom {
    return (self.worldNode.xScale <= kWorldScaleCap);
}

- (BOOL)playerIsBelowBottomBoundary {
    return ([self currentPlayer].position.y < [self bottomZoomBoundary]);
}

- (BOOL)playerIsAboveTopBoundary {
    return ([self currentPlayer].position.y > [self topZoomBoundary]);
}

#pragma mark - Managing Assets
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
