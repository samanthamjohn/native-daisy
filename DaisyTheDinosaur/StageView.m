//
//  DaisyGreenView.m
//  DaisyTheDinosaur
//
//  Created by Samantha John on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DaisyGreenView.h"
#import "UIColor+daisy.h"

@implementation DaisyGreenView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor daisyGreenColor];
    }
    return self;
}
@end
