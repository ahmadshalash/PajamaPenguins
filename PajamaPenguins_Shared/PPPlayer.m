//
//  PPPlayer.m
//  PajamaPenguins
//
//  Created by Skye on 2/8/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPPlayer.h"

#define kAccelerationCap 45.0

@interface PPPlayer()
@property (nonatomic) CGFloat currentAccelleration;
@end

@implementation PPPlayer

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

- (void)update:(NSTimeInterval)dt {
    CGFloat rotateSpeed = .02 * dt;
    [self setZRotation:(M_PI * self.physicsBody.velocity.dy * rotateSpeed) + SSKDegreesToRadians(90)];
    
    //Clamp rotation
    if (self.zRotation >= SSKDegreesToRadians(30)) {
        [self setZRotation:SSKDegreesToRadians(30)];
    }
    
    if (self.zRotation <= SSKDegreesToRadians(150)) {
        [self setZRotation:SSKDegreesToRadians(150)];
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