//
//  StartScene.m
//  Amazing Block
//
//  Created by Hicham Chourak on 17/08/14.
//  Copyright (c) 2014 Hicham Chourak. All rights reserved.
//

#import "StartScene.h"
#import "MyScene.h"

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
        button.position = CGPointMake(size.width/2, size.height/4);
        button.name = @"startButton";
        [self addChild:button];
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
    }
}

@end