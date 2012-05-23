//
//  DaisyGreenView.m
//  DaisyTheDinosaur
//
//  Created by Samantha John on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StageView.h"
#import "UIColor+daisy.h"

@implementation StageView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor daisyGreenColor];
        CALayer *backgroundLayer = [CALayer layer];
        backgroundLayer.bounds = CGRectMake(0.f, 0.f, 963.f, 247.f);
        backgroundLayer.position = CGPointMake(494.f, 136.f);
        NSString* imageFileName = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"daisy-bg.jpg"];
        CGDataProviderRef dataProvider = CGDataProviderCreateWithFilename([imageFileName UTF8String]);
        CGImageRef backgroundImg = CGImageCreateWithJPEGDataProvider(dataProvider, NULL, NO, kCGRenderingIntentDefault);
        backgroundLayer.contents = (__bridge_transfer id) backgroundImg;
        [self.layer addSublayer:backgroundLayer];
        CGDataProviderRelease(dataProvider);

    }
    return self;
}   

@end
