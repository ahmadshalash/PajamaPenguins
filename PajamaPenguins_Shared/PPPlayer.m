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
        [self.physicsBody setAffectedByGravity:NO];
    }
    return self;
}

- (void)update:(NSTimeInterval)dt {
    
}

@end
