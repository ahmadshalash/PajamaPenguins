//
//  UIDevice+SFAdditions.h
//  PajamaPenguins
//
//  Created by Skye on 3/31/15.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (SFAdditions)
+ (UIUserInterfaceIdiom)userInterfaceIdiom;
+ (BOOL)isUserInterfaceIdiomPhone;
+ (BOOL)isUserInterfaceIdiomPad;
@end
