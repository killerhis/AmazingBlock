//
//  EndScene.m
//  AmazingBlock
//
//  Created by Hicham Chourak on 08/07/14.
//  Copyright (c) 2014 Hicham Chourak. All rights reserved.
//

#import "EndScene.h"
#import "MyScene.h"

@implementation EndScene

- (instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [SKColor whiteColor];
        
        SKSpriteNode *backgroundNode = [SKSpriteNode spriteNodeWithImageNamed:@"restart-background"];
        backgroundNode.position = CGPointMake(size.width/2, size.height/2);
        
        [self addChild:backgroundNode];
        
        SKSpriteNode *button = [SKSpriteNode spriteNodeWithImageNamed:@"button"];
        button.position = CGPointMake(size.width/2, size.height/4);
        button.name = @"startButton";
        [self addChild:button];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

        NSInteger bestScore = [defaults integerForKey:@"bestScore"];
        NSInteger score = [defaults integerForKey:@"Score"];

        //Add Score Labels
        
        SKLabelNode *bestScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-Light"];
    
        bestScoreLabel.fontSize = 25;
        bestScoreLabel.fontColor = [SKColor colorWithRed:17/255.0 green:17/255.0 blue:17/255.0 alpha:1.0f];
        bestScoreLabel.text = [NSString stringWithFormat:@"%i", bestScore];
        
        bestScoreLabel.position = CGPointMake(self.size.width/2, self.size.height/2 - bestScoreLabel.frame.size.height - 5);
        
        [self addChild:bestScoreLabel];
        
        SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-Light"];
        
        scoreLabel.fontSize = 25;
        scoreLabel.fontColor = [SKColor colorWithRed:17/255.0 green:17/255.0 blue:17/255.0 alpha:1.0f];
        scoreLabel.text = [NSString stringWithFormat:@"%i", score];
        
        scoreLabel.position = CGPointMake(self.size.width/2, self.size.height/2 + scoreLabel.frame.size.height + 4);
        
        [self addChild:scoreLabel];
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
