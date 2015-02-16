//
//  PPGameScene.m
//
//  Created by Skye Freeman on 1/1/2015.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.

#import "PPGameScene.h"
#import "PPPlayer.h"
#import "SSKColor+Additions.h"
#import "SSKCameraNode.h"
#import "SSKButtonNode.h"
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

//Physics Constants
CGFloat const kAirGravityStrength = -3;
CGFloat const kWaterGravityStrength = 6;

//Clamped Constants
CGFloat const kWorldScaleCap = 0.55;
CGFloat const kPlayerUpperVelocityLimit = 650.0;
CGFloat const kPlayerLowerAirVelocityLimit = -600.0;
CGFloat const kPlayerLowerWaterVelocityLimit = -300.0;

@interface PPGameScene()
@property (nonatomic) GameState gameState;

@property (nonatomic) SKNode *worldNode;
@property (nonatomic) SKNode *menuNode;
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
    self.anchorPoint = CGPointMake(0.5, 0.5);

    [self createWorld];
//    [self createMenu];
}

- (void)createWorld {
    self.worldNode = [SSKCameraNode node];
    [self.worldNode setName:@"world"];
    [self addChild:self.worldNode];
    
    PPPlayer *player = [[PPPlayer alloc] initWithTexture:[sTextures objectAtIndex:0]
                                              atPosition:CGPointMake(-self.size.width/4, 0)];
    [player setScale:1];
    [player setName:@"player"];
    [player setZRotation:SSKDegreesToRadians(90)];
    [player setZPosition:playerLayer];
    [self.worldNode addChild:player];
    
    SKSpriteNode *water = [SKSpriteNode spriteNodeWithColor:SSKColorWithRGB(85, 65, 50) size:CGSizeMake(self.size.width * 3, self.size.height * 3)];
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
    [self.worldNode addChild:boundary];
}

- (void)createMenu {
    self.menuNode = [SKNode node];
    [self.menuNode setZPosition:menuLayer];
    [self.menuNode setName:@"menu"];
    [self addChild:self.menuNode];
    
    SKLabelNode *titleLabel = [self createNewLabelWithText:@"Pajama Penguins" withFontSize:50];
    [titleLabel setPosition:CGPointMake(0, self.size.height/6 * 2)];
    [self.menuNode addChild:titleLabel];
    
    SKLabelNode *startLabel = [self createNewLabelWithText:@"Tap to start!" withFontSize:45];
    [startLabel setPosition:CGPointMake(0, -self.size.height/6 * 2)];
    [self.menuNode addChild:startLabel];

    SKSpriteNode *startIcon = [SKSpriteNode spriteNodeWithTexture:[sTextures objectAtIndex:120]];
    [startIcon setScale:5];
    [startIcon setPosition:CGPointMake(startLabel.position.x, startLabel.position.y + startIcon.size.height)];
    [self.menuNode addChild:startIcon];
}

#pragma mark - Initial scene animations
- (void)startSceneAnimations {
}

#pragma mark - Game Start
- (void)prepareGameStart {
    NSLog(@"Prepare Game");
    [self runAction:[SKAction fadeOutWithDuration:.5] onNode:[self childNodeWithName:@"menu"]];
    self.gameState = Playing;
}

#pragma mark - Player
- (void)updatePlayer:(NSTimeInterval)dt {
    [(PPPlayer*)[self.worldNode childNodeWithName:@"player"] update:dt];
}

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
    NSLog(@"player speed: %fl",[self.worldNode childNodeWithName:@"player"].physicsBody.velocity.dy);
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

- (void)runAction:(SKAction*)action onNode:(SKNode*)node {
    [node runAction:action];
}

#pragma mark - Input
- (void)interactionBeganAtPosition:(CGPoint)position {
    if (self.gameState == MainMenu) {
        [self prepareGameStart];
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
    [self updateWorldZoom];
    [self clampPlayerVelocity];
}

- (void)didFinishUpdate {
}

#pragma mark - Updated Per Frame
- (void)updateGravity {
    SKNode *player = [self.worldNode childNodeWithName:@"player"];
    SKNode *water = [self.worldNode childNodeWithName:@"water"];
    
    if (player.position.y > water.position.y) {
        [self.physicsWorld setGravity:CGVectorMake(0, kAirGravityStrength)];
    } else {
        [self.physicsWorld setGravity:CGVectorMake(0, kWaterGravityStrength)];
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
            [self stopPlayerDive];
            
            [self.worldNode setScale:kWorldScaleCap];
            [self.worldNode setPosition:CGPointMake(-(distance.dx) * (1 - kWorldScaleCap), -(distance.dy)*(1 - kWorldScaleCap))];
        }
    }
    
    else if (player.position.y <= bottomBoundary) {
        [self.worldNode setScale:1 - botRatio];
        [self.worldNode setPosition:CGPointMake(-(amtToMoveBottom.dx), amtToMoveBottom.dy)];
        
        if (self.worldNode.xScale <= kWorldScaleCap) {
            [self stopPlayerDive];
            
            [self.worldNode setScale:kWorldScaleCap];
            [self.worldNode setPosition:CGPointMake(-(distance.dx) * (1 - kWorldScaleCap), (distance.dy) * (1 - kWorldScaleCap))];
        }
    }
    
    else {
        [self.worldNode setScale:1];
        [self.worldNode setPosition:CGPointZero];
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
