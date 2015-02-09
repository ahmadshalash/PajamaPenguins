//
//  PPPlayer.m
//  PajamaPenguins
//
//  Created by Skye on 2/8/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPPlayer.h"

@implementation PPPlayer

- (instancetype)initWithTexture:(SKTexture *)texture atPosition:(CGPoint)position {
    self = [super initWithTexture:texture];
    if (self) {
        self.position = position;
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:texture.size.width/2];
    }
    return self;
}

- (void)update:(NSTimeInterval)dt {
    [self setZRotation:(M_PI * self.physicsBody.velocity.dy * .00025) + SSKDegreesToRadians(90)];

    //Clamp rotation between 45 and 135 degrees
    if (self.zRotation >= SSKDegreesToRadians(45)) {
        [self setZRotation:SSKDegreesToRadians(45)];
    }
    
    if (self.zRotation <= SSKDegreesToRadians(135)) {
        [self setZRotation:SSKDegreesToRadians(135)];
    }

    if (_playerShouldDive) {
        [self.physicsBody setVelocity:CGVectorMake(0, self.physicsBody.velocity.dy + _yVelocity)];
        
        _yVelocity -= 2;
        if (_yVelocity <= -40) {
            _yVelocity = -40;
        }
    } else {
        _yVelocity = 0;
    }
}

@end
