//
//  FreeplayViewController.m
//  DaisyTheDinosaur
//
//  Created by Samantha John on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FreeplayViewController.h"

@interface FreeplayViewController ()

@end

@implementation FreeplayViewController
@synthesize toolboxView = _toolboxView;
@synthesize toolbox = _toolbox;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSDictionary *)toolbox
{
    NSArray *controls = [[NSArray alloc] initWithObjects:@"repeat", @"when", nil];
    NSArray *methods = [[NSArray alloc] initWithObjects:@"move", @"turn", @"grow", @"shrink", @"jump", @"roll", @"spin" , nil];
    NSArray *tools = [[NSArray alloc] initWithObjects:controls, methods, nil];
    NSArray *toolKeys = [[NSArray alloc] initWithObjects:@"controls", @"methods", nil];
    return [[NSDictionary alloc] initWithObjects:tools forKeys:toolKeys];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.toolboxView.dataSource = self;
    self.toolboxView.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setToolboxView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  
{
    NSString *methodName;
    static NSString *CellIdentifier;
    if (indexPath.section == 0) {
        CellIdentifier = @"Control";
        NSArray *controls = [self.toolbox objectForKey:@"controls"];
        methodName = [controls objectAtIndex:indexPath.row];
    } else {
        CellIdentifier = @"Method";
        NSArray *methods = [self.toolbox objectForKey:@"methods"];
        methodName = [methods objectAtIndex:indexPath.row];
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.text = methodName;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section    
{
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return 7;
    } else  {
        return 0;
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Controls";
    } else {
        return @"Methods";
    }
}

@end
