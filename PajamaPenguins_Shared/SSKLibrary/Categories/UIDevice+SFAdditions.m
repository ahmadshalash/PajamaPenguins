//
//  UIDevice+SFAdditions.m
//  PajamaPenguins
//
//  Created by Skye on 3/31/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import "UIDevice+SFAdditions.h"

@implementation UIDevice (SFAdditions)
+ (UIUserInterfaceIdiom)userInterfaceIdiom {
    switch ([[UIDevice currentDevice] userInterfaceIdiom]) {
        case UIUserInterfaceIdiomPhone:
            return UIUserInterfaceIdiomPhone;
            
        case UIUserInterfaceIdiomPad:
            return UIUserInterfaceIdiomPad;
            
        default:
            return UIUserInterfaceIdiomUnspecified;
    }
}

+ (BOOL)isUserInterfaceIdiomPhone {
    if ([UIDevice userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isUserInterfaceIdiomPad {
    if ([UIDevice userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    }
    
    return NO;
}

@end
