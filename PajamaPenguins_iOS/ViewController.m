//
//  ViewController.m
//
//  Created by Skye Freeman on 1/1/2015.
//  Copyright (c) 2015 Skye Freeman. All rights reserved.

#import "ViewController.h"
#import "SSKGameScene.h"

#define DEBUG_MODE 1 // Comment/uncomment to toggle debug information.

@implementation ViewController

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    SKView * skView = (SKView *)self.view;
    if (!skView.scene) {
        
        //Provides extra rendering optimizations. (However, zPositions need to be explicitly set)
        skView.ignoresSiblingOrder = YES;
        
        SKScene * scene = [SSKGameScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:scene];
    }
    
#ifdef DEBUG_MODE
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
#endif
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
