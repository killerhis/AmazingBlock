//
//  EndScene.m
//  AmazingBlock
//
//  Created by Hicham Chourak on 08/07/14.
//  Copyright (c) 2014 Hicham Chourak. All rights reserved.
//

#import "EndScene.h"
#import "MyScene.h"
#import <Chartboost/Chartboost.h>
#import <Chartboost/CBNewsfeed.h>
#import <CommonCrypto/CommonDigest.h>
#import <AdSupport/AdSupport.h>
#import "GameCenterManager.h"
#import "ViewController.h"

@implementation EndScene

- (instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [SKColor whiteColor];
        
        // Show interstitial at location HomeScreen. See Chartboost.h for available location options.
        [Chartboost showInterstitial:CBLocationHomeScreen];
        
        // GA
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"GameOverMenu"];
        [tracker send:[[GAIDictionaryBuilder createAppView] build]];
        tracker.allowIDFACollection = NO;
        
        
        
        float scale;
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            scale = 2.0f; /* Device is iPad */
        } else {
            scale = 1.0f;
        }
        
        SKSpriteNode *backgroundNode = [SKSpriteNode spriteNodeWithImageNamed:@"restart-background"];
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
        rateButton.position = CGPointMake(size.width/2, size.height/4 - size.height/10);
        rateButton.name = @"rateButton";
        [self addChild:rateButton];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

        NSInteger bestScore = [defaults integerForKey:@"bestScore"];
        NSInteger score = [defaults integerForKey:@"Score"];

        //Add Score Labels
        
        SKLabelNode *bestScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-Light"];
    
        bestScoreLabel.fontSize = 25*scale;
        bestScoreLabel.fontColor = [SKColor colorWithRed:17/255.0 green:17/255.0 blue:17/255.0 alpha:1.0f];
        bestScoreLabel.text = [NSString stringWithFormat:@"%i", (int)bestScore];
        
        bestScoreLabel.position = CGPointMake(self.size.width/2, self.size.height/2 - bestScoreLabel.frame.size.height - 5*scale);
        
        [self addChild:bestScoreLabel];
        
        SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-Light"];
        
        scoreLabel.fontSize = 25*scale;
        scoreLabel.fontColor = [SKColor colorWithRed:17/255.0 green:17/255.0 blue:17/255.0 alpha:1.0f];
        scoreLabel.text = [NSString stringWithFormat:@"%i", (int)score];
        
        scoreLabel.position = CGPointMake(self.size.width/2, self.size.height/2 + scoreLabel.frame.size.height + 4*scale);
        
        [self addChild:scoreLabel];
        
        NSInteger gamesPlayed = [defaults integerForKey:@"gamesPlayed"];
        
        if (gamesPlayed == 5 || gamesPlayed == 40)
        {
            // Rate Button
            SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"ratebut.png"];
            rateButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
            rateButton.name = @"rate";
            rateButton.zPosition = 100;
            rateButton.alpha = 0.0f;
            [self addChild:rateButton];
            
            [rateButton runAction:[SKAction fadeAlphaTo:1.0 duration:0.2]];
        }
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
    } else if ([node.name isEqualToString:@"rate"]) {
        
        // Rate app
        [self rateApp];
        
        [node runAction:[SKAction fadeAlphaTo:1.0 duration:0.2] completion:^{
            [node removeFromParent];
        }];
    }
}

- (float)setDeviceScale
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        return 2.0f; /* Device is iPad */
    } else {
        return 1.0f;
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
