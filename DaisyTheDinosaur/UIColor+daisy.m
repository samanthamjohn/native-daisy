//
//  UIColor+daisy.m
//  DaisyTheDinosaur
//
//  Created by Samantha John on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIColor+daisy.h"

@implementation UIColor (daisy)
+ (UIColor *)daisyGreenColor
{
    return [UIColor colorWithRed:201.f/255.f green:217.f/255.f blue:112.f/255.f alpha:1.f];
}

+ (UIColor *)daisyGrayColor
{
    float saturation = 130.f/255.f;
    return [UIColor colorWithRed:saturation green:saturation blue:saturation alpha:1.f];
}

+ (UIColor *)daisyProgramGrayColor
{
    return [UIColor colorWithRed:204.f/255.f green:202.f/255.f blue:202.f/255.f alpha:1.f];
}
@end
