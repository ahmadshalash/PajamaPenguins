//
//  SSKGameCenter.m
//
//  Created by Skye Freeman on 4/11/14.
//  Copyright (c) 2014 SkyeFreeman. All rights reserved.
//

#import "SSKGameCenter.h"

NSString *const PresentAuthenticationViewController = @"present_authentication_view_controller";

@interface SSKGameCenter()<GKGameCenterControllerDelegate>
@end

@implementation SSKGameCenter {
	BOOL _enableGameCenter;
}

- (id)init {
	self = [super init];
	if (self) {
		_enableGameCenter = YES;
	}
	return self;
}

+ (instancetype)sharedGameCenterHelper {
	static SSKGameCenter *sharedGameCenterHelper;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken,^{
		sharedGameCenterHelper = [[SSKGameCenter alloc] init];
	});
	return sharedGameCenterHelper;
}

- (void)authenticateLocalPlayer {
	GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
	
	localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error) {
		[self setLastError:error];
		
		if (viewController != nil) {
			[self setAuthenticationViewController:viewController];
		}else if ([GKLocalPlayer localPlayer].isAuthenticated) {
			_enableGameCenter = YES;
		}else {
			_enableGameCenter = NO;
		}
	};
}

- (void)setAuthenticationViewController:(UIViewController *)authenticationViewController {
	if (authenticationViewController != nil) {
		_authenticationViewController = authenticationViewController;
		[[NSNotificationCenter defaultCenter] postNotificationName:PresentAuthenticationViewController object:self];
	}
}

- (void)setLastError:(NSError *)error {
	_lastError = [error copy];
	if (_lastError) NSLog(@"GameKitHelper ERROR: %@", [[_lastError userInfo] description]);
}

- (void)reportScore:(int64_t)score forLeaderboardID:(NSString*)leaderboardID {
	if (!_enableGameCenter)	NSLog(@"Local Play Is Not Authenticated");
	
	GKScore *scorereporter = [[GKScore alloc] initWithLeaderboardIdentifier:leaderboardID];
	scorereporter.value = score;
	scorereporter.context = 0;
	
	NSArray *scores = @[scorereporter];
	
    [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
        [self setLastError:error];
	}];
	
	NSLog(@"Game Center Score updated");
}

- (void)reportAchievements:(NSArray*)achievements {
	if (!_enableGameCenter) NSLog(@"Local Play is Not Authenticated");

    [GKAchievement reportAchievements:achievements withCompletionHandler:^(NSError *error) {
        [self setLastError:error];
    }];
}

- (void)showGKGameCenterViewController:(UIViewController*)viewController {
    if (!_enableGameCenter) {
		NSLog(@"Local Play is Not Authenticated");
	}
	
	GKGameCenterViewController *gameCenterVC = [[GKGameCenterViewController alloc] init];
	gameCenterVC.gameCenterDelegate = self;
	gameCenterVC.viewState = GKGameCenterViewControllerStateDefault;

	[viewController presentViewController:gameCenterVC animated:YES completion:nil];
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
