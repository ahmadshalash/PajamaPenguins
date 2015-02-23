//
//  SKNode+SFAdditions.m
//  PajamaPenguins
//
//  Created by Skye on 2/23/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "SKNode+SFAdditions.h"

@implementation SKNode (SFAdditions)

- (void)runAction:(SKAction *)action withKey:(NSString *)key completion:(void(^)(void))block {
    SKAction *completion = [SKAction runBlock:^{
        block();
    }];
    SKAction *sequence = [SKAction sequence:@[action,completion]];
    [self runAction:sequence withKey:key];
}

@end
