//
//  SSKiAd.m
//
//  Created by Skye Freeman on 4/30/14.
//  Copyright (c) 2014 SkyeFreeman. All rights reserved.
//

#import "SSKiAD.h"

#define IS_WIDESCREEN ([[UIScreen mainScreen] bounds].size.height == 568)

@implementation SSKiAD {
	int SCREEN_HEIGHT;
	int SCREEN_WIDTH;
}

-(id)init {
	self = [super init];

	if (self) {
		if (IS_WIDESCREEN) {
			SCREEN_HEIGHT = 568;
		}else {
			SCREEN_HEIGHT = 480;
		}
		SCREEN_WIDTH = 320;
	}
	return self;
}

+(instancetype)sharedAdHelper {
	static SSKiAD *sharedAdHelper;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken,^{
		sharedAdHelper = [[SSKiAD alloc] init];
	});
	return sharedAdHelper;
}

-(ADBannerView*)createAdBannerView {
	self.adBannerView = [[ADBannerView alloc] initWithFrame:
						 CGRectMake(0,SCREEN_HEIGHT, SCREEN_WIDTH, 50)];
	_adBannerView.delegate = self;
	NSLog(@"%d",SCREEN_HEIGHT);
	return self.adBannerView;
}

-(void)showAd {
	_adBannerView.frame =
	CGRectMake(0,SCREEN_HEIGHT,SCREEN_WIDTH, 50);
	
	if (_adBannerViewIsVisible) {
		[UIView animateWithDuration:1.0
						 animations:^{
							 _adBannerView.frame =
							 CGRectMake(0, SCREEN_HEIGHT - 50,SCREEN_WIDTH,50);
						 }];
	}
}

-(void)hideAd {
	[UIView animateWithDuration:1.0
						  delay:2.0
						options:UIViewAnimationOptionAllowUserInteraction
					 animations:^{
						 _adBannerView.frame =
						 CGRectMake(0, SCREEN_HEIGHT,SCREEN_WIDTH,50);
					 } completion:^(BOOL finished) {}];
	_adBannerView.frame =
	CGRectMake(0, SCREEN_HEIGHT,SCREEN_WIDTH,50);
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
	if (_adBannerViewIsVisible) {
		_adBannerViewIsVisible = NO;
		[self hideAd];
		NSLog(@"Ad hidden");
	}
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner {
	if (!_adBannerViewIsVisible) {
		_adBannerViewIsVisible = YES;
		[self showAd];
		NSLog(@"Ad fetched");
	}
}


@end
