//
//  StartScene.m
//  Amazing Block
//
//  Created by Hicham Chourak on 17/08/14.
//  Copyright (c) 2014 Hicham Chourak. All rights reserved.
//

#import "StartScene.h"
#import "MyScene.h"
#import "GameCenterManager.h"
#import "ViewController.h"

@implementation StartScene

- (instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        
        // GA
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"StartMenu"];
        [tracker send:[[GAIDictionaryBuilder createAppView] build]];
        tracker.allowIDFACollection = NO;
        
        self.backgroundColor = [SKColor whiteColor];
        
        SKSpriteNode *backgroundNode = [SKSpriteNode spriteNodeWithImageNamed:@"start_background"];
        backgroundNode.position = CGPointMake(size.width/2, size.height/2);
        
        [self addChild:backgroundNode];
        
        SKSpriteNode *button = [SKSpriteNode spriteNodeWithImageNamed:@"button"];
        button.position = CGPointMake(size.width/4, size.height/4);
        button.name = @"startButton";
        [self addChild:button];
        
        SKSpriteNode *gameCenterButton = [SKSpriteNode spriteNodeWithImageNamed:@"gamecenter"];
        gameCenterButton.position = CGPointMake(3*size.width/4, size.height/4);
        gameCenterButton.name = @"gameCenterButton";
        [self addChild:gameCenterButton];
        
        SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"rate"];
        rateButton.position = CGPointMake(size.width/2, size.height/4 + size.height/10);
        rateButton.name = @"rateButton";
        [self addChild:rateButton];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"startButton"]) {
        
        MyScene *firstScene = [MyScene sceneWithSize:self.size];
        [self.view presentScene:firstScene transition:[SKTransition doorsOpenHorizontalWithDuration:0.5]];
    } else if ([node.name isEqualToString:@"gameCenterButton"]) {
        // show gamecenter leaderboard
        [self showLeaderboard];
    } else if ([node.name isEqualToString:@"rateButton"]) {
        // rate game
        [self rateApp];
    }
}

#pragma mark - Game Center Methods

- (void)showLeaderboard
{
    if ([[GameCenterManager sharedManager] checkGameCenterAvailability]) {
        [[GameCenterManager sharedManager] presentLeaderboardsOnViewController:(ViewController *)self.view.window.rootViewController];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Center Unavailable" message:@"User is not signed in!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - Helper Methods

- (void)rateApp
{
    NSString *str = @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=910010318&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8";
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

@end