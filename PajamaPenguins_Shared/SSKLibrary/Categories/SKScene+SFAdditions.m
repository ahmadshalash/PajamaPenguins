//
//  SKScene+SFAdditions.m
//  PajamaPenguins
//
//  Created by Skye on 2/24/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "SKScene+SFAdditions.h"

@implementation SKScene (SFAdditions)
- (void)enumerateChilrenForChildNodesWithName:(NSString *)name usingBlock:(void (^)(SKNode *node, BOOL *stop))block {
    NSString *recursiveName = [NSString stringWithFormat:@"//%@",name];
    [self enumerateChildNodesWithName:recursiveName usingBlock:^(SKNode *node, BOOL *stop) {
        block(node,stop);
    }];
}
@end
