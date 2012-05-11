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

- (NSArray *)toolbox
{
    NSArray *controls = [[NSArray alloc] initWithObjects:@"repeat", @"when",@"move", @"turn", @"grow", @"shrink", @"jump", @"roll", @"spin" , nil];
    return controls;
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
    return (interfaceOrientation == UIInterfaceOrientationIsLandscape(interfaceOrientation));
}
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52.f;
}


#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.toolbox count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  
{
    NSString *methodName = [self.toolbox objectAtIndex:indexPath.row];
    static NSString *CellIdentifier;
    NSString *backgroundImgFile;
    
    if (indexPath.row < 2) {
        CellIdentifier = @"Control";
        backgroundImgFile = @"control_icon";
    } else {
        CellIdentifier = @"Method";
        backgroundImgFile = @"method_icon";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UIImageView *backgroundImageView;
    UILabel *methodNameView;

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    CGRect methodFrame = CGRectMake(5.f, 5.f, 142.f, 42.f);
    cell.contentView.backgroundColor = [UIColor clearColor];               
    
    if (![cell.contentView viewWithTag:kbackgroundImageViewTag]) {
        backgroundImageView = [[UIImageView alloc] initWithFrame:methodFrame];
        backgroundImageView.tag = kbackgroundImageViewTag;
        backgroundImageView.image = [UIImage imageNamed:backgroundImgFile];
        [cell.contentView addSubview:backgroundImageView];
    }

    if (![cell.contentView viewWithTag:kmethodNameViewTag]) {  
        CGRect labelFrame = CGRectMake(0.f, 0.f, 152.f, 42.f);

        methodNameView = [[UILabel alloc] initWithFrame:labelFrame];
        methodNameView.textAlignment = UITextAlignmentCenter;
        methodNameView.tag = kmethodNameViewTag;
        methodNameView.backgroundColor = [UIColor clearColor];
        methodNameView.textColor = [UIColor whiteColor];
        methodNameView.font = [UIFont fontWithName:@"Helvetica" size:20.f];
        [cell.contentView addSubview:methodNameView];
    } else {
        methodNameView = (UILabel *)[cell.contentView viewWithTag:kmethodNameViewTag];
    }
    methodNameView.text = methodName;
    return cell;
}

@end
