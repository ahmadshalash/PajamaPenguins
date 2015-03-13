//
//  PPGameScene.m
//
//  Created by Skye Freeman on 1/1/2015.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.

#import "PPGameScene.h"
#import "PPMenuScene.h"
#import "PPSharedAssets.h"
#import "PPPlayer.h"
#import "PPIcebergObstacle.h"

#import "SKColor+SFAdditions.h"
#import "SKNode+SFAdditions.h"
#import "SKScene+SFAdditions.h"
#import "SKAction+SFAdditions.h"

#import "SSKProgressBarNode.h"
#import "SSKWaterSurfaceNode.h"
#import "SSKDynamicColorNode.h"
#import "SSKColorNode.h"
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
    backgroundLayer,
    parallaxLayer,
    obstacleLayer,
    playerLayer,
    foregroundLayer,
    waterSurfaceLayer,
    hudLayer,
    menuLayer,
    fadeOutLayer,
}Layers;

//Texture Constants
CGFloat const kLargeTileWidth = 30.0;
CGFloat const kSmallTileWidth = 15.0;
CGFloat const kBackgroundAlpha = 0.55;

//Physics Constants
static const uint32_t playerCategory   = 0x1 << 0;
static const uint32_t obstacleCategory = 0x1 << 1;
static const uint32_t edgeCategory     = 0x1 << 2;

CGFloat const kAirGravityStrength = -2.75;
CGFloat const kWaterGravityStrength = 6;
CGFloat const kGameOverGravityStrength = -9.8;

CGFloat const kObstacleSplashStrength = 10;
CGFloat const kMaxSplashStrength = 20;

//Clamped Constants
//CGFloat const kMaxBreathTimer = 6.0;
CGFloat const kMaxBreathTimer = 96.0;

CGFloat const kWorldScaleCap = 0.55;

CGFloat const kPlayerUpperVelocityLimit = 700.0;
CGFloat const kPlayerLowerAirVelocityLimit = -700.0;
CGFloat const kPlayerLowerWaterVelocityLimit = -550.0;

//Name Constants
NSString * const kPixelFontName = @"Fipps-Regular";

//Action Constants
CGFloat const kMoveAndFadeTime = 0.2;
CGFloat const kMoveAndFadeDistance = 20;

//Parallax Constants
CGFloat const kParallaxMinSpeed = -20.0;

@interface PPGameScene()
@property (nonatomic) GameState gameState;
@property (nonatomic) SSKDynamicColorNode *blendBackground;
@property (nonatomic) SSKWaterSurfaceNode *waterSurface;
@property (nonatomic) NSMutableArray *obstacleTexturePool;
@property (nonatomic) SKEmitterNode *snowEmitter;
@property (nonatomic) SKNode *worldNode;
@property (nonatomic) SKNode *menuNode;
@property (nonatomic) SKNode *hudNode;
@property (nonatomic) SKNode *gameOverNode;
@end

@implementation PPGameScene {
    NSTimeInterval _lastUpdateTime;
    CGFloat _lastPlayerHeight;
    CGFloat _breathTimer;
    
    CGFloat _playerBubbleBirthrate;
}

- (instancetype)initWithSize:(CGSize)size {
    return [super initWithSize:size];
}

- (void)didMoveToView:(SKView *)view {
    NSLog(@"Screen Size: %fl,%fl",self.size.width, self.size.height);
    [self createNewGame];
    [self testStuff];
}

#pragma mark - Test Stuff
- (void)testStuff {
}

#pragma mark - Creating scene layers
- (void)createNewGame {
    [self createWorldLayer];
    [self startGameAnimations];
    [self gameMenu];
}

