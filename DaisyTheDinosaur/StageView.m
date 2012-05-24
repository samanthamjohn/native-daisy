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
    NSMutableArray *animations = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in methodList) {
        name = [dict objectForKey:@"methodName"];
        if (name == @"move") {
            newPosition = CGPointMake(currentPosition.x + 50, currentPosition.y);
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
            animation.beginTime = start;
            animation.removedOnCompletion = NO;
            animation.fillMode = kCAFillModeForwards;
            animation.fromValue = [NSValue valueWithCGPoint:currentPosition];
            animation.toValue = [NSValue valueWithCGPoint:newPosition];
            animation.duration = duration;
            start += duration;
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            currentPosition = newPosition;
    
            [animations addObject:animation];
        } else if (name == @"turn") {
            NSLog(@"================> %@", @"turn");
        } else if (name == @"roll") {
            CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            rotate.removedOnCompletion = NO;
            rotate.fillMode = kCAFillModeForwards;
            rotate.duration = duration;
            rotate.beginTime = start;
            start = start + duration;
            rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
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

@end
