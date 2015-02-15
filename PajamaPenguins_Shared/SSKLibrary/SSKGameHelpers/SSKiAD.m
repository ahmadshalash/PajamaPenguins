//
//  SSKiAd.m
//
//  Created by Skye Freeman on 4/30/14.
//  Copyright (c) 2014 SkyeFreeman. All rights reserved.
//

#import "SSKiAD.h"

#define ADBannerIPhonePortraitHeight 50;
#define ADBannerIPhoneLandscapeHeight 32;
#define ADBannerIPadUniversalHeight 66;

@interface SSKiAD()
@property (nonatomic, readwrite) BOOL adBannerViewIsVisible;
@end

@implementation SSKiAD {
    CGRect _screenSize;
    CGFloat _adHeight;
}

/* 
 TODO: Ad ad height to adjust by device/screen-orientation
 */

- (id)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        _screenSize = frame;
        _adHeight = ADBannerIPhonePortraitHeight;
    }
	return self;
}

+ (instancetype)sharedManager {
	static SSKiAD *sharedInstance;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken,^{
		sharedInstance = [[SSKiAD alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	});
	return sharedInstance;
}

- (ADBannerView*)createAdBannerView {
    self.adBannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, _screenSize.size.height, _screenSize.size.width, _adHeight)];
	_adBannerView.delegate = self;
	return self.adBannerView;
}

- (void)showAd {
	if (self.adBannerViewIsVisible) {
		[UIView animateWithDuration:1.0 animations:^{
            self.adBannerView.frame = [self activeAdPosition];
        } completion:^(BOOL finished) {
            self.adBannerView.frame = [self activeAdPosition];
        }];
	}
}

- (void)hideAd {
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.adBannerView.frame = [self inactiveAdPosition];
    } completion:^(BOOL finished) {
        _adBannerView.frame = [self inactiveAdPosition];
    }];
}

#pragma mark - ADBannerView Delegate Methods
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    if (_adBannerViewIsVisible) {
        _adBannerViewIsVisible = NO;
        [self hideAd];
        NSLog(@"Ad hidden");
    }
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
	if (!_adBannerViewIsVisible) {
		_adBannerViewIsVisible = YES;
		[self showAd];
		NSLog(@"Ad fetched");
	}
}

#pragma mark - Convenience
- (CGRect)activeAdPosition {
    return CGRectMake(0, _screenSize.size.height - _adHeight, _screenSize.size.width, _adHeight);
}

- (CGRect)inactiveAdPosition {
    return CGRectMake(0, _screenSize.size.height, _screenSize.size.width, _adHeight);
}
@end