- (void)createWorldLayer {
    self.worldNode = [SSKCameraNode node];
    [self.worldNode setName:@"world"];
    [self addChild:self.worldNode];
    
    //Color blend background
    self.blendBackground = [SSKDynamicColorNode nodeWithRed:125 green:255 blue:255 size:self.size];
    [self.blendBackground setZPosition:backgroundLayer];
    [self addChild:self.blendBackground];
    
    //Parallaxing Nodes
    CGPoint cloudBottomPos = CGPointMake(0, self.size.height/8 * 6);
    CGPoint cloudMiddlePos = CGPointMake(0, cloudBottomPos.y + [PPSharedAssets sharedCloudBackgroundMiddleTexture].size.height/3);
    CGPoint cloudUpperPos = CGPointMake(0, cloudMiddlePos.y + [PPSharedAssets sharedCloudBackgroundUpperTexture].size.height/3);
    CGPoint cloudForegroundPos = CGPointMake(0, cloudUpperPos.y + [PPSharedAssets sharedCloudForegroundTexture].size.height/3);
    
    SSKParallaxNode *backgroundSlow = [self backgroundLayerWithSpeed:kParallaxMinSpeed position:cloudBottomPos texture:[PPSharedAssets sharedCloudBackgroundLowerTexture]];
    [backgroundSlow setAlpha:.6];
    [self.worldNode addChild:backgroundSlow];
    
    SSKParallaxNode *backgroundMedium = [self backgroundLayerWithSpeed:kParallaxMinSpeed*2 position:cloudMiddlePos texture:[PPSharedAssets sharedCloudBackgroundMiddleTexture]];
    [self.worldNode addChild:backgroundMedium];
    
    SSKParallaxNode *backgroundFast = [self backgroundLayerWithSpeed:kParallaxMinSpeed*3 position:cloudUpperPos texture:[PPSharedAssets sharedCloudBackgroundUpperTexture]];
    [backgroundFast setAlpha:.7];
    [self.worldNode addChild:backgroundFast];
    
    SSKParallaxNode *foreground = [self backgroundLayerWithSpeed:kParallaxMinSpeed*4 position:cloudForegroundPos texture:[PPSharedAssets sharedCloudForegroundTexture]];
    [foreground setAlpha:.95];
    [foreground setZPosition:foregroundLayer];
    [self.worldNode addChild:foreground];

    //Snow Emitter
    self.snowEmitter = [PPSharedAssets sharedSnowEmitter].copy;
    [self.snowEmitter setZPosition:foregroundLayer];
    [self.snowEmitter setPosition:CGPointMake(self.size.width/2, cloudForegroundPos.y)];
    [self.snowEmitter setName:@"snowEmitter"];
    [self.worldNode addChild:self.snowEmitter];
    
    //Water Surface
    CGPoint surfaceStart = CGPointMake(-self.size.width/2, 0);
    CGPoint surfaceEnd = CGPointMake(self.size.width/kWorldScaleCap, 0);
    
    self.waterSurface = [SSKWaterSurfaceNode surfaceWithStartPoint:surfaceStart endPoint:surfaceEnd jointWidth:5];
    [self.waterSurface setName:@"water"];
    [self.waterSurface setAlpha:.8];
    [self.waterSurface setZPosition:waterSurfaceLayer];
    [self.waterSurface setBodyWithDepth:(self.size.height)/kWorldScaleCap];
    [self.waterSurface setTexture:[PPSharedAssets sharedWaterGradient]];
    [self.waterSurface setSplashDamping:.05];
    [self.waterSurface setSplashTension:.005];
    [self.worldNode addChild:self.waterSurface];

    //Player
    PPPlayer *player = [PPPlayer playerWithIdleTextures:[PPSharedAssets sharedPenguinGreyIdleFrames]
                                           swimTextures:[PPSharedAssets sharedPenguinGreySwimFrames]
                                            flyTextures:[PPSharedAssets sharedPenguinGreyFlyFrames]];
    [player setPosition:CGPointMake(-self.size.width/4, 50)];
    [player setName:@"player"];
    [player setZRotation:SSKDegreesToRadians(90)];
    [player setZPosition:playerLayer];
    [player.physicsBody setCategoryBitMask:playerCategory];
    [player.physicsBody setCollisionBitMask:obstacleCategory | edgeCategory];
    [player.physicsBody setContactTestBitMask:obstacleCategory];
    [player setPlayerShouldRotate:YES];
    [player setPlayerState:PlayerStateFly];
    [self.worldNode addChild:player];
    
    //Setting Players initial position height (for water surface tracking)
    _lastPlayerHeight = player.position.y;
    
    //Player's bubble emitter
    SKEmitterNode *playerBubbleEmitter = [PPSharedAssets sharedBubbleEmitter].copy;
    [playerBubbleEmitter setName:@"bubbleEmitter"];
    [playerBubbleEmitter setZPosition:waterSurfaceLayer];
    [self.worldNode addChild:playerBubbleEmitter];
    
    _playerBubbleBirthrate = playerBubbleEmitter.particleBirthRate; //To reset the simulation
    
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

    SKSpriteNode *startFinger = [SKSpriteNode spriteNodeWithTexture:[PPSharedAssets sharedFingerSprite]];
    [startFinger setPosition:CGPointMake(0, -self.size.height/3)];
    [startFinger setName:@"finger"];
    [self.menuNode addChild:startFinger];
    
    SKSpriteNode *startFingerEffect = [SKSpriteNode spriteNodeWithTexture:[PPSharedAssets sharedFingerSpriteEffect]];
    [startFingerEffect setPosition:CGPointMake(startFinger.position.x - startFinger.size.width/8,
                                               startFinger.position.y + startFingerEffect.size.height * 1.5)];
    [startFingerEffect setAlpha:0];
    [startFingerEffect setName:@"fingerEffect"];
    [self.menuNode addChild:startFingerEffect];
}

