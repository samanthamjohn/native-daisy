//
//  TitleLabel.m
//  DaisyTheDinosaur
//
//  Created by Samantha John on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TitleLabel.h"
#import "UIColor+daisy.h"

@implementation TitleLabel

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.font = [UIFont fontWithName:@"MuseoSlab-500" size:22.f];
        self.textColor = [UIColor daisyGrayColor];
    }
    return self;
}

@end
