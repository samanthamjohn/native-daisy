//
//  FreeplayViewController.h
//  DaisyTheDinosaur
//
//  Created by Samantha John on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+daisy.h"
enum CellViewTag {
    kbackgroundImageViewTag = 2047,
    kmethodNameViewTag = 2048
};

@interface FreeplayViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *toolboxView;
@property (strong, nonatomic) NSArray *toolbox;
@end
