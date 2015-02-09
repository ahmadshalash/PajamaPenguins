//
//  PPPlayer.m
//  PajamaPenguins
//
//  Created by Skye on 2/8/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPPlayer.h"

#define veloCap -30.0

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
        
        _yVelocity -= 1;
        if (_yVelocity <= veloCap) {
            _yVelocity = veloCap;
        }
    } else {
        _yVelocity = 0;
    }
    NSLog(@"%fl",_yVelocity);
}

@end
