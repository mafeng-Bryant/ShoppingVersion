//
//  productViewController.m
//  shopping
//
//  Created by lai yun on 12-12-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "productViewController.h"
#import "Common.h"
#import "DBOperate.h"
#import "LightMenuBar.h"
#import "CustomTabBar.h"
#import "shoppingAppDelegate.h"

@interface productViewController ()

@end

@implementation productViewController

@synthesize delegate;
@synthesize myMenuBar;
@synthesize productCatItems;
@synthesize spinner;
@synthesize myWaterFlowView;
@synthesize productTableView;
@synthesize showType;
@synthesize waterFlowButton;
@synthesize productTableButton;
@synthesize titleLabel;

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
	
	//商品分类数据初始化
	NSMutableArray *tempProductCatArray = [[NSMutableArray alloc] init];
	self.productCatItems = tempProductCatArray;
	[tempProductCatArray release];
    
    //上bar
//    UIImage *topBarImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NAV_BG_PIC ofType:nil]];
    UIImage *topBarImage = nil;
    if (IOS_VERSION >= 7.0) {
        topBarImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:IOS7_NAV_BG_PIC ofType:nil]];
    }else{
        topBarImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NAV_BG_PIC ofType:nil]];
    }
    UIImageView *topBarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f , 0.0f , self.view.frame.size.width , topBarImage.size.height)];
	topBarImageView.image = topBarImage;
	[topBarImage release];
    
    //标题
    CGFloat yValue = IOS_VERSION < 7.0 ? 0.0f : 20.0f;
    UILabel *tempTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0f , yValue , topBarImageView.frame.size.width , topBarImageView.frame.size.height - yValue)];
    tempTitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0f];
    tempTitleLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    tempTitleLabel.text = @"逛逛";		
    tempTitleLabel.textAlignment = UITextAlignmentCenter;
    tempTitleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel = tempTitleLabel;
    [topBarImageView addSubview:self.titleLabel];
    [tempTitleLabel release];
    
    [self.view addSubview:topBarImageView];
	[topBarImageView release];
    
    //商品分类按钮
    
    CGFloat y1 = IOS_VERSION < 7.0 ? 2.0f : 20.0f + 2.0f;
    UIButton *productCatButton = [UIButton buttonWithType:UIButtonTypeCustom];  
    productCatButton.frame = CGRectMake(5.0f, y1, 40.0f, 40.0f);
    [productCatButton addTarget:self action:@selector(productCat) forControlEvents:UIControlEventTouchDown];
    [productCatButton setBackgroundImage:[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品分类按钮" ofType:@"png"]] forState:UIControlStateNormal];
    
    [self.view addSubview:productCatButton];
    
    //显示方式切换按钮
    CGFloat y2 = IOS_VERSION < 7.0 ? 0.0f : 20.0f;
    UIView* operatButtonView = [[UIView alloc] initWithFrame:CGRectMake( 250.0f , y2 , 62.0f , 44.0f )];
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
    [self.view addSubview:operatButtonView];
    
    
    //在这 添加瀑布流 视图
    CGFloat y3 = IOS_VERSION < 7.0 ? 44.0f + 40.0f : 20.0f + 44.0f + 40.0f;
    myWaterFlowViewController *tempMyWaterFlowView = [[myWaterFlowViewController alloc] init];
    tempMyWaterFlowView.view.frame = CGRectMake( 0.0f , y3 ,self.view.frame.size.width , VIEW_HEIGHT - 20.0f - y3);
    tempMyWaterFlowView.view.backgroundColor = [UIColor clearColor];
    tempMyWaterFlowView.view.hidden = YES;
    self.myWaterFlowView = tempMyWaterFlowView;
    [tempMyWaterFlowView release];
    [self.view addSubview:self.myWaterFlowView.view];
    
    //在这 添加普通商品列表 
    productTableViewController *tempProductTableView = [[productTableViewController alloc] init];
    tempProductTableView.view.frame = CGRectMake( 0.0f , y3 ,self.view.frame.size.width , VIEW_HEIGHT - 20.0f - y3);
    tempProductTableView.view.backgroundColor = [UIColor clearColor];
    tempProductTableView.view.hidden = YES;
    self.productTableView = tempProductTableView;
    [tempProductTableView release];
    [self.view addSubview:self.productTableView.view];

    //添加loading图标
	UIActivityIndicatorView *tempSpinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
	[tempSpinner setCenter:CGPointMake(self.view.frame.size.width / 3, self.view.frame.size.height / 2.0)];
	self.spinner = tempSpinner;
	UILabel *loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 100, 20)];
	loadingLabel.font = [UIFont systemFontOfSize:14];
	loadingLabel.textColor = [UIColor colorWithRed:0.5 green: 0.5 blue: 0.5 alpha:1.0];
	loadingLabel.text = LOADING_TIPS;		
	loadingLabel.textAlignment = UITextAlignmentCenter;
	loadingLabel.backgroundColor = [UIColor clearColor];
	[self.spinner addSubview:loadingLabel];
    [loadingLabel release];
	[self.view addSubview:self.spinner];
	[self.spinner startAnimating];
	[tempSpinner release];
    
    //默认瀑布流显示
    [self showWaterFlow];
    
    //网络请求
    [self accessCatService];
	
}


