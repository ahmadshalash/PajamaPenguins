//
//  SSKiAD.h
//
//  Created by Skye Freeman on 4/30/14.
//  Copyright (c) 2014 SkyeFreeman. All rights reserved.
//

#import "iAd/iAd.h"

@interface SSKiAD : UIView <ADBannerViewDelegate>

@property (nonatomic,retain) ADBannerView *adBannerView;
@property (nonatomic,assign) BOOL adBannerViewIsVisible;

+ (instancetype)sharedAdHelper;
- (ADBannerView*)createAdBannerView;

@end
