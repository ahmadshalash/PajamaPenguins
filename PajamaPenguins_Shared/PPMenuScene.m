//
//  PPMenuScene.m
//  PajamaPenguins
//
//  Created by Skye on 3/5/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPMenuScene.h"
#import "PPGameScene.h"
#import "PPSharedAssets.h"
#import "PPPlayer.h"

#import "SSKUtils.h"

#import "SKColor+SFAdditions.h"
#import "SKTexture+SFAdditions.h"
#import "UIDevice+SFAdditions.h"

#import "SSKButtonNode.h"
#import "SSKGraphicsUtils.h"
#import "SSKWaterSurfaceNode.h"
#import "SSKDynamicColorNode.h"

typedef NS_ENUM(NSUInteger, SceneLayer) {
    SceneLayerBackground = 0,
    SceneLayerForeground,
    SceneLayerMenu,
};

CGFloat const kPlatformPadding = 50.0;

@interface PPMenuScene()
@property (nonatomic) SKNode *menuBackgroundNode;
@property (nonatomic) SKNode *menuNode;
@end

@implementation PPMenuScene

- (instancetype)initWithSize:(CGSize)size {
    return [super initWithSize:size];
}

- (void)didMoveToView:(SKView *)view {
    [self createSceneBackground];
    [self createMenu];
    [self startAnimations];
    
    [self testStuff];
}

- (void)testStuff {
}

#pragma mark - Scene Construction
- (void)createSceneBackground {
    [self.scene setBackgroundColor:[SKColor skyColor]];
    
    self.menuBackgroundNode = [SKNode node];
    [self.menuBackgroundNode setZPosition:SceneLayerBackground];
    [self.menuBackgroundNode setName:@"menuBackground"];
    [self addChild:self.menuBackgroundNode];
    
//    [self.menuBackgroundNode addChild:[self newColorBackground]];
    [self.menuBackgroundNode addChild:[self skyBackground]];
    [self.menuBackgroundNode addChild:[self newSnowEmitter]];
    
    SKNode *platformNode = [SKNode new];
    [platformNode setName:@"platform"];
    [self.menuBackgroundNode addChild:platformNode];
    
    [platformNode addChild:[self newPlatformIceberg]];
    [platformNode addChild:[self blackPenguin]];
    
    [self.menuBackgroundNode addChild:[self newWaterSurface]];
}

- (void)createMenu {
    self.menuNode = [SKNode node];
    [self.menuNode setZPosition:SceneLayerMenu];
    [self.menuNode setName:@"menu"];
    [self addChild:self.menuNode];
    
    SKLabelNode *titleLabel = [self newTitleLabel];
    [titleLabel setPosition:CGPointMake(0, self.size.height/2 + titleLabel.frame.size.height)]; //For animation
    [self.menuNode addChild:titleLabel];
    
    SSKButtonNode *playButton = [self playButton];
    [playButton setPosition:CGPointMake(0, -self.size.height/2 - playButton.size.height)];      //For animation
    [self.menuNode addChild:playButton];
}

- (void)startAnimations {
    //Water waves
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[[self waterSurfaceSplash],[SKAction waitForDuration:.5]]]]];
    
    //Pause to prevent frame skip
    [self runAction:[SKAction waitForDuration:.5] completion:^{

        //Iceberg float
        [[self.menuBackgroundNode childNodeWithName:@"platform"] runAction:[SKAction repeatActionForever:[self floatAction]]];
        
        //Button move in
        [[self.menuNode childNodeWithName:@"playButton"] runAction:[SKAction moveTo:CGPointMake(0, -self.size.height/4) duration:.75 timingMode:SKActionTimingEaseOut]];
        
        //Title move in
        [[self.menuNode childNodeWithName:@"titleLabel"] runAction:[SKAction moveTo:CGPointMake(0, self.size.height/8 * 3) duration:.75 timingMode:SKActionTimingEaseOut]];
    }];
}

#pragma mark - Nodes
- (SSKWaterSurfaceNode*)newWaterSurface {
    CGFloat surfacePadding = 5;
    CGPoint surfaceStart = CGPointMake(-self.size.width/2 - surfacePadding, 0);
    CGPoint surfaceEnd = CGPointMake(self.size.width/2 + surfacePadding, 0);
    CGSize waterSize = CGSizeMake(self.size.width, self.size.height/2);
    SSKWaterSurfaceNode *waterSurface = [SSKWaterSurfaceNode surfaceWithStartPoint:surfaceStart
                                                                          endPoint:surfaceEnd
                                                                             depth:waterSize.height
                                                                           texture:[SKTexture textureWithGradientOfSize:waterSize startColor:[SKColor blueColor] endColor:[SKColor redColor] direction:GradientDirectionDiagonalRight]];
//    SSKWaterSurfaceNode *waterSurface = [SSKWaterSurfaceNode surfaceWithStartPoint:surfaceStart endPoint:surfaceEnd jointWidth:5];
    [waterSurface setAlpha:0.9];
    [waterSurface setZPosition:SceneLayerForeground];
    [waterSurface setName:@"waterSurface"];
//    [waterSurface setBodyWithDepth:self.size.height/2];
//    [waterSurface setTexture:[PPSharedAssets sharedWaterGradient]];
    [waterSurface setSplashDamping:.003];
    [waterSurface setSplashTension:.0025];
    return waterSurface;
}

