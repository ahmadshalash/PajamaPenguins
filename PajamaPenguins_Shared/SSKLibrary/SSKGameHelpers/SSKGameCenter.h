//
//  SSKGameCenter.h
//
//  Created by Skye Freeman on 4/11/14.
//  Copyright (c) 2014 SkyeFreeman. All rights reserved.
//

@import GameKit;

extern NSString *const PresentAuthenticationViewController;

@interface SSKGameCenter : NSObject

@property (nonatomic,readonly) UIViewController *authenticationViewController;
@property (nonatomic,readonly) NSError *lastError;

+ (instancetype)sharedGameCenterHelper;
- (void)authenticateLocalPlayer;
- (void)reportAchievements:(NSArray*)achievements;
- (void)reportScore:(int64_t)score forLeaderboardID:(NSString*)leaderboardID;
- (void)showGKGameCenterViewController:(UIViewController *)viewController;

@end