- (void)createHudLayer {
    self.hudNode = [SKNode new];
    [self.hudNode setZPosition:hudLayer];
    [self.hudNode setName:@"hud"];
    [self.hudNode setAlpha:0];
    [self addChild:self.hudNode];
    
    SSKScoreNode *scoreCounter = [SSKScoreNode scoreNodeWithFontNamed:kPixelFontName fontSize:12 fontColor:[SKColor blackColor]];
    [scoreCounter setName:@"scoreCounter"];
    [scoreCounter setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeLeft];
    [scoreCounter setVerticalAlignmentMode:SKLabelVerticalAlignmentModeTop];
    [scoreCounter setPosition:CGPointMake(-self.size.width/2 + 5, self.size.height/2 - 5)];
    [self.hudNode addChild:scoreCounter];
    
    SSKProgressBarNode *breathMeter = [[SSKProgressBarNode alloc] initWithFrameColor:[SKColor blackColor] barColor:[SKColor redColor] size:CGSizeMake(150, 20)];
    [breathMeter setName:@"progressBar"];
    [breathMeter setPosition:CGPointMake(0, self.size.height/2 - 20)];
    [self.hudNode addChild:breathMeter];
    
    [self.hudNode setPosition:CGPointMake(-kMoveAndFadeDistance, 0)];
    [self.hudNode runAction:[SKAction moveDistance:CGVectorMake(kMoveAndFadeDistance, 0) fadeInWithDuration:kMoveAndFadeTime]];
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
    
    SSKButtonNode *menuButton = [[SSKButtonNode alloc] initWithIdleTexture:[PPSharedAssets sharedHomeButtonUpTexture] selectedTexture:[PPSharedAssets sharedHomeButtonDownTexture]];
    [menuButton setPosition:CGPointMake(0, -self.size.height/4)];
    [menuButton setTouchUpInsideTarget:self selector:@selector(loadMenuScene)];
    [self.gameOverNode addChild:menuButton];
    
    [self.gameOverNode setPosition:CGPointMake(-kMoveAndFadeDistance, 0)];
    [self.gameOverNode runAction:[SKAction moveDistance:CGVectorMake(kMoveAndFadeDistance, 0) fadeInWithDuration:kMoveAndFadeTime]];
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
    
    [self resetBreathTimer];
    [self createHudLayer];

    [self populateObstacleTexturePool];
    [self startObstacleSpawnSequence];
    [self startSplashAtObstaclesForever];
    
    [self startScoreCounter];
}

