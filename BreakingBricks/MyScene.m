//
//  MyScene.m
//  AmazingBlock
//
//  Created by Hicham Chourak on 07/07/14.
//  Copyright (c) 2014 Hicham Chourak. All rights reserved.
//

#import "MyScene.h"
#import "EndScene.h"

#define ARC4RANDOM_MAX 0x100000000

@interface MyScene ()

@property (nonatomic) SKSpriteNode *paddle;
@property (nonatomic) SKNode *instructions;

@property (nonatomic) BOOL gameEnding;

@property (nonatomic, strong) SKAction *playSFX;
@property (nonatomic, strong) SKAction *playBrickSFX;

@property (nonatomic) int score;
@property (nonatomic) int firstTouch;

@end

static const uint32_t ballCategory = 0x1;
static const uint32_t brickCategory = 0x1 << 1;
static const uint32_t paddleCategory = 0x1 << 2;
static const uint32_t edgeCategory = 0x1 << 3;
static const uint32_t bottemEdgeCategory = 0x1 << 4;

static NSString *brickName = @"brick";
static NSString *scoreLabelName = @"scoreLabelName";

@implementation MyScene {

    int lineLevel;
    
    SKSpriteNode *ball;
    SKSpriteNode *brick;
    
    int brickCount;
}

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {

        
        self.backgroundColor = [SKColor whiteColor];
        
        // Setup Game values
        self.gameEnding = NO;
        self.score = 0;
        self.firstTouch = 0;
        lineLevel = 0;
        
        //init soundeffects
        self.playBrickSFX = [SKAction playSoundFileNamed:@"blip.caf" waitForCompletion:NO];
        self.playSFX = [SKAction playSoundFileNamed:@"brickhit.caf" waitForCompletion:NO];
        
        // add physics body to scene
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsBody.categoryBitMask = edgeCategory;
        
        // Change gravity
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        
        // Add ball sprite
        [self addBall:self.size];
        
        // Add paddle sprite
        [self addPlayer:self.size];
        
        // Add bricks
        [self addBricks:self.size];
        
        // add buttom edge
        [self addBottomEdge:self.size];
        
        // add userinterface
        [self setupHud];
        [self gameInstructions];
        
    }
    return self;
}

-(void)update:(CFTimeInterval)currentTime
{
    if ([self isGameOver]) {
        [self endGame];
    }
}

#pragma mark - Interface Elements

- (void)setupHud
{
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-Thin"];
    
    scoreLabel.name = scoreLabelName;
    scoreLabel.fontSize = 40;
    
    scoreLabel.fontColor = [SKColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0f];
    scoreLabel.text = [NSString stringWithFormat:@"%i", 0];
    
    scoreLabel.position = CGPointMake(self.size.width/2, self.size.height - scoreLabel.frame.size.height/2 - self.size.height/16);
    
    [self addChild:scoreLabel];
}

- (void)adjustScoreBy:(NSUInteger)points
{
    self.score += points;
    SKLabelNode *scoreLabel = (SKLabelNode *)[self childNodeWithName:scoreLabelName];
    scoreLabel.text = [NSString stringWithFormat:@"%i", self.score];
}

- (void)gameInstructions
{
    self.instructions = [[SKNode alloc] init];
    
    SKSpriteNode *arrow_left = [SKSpriteNode spriteNodeWithImageNamed:@"arrow-left"];
    arrow_left.position = CGPointMake(self.size.width/2 - 60, self.size.height/5);
    
    [self.instructions addChild:arrow_left];
    
    
    SKSpriteNode *arrow_right = [SKSpriteNode spriteNodeWithImageNamed:@"arrow"];
    arrow_right.position = CGPointMake(self.size.width/2 + 60, self.size.height/5);
    
    [self.instructions addChild:arrow_right];
    
    // add text
    
    SKLabelNode *slideText = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-Thin"];
    
    slideText.fontSize = 25;
    
    slideText.fontColor = [SKColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0f];
    slideText.text = @"SLIDE";
    
    slideText.position = CGPointMake(self.size.width/2, self.size.height/5 - slideText.frame.size.height/2);
    
    [self.instructions addChild:slideText];
    
    [self addChild:self.instructions];

}

#pragma mark - Touch events

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *notTheBall;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        notTheBall = contact.bodyB;
    } else {
        notTheBall = contact.bodyA;
    }
    
    if (notTheBall.categoryBitMask == brickCategory)
    {
        [notTheBall.node removeFromParent];
        [self runAction:self.playBrickSFX];
        brickCount++;
        
        // Add score
        [self adjustScoreBy:1];

        if (brickCount == 8)
        {
            brickCount = 0;
            [ball.physicsBody applyImpulse:CGVectorMake(ball.physicsBody.velocity.dx*0.0005, ball.physicsBody.velocity.dy*0.0005)];

            [self addBrickLine:self.size];
            
            [self enumerateChildNodesWithName:brickName usingBlock:^(SKNode *node, BOOL *stop) {
                
                SKAction *move = [SKAction moveBy:CGVectorMake(0, -20) duration:1];
                [node runAction:move];
            }];
        }
    }
    
    if (notTheBall.categoryBitMask == paddleCategory)
    {
        [self runAction:self.playSFX];
    }
    
    if (notTheBall.categoryBitMask == bottemEdgeCategory)
    {
        [self endGame];
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        CGPoint newPosition = CGPointMake(location.x, self.size.height/10);
        
        if (self.firstTouch == 0) {
            [self.instructions removeFromParent];
            [self addBallImpulse];
            self.firstTouch++;
        }
        
        // stop moving paddle from going beyond edges
        if (newPosition.x < self.paddle.size.width/2) {
            newPosition.x = self.paddle.size.width/2;
        } else if (newPosition.x > self.size.width - self.paddle.size.width/2) {
            newPosition.x = self.size.width - self.paddle.size.width/2;
        }
        
        if(!self.gameEnding) {
            self.paddle.position = newPosition;
        }
    }
}

