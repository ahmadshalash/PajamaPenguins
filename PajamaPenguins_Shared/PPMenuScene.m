//
//  PPMenuScene.m
//  PajamaPenguins
//
//  Created by Skye on 3/5/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPMenuScene.h"

#import "SSKGraphicsUtils.h"
#import "SSKWaterSurfaceNode.h"
#import "SSKDynamicColorNode.h"

typedef NS_ENUM(NSUInteger, SceneLayer) {
    SceneLayerBackground = 0,
    SceneLayerMenu,
};

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
}

#pragma mark - Scene Construction
- (void)createSceneBackground {
    self.menuBackgroundNode = [SKNode new];
    [self.menuBackgroundNode setZPosition:SceneLayerBackground];
    [self.menuBackgroundNode setName:@"menuBackground"];
    [self addChild:self.menuBackgroundNode];
    
    [self.menuBackgroundNode addChild:[self newColorBackground]];
    [self.menuBackgroundNode addChild:[self newPlatformIceberg]];
    [self.menuBackgroundNode addChild:[self newWaterSurface]];
}

- (void)createMenu {
    self.menuNode = [SKNode node];
    [self.menuNode setZPosition:SceneLayerMenu];
    [self.menuNode setName:@"menu"];
    [self addChild:self.menuNode];
    
    [self.menuNode addChild:[self newLabelNodeWithText:@"Pajama Penguins" position:CGPointMake(0, self.size.height/8 * 3)]];
}

- (void)startAnimations {
    [[self.menuBackgroundNode childNodeWithName:@"platformIceberg"] runAction:[SKAction repeatActionForever:[self floatAction]]];
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[[self waterSurfaceSplash],[SKAction waitForDuration:.5]]]]];
}
#pragma mark - Nodes
- (SSKWaterSurfaceNode*)newWaterSurface {
    CGFloat surfacePadding = 5;
    CGPoint surfaceStart = CGPointMake(-self.size.width/2 - surfacePadding, 0);
    CGPoint surfaceEnd = CGPointMake(self.size.width/2 + surfacePadding, 0);
    SSKWaterSurfaceNode *waterSurface = [SSKWaterSurfaceNode surfaceWithStartPoint:surfaceStart endPoint:surfaceEnd jointWidth:5];
    [waterSurface setAlpha:0.7];
    [waterSurface setName:@"waterSurface"];
    [waterSurface setBodyWithDepth:self.size.height/2 + surfacePadding];
    [waterSurface setTexture:[self sharedWaterGradient]];
    [waterSurface setSplashDamping:.003];
    [waterSurface setSplashTension:.0025];
    return waterSurface;
}

- (SSKDynamicColorNode*)newColorBackground {
    SSKDynamicColorNode *colorBackground = [SSKDynamicColorNode nodeWithRed:125 green:255 blue:255 size:self.size];
    [colorBackground startCrossfadeForeverWithMax:255 min:125 interval:10];
    [colorBackground setName:@"colorBackground"];
    return colorBackground;
}

- (SKSpriteNode*)newPlatformIceberg {
    SKSpriteNode *platform = [SKSpriteNode spriteNodeWithTexture:[self sharedIcebergTexture]];
    [platform setName:@"platformIceberg"];
    [platform setAnchorPoint:CGPointMake(0.5, 1)];
    [platform setPosition:CGPointMake(0, 50)];
    return platform;
}

- (SKLabelNode*)newLabelNodeWithText:(NSString*)text position:(CGPoint)position {
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Fipps-Regular"];
    [label setText:text];
    [label setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
    [label setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    [label setFontSize:20];
    [label setFontColor:[SKColor blackColor]];
    [label setPosition:position];
    return label;
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
}

#pragma mark - Asset Loading
+ (void)loadSceneAssets {
    switch ([[UIDevice currentDevice] userInterfaceIdiom]) {
            
        case UIUserInterfaceIdiomPhone:
            sWaterGradient = [SKTexture textureWithImageNamed:@"WaterGradientBlue-iphone"];
            sIcebergTexture = [SKTexture loadPixelTextureWithName:@"platform_iceberg"];
            break;
            
        case UIUserInterfaceIdiomPad:
            break;
            
        default:
            break;
    }
}

static SKTexture *sWaterGradient = nil;
- (SKTexture*)sharedWaterGradient {
    return sWaterGradient;
}

static SKTexture *sIcebergTexture = nil;
- (SKTexture*)sharedIcebergTexture {
    return sIcebergTexture;
}
@end