- (void)startGameAnimations {
    [self runAction:[SKAction waitForDuration:.5] completion:^{
        [self.blendBackground startCrossfadeForeverWithMax:255 min:125 interval:5];
    }];
}

#pragma mark - GameState GameOver
- (void)gameEnd {
    self.gameState = GameOver;
    
    [self stopScoreCounter];
    [self stopObstacleSpawnSequence];
    [self stopObstacleMovement];
    [self stopObstacleSplash];
    
    [self runGameOverSequence];
}

- (void)runGameOverSequence {
    [self.blendBackground stopCrossfadeForever];
    [self setGravity:kGameOverGravityStrength];
    [self fadeoutHUD];
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

#pragma mark - Hud
- (void)fadeoutHUD {
    if (self.hudNode) {
        [self.hudNode runAction:[SKAction moveDistance:CGVectorMake(kMoveAndFadeDistance, 0) fadeOutWithDuration:kMoveAndFadeTime]];
    }
}

#pragma mark - Breath Meter
//Meter
- (void)updateBreathMeter {
    [(SSKProgressBarNode*)[self.hudNode childNodeWithName:@"progressBar"] setProgress:_breathTimer/kMaxBreathTimer];
}

- (void)checkBreathMeterForGameOver {
    if ([(SSKProgressBarNode*)[self.hudNode childNodeWithName:@"progressBar"] currentProgress] == 0.0) {
        [self gameEnd];
    }
}

//Timer
- (void)resetBreathTimer {
    _breathTimer = kMaxBreathTimer;
}

- (void)updateBreathTimer:(NSTimeInterval)dt {
    if ([self currentPlayer].position.y < [self.worldNode childNodeWithName:@"water"].position.y) {
        _breathTimer -= dt;
    } else {
        _breathTimer += dt;
    }
    
    if (_breathTimer < 0.0) {
        _breathTimer = 0.0;
    }
    else if (_breathTimer > kMaxBreathTimer) {
        _breathTimer = kMaxBreathTimer;
    }
}

#pragma mark - Player
- (void)clampPlayerVelocity {
    PPPlayer *player = [self currentPlayer];
    
    if (player.physicsBody.velocity.dy >= kPlayerUpperVelocityLimit) {
        [player.physicsBody setVelocity:CGVectorMake(player.physicsBody.velocity.dx, kPlayerUpperVelocityLimit)];
    }
    
    if (player.position.y > [self.worldNode childNodeWithName:@"water"].position.y) {
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
    [player.physicsBody applyImpulse:CGVectorMake(5, 50)];
    [player.physicsBody applyAngularImpulse:-.005];
}

- (void)updatePlayer:(NSTimeInterval)dt {
    [self checkPlayerAnimationState];

    [[self currentPlayer] update:dt];
    [self clampPlayerVelocity];
}

- (void)checkPlayerAnimationState {
    if ([self currentPlayer].position.y < self.waterSurface.position.y) {
        [[self currentPlayer] setPlayerState:PlayerStateSwim];
    } else {
        [[self currentPlayer] setPlayerState:PlayerStateFly];
    }
}

#pragma mark - Water Background
- (SKSpriteNode*)waterBackgroundNode {
    SKSpriteNode *waterBackground = [SKSpriteNode spriteNodeWithTexture:[SKTexture loadPixelTextureWithName:@"WaterBackground"]];
    [waterBackground setScale:[self backgroundSpriteScale]];
    [waterBackground setAnchorPoint:CGPointMake(0, 1)];
    [waterBackground setAlpha:0.65];
    return waterBackground;
}

#pragma mark - Water Surface
- (void)trackPlayerForSplash {
    CGFloat newPlayerHeight = [self currentPlayer].position.y;
    
    //Cross surface from bottom
    if (_lastPlayerHeight < 0 && newPlayerHeight > 0) {
        CGFloat splashRatio = [self currentPlayer].physicsBody.velocity.dy / kPlayerUpperVelocityLimit;
        CGFloat splashStrength = kMaxSplashStrength * splashRatio;
        
        [self.waterSurface splash:[self currentPlayer].position speed:splashStrength];
        [self runOneShotEmitter:[PPSharedAssets sharedPlayerSplashUpEmitter] location:[self currentPlayer].position];
        
        _lastPlayerHeight = newPlayerHeight;
    }
    //Cross surface from top
    else if (_lastPlayerHeight > 0 && newPlayerHeight < 0) {
        CGFloat splashRatio = [self currentPlayer].physicsBody.velocity.dy / kPlayerLowerAirVelocityLimit;
        CGFloat splashStrength = kMaxSplashStrength * splashRatio;
        
        [self.waterSurface splash:[self currentPlayer].position speed:-splashStrength];
        [self runOneShotEmitter:[PPSharedAssets sharedPlayerSplashDownEmitter] location:[self currentPlayer].position];
        
        _lastPlayerHeight = newPlayerHeight;
    }
}

- (void)startSplashAtObstaclesForever {
    if ([self actionForKey:@"obstacleSplash"]) {
        NSLog(@"An action with name obstacleSplash is already active");
        return;
    }
    
    SKAction *splashBlock = [SKAction runBlock:^{
        [self.worldNode enumerateChildNodesWithName:@"obstacle" usingBlock:^(SKNode *node, BOOL *stop) {
            PPIcebergObstacle *obstacle = (PPIcebergObstacle*)node;
            CGPoint splashLocation = CGPointMake(obstacle.position.x - obstacle.frame.size.width/2, obstacle.position.y);
            
            [self.waterSurface splash:splashLocation speed:kObstacleSplashStrength];
            [self runOneShotEmitter:[PPSharedAssets sharedObstacleSplashEmitter] location:CGPointMake(splashLocation.x, splashLocation.y + 30)];
        }];
    }];
    
    SKAction *wait = [SKAction waitForDuration:.4];
    SKAction *sequence = [SKAction sequence:@[wait,splashBlock]];
    [self runAction:[SKAction repeatActionForever:sequence] withKey:@"obstacleSplash"];
    
}

- (void)stopObstacleSplash {
    [self removeActionForKey:@"obstacleSplash"];
}

- (void)trackPlayerForBubbles {
    if ([self playerIsBelowBottomBoundary]) {
        [[self playerBubbleEmitter] setPosition:[self currentPlayer].position];

        if ([self playerBubbleEmitter].particleBirthRate == 0) {
            [[self playerBubbleEmitter] resetSimulation];
            [[self playerBubbleEmitter] setParticleBirthRate:_playerBubbleBirthrate];
        }
    } else {
        [[self playerBubbleEmitter] setParticleBirthRate:0];
    }
}


#pragma mark - Emitters
- (void)runOneShotEmitter:(SKEmitterNode*)emitter location:(CGPoint)location {
    SKEmitterNode *splashEmitter = emitter.copy;
    [splashEmitter setPosition:location];
    [splashEmitter setZPosition:waterSurfaceLayer];
    [self.worldNode addChild:splashEmitter];
    [SSKGraphicsUtils runOneShotActionWithEmitter:splashEmitter duration:0.15];
}

- (SKEmitterNode*)playerBubbleEmitter {
    return (SKEmitterNode*)[self.worldNode childNodeWithName:@"bubbleEmitter"];
}

- (void)trackCloudForSnowPosition {
    
}

#pragma mark - Obstacles

//TEMP ***
- (PPIcebergObstacle*)newIcebergWithSize:(CGSize)size {
    PPIcebergObstacle *obstacle = [[PPIcebergObstacle alloc] initWithSize:size];
    [obstacle setName:@"obstacle"];
    [obstacle setZPosition:obstacleLayer];
    [obstacle.physicsBody setCategoryBitMask:obstacleCategory];
    return obstacle;
}

- (SKNode*)newObstacle {
    PPIcebergObstacle *newObstacle = [self newIcebergWithSize:CGSizeMake(100, 100)];
    [newObstacle setPosition:CGPointMake((self.size.width/kWorldScaleCap) + newObstacle.size.width/2, 0)];
    return newObstacle;
}


//TEMP ***

- (PPIcebergObstacle*)newIceBergWithTexture:(SKTexture*)texture {
    PPIcebergObstacle *obstacle = [PPIcebergObstacle spriteNodeWithTexture:texture];
    [obstacle setName:@"obstacle"];
    [obstacle setZPosition:obstacleLayer];
    [obstacle.physicsBody setCategoryBitMask:obstacleCategory];
    return obstacle;
}

- (SKNode*)generateNewRandomObstacle {
    CGFloat randomNum = SSKRandomFloatInRange(0, self.obstacleTexturePool.count);
    SKTexture *randomTexture = [self.obstacleTexturePool objectAtIndex:randomNum];
    
    PPIcebergObstacle *newIceberg = [self newIceBergWithTexture:randomTexture];
    [newIceberg setPosition:CGPointMake((self.size.width/kWorldScaleCap) + newIceberg.size.width/2, 0)];
    return newIceberg;
}

- (void)populateObstacleTexturePool {
    self.obstacleTexturePool = nil;
    self.obstacleTexturePool = [NSMutableArray new];
    
    [self.obstacleTexturePool addObject:[PPSharedAssets sharedObstacleMediumTexture]];
    [self.obstacleTexturePool addObject:[PPSharedAssets sharedObstacleLargeTexture]];
}

#pragma mark - Obstacle Spawn Sequence
- (void)startObstacleSpawnSequence {
    SKAction *wait = [SKAction waitForDuration:1.5];
    SKAction *spawnFloatMove = [SKAction runBlock:^{
//        SKNode *obstacle = [self generateNewRandomObstacle];
        SKNode *obstacle = [self newObstacle];
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

- (void)updateGravity {
    if ([self currentPlayer].position.y > [self.worldNode childNodeWithName:@"water"].position.y) {
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

#pragma mark - Scene Transfer
- (void)loadMenuScene {
    [PPMenuScene loadSceneAssetsWithCompletionHandler:^{
        SKScene *menuScene = [PPMenuScene sceneWithSize:self.size];
        SKTransition *fade = [SKTransition fadeWithColor:[SKColor whiteColor] duration:1];
        [self.view presentScene:menuScene transition:fade];
    }];
}

#pragma mark - Scene Processing
- (void)update:(NSTimeInterval)currentTime {
    NSTimeInterval deltaTime = currentTime - _lastUpdateTime;
    _lastUpdateTime = currentTime;
    
    if (deltaTime > 1) {
        deltaTime = 0;
    }
    
    if (self.gameState == MainMenu || self.gameState == Playing) {
        [self updatePlayer:deltaTime];
        [self updateGravity];
    }
    
    if (self.gameState == Playing) {
        [self updateBreathTimer:deltaTime];
        [self updateBreathMeter];
        [self checkBreathMeterForGameOver];
    }

    //Background
    [self updateParallaxNodesWithDelta:deltaTime];
    
    //Water surface
    [self trackPlayerForSplash];
    [self.waterSurface update:deltaTime];
    
    //Bubbles
    [self trackPlayerForBubbles];
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
- (SSKParallaxNode*)backgroundLayerWithSpeed:(CGFloat)speed position:(CGPoint)position texture:(SKTexture*)texture {
    NSMutableArray *parallaxNodes = [NSMutableArray new];

    SKSpriteNode *layer = [SKSpriteNode spriteNodeWithTexture:texture];
    [layer setPosition:position];
    [layer setAnchorPoint:CGPointMake(0.5, 0)];
    [parallaxNodes addObject:layer];
    
    SSKParallaxNode *parallaxLayer = [SSKParallaxNode nodeWithSize:self.scene.size attachedNodes:parallaxNodes moveSpeed:CGPointMake(speed, 0) numFrames:3];
    [parallaxLayer setName:@"parallaxNode"];
//    [parallaxLayer setAlpha:.9];
    [parallaxLayer setZPosition:backgroundLayer];
    return parallaxLayer;
}

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

@end
