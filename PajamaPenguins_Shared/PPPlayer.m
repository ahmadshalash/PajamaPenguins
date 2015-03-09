//
//  PPPlayer.m
//  PajamaPenguins
//
//  Created by Skye on 2/8/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPPlayer.h"

#define kAccelerationCap 45.0

CGFloat const kAnimationSpeed = .05;

@interface PPPlayer()
@property (nonatomic) CGFloat currentAccelleration;

@property (nonatomic) NSArray *idleTextures;
@property (nonatomic) NSArray *swimTextures;
@property (nonatomic) NSArray *flyTextures;
@end

@implementation PPPlayer
+ (instancetype)playerWithIdleTextures:(NSArray*)idleTextures swimTextures:(NSArray*)swimTextures flyTextures:(NSArray*)flyTextures {
    return [[self alloc] initWithIdleTextures:idleTextures swimTextures:swimTextures flyTextures:flyTextures];
}

- (instancetype)initWithIdleTextures:(NSArray*)idleTextures swimTextures:(NSArray*)swimTextures flyTextures:(NSArray*)flyTextures {
    self = [super initWithTexture:[idleTextures objectAtIndex:0]];
    if (self) {
        self.idleTextures = idleTextures;
        self.swimTextures = swimTextures;
        self.flyTextures = flyTextures;
        
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:[(SKTexture*)[self.idleTextures objectAtIndex:0] size].width/2 - 5];
        [self.physicsBody setDynamic:YES];
        [self.physicsBody setFriction:0];
        [self.physicsBody setRestitution:0];
    }
    return self;
}

//
- (instancetype)initWithFirstTexture:(SKTexture *)firstTexture secondTexture:(SKTexture *)secondTexture {
    self = [super initWithFirstTexture:firstTexture secondTexture:secondTexture];
    if (self) {
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.firstTexture.size.width/2 - 1];
        [self.physicsBody setDynamic:YES];
        [self.physicsBody setFriction:0];
        [self.physicsBody setRestitution:0];
    }
    return self;
}
#pragma mark - Rotation
- (void)setPlayerRotation:(NSTimeInterval)dt {
    CGFloat rotateSpeed = .02 * dt;
    [self setZRotation:(M_PI * self.physicsBody.velocity.dy * rotateSpeed) + SSKDegreesToRadians(90)];
    
    //Clamp rotation
    if (self.zRotation >= SSKDegreesToRadians(30)) {
        [self setZRotation:SSKDegreesToRadians(30)];
    }
    
    if (self.zRotation <= SSKDegreesToRadians(150)) {
        [self setZRotation:SSKDegreesToRadians(150)];
    }
}

#pragma mark - Animation
- (void)runAnimationWithTextures:(NSArray*)textures speed:(CGFloat)speed key:(NSString*)key {
    SKAction *animation = [self actionForKey:key];
    if (animation || [textures count] < 1) return;
    
    [self runAction:[SKAction animateWithTextures:textures timePerFrame:speed] withKey:key];
}

#pragma mark - Update
- (void)update:(NSTimeInterval)dt {
    
    //Rotation
    [self setPlayerRotation:dt];
    
    //Animation
    switch (self.playerState) {
        case PlayerStateIdle:
            [self runAnimationWithTextures:self.idleTextures speed:0.25 key:@"playerIdle"];
            break;
            
        case PlayerStateSwim:
            [self runAnimationWithTextures:self.swimTextures speed:kAnimationSpeed key:@"playerSwim"];
            break;
            
        case PlayerStateFly:
            break;
            
        default:
            break;
    }
    
    //Player State
    if (_playerShouldDive) {
        [self animateToSecondTexture];
        [self.physicsBody setVelocity:CGVectorMake(0, self.physicsBody.velocity.dy - _currentAccelleration)];
        _currentAccelleration = kAccelerationCap;
    } else {
        [self animateToFirstTexture];
        _currentAccelleration = 0;
    }
}

@end