//
//  PPIcebergObstacle.m
//  PajamaPenguins
//
//  Created by Skye on 2/21/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "PPIcebergObstacle.h"

@implementation PPIcebergObstacle

#warning placeholder
- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithColor:[SKColor whiteColor] size:size];
    if (self) {
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];
        self.physicsBody.affectedByGravity = NO;
        self.physicsBody.dynamic = NO;
    }
    return self;
}

- (instancetype)initWithTexture:(SKTexture *)texture {
    self = [super initWithTexture:texture];
    if (self) {
        [self setTexture:texture];

        self.physicsBody = [SKPhysicsBody bodyWithTexture:texture size:self.size];
        self.physicsBody.affectedByGravity = NO;
        self.physicsBody.dynamic = NO;
    }
    return self;
}

- (instancetype)initWithImageNamed:(NSString *)name {
    return [PPIcebergObstacle spriteNodeWithTexture:[SKTexture textureWithImageNamed:name]];
}

@end
