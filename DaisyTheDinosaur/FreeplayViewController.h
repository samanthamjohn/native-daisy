//
//  FreeplayViewController.h
//  DaisyTheDinosaur
//
//  Created by Samantha John on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FreeplayViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *toolboxView;
@property (strong, nonatomic) NSDictionary *toolbox;
@end
