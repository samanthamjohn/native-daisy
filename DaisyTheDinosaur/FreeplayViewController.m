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
@property (nonatomic, strong) NSDictionary *insertedCellData;
@property (nonatomic, strong) UIView *selectedView;
@end

@implementation FreeplayViewController
@synthesize toolboxView = _toolboxView;
@synthesize programTableView = _programTableView;
@synthesize programView = _programView;
@synthesize viewBeingDragged = _viewBeingDragged;
@synthesize dragOffset = _dragOffset;
@synthesize methodNameBeingDragged = _methodNameBeingDragged;
@synthesize backgroundImgFileBeingDragged = _backgroundImgFileBeingDragged;
@synthesize scripts = _scripts;
@synthesize toolbox = _toolbox;
@synthesize insertedCellData = _insertedCellData;
@synthesize selectedView = _selectedView;

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
    if (!_toolbox)
    {
        _toolbox = [[NSArray alloc] initWithObjects:@"repeat", @"when",@"move", @"turn", @"grow", @"shrink", @"jump", @"roll", @"spin" , nil];
    }
    return _toolbox;
}

- (NSMutableArray *)scripts
{
    if (!_scripts) {
        _scripts = [[NSMutableArray alloc] initWithObjects:nil, nil];
    }
    return _scripts;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.toolboxView.dataSource = self;
    self.toolboxView.delegate = self;
    self.programTableView.dataSource = self;
    self.programTableView.delegate = self;
    [self.programTableView setEditing:YES];
}

- (void)viewDidUnload
{
    [self setToolboxView:nil];
    [self setProgramView:nil];
    [self setProgramTableView:nil];
    [self setViewBeingDragged:nil];
    [self setSelectedView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (UIView *)selectedView
{
    if (!_selectedView)
    {
        _selectedView  = [[UIView alloc] initWithFrame:CGRectMake(10.f, CELL_HEIGHT - 10.f, CELL_WIDTH - 20.f, 10.f)];
        _selectedView.backgroundColor = [UIColor whiteColor];
    }
    return _selectedView;
}

- (MethodView *)viewBeingDragged
{
    if(!_viewBeingDragged && self.methodNameBeingDragged && self.backgroundImgFileBeingDragged) {
         _viewBeingDragged = [[MethodView alloc] initWithFrame:CGRectMake(0.f, 0.f, CELL_WIDTH, CELL_HEIGHT) withName:self.methodNameBeingDragged withBackgroundImageFile:self.backgroundImgFileBeingDragged];
        [self.view addSubview:self.viewBeingDragged];
    } 
    return _viewBeingDragged;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationIsLandscape(interfaceOrientation));
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (BOOL) tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (UIControl *control in cell.subviews)
    {       
        
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellReorderControl")] && [control.subviews count] > 0)
        {        
            UIView* resizedGripView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(control.frame), CGRectGetMaxY(control.frame))];
            
            [resizedGripView addSubview:control];
            [cell addSubview:resizedGripView];
            
            CGSize sizeDifference = CGSizeMake(resizedGripView.frame.size.width - control.frame.size.width, resizedGripView.frame.size.height - control.frame.size.height);
            CGSize transformRatio = CGSizeMake(resizedGripView.frame.size.width / control.frame.size.width, resizedGripView.frame.size.height / control.frame.size.height);
            
            //	Original transform
            CGAffineTransform transform = CGAffineTransformIdentity;
            
            //	Scale custom view so grip will fill entire cell
            transform = CGAffineTransformScale(transform, transformRatio.width, transformRatio.height);
            
            //	Move custom view so the grip's top left aligns with the cell's top left
            transform = CGAffineTransformTranslate(transform, -sizeDifference.width / 2.0, -sizeDifference.height / 2.0);
            
            [resizedGripView setTransform:transform];
            
            
            for (id someObj in control.subviews)
            {
                if ([someObj isMemberOfClass:[UIImageView class]])
                {
                    ((UIImageView*)someObj).image = nil;
                }
            }
            
        }
    }   
}

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.toolboxView) {
        return [self.toolbox count];        
    } else if (tableView == self.programTableView) {
        return [self.scripts count];
    } else {
        return 0;
    }
    

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  
{
    static NSString *CellIdentifier;
    NSString *methodName;
    NSString *backgroundImgFile;
    if (tableView == self.toolboxView) {
        methodName = [self.toolbox objectAtIndex:indexPath.row];        
        if (indexPath.row < 2) {
            CellIdentifier = @"Control";
            backgroundImgFile = @"control_icon";
        } else {
            CellIdentifier = @"Method";
            backgroundImgFile = @"method_icon";
        }
    } else {
        NSDictionary *method = [self.scripts objectAtIndex:indexPath.row];
        methodName = [method objectForKey:@"methodName"];
        backgroundImgFile = [method objectForKey:@"backgroundImgFile"];
        if (backgroundImgFile == @"control_icon") {
            CellIdentifier = @"Control";
        } else {
            CellIdentifier = @"Method";
        }
    }
        
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        if (tableView == self.programTableView)
        {
            cell = [[ScriptViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];   
        } else {
            cell = [[DaisyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    }
    
    if (tableView == self.programTableView) 
    {
        cell = (ScriptViewCell *)cell;
        [(ScriptViewCell *)cell addSubviewsWithMethodName:methodName backgroundImageFile:backgroundImgFile];
        cell.tag = indexPath.row;
        UIPinchGestureRecognizer  *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(deleteFromScript:)];
        UILongPressGestureRecognizer *longPress= [[UILongPressGestureRecognizer alloc] initWithTarget:self action:nil];
        pinchRecognizer.delegate = self;
        longPress.delegate = self;
        [cell addGestureRecognizer:pinchRecognizer];
        [cell addGestureRecognizer:longPress];

    } else {
        cell = (DaisyCell *)cell;
        [(DaisyCell *)cell addSubviewsWithMethodName:methodName backgroundImageFile:backgroundImgFile];
        UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:nil];
        UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panFromToolbox:)];
        swipeGesture.delegate = self;
        gesture.delegate = self;
        [[(DaisyCell *)cell methodView] addGestureRecognizer:swipeGesture];
        [[(DaisyCell *)cell methodView] addGestureRecognizer:gesture];
    }
    return cell;
}


- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.programTableView) {
        return YES;
    } else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    if (tableView == self.programTableView)
    {
        int size = self.scripts.count;
        if (size > 0)
        {
            id movingObject = [self.scripts objectAtIndex:fromIndexPath.row];            
            [self.scripts objectAtIndex:toIndexPath.row];
            NSMutableArray *newArray = [[NSMutableArray alloc] initWithObjects:nil];
            for (int i=0; i <= (self.scripts.count - 1); i++) {
                if (i == toIndexPath.row)
                {
                    [newArray addObject:movingObject];
                } else {
                    [newArray addObject:[self.scripts objectAtIndex:i]];
                }
            }
            self.scripts = newArray;
        }
    }
}


#pragma mark UIGestureRecognizerDelegate

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
    [self.selectedView removeFromSuperview];
    CGPoint point = [pan locationInView:self.view];
    if (pan.state == UIGestureRecognizerStateBegan) {
        if ([pan.view isKindOfClass:[MethodView class]])
        {
            self.methodNameBeingDragged = ((MethodView *)pan.view).name;
            self.backgroundImgFileBeingDragged = ((MethodView *)pan.view).backgroundImgFile;
        }

        CGPoint touchLocation = [pan locationOfTouch:0 inView:self.view];
        CGPoint methodCenter = [pan.view.superview convertPoint:pan.view.center toView:self.view];
        self.dragOffset = CGPointMake(methodCenter.x - touchLocation.x, methodCenter.y - touchLocation.y);
        self.viewBeingDragged.center = CGPointMake(point.x + self.dragOffset.x, point.y + self.dragOffset.y);
        [self.programView setBackgroundColor:[UIColor lightGrayColor]];
    }
    else if (pan.state == UIGestureRecognizerStateChanged) 
    {
        self.viewBeingDragged.center = CGPointMake(point.x + self.dragOffset.x, point.y + self.dragOffset.y);
        CGPoint programTablePoint = [self.programTableView convertPoint:point fromView:self.view];
        if ([self.programTableView pointInside:programTablePoint withEvent:nil]) {
            
            for (id cell in [self.programTableView subviews]) {
                if ([cell isKindOfClass:[UITableViewCell class]])
                {
                    CGPoint cellPoint = [(UITableViewCell *)cell convertPoint:point fromView:self.view];
                    if ([(UITableViewCell *)cell pointInside:cellPoint withEvent:nil]) {
                        [[(UITableViewCell *)cell contentView] addSubview:self.selectedView];
                    }
                }
            } 
        }

    } else if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled ||pan.state == UIGestureRecognizerStateFailed) {
        [self.viewBeingDragged removeFromSuperview];
        
        CGPoint programPoint = [self.programView convertPoint:point fromView:self.view];
        CGPoint programTablePoint = [self.programTableView convertPoint:point fromView:self.view];
        if ([self.programTableView pointInside:programTablePoint withEvent:nil]) {
            
            for (id cell in [self.programTableView subviews]) {
                if ([cell isKindOfClass:[UITableViewCell class]])
                {   
                    CGPoint cellPoint = [(UITableViewCell *)cell convertPoint:point fromView:self.view];
                    if ([(UITableViewCell *)cell pointInside:cellPoint withEvent:nil]) {
                        self.insertedCellData = [NSDictionary dictionaryWithObjectsAndKeys: self.methodNameBeingDragged, @"methodName", self.backgroundImgFileBeingDragged, @"backgroundImgFile", nil];
                        [self.scripts insertObject:self.insertedCellData atIndex:[(UITableViewCell *)cell tag] + 1];
                    }
                }
            } 
            if (!self.insertedCellData) {
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: self.methodNameBeingDragged, @"methodName", self.backgroundImgFileBeingDragged, @"backgroundImgFile", nil];          
                [self.scripts addObject:dict];            
            }
            [self.programTableView reloadData];
        }
        else if ([self.programView pointInside:programPoint withEvent:nil]) 
        {
            [self.viewBeingDragged addGestureRecognizer:[[UIPanGestureRecognizer alloc]  initWithTarget:self action:@selector(dragFromProgramView:)]];
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: self.methodNameBeingDragged, @"methodName", self.backgroundImgFileBeingDragged, @"backgroundImgFile", nil];
            
            [self.scripts addObject:dict];            
            [self.programTableView reloadData];
        }
        self.backgroundImgFileBeingDragged = nil;
        self.methodNameBeingDragged = nil;
        self.viewBeingDragged = nil;
        self.insertedCellData = nil;
        [self.programView setBackgroundColor:[UIColor daisyProgramGrayColor]];
    }
 }

- (void) deleteFromScript: (UIPinchGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        ScriptViewCell *cell = (ScriptViewCell *)gesture.view;
        int index = cell.tag;
        if (self.scripts.count > index)
        {
            [self.scripts removeObjectAtIndex:index];
            [self.programTableView reloadData];
        }
    }
    
}

@end
