//
//  SKNode+SFAdditions.h
//  PajamaPenguins
//
//  Created by Skye on 2/23/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKNode (SFAdditions)

- (void)runAction:(SKAction *)action withKey:(NSString *)key completion:(void(^)(void))block;

@end
