//
//  MyCollectionViewController.m
//  shopping
//
//  Created by 来 云 on 13-1-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "Common.h"
#import "DBOperate.h"
@interface MyCollectionViewController ()

@end

@implementation MyCollectionViewController

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
	self.title = @"我的收藏";
    
    NSArray *imageArr = [[NSArray alloc] initWithObjects:@"切换标签1.png",@"切换标签2.png",nil];
    segmentView = [[CustomSegment alloc] initWithSelectedImgArray:imageArr point:CGPointMake(0, 0)titleArray:[NSArray arrayWithObjects:@"商品",@"资讯", nil]];
    segmentView.delegate = self;
    [self.view addSubview:segmentView];
    
    productsViewController = [[MyProductsViewController alloc] init];
    productsViewController.collectView = self;
    productsViewController.view.frame = CGRectMake(0, 40, 320, self.view.frame.size.height - 40);
    [self.view addSubview:productsViewController.view];
    productsViewController.view.hidden = NO;
    
    newsViewController = [[MyNewsViewController alloc] init];
    newsViewController.collectView = self;
    newsViewController.view.frame = CGRectMake(0, 40, 320, self.view.frame.size.height - 40);
    [self.view addSubview:newsViewController.view];
    newsViewController.view.hidden = YES;
    
    [segmentView setSelectedIndex:0];
}

- (void)dealloc
{
    [productsViewController release];
    [newsViewController release];
    [progressHUD release];
    
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
        productsViewController.view.hidden = NO;
        newsViewController.view.hidden = YES;
        [productsViewController addView];
    }else {
        productsViewController.view.hidden = YES;
        newsViewController.view.hidden = NO;
        [newsViewController addView];
    }
    
}

@end
