//
//  SSKiAD.h
//
//  Created by Skye Freeman on 4/30/14.
//  Copyright (c) 2014 SkyeFreeman. All rights reserved.
//

#import "iAd/iAd.h"

@interface SSKiAD : UIView <ADBannerViewDelegate>

@property (nonatomic, retain) ADBannerView *adBannerView;
@property (nonatomic, readonly) BOOL adBannerViewIsVisible;

+ (instancetype)sharedManager;

@end
