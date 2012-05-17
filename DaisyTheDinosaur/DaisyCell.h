//
//  DaisyCell.h
//  DaisyTheDinosaur
//
//  Created by Samantha John on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MethodView.h"

@interface DaisyCell : UITableViewCell
- (void)addSubviewsWithMethodName:(NSString *)methodName backgroundImageFile: (NSString *)backgroundImageFile;
@property (nonatomic, weak) MethodView *methodView;
@end
