//
//  AppDelegate.h
//  AmazingBlock
//
//  Created by Hicham Chourak on 07/07/14.
//  Copyright (c) 2014 Hicham Chourak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <Chartboost/Chartboost.h>
#import <Chartboost/CBNewsfeed.h>
#import <CommonCrypto/CommonDigest.h>
#import <AdSupport/AdSupport.h>
#import "GameCenterManager.h"
#import "Promo.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, ChartboostDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSNumber *appID;
@property (strong, nonatomic) Promo *promo;

@end