//添加滚动分类导航
-(void)addCatNat
{
    CGFloat fixY = IOS_VERSION < 7.0 ? 44.0f : 20.0f + 44.0f;
    //背景
    UIImageView *natBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake( 0 , fixY , self.view.frame.size.width , 40.0f)];
    UIImage *backImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"共用二级bar背景" ofType:@"png"]];
    natBackImageView.image = backImage;
    [self.view addSubview:natBackImageView];
    
    //分类滚动导航
	LightMenuBar *tempMenuBar = [[LightMenuBar alloc] initWithFrame:CGRectMake(16, fixY, 288.0f, 40.0f) andStyle:LightMenuBarStyleItem];
	//LightMenuBar *menuBar = [[LightMenuBar alloc] initWithFrame:CGRectMake(0, 20, 320, 40) andStyle:LightMenuBarStyleButton];
    tempMenuBar.delegate = self;
    tempMenuBar.bounces = YES;
    tempMenuBar.selectedItemIndex = 0;
    tempMenuBar.backgroundColor = [UIColor clearColor];
    self.myMenuBar = tempMenuBar;
    [self.view addSubview:self.myMenuBar];
    
    //左边滚动按钮
	UIImageView *leftButton = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, fixY, 20.0f, 40.0f)];
	leftButton.image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"导航栏left_arrow" ofType:@"png"]];
	
	//绑定点击事件
	leftButton.userInteractionEnabled = YES;
	UITapGestureRecognizer *leftSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goLeft)];
	[leftButton addGestureRecognizer:leftSingleTap];
	[leftSingleTap release];
	
	[self.view addSubview:leftButton];
	[leftButton release];
    
    //右边滚动按钮
	UIImageView *rightButton = [[UIImageView alloc]initWithFrame:CGRectMake(300.0f, fixY, 20.0f, 40.0f)];
	rightButton.image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"导航栏right_arrow" ofType:@"png"]];
	
	//绑定点击事件
	rightButton.userInteractionEnabled = YES;
	UITapGestureRecognizer *rightSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goRight)];
	[rightButton addGestureRecognizer:rightSingleTap];
	[rightSingleTap release];
	
	[self.view addSubview:rightButton];
	[rightButton release];
    
    //增加的遮盖图层
    UIImage *coverImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"上bar底部遮盖" ofType:@"png"]];
    UIImageView *coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f , CGRectGetMaxY(self.myMenuBar.frame) , coverImage.size.width , coverImage.size.height)];
    coverImageView.image = coverImage;
    [coverImage release];
    [self.view addSubview:coverImageView];
	[coverImageView release];
    
}

//商品分类按钮
-(void)productCat
{
    [self.delegate productBtnAction:YES];
//    shoppingAppDelegate *delegate =  (shoppingAppDelegate *)[UIApplication sharedApplication].delegate;
//    NSArray *arrayViewControllers = delegate.navController.viewControllers;
//    if ([[arrayViewControllers objectAtIndex:0] isKindOfClass:[CustomTabBar class]])
//    {
//        CustomTabBar *tabViewController = [arrayViewControllers objectAtIndex:0];
//        [tabViewController hideTabBarWithAnimation];
//        tabViewController.view.frame = CGRectMake(0, 0, tabViewController.view.frame.size.width, tabViewController.view.frame.size.height+49);
//    }
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
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
        [UIView commitAnimations];
        
    }
    else if(showType == 2)
    {
        self.myWaterFlowView.view.hidden = YES;
        [UIView beginAnimations:nil context:self.productTableView.view];
        [UIView setAnimationDuration:1];
        self.productTableView.view.hidden = NO;
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
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

//向左滚动
-(void)goLeft
{
    [self.myMenuBar goLeftOrRight:@"left" animated:YES];
}

//向右滚动
-(void)goRight
{
    [self.myMenuBar goLeftOrRight:@"right" animated:YES];
}


//网络获取分类数据
-(void)accessCatService
{
	NSString *reqUrl = @"product/cats.do?param=%@";
	
	NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
								 [Common getSecureString],@"keyvalue",
								 [Common getVersion:OPERAT_PRODUCT_CAT_REFRESH],@"ver",
								 [NSNumber numberWithInt: SITE_ID],@"site_id",
                                 nil];
	
	[[DataManager sharedManager] accessService:jsontestDic 
									   command:OPERAT_PRODUCT_CAT_REFRESH 
								  accessAdress:reqUrl
									  delegate:self 
									 withParam:nil];
}

