//
//  PPGameScene.m
//
//  Created by Skye Freeman on 1/1/2015.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.

#import "PPGameScene.h"
#import "PPPlayer.h"
#import "PPIcebergObstacle.h"
#import "PPWaterSprite.h"
#import "PPGradientSprite.h"

#import "SKColor+SFAdditions.h"
#import "SKNode+SFAdditions.h"
#import "SKScene+SFAdditions.h"

#import "SSKParallaxNode.h"
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
    waterSurfaceLayer,
    obstacleLayer,
    playerLayer,
    foregroundLayer,
    hudLayer,
    menuLayer,
    fadeOutLayer,
}Layers;

//Texture Constants
CGFloat const kLargeTileWidth = 30.0;
CGFloat const kSmallTileWidth = 15.0;

//Physics Constants
static const uint32_t playerCategory   = 0x1 << 0;
static const uint32_t obstacleCategory = 0x1 << 1;
static const uint32_t edgeCategory     = 0x1 << 2;

CGFloat const kAirGravityStrength = -3;
CGFloat const kWaterGravityStrength = 6;
CGFloat const kGameOverGravityStrength = -9.8;

//Clamped Constants
CGFloat const kWorldScaleCap = 0.6;
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
    self.backgroundColor = SKColorWithRGB(0,180,255);
    self.anchorPoint = CGPointMake(0.5, 0.5);
    
    [self createNewGame];
    [self testStuff];
}

#pragma mark - Test Stuff
- (void)testStuff {
//    [(PPGradientSprite*)[self.worldNode childNodeWithName:@"sky"] crossFadeToRed:100 green:30 blue:50 duration:3];
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

    //Parallaxing Nodes
//    SSKParallaxNode *waterSurfaceNode = [SSKParallaxNode nodeWithSize:[self maxWorldScaleSize]
//                                                        attachedNodes:[self waterSurfaceForParallax]
//                                                            moveSpeed:CGPointMake(-30, 0)];
//    [waterSurfaceNode setName:@"parallaxNode"];
//    [waterSurfaceNode setZPosition:waterSurfaceLayer];
//    [self.worldNode addChild:waterSurfaceNode];
    
    //Sky background
    PPGradientSprite *skyGradient = [PPGradientSprite spriteNodeWithGradientTexture:
                                     [SSKGraphicsUtils loadPixelTextureWithName:@"SkyGradientTexture"] red:100 green:200 blue:255];
    [skyGradient setAnchorPoint:CGPointMake(0, 0)];
    [skyGradient setZPosition:backgroundLayer];
    [skyGradient setPosition:CGPointMake(-self.size.width/2, 0)];
    [skyGradient setName:@"sky"];
    [self.worldNode addChild:skyGradient];
    
    //Water background
    PPGradientSprite *waterBackground = [PPGradientSprite spriteNodeWithGradientTexture:
                                         [SSKGraphicsUtils loadPixelTextureWithName:@"WaterGradientTexture"] red:0 green:128 blue:255];
    [waterBackground setPosition:CGPointMake(-self.size.width/2, 0)];
    [waterBackground setZPosition:foregroundLayer];
    [waterBackground setAnchorPoint:CGPointMake(0, 1)];
    [waterBackground setAlpha:.6];
    [waterBackground setName:@"water"];
    [self.worldNode addChild:waterBackground];

    
    //Player
    PPPlayer *player = [[PPPlayer alloc] initWithFirstTexture:[sLargeTextures objectAtIndex:0]
                                                secondTexture:[sLargeTextures objectAtIndex:1]];
    [player setPosition:CGPointMake(-self.size.width/4, 50)];
    [player setScale:[self getPlayerScale]];
    [player setName:@"player"];
    [player setZRotation:SSKDegreesToRadians(90)];
    [player setZPosition:playerLayer];
    [player.physicsBody setCategoryBitMask:playerCategory];
    [player.physicsBody setCollisionBitMask:obstacleCategory | edgeCategory];
    [player.physicsBody setContactTestBitMask:obstacleCategory];
    [self.worldNode addChild:player];
    
    //Screen Physics Boundary
    SKSpriteNode *boundary = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(self.size.width,self.size.height)];
    boundary.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:boundary.frame];
    [boundary.physicsBody setFriction:0];
    [boundary.physicsBody setRestitution:0];
    [boundary.physicsBody setCategoryBitMask:edgeCategory];
    [self addChild:boundary];
}

