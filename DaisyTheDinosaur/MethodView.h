//
//  MethodView.h
//  DaisyTheDinosaur
//
//  Created by Samantha John on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CELL_HEIGHT 72.f
#define CELL_WIDTH 220.f

@interface MethodView : UIView
- (id)initWithFrame:(CGRect)frame withName:(NSString *)name withBackgroundImageFile:(NSString *)backgroundImgFile;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *backgroundImgFile;
@end


