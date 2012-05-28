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
@property (nonatomic, strong) NSString *direction;
@end
@implementation StageView
@synthesize daisyLayer = _daisyLayer;
@synthesize direction = _direction;

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
    self.direction = @"forward";
    NSMutableArray *animations = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in methodList) {
        name = [dict objectForKey:@"methodName"];
        if (name == @"move") {
            if (self.direction == @"backward") {
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
            CABasicAnimation *turn;
            CABasicAnimation *newTurn;
            if (self.direction == @"forward") {
                turn = [self createTurnWithDuration:0.5 WithStartTime:start FromImageNamed: @"1.png" ToImageNamed:@"back.png"];
                start = start + 0.5;
                
                newTurn = [self createTurnWithDuration:0.5 WithStartTime:start FromImageNamed: @"back.png" ToImageNamed:@"l1.png"];
                self.direction = @"backward";
            } else if (self.direction == @"backward") {
                turn = [self createTurnWithDuration:0.5 WithStartTime:start FromImageNamed: @"l1.png" ToImageNamed:@"front.png"];
                start = start + 0.5;
                
                newTurn = [self createTurnWithDuration:0.5 WithStartTime:start FromImageNamed: @"front.png" ToImageNamed:@"1.png"];
                self.direction = @"forward";

            }
            [animations addObject:turn];
            [animations addObject:newTurn];
            start = start + 0.5;
            

        } else if (name == @"roll") {
            CABasicAnimation *rotate = [self createDaisyAnimationWithKeyPath:@"transform.rotation.z" andDuration:duration atStart:start];
            start = start + duration;
            rotate.toValue = [NSNumber numberWithFloat: 2 * M_PI ];    
            [animations addObject:rotate];
        }
        
    }
    
    totalDuration = start + duration;
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = totalDuration;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    [group setAnimations:[NSArray arrayWithArray:animations]];
    [self.daisyLayer addAnimation:group forKey:nil];

 }

- (CABasicAnimation *)createDaisyAnimationWithKeyPath:(NSString *)keyPath andDuration:(CGFloat) duration atStart:(CGFloat)start
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.beginTime = start;
    animation.removedOnCompletion = NO;
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
