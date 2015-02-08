//
//  ViewController.m
//
//  Created by Skye Freeman on 1/1/2015.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.

#import "ViewController.h"
#import "PPGameScene.h"

#define DEBUG_MODE 1 // Comment/uncomment to toggle debug information.

@implementation ViewController

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    SKView * skView = (SKView *)self.view;
    skView.ignoresSiblingOrder = YES; //Provides extra rendering optimizations. (However, zPositions need to be explicitly set)

    if (!skView.scene) {
        [PPGameScene loadSceneAssetsWithCompletionHandler:^{
            NSLog(@"Loading Complete.");
            SKScene * scene = [PPGameScene sceneWithSize:skView.bounds.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            [skView presentScene:scene];
        }];
    }
    
#ifdef DEBUG_MODE
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
#endif
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
