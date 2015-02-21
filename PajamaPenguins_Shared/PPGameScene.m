//
//  PPGameScene.m
//
//  Created by Skye Freeman on 1/1/2015.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.

#import "PPGameScene.h"
#import "PPPlayer.h"
#import "PPObstacle.h"
#import "SKColor+SFAdditions.h"
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
CGFloat const kWorldScaleCap = 0.60;
CGFloat const kPlayerUpperVelocityLimit = 700.0;
CGFloat const kPlayerLowerAirVelocityLimit = -700.0;
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

@implementation PPGameScene

- (id)initWithSize:(CGSize)size {
    return [super initWithSize:size];
}

- (void)didMoveToView:(SKView *)view {
    self.backgroundColor = SKColorWithRGB(6, 220, 220);
    self.anchorPoint = CGPointMake(0.5, 0.5);
    
    [self createNewGame];
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
    [player setScale:1.5];
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
    [(PPPlayer*)[self.worldNode childNodeWithName:@"player"] setPlayerShouldDive:YES];
}

- (void)stopPlayerDive {
    [(PPPlayer*)[self.worldNode childNodeWithName:@"player"] setPlayerShouldDive:NO];
}

- (void)clampPlayerVelocity {
    PPPlayer *player = (PPPlayer*)[self.worldNode childNodeWithName:@"player"];
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
- (PPObstacle*)newObstacleAtPoint:(CGPoint)point withWidth:(NSUInteger)width{
    PPObstacle *obstacle = [[PPObstacle alloc] initWithTexturesFromArray:sObstacleTextures textureWidth:15 numHorizontalCells:width];
    [obstacle setPosition:point];
    [obstacle setName:@"obstacle"];
    [obstacle.iceberg.physicsBody setCategoryBitMask:obstacleCategory];
    return obstacle;
}

- (SKNode*)generateNewObstacleWithRandomSize {
    CGFloat randomNum = SSKRandomFloatInRange(1, 15);
    CGPoint spawnPoint = CGPointMake(self.size.width * 1.5, 0);
    return [self newObstacleAtPoint:spawnPoint withWidth:randomNum];
}

#pragma mark - Obstacle Spawn Sequence
- (void)startObstacleSpawnSequence {
    [self runAction:[SKAction fadeOutWithDuration:.5] onNode:[self childNodeWithName:@"menu"]];
    SKAction *wait = [SKAction waitForDuration:2];
    SKAction *spawnFloatMove = [SKAction runBlock:^{
        SKNode *obstacle = [self generateNewObstacleWithRandomSize];
        [self.worldNode addChild:obstacle];
        [obstacle runAction:[SKAction repeatActionForever:[self floatAction]]];
        [obstacle runAction:[SKAction moveToX:-self.size.width duration:6] withKey:@"moveObstacle"];
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
    if (!(self.gameState == GameOver)) {
        [self updatePlayingGravity];
        [self updatePlayer:currentTime];
    }
}

- (void)didEvaluateActions {
    if (!(self.gameState == GameOver)) {
        [self updateWorldZoom];
    }
}

- (void)didSimulatePhysics {
    if (!(self.gameState == GameOver)) {
        [self clampPlayerVelocity];
    }
}

#pragma mark - Updated Per Frame
- (void)updatePlayer:(NSTimeInterval)dt {
    [(PPPlayer*)[self.worldNode childNodeWithName:@"player"] update:dt];
}

- (void)updatePlayingGravity {
    SKNode *player = [self.worldNode childNodeWithName:@"player"];
    SKNode *water = [self.worldNode childNodeWithName:@"water"];
    
    if (player.position.y > water.position.y) {
        [self setGravity:kAirGravityStrength];
    } else {
        [self setGravity:kWaterGravityStrength];
    }
}

- (void)updateWorldZoom {
    SKNode *player = [self.worldNode childNodeWithName:@"player"];
    
    CGFloat topBoundary = self.size.height/4;
    CGFloat bottomBoundary = -topBoundary;
    
    CGFloat maxDistance = self.size.height/2 - topBoundary;
    CGFloat currentDistanceFromTop = SSKSubtractNumbers(player.position.y, topBoundary);
    CGFloat currentDistanceFromBottom = SSKSubtractNumbers(player.position.y, bottomBoundary);

    CGFloat ratio = 0.125;
    CGFloat topRatio = fabsf((currentDistanceFromTop/maxDistance) * ratio);
    CGFloat botRatio = fabsf((currentDistanceFromBottom/maxDistance) * ratio);
    
    CGVector distance = SSKDistanceBetweenPoints(CGPointZero, CGPointMake(self.size.width/2, self.size.height/2));
    
    CGVector amtToMoveTop =  CGVectorMake(distance.dx * topRatio, distance.dy * topRatio);
    CGVector amtToMoveBottom = CGVectorMake(distance.dx * botRatio, distance.dy * botRatio);
    
    if (player.position.y > topBoundary)
    {
        [self.worldNode setScale:1 - topRatio];
        [self.worldNode setPosition:CGPointMake(-(amtToMoveTop.dx), -(amtToMoveTop.dy))];
        
        if (self.worldNode.xScale <= kWorldScaleCap) {
            [self.worldNode setScale:kWorldScaleCap];
            [self.worldNode setPosition:CGPointMake(-(distance.dx) * (1 - kWorldScaleCap), -(distance.dy)*(1 - kWorldScaleCap))];
        }
    }
    
    else if (player.position.y <= bottomBoundary) {
        [self.worldNode setScale:1 - botRatio];
        [self.worldNode setPosition:CGPointMake(-(amtToMoveBottom.dx), amtToMoveBottom.dy)];
        
        if (self.worldNode.xScale <= kWorldScaleCap) {
            [self.worldNode setScale:kWorldScaleCap];
            [self.worldNode setPosition:CGPointMake(-(distance.dx) * (1 - kWorldScaleCap), (distance.dy) * (1 - kWorldScaleCap))];
        }
    }
    
    else {
        [self.worldNode setScale:1];
        [self.worldNode setPosition:CGPointZero];
    }
}

#pragma mark - Managing Assets
+ (void)loadSceneAssets {
    NSDate *startTime = [NSDate date];

    //Shared Textures
    sTextures = [SSKGraphicsUtils loadFramesFromSpriteSheetNamed:@"PajamaPenguinsSpriteSheet"
                                                       frameSize:CGSizeMake(15, 15)
                                                          origin:CGPointMake(0, 225)
                                                       gridWidth:15
                                                      gridHeight:15];
    
    //Obstacle Textures
    NSMutableArray *tempObstacleTextures = [NSMutableArray new];
    for (int i = 15; i < 31; i++) {
        [tempObstacleTextures addObject:[sTextures objectAtIndex:i]];
    }
    sObstacleTextures = [NSArray arrayWithArray:tempObstacleTextures];
    
    NSLog(@"Scene loaded in %f seconds",[[NSDate date] timeIntervalSinceDate:startTime]);
}

static NSArray *sTextures = nil;
- (NSArray*)sharedTextures {
    return sTextures;
}

static NSArray *sObstacleTextures = nil;
- (NSArray*)sharedObstacleTextures {
    return sObstacleTextures;
}

@end
