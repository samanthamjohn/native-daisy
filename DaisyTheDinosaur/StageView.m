//
//  DaisyGreenView.m
//  DaisyTheDinosaur
//
//  Created by Samantha John on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StageView.h"
#import "UIColor+daisy.h"
@interface StageView()
@property (nonatomic, strong) CALayer *daisyLayer;
@end
@implementation StageView
@synthesize daisyLayer = _daisyLayer;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor daisyGreenColor];
        CALayer *backgroundLayer = [CALayer layer];
        backgroundLayer.bounds = CGRectMake(0.f, 0.f, 963.f, 247.f);
        backgroundLayer.position = CGPointMake(12.f + 963.f/2.f, 12.f + 247.f/2.f);
        NSString *imageFileName = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"daisy-bg.jpg"];
        CGDataProviderRef dataProvider = CGDataProviderCreateWithFilename([imageFileName UTF8String]);
        CGImageRef backgroundImg = CGImageCreateWithJPEGDataProvider(dataProvider, NULL, NO, kCGRenderingIntentDefault);
        backgroundLayer.contents = (__bridge_transfer id) backgroundImg;
        [self.layer addSublayer:backgroundLayer];
        CGDataProviderRelease(dataProvider);
        
        self.daisyLayer = [CALayer layer];
        self.daisyLayer.bounds = CGRectMake(0.f, 0.f, 72.f, 78.f);
        self.daisyLayer.position = CGPointMake(53.f + 72.f/2.f, 119.f + 78.f/2.f);
        imageFileName = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"1.png"];
        CGDataProviderRef dinoDataProvider = CGDataProviderCreateWithFilename([imageFileName UTF8String]);
        CGImageRef daisyImg = CGImageCreateWithPNGDataProvider(dinoDataProvider, NULL, NO, kCGRenderingIntentDefault);
        self.daisyLayer.contents = (__bridge_transfer id) daisyImg;
        [self.layer addSublayer:self.daisyLayer];
        CGDataProviderRelease(dinoDataProvider);
    }
    return self;
}   

- (void) playMethods:(NSArray *)methodList
{
    NSString *name;
    CGFloat start = 0.f;
    CGFloat duration = 1.5;
    CGFloat totalDuration = 0.f;
    
    CGPoint currentPosition = self.daisyLayer.position;
    CGPoint newPosition;
    CGFloat scale = 1.f;
    NSString *direction = @"forward";
    NSMutableArray *animations = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in methodList) {
        name = [dict objectForKey:@"methodName"];
        if (name == @"move") {
            if (direction == @"backward") {
                newPosition = CGPointMake(currentPosition.x - 50, currentPosition.y);
            } else {
                newPosition = CGPointMake(currentPosition.x + 50, currentPosition.y);
            }
            CABasicAnimation *animation = [self createDaisyAnimationWithKeyPath:@"position" andDuration:duration atStart:start];
            animation.fromValue = [NSValue valueWithCGPoint:currentPosition];
            animation.toValue = [NSValue valueWithCGPoint:newPosition];
            start += duration;
            currentPosition = newPosition;
            [animations addObject:animation];
        } else if (name == @"turn") {
            CABasicAnimation *turn = [self createTurnWithDuration:0.5 WithStartTime:start FromImageNamed: @"1.png" ToImageNamed:@"back.png"];
            start += 0.5;
            
            CABasicAnimation *newTurn = [self createTurnWithDuration:0.5 WithStartTime:start FromImageNamed: @"back.png" ToImageNamed:@"1.png"];
            CABasicAnimation *flip = [self createDaisyAnimationWithKeyPath:@"transform.rotation.y" andDuration:0.1f atStart:start];
            flip.toValue = [NSNumber numberWithFloat:M_PI];

            if (direction == @"forward") {
                direction = @"backward";
            } else if (direction == @"backward") {
                direction = @"forward";
            }
            [animations addObject:turn];
            currentPosition = [self addFlipAnimationToAnimations:animations AtStartTime:start fromPosition:currentPosition FacingDirection:direction];
            [animations addObject:newTurn];
            start = start + 0.5;
        } else if (name == @"spin") {
            CABasicAnimation *turn1 = [self createTurnWithDuration:0.5 WithStartTime:start FromImageNamed: @"1.png" ToImageNamed:@"back.png"];
            start = start + 0.5;
            CGFloat flip1start = start;
            
            CABasicAnimation *turn2 = [self createTurnWithDuration:0.5 WithStartTime:start FromImageNamed: @"back.png" ToImageNamed:@"1.png"];
            start = start + 0.5;
            CABasicAnimation *turn3 = [self createTurnWithDuration:0.5 WithStartTime:start FromImageNamed: @"1.png" ToImageNamed:@"front.png"];
            start = start + 0.5;
            CGFloat flip2start = start;
            CABasicAnimation *turn4 = [self createTurnWithDuration:0.5 WithStartTime:start FromImageNamed: @"front.png" ToImageNamed:@"1.png"];
            [animations addObject:turn1];
            currentPosition = [self addFlipAnimationToAnimations:animations AtStartTime:flip1start fromPosition:currentPosition FacingDirection:direction];
            [animations addObject:turn2];
            [animations addObject:turn3];
            currentPosition = [self addFlipAnimationToAnimations:animations AtStartTime:flip2start fromPosition:currentPosition FacingDirection:direction];

            [animations addObject:turn4];

            start = start + 0.5;
        } else if (name == @"roll") {
            CABasicAnimation *rotate = [self createDaisyAnimationWithKeyPath:@"transform.rotation.z" andDuration:duration atStart:start];
            start = start + duration;
            if (direction == @"forward") 
            {
                rotate.toValue = [NSNumber numberWithFloat: 2 * M_PI ];       
            } else {
                rotate.toValue = [NSNumber numberWithFloat:-2 * M_PI];
            }
            [animations addObject:rotate];
        } else if (name == @"shrink") {
            CABasicAnimation *shrink = [self createDaisyAnimationWithKeyPath:@"transform.scale" andDuration:duration atStart:start];
            shrink.fromValue = [NSNumber numberWithFloat:scale];
            scale = scale * 0.8;
            shrink.toValue = [NSNumber numberWithFloat:scale];

            [animations addObject:shrink];
            
            CABasicAnimation *moveDown = [self createDaisyAnimationWithKeyPath:@"position.y" andDuration:duration atStart:start];
            newPosition = CGPointMake(currentPosition.x, currentPosition.y + 50 - 0.66 * self.daisyLayer.frame.size.height * 0.8);
            moveDown.fromValue = [NSNumber numberWithFloat:currentPosition.y];
            moveDown.toValue = [NSNumber numberWithFloat:newPosition.y];
            currentPosition = newPosition;
            start += duration;
            
            [animations addObject:moveDown];        
        } else if (name == @"grow") {
            CABasicAnimation *grow = [self createDaisyAnimationWithKeyPath:@"transform.scale" andDuration:duration atStart:start];
            grow.fromValue = [NSNumber numberWithFloat:scale];
            scale = scale * 1.25;
            grow.toValue = [NSNumber numberWithFloat:scale];
            if (scale > 2.f)
            {
                CABasicAnimation *switchToLarge;
                switchToLarge = [self createTurnWithDuration:0.1 WithStartTime:start FromImageNamed:@"1.png" ToImageNamed:@"1_large.png"];
                [animations addObject:switchToLarge];
                start += 0.1;
            }
            [animations addObject:grow];

            CABasicAnimation *moveUp = [self createDaisyAnimationWithKeyPath:@"position.y" andDuration:duration atStart:start];
            newPosition = CGPointMake(currentPosition.x, currentPosition.y + 50 - 0.66 * self.daisyLayer.frame.size.height * 1.25);
            moveUp.fromValue = [NSNumber numberWithFloat:currentPosition.y];
            moveUp.toValue = [NSNumber numberWithFloat:newPosition.y];
            currentPosition = newPosition;
            start += duration;

            [animations addObject:moveUp];

        } else if (name == @"jump") {
            CAKeyframeAnimation *jump = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
            jump.beginTime = start;
            jump.fillMode = kCAFillModeForwards;
            jump.duration = duration;
            jump.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            jump.calculationMode = kCAAnimationLinear;
            jump.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:currentPosition.y], [NSNumber numberWithFloat:currentPosition.y - 50], [NSNumber numberWithFloat:currentPosition.y], nil];
            [animations addObject:jump];
            start += duration;
        }
        
    }
    
    totalDuration = start + 0.5;
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = totalDuration;
    group.fillMode = kCAFillModeForwards;
    [group setAnimations:[NSArray arrayWithArray:animations]];
    [self.daisyLayer addAnimation:group forKey:nil];

 }

