//
//  DaisyCell.m
//  DaisyTheDinosaur
//
//  Created by Samantha John on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DaisyCell.h"

@implementation DaisyCell
@synthesize methodView = _methodView;

- (void)addSubviewsWithMethodName:(NSString *)methodName backgroundImageFile:(NSString *)backgroundImgFile
{
    if ([self.contentView.subviews count] == 0)
    {
        MethodView *methodView = [[MethodView alloc] initWithFrame:CGRectMake(0.f, 0.f, CELL_WIDTH, CELL_HEIGHT) withName:methodName withBackgroundImageFile:backgroundImgFile];
        //FIXME why can't I just set this directly?? 
        self.methodView = methodView;
        self.contentView.backgroundColor = [UIColor clearColor];   
        [self.contentView addSubview:self.methodView];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
