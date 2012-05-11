//
//  ProgramView.m
//  DaisyTheDinosaur
//
//  Created by Samantha John on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProgramView.h"
#import "UIColor+daisy.h"

@implementation ProgramView
- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor daisyProgramGrayColor];
    }
    return self;
}
@end