- (CGPoint)addFlipAnimationToAnimations:(NSMutableArray *)animations AtStartTime:(CGFloat)start fromPosition: (CGPoint)currentPosition FacingDirection:(NSString *)direction
{
    CABasicAnimation *flip = [self createDaisyAnimationWithKeyPath:@"transform.rotation.y" andDuration:0.1f atStart:start];
    flip.toValue = [NSNumber numberWithFloat:M_PI];
    
    CABasicAnimation *move = [self createDaisyAnimationWithKeyPath:@"position.x" andDuration:0.1f atStart:start];
    CGPoint newPosition;
    if (direction == @"forward")
    {
        newPosition= CGPointMake(currentPosition.x - 4.f, currentPosition.y);
    } else {
        newPosition = CGPointMake(currentPosition.x + 4.f, currentPosition.y);
    }
    move.toValue = [NSNumber numberWithFloat:newPosition.x];       
    [animations addObject:flip];
    [animations addObject:move];
    return newPosition; 
}

- (CABasicAnimation *)createDaisyAnimationWithKeyPath:(NSString *)keyPath andDuration:(CGFloat) duration atStart:(CGFloat)start
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.beginTime = start;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    return animation;
}

- (CABasicAnimation *)createTurnWithDuration:(CGFloat)duration WithStartTime:(CGFloat)start FromImageNamed: (NSString *)fromImageName ToImageNamed: (NSString *)imageName
{
    CABasicAnimation *turn = [self createDaisyAnimationWithKeyPath:@"contents" andDuration:duration atStart:start];
    
    NSString *toImageFile = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:imageName];
    CGDataProviderRef dataProvider = CGDataProviderCreateWithFilename([toImageFile UTF8String]);
    CGImageRef toImage = CGImageCreateWithPNGDataProvider(dataProvider, NULL, NO, kCGRenderingIntentDefault);
    turn.toValue = (__bridge_transfer id) toImage;
    
    NSString *fromImageFile = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fromImageName];
    CGDataProviderRef fromDataProvider = CGDataProviderCreateWithFilename([fromImageFile UTF8String]);

    CGImageRef fromImage = CGImageCreateWithPNGDataProvider(fromDataProvider, NULL, NO, kCGRenderingIntentDefault);
    turn.fromValue = (__bridge_transfer id) fromImage;
    
    CGDataProviderRelease(fromDataProvider);
    CGDataProviderRelease(dataProvider);

    return turn;
}



@end