- (void)createMenuLayer {
    self.menuNode = [SKNode node];
    [self.menuNode setZPosition:menuLayer];
    [self.menuNode setName:@"menu"];
    [self addChild:self.menuNode];
    
    SKLabelNode *titleLabel = [self createNewLabelWithText:@"Pajama Penguins" withFontSize:18];
    [titleLabel setPosition:CGPointMake(0, self.size.height/6 * 2)];
    [self.menuNode addChild:titleLabel];

    SKSpriteNode *startFinger = [SKSpriteNode spriteNodeWithTexture:[sSmallTextures objectAtIndex:120]];
    [startFinger setScale:5];
    [startFinger setPosition:CGPointMake(0, -self.size.height/3)];
    [startFinger setName:@"finger"];
    [self.menuNode addChild:startFinger];
    
    SKSpriteNode *startFingerEffect = [SKSpriteNode spriteNodeWithTexture:[sSmallTextures objectAtIndex:121]];
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
    
    SSKButtonNode *restartButton = [[SSKButtonNode alloc] initWithIdleTexture:[sSmallTextures objectAtIndex:135] selectedTexture:[sSmallTextures objectAtIndex:136]];
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
- (void)clampPlayerVelocity {
    PPPlayer *player = [self currentPlayer];
    
    if (player.physicsBody.velocity.dy >= kPlayerUpperVelocityLimit) {
        [player.physicsBody setVelocity:CGVectorMake(player.physicsBody.velocity.dx, kPlayerUpperVelocityLimit)];
    }
    
    if (player.position.y > [self childNodeWithName:@"//water"].position.y) {
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
    [player.physicsBody applyImpulse:CGVectorMake(.85, 25)];
    [player.physicsBody applyAngularImpulse:-.0005];
}

#pragma mark - Water
//Water Surface Background
- (SKNode*)waterSurfaceNode {
    SKNode *node = [SKNode new];
    
    NSInteger newTileSize = [self getWaterSurfaceScale] * kLargeTileWidth;
    NSInteger numTilesForScreen = (self.size.width * (1 + kWorldScaleCap))/newTileSize;
    
    for (int i = 0; i < numTilesForScreen; i++) {
        PPWaterSprite *waterTile;
        
        if (i % 3 == 0) {
            waterTile = [PPWaterSprite spriteNodeWithTexture:[sLargeTextures objectAtIndex:10]];
        }
        else if (i % 3 == 1) {
            waterTile = [PPWaterSprite spriteNodeWithTexture:[sLargeTextures objectAtIndex:11]];
        }
        else if (i % 3 == 2){
            waterTile = [PPWaterSprite spriteNodeWithTexture:[sLargeTextures objectAtIndex:12]];
        }
        
        [waterTile setScale:[self getWaterSurfaceScale]];
        [waterTile setPosition:CGPointMake(-self.size.width/2 + (newTileSize * i), 0)];
        [node addChild:waterTile];
    }
    return node;
}

- (NSArray*)waterSurfaceForParallax {
    NSMutableArray *waterTiles = [NSMutableArray array];
    for (int i = 0; i < 2; i++) {
        [waterTiles addObject:[self waterSurfaceNode]];
    }
    return [NSArray arrayWithArray:waterTiles];
}

//Underwater Background
- (SKSpriteNode*)waterBackgroundNode {
    SKSpriteNode *waterBackground = [SKSpriteNode spriteNodeWithTexture:[SSKGraphicsUtils loadPixelTextureWithName:@"WaterBackground"]];
    [waterBackground setScale:[self backgroundSpriteScale]];
    [waterBackground setAnchorPoint:CGPointMake(0, 1)];
    [waterBackground setAlpha:0.65];
    return waterBackground;
}

#pragma mark - Sky
- (SKSpriteNode*)skyBackgroundNode {
    SKSpriteNode *skyBackground = [SKSpriteNode spriteNodeWithTexture:[SSKGraphicsUtils loadPixelTextureWithName:@"SkyBackground"]];
    [skyBackground setScale:[self backgroundSpriteScale]];
    [skyBackground setAnchorPoint:CGPointMake(0, 0)];
    return skyBackground;
}

#pragma mark - Obstacles
- (PPIcebergObstacle*)newIceBergAtPosition:(CGPoint)position withWidth:(CGFloat)width {
    PPIcebergObstacle *obstacle = [[PPIcebergObstacle alloc] initWithWidth:width];
    [obstacle setPosition:position];
    [obstacle setName:@"obstacle"];
    [obstacle setZPosition:obstacleLayer];
    [obstacle.physicsBody setCategoryBitMask:obstacleCategory];
    return obstacle;
}

- (SKNode*)generateNewObstacleWithRandomSize {
    CGFloat randomNum = SSKRandomFloatInRange(15, 250);
    
    //Max zoom width position
    CGFloat spawnPosition = self.size.width/kWorldScaleCap;
    
    //Offset by half of iceberg width
    CGPoint spawnPoint = CGPointMake(spawnPosition + randomNum/2, 0);
    
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

- (void)updatePlayingGravity {
    if ([self currentPlayer].position.y > [self childNodeWithName:@"//water"].position.y) {
        [self setGravity:kAirGravityStrength];
    } else {
        [self setGravity:kWaterGravityStrength];
    }
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

- (CGFloat)getPlayerScale {
    CGFloat playerWidth = self.size.width/7.5;
    return (playerWidth/kLargeTileWidth);
}

- (CGFloat)getWaterSurfaceScale {
    CGFloat waterWidth = self.size.width/5;
    return (waterWidth/kLargeTileWidth);
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
            [[self currentPlayer] setPlayerShouldDive:YES];
        }
    }
}

- (void)interactionEndedAtPosition:(CGPoint)position {
    [[self currentPlayer] setPlayerShouldDive:NO];
}

#pragma mark - Scene Processing
- (void)update:(NSTimeInterval)currentTime {
    NSTimeInterval deltaTime = currentTime - _lastUpdateTime;
    _lastUpdateTime = currentTime;
    
    if (deltaTime > 1) {
        deltaTime = 0;
    }

    if (!(self.gameState == GameOver)) {
        [self updateParallaxNodesWithDelta:deltaTime];
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
    if (self.gameState == Playing) {
        [self updateWorldZoom];
    }
}
#pragma mark - Parallaxing
- (void)updateParallaxNodesWithDelta:(NSTimeInterval)dt {
    [self.worldNode enumerateChildNodesWithName:@"parallaxNode" usingBlock:^(SKNode *node, BOOL *stop) {
        [(SSKParallaxNode*)node update:dt];
    }];
}

#pragma mark - World Zoom
- (void)updateWorldZoom {
    if ([self playerIsAboveTopBoundary]) {
        CGFloat newScale = 1 - ([self percentageOfMaxScaleWithRatio:[self topZoomRatio]]);
        [self.worldNode setScale:newScale];
        [self.worldNode setPosition:CGPointMake([self amountToOffsetTop].dx, [self amountToOffsetTop].dy)];
    }
    
    else if ([self playerIsBelowBottomBoundary]) {
        CGFloat newScale = 1 - ([self percentageOfMaxScaleWithRatio:[self bottomZoomRatio]]);
        [self.worldNode setScale:newScale];
        [self.worldNode setPosition:CGPointMake([self amountToOffsetBottom].dx, [self amountToOffsetBottom].dy)];
    }
    
    else {
        [self resetWorldZoom];
    }
}

- (void)resetWorldZoom {
    [self.worldNode setScale:1];
    [self.worldNode setPosition:CGPointZero];
}

- (CGVector)amountToOffsetTop {
    return CGVectorMake(-([self distanceFromCenterToTopRight].dx * [self percentageOfMaxScaleWithRatio:[self topZoomRatio]]),
                        -([self distanceFromCenterToTopRight].dy * [self percentageOfMaxScaleWithRatio:[self topZoomRatio]]));
}

- (CGVector)amountToOffsetBottom {
    return CGVectorMake(-([self distanceFromCenterToTopRight].dx * [self percentageOfMaxScaleWithRatio:[self bottomZoomRatio]]),
                        [self distanceFromCenterToTopRight].dy * [self percentageOfMaxScaleWithRatio:[self bottomZoomRatio]]);
}

- (CGFloat)topZoomRatio {
    CGFloat ratioDistanceFromTop = fabsf(([self currentPlayerDistanceFromTopBoundary]/[self distanceFromBoundaryToMaxZoomBoundary]));
    if (ratioDistanceFromTop > 1) {
        ratioDistanceFromTop = 1;
    }
    return ratioDistanceFromTop;
}

- (CGFloat)bottomZoomRatio {
    CGFloat ratioDistanceFromBottom = fabsf(([self currentPlayerDistanceFromBottomBoundary]/[self distanceFromBoundaryToMaxZoomBoundary]));
    if (ratioDistanceFromBottom > 1) {
        ratioDistanceFromBottom = 1;
    }
    return ratioDistanceFromBottom;
}

- (CGVector)distanceFromCenterToTopRight {
    return SSKDistanceBetweenPoints(CGPointZero, CGPointMake(self.size.width/2, self.size.height/2));
}

- (CGFloat)currentPlayerDistanceFromTopBoundary {
    return ([self currentPlayer].position.y - [self topZoomBoundary]);
}

- (CGFloat)currentPlayerDistanceFromBottomBoundary {
    return ([self currentPlayer].position.y - [self bottomZoomBoundary]);
}

- (CGFloat)distanceFromBoundaryToMaxZoomBoundary {
    return (self.size.height - [self topZoomBoundary]);
}

- (CGFloat)topZoomBoundary {
    return self.size.height/5;
}

- (CGFloat)bottomZoomBoundary {
    return -self.size.height/5;
}

- (CGFloat)percentageOfMaxScaleWithRatio:(CGFloat)ratio {
    return ([self scaleCapInversion] * ratio);
}

- (CGFloat)scaleCapInversion {
    return (1 - kWorldScaleCap);
}

- (CGSize)maxWorldScaleSize {
    return CGSizeMake(self.size.width * (1 + kWorldScaleCap), self.size.height * (1 + kWorldScaleCap));
}

- (CGFloat)backgroundSpriteScale {
    return ((self.size.width/kWorldScaleCap)/self.size.width) + ((self.size.width/2)/kWorldScaleCap)/(self.size.width/2);
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

    sSmallTextures = [SSKGraphicsUtils loadFramesFromSpriteSheetNamed:@"PajamaPenguinsSmallSheet"
                                                       frameSize:CGSizeMake(15, 15)
                                                          origin:CGPointMake(0, 225)
                                                       gridWidth:15
                                                      gridHeight:15];
    
    sLargeTextures = [SSKGraphicsUtils loadFramesFromSpriteSheetNamed:@"PajamaPenguinsLargeSheet"
                                                            frameSize:CGSizeMake(30, 30)
                                                               origin:CGPointMake(0, 280)
                                                            gridWidth:10
                                                           gridHeight:10];
    
    NSLog(@"Scene loaded in %f seconds",[[NSDate date] timeIntervalSinceDate:startTime]);
}

static NSArray *sSmallTextures = nil;
- (NSArray*)sharedSmallTextures {
    return sSmallTextures;
}

static NSArray *sLargeTextures = nil;
- (NSArray*)sharedLargeTextures {
    return sLargeTextures;
}

@end
