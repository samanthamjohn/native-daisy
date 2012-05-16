//
//  FreeplayViewController.h
//  DaisyTheDinosaur
//
//  Created by Samantha John on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+daisy.h"
#import "MethodView.h"
#import "ProgramView.h"

@interface FreeplayViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *toolboxView;
@property (weak, nonatomic) IBOutlet UITableView *programTableView;
@property (strong, nonatomic, readonly) NSArray *toolbox;
@property (strong, nonatomic) NSMutableArray *scripts;
@property (weak, nonatomic) IBOutlet ProgramView *programView;
@end
