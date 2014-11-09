//
//  ViewController.m
//  AmazingBlock
//
//  Created by Hicham Chourak on 07/07/14.
//  Copyright (c) 2014 Hicham Chourak. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
#import "StartScene.h"
#import "GADBannerView.h"
#import "GADRequest.h"

@implementation ViewController {
    GADBannerView *_bannerView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set GameCenter Manager Delegate
    [[GameCenterManager sharedManager] setDelegate:self];
    
    // Load notification for background states
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    //play background music
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"backgroundMusic" ofType:@"mp3"]];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.player.numberOfLoops = -1;
    self.player.volume = 0.2;
    [self.player play];
    
    __weak SKView * skView = (SKView *)self.view;
    
    // Load admob ads
    _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    _bannerView.adUnitID = @"ca-app-pub-2660521344509391/8866541401";
    _bannerView.rootViewController = self;
    _bannerView.center = CGPointMake(skView.bounds.size.width / 2, skView.bounds.size.height - (_bannerView.frame.size.height / 2));
    [self.view addSubview:_bannerView];
    [_bannerView loadRequest:[GADRequest request]];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        dispatch_async(dispatch_get_main_queue(), ^(void){

            // Create and configure the scene.
            SKScene * scene = [StartScene sceneWithSize:skView.bounds.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            
            // Present the scene.
            [skView presentScene:scene];
            
            // create Promo ad
            self.promo = [[Promo alloc] init];
            [self.promo fetchPromoAdWithController:self];

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
}

-(void) appWillResignActive:(NSNotification*)note{
    [self.player pause];
}

-(void) appWillEnterForeground:(NSNotification*)note{
    [self.player play];
}

#pragma mark - GameCenterDelegate

- (void)gameCenterManager:(GameCenterManager *)manager authenticateUser:(UIViewController *)gameCenterLoginController
{
    [self presentViewController:gameCenterLoginController animated:YES completion:nil];
}

@end
