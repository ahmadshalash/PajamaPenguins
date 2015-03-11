//
//  ViewController.m
//
//  Created by Skye Freeman on 1/1/2015.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.

#import "ViewController.h"
#import "PPMenuScene.h"
#import "PPGameScene.h"

#import "PPSharedAssets.h"

#define DEBUG_MODE 1 // Comment/uncomment to toggle debug information.

@implementation ViewController

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    SKView * skView = (SKView *)self.view;
    [skView setIgnoresSiblingOrder:YES]; //Provides extra rendering optimizations. (However, zPositions need to be explicitly set)

    if (!skView.scene) {
        [PPSharedAssets loadSharedAssetsWithCompletion:^{
            NSLog(@"Loading Complete.");
            SKScene *scene = [PPMenuScene sceneWithSize:skView.bounds.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            [skView presentScene:scene];
        }];
    }
    
#ifdef DEBUG_MODE
    skView.showsPhysics = YES;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
#endif
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
