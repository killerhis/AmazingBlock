//
//  ViewController.m
//  AmazingBlock
//
//  Created by Hicham Chourak on 07/07/14.
//  Copyright (c) 2014 Hicham Chourak. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
#import "EndScene.h"
#import "StartScene.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //play background music
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"backgroundMusic" ofType:@"mp3"]];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.player.numberOfLoops = -1;
    self.player.volume = 0.2;
    [self.player play];
    
    //__weak MyScene *weakself = self;
    __weak SKView * skView = (SKView *)self.view;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            // Configure the view.
            //skView.showsFPS = YES;
            //skView.showsNodeCount = YES;
            
            // Create and configure the scene.
            SKScene * scene = [StartScene sceneWithSize:skView.bounds.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            
            // Present the scene.
            [skView presentScene:scene];

        });
    });
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