- (SKSpriteNode*)skyBackground {
    SKSpriteNode *sky = [SKSpriteNode spriteNodeWithTexture:[PPSharedAssets sharedSkyGradient]];
    [sky setAnchorPoint:CGPointMake(0.5, 0)];
    return sky;
}

- (SSKDynamicColorNode*)newColorBackground {
    SSKDynamicColorNode *colorBackground = [SSKDynamicColorNode nodeWithRed:125 green:255 blue:255 size:self.size];
    [colorBackground startCrossfadeForeverWithMax:255 min:125 interval:10];
    [colorBackground setName:@"colorBackground"];
    return colorBackground;
}

- (SKSpriteNode*)newPlatformIceberg {
    SKSpriteNode *platform = [SKSpriteNode spriteNodeWithTexture:[PPSharedAssets sharedIcebergTexture]];
    [platform setName:@"platformIceberg"];
    [platform setAnchorPoint:CGPointMake(0.5, 1)];
    [platform setPosition:CGPointMake(0, kPlatformPadding)];
    return platform;
}

- (SKLabelNode*)newTitleLabel {
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"AmericanTypewriter"];
    [label setText:@"Pajama Penguins"];
    [label setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
    [label setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    [label setFontSize:30];
    [label setFontColor:[SKColor whiteColor]];
    [label setPosition:CGPointMake(0, self.size.height/8 * 3)];
    [label setName:@"titleLabel"];
    return label;
}

- (SKEmitterNode*)newSnowEmitter {
    SKEmitterNode *snowEmitter = [PPSharedAssets sharedSnowEmitter].copy;
    [snowEmitter setPosition:CGPointMake(self.size.width/2, self.size.height/2)];
    [snowEmitter setName:@"snowEmitter"];
    return snowEmitter;
}

- (SSKButtonNode*)playButton {
    SSKButtonNode *playButton = [SSKButtonNode buttonWithIdleTexture:[PPSharedAssets sharedPlayButtonUpTexture] selectedTexture:[PPSharedAssets sharedPlayButtonDownTexture]];
    [playButton setTouchUpInsideTarget:self selector:@selector(loadGameScene)];
    [playButton setName:@"playButton"];
    return playButton;
}

#pragma mark - Penguins Types
- (PPPlayer*)penguinWithType:(PlayerType)type atlas:(SKTextureAtlas*)atlas {
    PPPlayer *penguin = [PPPlayer playerWithType:type atlas:atlas];
    [penguin setSize:[self playerSize]];
    [penguin setAnchorPoint:CGPointMake(0.5, 0)];
    [penguin setPosition:CGPointMake(0, kPlatformPadding/2)];
    [penguin setPlayerState:PlayerStateIdle];
    [penguin setName:@"penguin"];
    return penguin;
}

- (PPPlayer*)blackPenguin {
    return [self penguinWithType:PlayerTypeBlack atlas:[PPSharedAssets sharedPenguinBlackTextures]];
}

- (void)updateAllPenguins:(NSTimeInterval)dt {
    [self enumerateChildNodesWithName:@"//penguin" usingBlock:^(SKNode *node, BOOL *stop) {
        PPPlayer *penguin = (PPPlayer*)node;
        [penguin update:dt];
    }];
}

#pragma mark - Actions
- (SKAction*)floatAction {
    SKAction *up = [SKAction moveByX:0 y:20 duration:3];
    [up setTimingMode:SKActionTimingEaseInEaseOut];
    SKAction *down = [up reversedAction];
    return [SKAction sequence:@[up,down]];
}

- (SKAction*)waterSurfaceSplash {
    return [SKAction runBlock:^{
        [(SSKWaterSurfaceNode*)[self.menuBackgroundNode childNodeWithName:@"waterSurface"] splash:CGPointMake(self.size.width/2, 0) speed:-5];
        [(SSKWaterSurfaceNode*)[self.menuBackgroundNode childNodeWithName:@"waterSurface"] splash:CGPointMake(-self.size.width/2, 0) speed:-5];
    }];
}

#pragma mark - Update
- (void)update:(NSTimeInterval)currentTime {
    [(SSKWaterSurfaceNode*)[self.menuBackgroundNode childNodeWithName:@"waterSurface"] update:currentTime];
    [self updateAllPenguins:currentTime];
}

#pragma mark - Transfer To Game Scene
- (void)loadGameScene {
    [PPGameScene loadSceneAssetsWithCompletionHandler:^{
        SKScene *gameScene = [PPGameScene sceneWithSize:self.size];
        SKTransition *fade = [SKTransition fadeWithColor:[SKColor whiteColor] duration:1];
        [self.view presentScene:gameScene transition:fade];
    }];
}

#pragma mark - Device Sprite Sizing
- (CGSize)playerSize {
    if ([UIDevice isUserInterfaceIdiomPhone]) {
        return CGSizeMake(50, 50);
    }
    else if ([UIDevice isUserInterfaceIdiomPad]) {
        return CGSizeMake(120, 120);
    }
    
    return CGSizeMake(50, 50);
}

@end