//更新商品分类的操作
-(void)updateProductCat
{
    //从数据库中取出数据 
   self.productCatItems = (NSMutableArray *)[DBOperate queryData:T_PRODUCT_CAT theColumn:@"parent_id" theColumnValue:[NSString stringWithFormat:@"%d",0] orderBy:@"sort_order" orderType:@"desc" withAll:NO];
	
	if ([self.productCatItems count] == 0) 
	{
		UILabel *noneLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 54, 180, 20)];
		noneLabel.font = [UIFont systemFontOfSize:14];
		noneLabel.textColor = [UIColor colorWithRed:0.5 green: 0.5 blue: 0.5 alpha:1.0];
		noneLabel.text = @"暂无商品分类";			
		noneLabel.textAlignment = UITextAlignmentCenter;
		noneLabel.backgroundColor = [UIColor clearColor];
		[self.view addSubview:noneLabel];
		[noneLabel release];
	}
	else 
	{
		//添加分类导航
		[self addCatNat];
	}
    
    //设置回常态
	[self backNormal];
}

//回归常态
-(void)backNormal
{
	//loading图标移除
	if (self.spinner != nil) {
		[self.spinner stopAnimating];
	}
}

//网络请求回调函数
- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver;
{
	[self performSelectorOnMainThread:@selector(updateProductCat) withObject:nil waitUntilDone:NO];
}



#pragma mark 滚动导航委托 LightMenuBarDelegate
- (NSUInteger)itemCountInMenuBar:(LightMenuBar *)menuBar {
	
	return [self.productCatItems count];
	
}

- (NSString *)itemTitleAtIndex:(NSUInteger)index inMenuBar:(LightMenuBar *)menuBar {
	
	NSArray *productCatArray = [self.productCatItems objectAtIndex:index];
	return [productCatArray objectAtIndex:product_cat_name];
	
}

- (void)itemSelectedAtIndex:(NSUInteger)index inMenuBar:(LightMenuBar *)menuBar {
	
	//设置回常态
	[self backNormal];
	
	NSArray *productCatArray = [self.productCatItems objectAtIndex:index];
	NSString *cat_id = [productCatArray objectAtIndex:product_cat_id];
    
    self.titleLabel.text = [productCatArray objectAtIndex:product_cat_name];
	
    [self pvAction:[cat_id intValue]];
    
    if (self.showType == 1)
    {
        //注册监视
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(showProductTableView) 
                                                     name:@"showProductTable" 
                                                   object:nil];
        //瀑布流 视图
        self.myWaterFlowView.currentCatId = cat_id;
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
        self.productTableView.currentCatId = cat_id;
        [self.productTableView showProductTableView];
    }
}

//< Optional
- (CGFloat)itemWidthAtIndex:(NSUInteger)index inMenuBar:(LightMenuBar *)menuBar {
	
	if ([self.productCatItems count] > 3) 
	{
		return self.myMenuBar.frame.size.width / 3;
	}
	else 
	{
		return self.myMenuBar.frame.size.width / [self.productCatItems count];
	}
	
}

/****************************************************************************/
//< For Background Area
/****************************************************************************/

/**< Top and Bottom Padding, by Default 5.0f */
- (CGFloat)verticalPaddingInMenuBar:(LightMenuBar *)menuBar {
    return 0.0f;
}

/**< Left and Right Padding, by Default 5.0f */
- (CGFloat)horizontalPaddingInMenuBar:(LightMenuBar *)menuBar {
    return 0.0f;
}

/**< Corner Radius of the background Area, by Default 5.0f */
- (CGFloat)cornerRadiusOfBackgroundInMenuBar:(LightMenuBar *)menuBar {
    return 0.0f;
}

- (UIColor *)colorOfBackgroundInMenuBar:(LightMenuBar *)menuBar {
    //return [UIColor blackColor];
	return [UIColor clearColor];
}

/****************************************************************************/
//< For Button 
/****************************************************************************/

/**< Corner Radius of the Button highlight Area, by Default 5.0f */
- (CGFloat)cornerRadiusOfButtonInMenuBar:(LightMenuBar *)menuBar {
    return 1.0f;
}

- (UIColor *)colorOfButtonHighlightInMenuBar:(LightMenuBar *)menuBar {
    //return [UIColor whiteColor];
	//return [UIColor colorWithRed:0.9 green:0.4 blue:0.0 alpha:1.0f];
    NSString *checkedImgName;
    if ([self.productCatItems count] > 3) 
	{
		checkedImgName = @"导航栏3选中";
	}
	else 
	{
		checkedImgName = [NSString stringWithFormat:@"导航栏%d选中",[self.productCatItems count]];
	}
    
    UIImage *currentCheckedBackground = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:checkedImgName ofType:@"png"]];
    return [UIColor colorWithPatternImage:currentCheckedBackground];
    
}