#pragma mark - game elements


- (void) addBricks:(CGSize)size
{
    
    for (int j=0; j < 6; j++) {
        
        
        for (int i =0; i < 8; i++) {
            brick = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:139/255.0 green:188/255.0 blue:255/255.0 alpha:1.0] size:CGSizeMake(30, 10)];
            brick.name = brickName;
            
            int xPos = size.width/9 * (i+1);
            int yPos = size.height - (brick.size.height*2)*(j+4);
            
            brick.position = CGPointMake(xPos, yPos);
            
            // add a static physic body
            brick.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:brick.frame.size];
            brick.physicsBody.dynamic = NO;
            brick.physicsBody.categoryBitMask = brickCategory;
            brick.physicsBody.friction = 0.0;
            brick.physicsBody.linearDamping = 0.0;
            
            [self addChild:brick];
        }
    }
    
}

- (void) addBrickLine:(CGSize)size
{
    
    for (int j=0; j < 1; j++) {
        
        
        for (int i =0; i < 8; i++) {
            brick = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:139/255.0 green:188/255.0 blue:255/255.0 alpha:1.0] size:CGSizeMake(30, 10)];
            brick.name = brickName;
            
            int xPos = size.width/9 * (i+1);
            int yPos = size.height - (brick.size.height*2)*(j+3);
            
            brick.position = CGPointMake(xPos, yPos);
            
            // add a static physic body
            brick.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:brick.frame.size];
            brick.physicsBody.dynamic = NO;
            brick.physicsBody.categoryBitMask = brickCategory;
            
            [self addChild:brick];
        }
    }
    
}

- (void) addPlayer:(CGSize)size
{
    // create paddle sprite
    self.paddle = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:148/255.0 green:203/255.0 blue:101/255.0 alpha:1.0] size:CGSizeMake(80, 20)];
    
    self.paddle.position = CGPointMake(size.width/2, size.height/10);
    
    self.paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.paddle.frame.size];
    self.paddle.physicsBody.restitution = 0.1f;
    self.paddle.physicsBody.friction = 0.4f;
    self.paddle.physicsBody.dynamic = NO;
    self.paddle.physicsBody.categoryBitMask = paddleCategory;
    
    // Add to scene
    [self addChild:self.paddle];
    
}

- (void)addBall:(CGSize)size
{
    // Create a new sprite
    ball = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:154/255.0 green:96/255.0 blue:183/255.0 alpha:1.0] size:CGSizeMake(10, 10)];
    
    
    // center position
    ball.position = CGPointMake(size.width/2, size.height/2);
    
    // add physics
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.frame.size.width/2];
    ball.physicsBody.friction = 0;
    ball.physicsBody.linearDamping = 0;
    ball.physicsBody.restitution = 1;
    ball.physicsBody.allowsRotation = NO;
    ball.physicsBody.categoryBitMask = ballCategory;
    ball.physicsBody.contactTestBitMask = brickCategory | paddleCategory | bottemEdgeCategory;
    
    [self addChild:ball];
}

- (void)addBallImpulse
{
    double neg = ((double)arc4random() / ARC4RANDOM_MAX);
    double dxVector = ((double)arc4random() / ARC4RANDOM_MAX);
    
    double dyVector = sqrt(2 - pow(dxVector,2));
    
    if (neg < 0.5) {
        dxVector = dxVector*-1;
    }
    
    [ball.physicsBody applyImpulse:CGVectorMake(dxVector,dyVector)];
}

- (void) addBottomEdge:(CGSize)size
{
    SKNode *bottemEdge = [SKNode node];
    bottemEdge.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, 1) toPoint:CGPointMake(size.width, 1)];
    bottemEdge.physicsBody.categoryBitMask = bottemEdgeCategory;
    [self addChild:bottemEdge];
}


#pragma mark - Game End Helpers

- (BOOL)isGameOver
{
    __block BOOL bricksTooLow = NO;
    [self enumerateChildNodesWithName:brickName usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y <= 100) {
            bricksTooLow = YES;
            *stop = YES;
        }
    }];

    return bricksTooLow;
}

- (void)endGame
{
    if (!self.gameEnding) {
        self.gameEnding = YES;
        ball.paused = YES;
        brick.paused = YES;
        
        // Save new Highscore
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setInteger:self.score forKey:@"Score"];
        NSInteger bestScore = [defaults integerForKey:@"bestScore"];
        
        if (self.score > bestScore) {
            
            [defaults setInteger:self.score forKey:@"bestScore"];
        }
        [defaults synchronize];
        
        EndScene *end = [EndScene sceneWithSize:self.size];
        [self.view presentScene:end transition:[SKTransition doorsCloseHorizontalWithDuration:0.5]];
    }
}


@end
