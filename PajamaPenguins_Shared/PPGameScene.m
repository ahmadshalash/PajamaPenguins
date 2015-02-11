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
    playerLayer,
    foregroundLayer,
    menuLayer,
}Layers;

CGFloat const kAirGravityStrength = -3;
CGFloat const kWaterGravityStrength = 6;
CGFloat const kEdgePadding = 50;
CGFloat const kWorldScaleCap = 0.80;

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
    self.anchorPoint = CGPointMake(0.5, 0.5);

    [self createWorld];
    [self createMenu];
}

- (void)createWorld {
    self.worldNode = [SKNode node];
    [self.worldNode setName:@"world"];
    [self addChild:self.worldNode];
    
    PPPlayer *player = [[PPPlayer alloc] initWithTexture:[sTextures objectAtIndex:0]
                                              atPosition:CGPointMake(-self.size.width/4, 0)];
    [player setScale:3];
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
    
    SKSpriteNode *boundary = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(water.size.width, water.size.height - kEdgePadding)];
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
    
    SKLabelNode *startLabel = [self createNewLabelWithText:@"Tap to start!" withFontSize:30];
    [startLabel setPosition:CGPointMake(0, -self.size.height/6 * 2)];
    [self.menuNode addChild:startLabel];

    SKSpriteNode *startIcon = [SKSpriteNode spriteNodeWithTexture:[sTextures objectAtIndex:17]];
    [startIcon setScale:5];
    [startIcon setPosition:CGPointMake(startLabel.position.x, startLabel.position.y + startIcon.size.height)];
    [self.menuNode addChild:startIcon];
}

#pragma mark - Initial scene animations
- (void)startSceneAnimations {
}

#pragma mark - Game Start
- (void)prepareGameStart {
    [self runAction:[SKAction fadeOutWithDuration:.5] onNode:[self childNodeWithName:@"menu"]];

    self.gameState = Playing;
}

#pragma mark - Player
- (void)updatePlayer:(NSTimeInterval)dt {
    [(PPPlayer*)[self.worldNode childNodeWithName:@"player"] update:dt];
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
        SKNode *player = [self.worldNode childNodeWithName:@"player"];
        [(PPPlayer*)player setPlayerShouldDive:YES];
    }
}

- (void)interactionEndedAtPosition:(CGPoint)position {
    SKNode *player = [self.worldNode childNodeWithName:@"player"];
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
    [self updateWorldZoom];
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

/* 
 
 @todo NEEDS TO BE DECOUPLED! (Extendable camera class?).
 
 */
- (void)updateWorldZoom {
    SKNode *player = [self.worldNode childNodeWithName:@"player"];
    
    CGFloat topBoundary = self.size.height/4;
    CGFloat bottomBoundary = -topBoundary;
    
    CGFloat maxDistance = self.size.height/2 - topBoundary;
    CGFloat currentDistanceFromTop = SSKSubtractNumbers(player.position.y, topBoundary);
    CGFloat currentDistanceFromBottom = SSKSubtractNumbers(player.position.y, bottomBoundary);

    CGFloat ratio = 0.15;
    CGFloat topRatio = fabsf((currentDistanceFromTop/maxDistance) * ratio);
    CGFloat botRatio = fabsf((currentDistanceFromBottom/maxDistance) * ratio);
    
    CGFloat distance = SSKDistanceBetweenPoints(CGPointZero, CGPointMake(self.size.width/2, self.size.height/2));

    CGFloat amtToMoveTop = distance*topRatio;
    CGFloat amtToMoveBottom = distance*botRatio;
    
    if (player.position.y > topBoundary)
    {
        [self.worldNode setScale:1 - topRatio];
        [self.worldNode setPosition:CGPointMake(-(amtToMoveTop/2), -(amtToMoveTop/2))];
        
        if (self.worldNode.xScale <= kWorldScaleCap) {
            [self.worldNode setScale:kWorldScaleCap];
            [self.worldNode setPosition:CGPointMake(-(distance/2) * (1 - kWorldScaleCap), -(distance/2)*(1 - kWorldScaleCap))];
        }
    }
    
    else if (player.position.y <= bottomBoundary) {
        [self.worldNode setScale:1 - botRatio];
        [self.worldNode setPosition:CGPointMake(-(amtToMoveBottom/2), amtToMoveBottom/2)];
        
        if (self.worldNode.xScale <= kWorldScaleCap) {
            [self.worldNode setScale:kWorldScaleCap];
            [self.worldNode setPosition:CGPointMake(-(distance/2) * (1 - kWorldScaleCap), (distance/2) * (1 - kWorldScaleCap))];
        }
    }
    
    else {
        [self.worldNode setScale:1];
        [self.worldNode setPosition:CGPointZero];
    }
    NSLog(@"%fl %fl",self.worldNode.position.x,self.worldNode.position.y);
}

- (void)updateWorldOffset {
    
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
