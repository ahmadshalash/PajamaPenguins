//
//  AppDelegate.m
//
//  Created by Skye Freeman on 1/1/2015.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.

#import "AppDelegate.h"
#import "SSKGameScene.h"

#define DEBUG_MODE 1 // Comment/uncomment to toggle debug information.

@implementation AppDelegate
@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    if (!self.skView.scene) {

        //Provides extra rendering optimizations. (However, zPositions need to be explicitly set)
        self.skView.ignoresSiblingOrder = YES;
        
        //Created and set screen size.
        SKScene *scene = [SSKGameScene sceneWithSize:CGSizeMake(1024, 768)];
        scene.scaleMode = SKSceneScaleModeAspectFit;
        [self.skView presentScene:scene];
    }

#ifdef DEBUG_MODE
    self.skView.showsFPS = YES;
    self.skView.showsNodeCount = YES;
#endif
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end
