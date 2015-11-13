//
//  subCatProductViewController.m
//  subCatProduct
//
//  Created by lai yun on 12-12-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "subCatProductViewController.h"
#import "Common.h"
#import "DBOperate.h"
#import "LightMenuBar.h"

@interface subCatProductViewController ()

@end

@implementation subCatProductViewController

@synthesize myWaterFlowView;
@synthesize productTableView;
@synthesize showType;
@synthesize waterFlowButton;
@synthesize productTableButton;
@synthesize catId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *ay = [DBOperate queryData:T_PRODUCT_CAT theColumn:@"id" theColumnValue:catId withAll:NO];
    if (ay != nil && [ay count] > 0) {
        self.title = [[ay objectAtIndex:0] objectAtIndex:product_cat_name];
    }
    
    
    //显示方式切换按钮
    UIView* operatButtonView = [[UIView alloc] initWithFrame:CGRectMake( 0.0f , 0.0f , 62.0f , 44.0f )];
    
    UIButton *tempWaterFlowButton = [UIButton buttonWithType:UIButtonTypeCustom];  
    tempWaterFlowButton.frame = CGRectMake(0.0f, 6.0f, 31.0f, 31.0f);  
    [tempWaterFlowButton addTarget:self action:@selector(showWaterFlow) forControlEvents:UIControlEventTouchDown];
    [tempWaterFlowButton setImage:[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"瀑布流切换按钮" ofType:@"png"]] forState:UIControlStateNormal]; 
    [tempWaterFlowButton setImage:[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"瀑布流切换按钮选中" ofType:@"png"]] forState:UIControlStateSelected];
    self.waterFlowButton = tempWaterFlowButton;
    [operatButtonView addSubview:self.waterFlowButton];
    
    UIButton *tempProductTableButton = [UIButton buttonWithType:UIButtonTypeCustom];  
    tempProductTableButton.frame = CGRectMake(31.0f, 6.0f, 31.0f, 31.0f);  
    [tempProductTableButton addTarget:self action:@selector(showProductTable) forControlEvents:UIControlEventTouchDown];
    [tempProductTableButton setBackgroundImage:[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品列表切换按钮" ofType:@"png"]] forState:UIControlStateNormal];
    [tempProductTableButton setBackgroundImage:[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品列表切换按钮选中" ofType:@"png"]] forState:UIControlStateSelected];
    self.productTableButton = tempProductTableButton;
    [operatButtonView addSubview:self.productTableButton];
    
    UIBarButtonItem *operatButton = [[UIBarButtonItem alloc] initWithCustomView:operatButtonView]; 
    self.navigationItem.rightBarButtonItem = operatButton;
    [operatButton release]; 
    [operatButtonView release];
    
    
    //在这 添加瀑布流 视图
    myWaterFlowViewController *tempMyWaterFlowView = [[myWaterFlowViewController alloc] init];
    tempMyWaterFlowView.view.frame = CGRectMake( 0.0f , 0.0f ,self.view.frame.size.width , self.view.frame.size.height);
    tempMyWaterFlowView.view.backgroundColor = [UIColor clearColor];
    tempMyWaterFlowView.view.hidden = NO;
    tempMyWaterFlowView.myTableViewHeight = self.view.frame.size.height - 44.0f;
    self.myWaterFlowView = tempMyWaterFlowView;
    [tempMyWaterFlowView release];
    [self.view addSubview:self.myWaterFlowView.view];
    
    //在这 添加普通商品列表 
    productTableViewController *tempProductTableView = [[productTableViewController alloc] init];
    tempProductTableView.view.frame = CGRectMake( 0.0f , 0.0f ,self.view.frame.size.width , self.view.frame.size.height);
    tempProductTableView.view.backgroundColor = [UIColor clearColor];
    tempProductTableView.view.hidden = YES;
    tempProductTableView.myTableViewHeight = self.view.frame.size.height - 44.0f;
    self.productTableView = tempProductTableView;
    [tempProductTableView release];
    [self.view addSubview:self.productTableView.view];
    
    //增加的遮盖图层
    UIImage *coverImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"上bar底部遮盖" ofType:@"png"]];
    UIImageView *coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f , 0.0f , coverImage.size.width , coverImage.size.height)];
    coverImageView.image = coverImage;
    [coverImage release];
    [self.view addSubview:coverImageView];
	[coverImageView release];

    //默认瀑布流显示
    self.showType = 1;
    [self.waterFlowButton setSelected:YES];
    
    if (self.showType == 1)
    {
        //注册监视
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(showProductTableView) 
                                                     name:@"showProductTable" 
                                                   object:nil];
        //瀑布流 视图
        self.myWaterFlowView.currentCatId = self.catId;
        [self.myWaterFlowView showWaterFlowView];
    }
    else if(self.showType == 2)
    {
        //注册监视
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(showWaterFlowView) 
                                                     name:@"showWaterFlow" 
                                                   object:nil];
        //普通商品列表
        self.productTableView.currentCatId = self.catId;
        [self.productTableView showProductTableView];
    }
	
}

//商品瀑布流展示
-(void)showWaterFlow
{
    if (!self.waterFlowButton.selected) 
    {
        //如果正在网络请求 禁止切换
        if (!self.productTableView._reloading && !self.productTableView._loadingMore) 
        {
            self.showType = 1;
            [self.waterFlowButton setSelected:YES];
            [self.productTableButton setSelected:NO];
            [self showViewWithAnimated];
        }
    }
}

//商品普通列表展示
-(void)showProductTable
{
    if (!self.productTableButton.selected) 
    {
        //如果正在网络请求 禁止切换
        if (!self.myWaterFlowView._reloading && !self.myWaterFlowView._loadingMore) 
        {
            self.showType = 2;
            [self.waterFlowButton setSelected:NO];
            [self.productTableButton setSelected:YES];
            [self showViewWithAnimated];
        }
    }
}


//动画切换
-(void)showViewWithAnimated
{
    if (showType == 1)
    {
        self.productTableView.view.hidden = YES;
        [UIView beginAnimations:nil context:self.myWaterFlowView.view];
        [UIView setAnimationDuration:1];
        self.myWaterFlowView.view.hidden = NO;
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:YES];
        [UIView commitAnimations];
        
    }
    else if(showType == 2)
    {
        self.myWaterFlowView.view.hidden = YES;
        [UIView beginAnimations:nil context:self.productTableView.view];
        [UIView setAnimationDuration:1];
        self.productTableView.view.hidden = NO;
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:YES];
        [UIView commitAnimations];
    }
}

//显示瀑布流
-(void)showWaterFlowView
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showWaterFlow" object:nil];
    self.myWaterFlowView.currentCatId = self.productTableView.currentCatId;
    [self.myWaterFlowView showWaterFlowView];
}

//显示普通列表
-(void)showProductTableView
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showProductTable" object:nil];
    self.productTableView.currentCatId = self.myWaterFlowView.currentCatId;
    [self.productTableView showProductTableView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.myWaterFlowView = nil;
    self.productTableView = nil;
    self.waterFlowButton = nil;
    self.productTableButton = nil;
    self.catId = nil;
}

- (void)dealloc 
{
    self.myWaterFlowView = nil;
    self.productTableView = nil;
    self.waterFlowButton = nil;
    self.productTableButton = nil;
    self.catId = nil;
    [super dealloc];
}

@end
