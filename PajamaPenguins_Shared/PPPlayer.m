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
        [self.physicsBody setAffectedByGravity:YES];
    }
    return self;
}

- (void)update:(NSTimeInterval)dt {
    [self setZRotation:(M_PI * self.physicsBody.velocity.dy * .0003) + SSKDegreesToRadians(90)];
    
    if (_playerShouldDive) {
        [self.physicsBody applyImpulse:CGVectorMake(0, _yVelocity)];
        
        _yVelocity -= .05;
        if (_yVelocity <= -.7) {
            _yVelocity = -.7;
        }
    }

    if (!_playerShouldDive) {
        _yVelocity = 0;
    }
}

@end
