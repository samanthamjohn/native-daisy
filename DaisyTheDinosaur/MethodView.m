//
//  MethodView.m
//  DaisyTheDinosaur
//
//  Created by Samantha John on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MethodView.h"
@interface MethodView()
@end

@implementation MethodView
@synthesize name = _name;
@synthesize backgroundImgFile = _backgroundImgFile;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame withName:(NSString *)name withBackgroundImageFile:(NSString *)backgroundImgFile;
{
    self.backgroundImgFile = backgroundImgFile;
    self.name = name;
    
    self = [super initWithFrame:frame];
    UIImageView *backgroundImageView;
    UILabel *methodNameView;
    
    if (self) {
        backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.f, 5.f, CELL_WIDTH - 10.f, CELL_HEIGHT - 10.f)];
        backgroundImageView.image = [UIImage imageNamed:backgroundImgFile];
        [self addSubview:backgroundImageView];
        
        CGRect labelFrame = CGRectMake(0.f, 0.f, CELL_WIDTH, CELL_HEIGHT);
        
        methodNameView = [[UILabel alloc] initWithFrame:labelFrame];
        methodNameView.textAlignment = UITextAlignmentCenter;
        methodNameView.backgroundColor = [UIColor clearColor];
        methodNameView.textColor = [UIColor whiteColor];
        methodNameView.font = [UIFont fontWithName:@"Helvetica" size:20.f];
        [self addSubview:methodNameView];
        methodNameView.text = name;
    }
    return self;
}

@end
