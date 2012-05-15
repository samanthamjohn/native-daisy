//
//  FreeplayViewController.m
//  DaisyTheDinosaur
//
//  Created by Samantha John on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FreeplayViewController.h"

@interface FreeplayViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) MethodView *viewBeingDragged;
@property (nonatomic) CGPoint dragOffset;
@property (nonatomic, strong) NSString *backgroundImgFileBeingDragged;
@property (nonatomic, strong) NSString *methodNameBeingDragged;
@end

@implementation FreeplayViewController
@synthesize toolboxView = _toolboxView;
@synthesize toolbox = _toolbox;
@synthesize programView = _programView;
@synthesize viewBeingDragged = _viewBeingDragged;
@synthesize dragOffset = _dragOffset;
@synthesize methodNameBeingDragged = _methodNameBeingDragged;
@synthesize backgroundImgFileBeingDragged = _backgroundImgFileBeingDragged;


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
    [self setProgramView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (MethodView *)viewBeingDragged
{
    if (_viewBeingDragged)
    {
        return _viewBeingDragged;
    } else {
        self.viewBeingDragged = [[MethodView alloc] initWithFrame:CGRectMake(0.f, 0.f, 152.f, 42.f) withName:@"turn" withBackgroundImageFile:@"method_icon"];
        [self.view addSubview:self.viewBeingDragged];
        return self.viewBeingDragged;
    }
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
    MethodView *methodView = [[MethodView alloc] initWithFrame:CGRectMake(0.f, 0.f, 152.f, 42.f) withName:methodName withBackgroundImageFile:backgroundImgFile];
  
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.contentView.backgroundColor = [UIColor clearColor];   
    [cell.contentView addSubview:methodView];
  
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:nil];
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panFromToolbox:)];
    swipeGesture.delegate = self;
    gesture.delegate = self;
    [cell addGestureRecognizer:swipeGesture];
    [cell addGestureRecognizer:gesture];

    return cell;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (self.viewBeingDragged) {
        return NO;
    } else {
        return YES;
    }
}

- (void)panFromToolbox:(UIPanGestureRecognizer *)pan
{
    
    CGPoint point = [pan locationInView:self.view];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        CGPoint touchLocation = [pan locationOfTouch:0 inView:self.view];
        CGPoint methodCenter = pan.view.center;
        self.dragOffset = CGPointMake(methodCenter.x - touchLocation.x, methodCenter.y - touchLocation.y);
    }
    else if (pan.state == UIGestureRecognizerStateChanged) 
    {
        self.viewBeingDragged.center = CGPointMake(point.x + self.dragOffset.x, point.y + self.dragOffset.y);
        self.viewBeingDragged.center = point;
        
    } else if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled ||pan.state == UIGestureRecognizerStateFailed) {
        [self.viewBeingDragged removeFromSuperview];
        
        CGPoint programPoint = [self.programView convertPoint:point fromView:self.view];
        if ([self.programView pointInside:programPoint withEvent:nil]) 
        {
           // [self.viewBeingDragged addGestureRecognizer:[[UIPanGestureRecognizer alloc]  initWithTarget:self action:@selector(dragFromProgramView:)]];
            self.viewBeingDragged.center = CGPointMake(programPoint.x + self.dragOffset.x, programPoint.y + self.dragOffset.y);
            
            [self.programView addSubview:self.viewBeingDragged];
            
        }
        
        self.viewBeingDragged = nil;
    }

 }

@end
