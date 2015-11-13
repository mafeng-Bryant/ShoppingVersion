//
//  MyCommentViewController.m
//  shopping
//
//  Created by 来 云 on 13-1-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MyCommentViewController.h"
#import "Common.h"
#import "DBOperate.h"
@interface MyCommentViewController ()

@end

@implementation MyCommentViewController
@synthesize userId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"我的评价";
    
    UIImage *backgroundImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"表的背景" ofType:@"png"]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    
    NSArray *imageArr = [[NSArray alloc] initWithObjects:@"切换标签1.png",@"切换标签2.png",nil];
    segmentView = [[CustomSegment alloc] initWithSelectedImgArray:imageArr point:CGPointMake(0, 0)titleArray:[NSArray arrayWithObjects:@"待评价商品",@"已发表评论", nil]];
    segmentView.delegate = self;
    [self.view addSubview:segmentView];
    
    uncommentViewController = [[UnCommentViewController alloc] init];
    uncommentViewController.userId = self.userId;
    uncommentViewController.myCommentView = self;
    uncommentViewController.view.frame = CGRectMake(0, 45, 320, self.view.frame.size.height - 45);
    [self.view addSubview:uncommentViewController.view];
    uncommentViewController.view.hidden = NO;
    
    commentViewController = [[CommentedViewController alloc] init];
    commentViewController.userId = self.userId;
    commentViewController.myCommentView = self;
    commentViewController.view.frame = CGRectMake(0, 45, 320, self.view.frame.size.height - 45);
    [self.view addSubview:commentViewController.view];
    commentViewController.view.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([commentViewController.type  intValue] == 1) {
        [segmentView setSelectedIndex:1];
    }else {
        [segmentView setSelectedIndex:0];
    }
}

- (void)dealloc
{
    [uncommentViewController release];
    [commentViewController release];
    [progressHUD release];
    [userId release];
    [super dealloc];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark ------ CustomSegmentDelegate method
- (void)segmentWithIndex:(int)index
{
    NSLog(@"index====%d",index);
    if (index == 0) {
        uncommentViewController.view.hidden = NO;
        commentViewController.view.hidden = YES;
        [uncommentViewController addView];
    }else {
        uncommentViewController.view.hidden = YES;
        commentViewController.view.hidden = NO;
        [commentViewController addView];
    }
    
}
@end