- (UIColor *)colorOfTitleNormalInMenuBar:(LightMenuBar *)menuBar {
    return [UIColor whiteColor];
}

- (UIColor *)colorOfTitleHighlightInMenuBar:(LightMenuBar *)menuBar {
    return [UIColor whiteColor];
}

- (UIFont *)fontOfTitleInMenuBar:(LightMenuBar *)menuBar {
    return [UIFont systemFontOfSize:15.0f];
}

/****************************************************************************/
//< For Seperator 
/****************************************************************************/

///**< Color of Seperator, by Default White */
//- (UIColor *)seperatorColorInMenuBar:(LightMenuBar *)menuBar {
//}

/**< Width of Seperator, by Default 1.0f */
- (CGFloat)seperatorWidthInMenuBar:(LightMenuBar *)menuBar {
    return 0.0f;
}

/**< Height Rate of Seperator, by Default 0.7f */
- (CGFloat)seperatorHeightRateInMenuBar:(LightMenuBar *)menuBar {
    return 0.0f;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.delegate = nil;
	self.productCatItems = nil;
    self.myMenuBar.delegate = nil;
    self.myMenuBar = nil;
	self.spinner = nil;
    self.myWaterFlowView = nil;
    self.productTableView = nil;
    self.waterFlowButton = nil;
    self.productTableButton = nil;
    self.titleLabel = nil;
}

- (void)dealloc 
{
    [self.delegate release];
    self.productCatItems = nil;
    self.myMenuBar.delegate = nil;
    self.myMenuBar = nil;
	self.spinner = nil;
    self.myWaterFlowView = nil;
    self.productTableView = nil;
    self.waterFlowButton = nil;
    self.productTableButton = nil;
    self.titleLabel = nil;
    [super dealloc];
}

//数据统计
- (void)pvAction:(int)_id
{
    NSDate* nowDate = [NSDate date];
    NSDateFormatter *outputFormat = [[NSDateFormatter alloc] init];
    [outputFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [outputFormat stringFromDate:nowDate];
    NSDate *currentDate = [outputFormat dateFromString:dateString];
    [outputFormat release];
    NSTimeInterval t = [currentDate timeIntervalSince1970];   //转化为时间戳
    long long int time = (long long int)t;
    NSNumber *num = [NSNumber numberWithLongLong:time];
    int currentInt = [num intValue];
    NSLog(@"currentInt ==== %d",currentInt);
    
    NSDate* date1 = [NSDate dateWithTimeIntervalSince1970:currentInt];
    NSDateFormatter *outputFormat1 = [[NSDateFormatter alloc] init];
    [outputFormat1 setDateFormat:@"yyyy-MM-dd HH"];
    NSString *dateString1 = [outputFormat1 stringFromDate:date1];
    NSDate *currentDate1 = [outputFormat1 dateFromString:dateString1];
    [outputFormat1 release];
    NSTimeInterval t1 = [currentDate1 timeIntervalSince1970];   //转化为时间戳
    long long int time1 = (long long int)t1;
    NSNumber *num1 = [NSNumber numberWithLongLong:time1];
    int leftInt = [num1 intValue];
    int rightInt = leftInt + 60 * 60;
    
    NSArray *arr = [DBOperate queryData:T_CATS_ACCESS oneColumn:@"currentTime" equalValue:[NSString stringWithFormat:@"%d",leftInt] twoColumn:@"currentTime" equalValue:[NSString stringWithFormat:@"%d",rightInt] threeColumn:@"catId" equalValue:[NSString stringWithFormat:@"%d",_id]];
    if ([arr count] == 0) {
        NSArray *item = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:_id],[NSNumber numberWithInt:currentInt],[NSNumber numberWithInt:1], nil];
        [DBOperate insertDataWithnotAutoID:item tableName:T_CATS_ACCESS];
    }else {
        [DBOperate deleteDataWithTwoConditions:T_CATS_ACCESS oneColumn:@"currentTime" oneValue:[NSString stringWithFormat:@"%d",leftInt] twoColumn:@"currentTime" twoValue:[NSString stringWithFormat:@"%d",rightInt] threeColumn:@"catId" threeValue:[NSString stringWithFormat:@"%d",_id]];
        
        NSMutableArray *listArr = [arr objectAtIndex:0];
        
        int count = [[listArr objectAtIndex:cats_access_visitCount] intValue];
        
        NSArray *item = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:_id],[NSNumber numberWithInt:currentInt],[NSNumber numberWithInt:count + 1], nil];
        [DBOperate insertDataWithnotAutoID:item tableName:T_CATS_ACCESS];
    }
}
@end
