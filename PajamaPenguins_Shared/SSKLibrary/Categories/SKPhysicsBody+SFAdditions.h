//
//  SKPhysicsBody+SFAdditions.h
//  PajamaPenguins
//
//  Created by Skye on 2/19/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKPhysicsBody (SFAdditions)
+ (SKPhysicsBody*)bodyWithEdgeLoopPathFromPoints:(NSArray*)points;
@end
