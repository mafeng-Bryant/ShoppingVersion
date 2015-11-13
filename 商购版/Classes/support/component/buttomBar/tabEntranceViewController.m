//
//  tabEntranceViewController.m
//
//  Created by MC374 on 12-7-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Common.h"

#import "tabEntranceViewController.h"
#import "homeViewController.h"
#import "productViewController.h"
#import "carViewController.h"
#import "LoginViewController.h"
#import "boxViewController.h"
#import "DataManager.h"
#import "FileManager.h"
#import "shoppingAppDelegate.h"
#import "DDMenuController.h"
#import "ShopCateViewController.h"
#import "CustomTabBar.h"
#import "subCatProductViewController.h"

@implementation tabEntranceViewController
@synthesize chooseVC;
@synthesize homeView;
@synthesize productView;
@synthesize carView;
@synthesize loginView;
@synthesize boxView;
@synthesize logoview;

- (id)init{
	self = [super init];//调用父类初始化函数
	if (self != nil) 
	{	
		NSArray *tabArray = [[NSArray alloc] initWithObjects:@"首页",@"逛逛",@"购物车",@"会员",@"百宝箱",nil];
		NSMutableArray *controllers = [NSMutableArray array];
		for(int i = 0; i < [tabArray count]; i++){
			NSString *keyName = [tabArray objectAtIndex:i];
			NSString *titleName = keyName;
			if ([keyName isEqualToString : @"首页"] ){
				homeViewController *tempHomeView = [[homeViewController alloc] init];
				UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:titleName ofType:@"png"]];
				[tempHomeView.tabBarItem initWithTitle:titleName image:img tag:0];
				[img release];
                self.homeView = tempHomeView;
				[tempHomeView release];
				[controllers addObject:self.homeView];
			}else if([keyName isEqualToString : @"逛逛"]){
                productViewController *tempProductView = [[productViewController alloc] init];
				UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:titleName ofType:@"png"]];
				[tempProductView.tabBarItem initWithTitle:titleName image:img tag:0];
				[img release];
				self.productView = tempProductView;
                [tempProductView release];
//				[controllers addObject:self.productView];
                
                rootController = [[DDMenuController alloc] initWithRootViewController:productView];
                rootController.delegate = self;
                
                productView.delegate = rootController;
                //添加左边的分类列表
                ShopCateViewController *leftController = [[ShopCateViewController alloc] init];
                leftController.menuController = rootController;
                rootController.leftViewController = leftController;
                [controllers addObject:rootController];
			} else if ([keyName isEqualToString : @"购物车"]){
				carViewController *tempCarView = [[carViewController alloc]init];
				UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:titleName ofType:@"png"]];
				[tempCarView.tabBarItem initWithTitle:titleName image:img tag:0];
				[img release];
				self.carView = tempCarView;
				[tempCarView release];
				[controllers addObject:self.carView];
			}else if ([keyName isEqualToString : @"会员"]) {
				LoginViewController *tempMemberView = [[LoginViewController alloc]init];
				UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:titleName ofType:@"png"]];
				[tempMemberView.tabBarItem initWithTitle:titleName image:img tag:0];
				[img release];
				self.loginView = tempMemberView;
				[tempMemberView release];
				[controllers addObject:self.loginView];
			}else if ([keyName isEqualToString : @"百宝箱"] ){
				boxViewController *tempBoxView = [[boxViewController alloc]init];
				UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:titleName ofType:@"png"]];
				[tempBoxView.tabBarItem initWithTitle:titleName image:img tag:0];
				[img release];
				self.boxView = tempBoxView;
				[tempBoxView release];
				[controllers addObject:self.boxView];
			}
		}
		
		self.viewControllers = controllers;
		self.customizableViewControllers = controllers;		
		self.delegate = self;
		
		self.view.backgroundColor = [UIColor clearColor];
		
	}
#ifdef SHOW_NAV_TAB_BG	
	UIView *v = [[UIView alloc] initWithFrame:self.view.frame];
	UIImage *img = [UIImage imageNamed:TAB_BG_PIC];
	UIColor *bcolor = [[UIColor alloc] initWithPatternImage:img];
	v.backgroundColor = bcolor;
	[self.tabBar insertSubview:v atIndex:0];
	self.tabBar.opaque = YES;
	[bcolor release];
	[v release];
#else
	CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, 49);
	UIView *view = [[UIView alloc] initWithFrame:frame];
	UIColor *color = [UIColor colorWithRed:BTO_COLOR_RED green:BTO_COLOR_GREEN blue:BTO_COLOR_BLUE alpha:0.6];
	[view setBackgroundColor:color];
	[[self tabBar] insertSubview:view atIndex:0];
	[[self tabBar] setAlpha:1];
	[view release];
#endif
	
	return self;
}

- (void) viewDidLoad{
	[super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     NSLog(@"self.navigationController.view.frame.size.height:%f",self.navigationController.view.frame.size.height);
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    if ([self selectedIndex] == 1) {
//        self.navigationController.view.frame = CGRectMake(self.navigationController.view.frame.origin.x, self.navigationController.view.frame.origin.y, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height);
//    }
}

- (void) viewDidUnload{
	[super viewDidUnload];
	self.chooseVC = nil;
	self.homeView = nil;
	self.productView = nil;
	self.carView = nil;
	self.loginView = nil;
	self.boxView = nil;
	self.logoview = nil;
}

-(void)dealloc{
    self.chooseVC = nil;
	self.homeView = nil;
	self.productView = nil;
	self.carView = nil;
	self.loginView = nil;
	self.boxView = nil;
	self.logoview = nil;
    [rootController release],rootController = nil;
    [navController release],navController = nil;
	[super dealloc];
}

- (void)hideRealTabBar{
	for(UIView *view in self.view.subviews){
		if([view isKindOfClass:[UITabBar class]]){
			view.hidden = YES;
			break;
		}
	}
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
	
	@try {
		int selectedIndextmp = [self selectedIndex];
		
		if(selectedIndextmp == 0)
        {
            self.navigationItem.titleView = logoview;
			self.title = nil;
			[chooseVC.view removeFromSuperview];
            self.navigationItem.leftBarButtonItem = nil;
			self.navigationItem.rightBarButtonItem = nil;
		}else if(selectedIndextmp == 1){
            rootController.superViewController = self;
            [chooseVC.view removeFromSuperview];
            self.title = nil;
//			self.navigationItem.titleView = nil;
//			self.title = @"逛逛";
//          self.navigationItem.leftBarButtonItem = nil;
//			self.navigationItem.rightBarButtonItem = nil;
            
		}else if(selectedIndextmp == 2){
			self.navigationItem.titleView = nil;
			self.title = @"我的购物车";
			[chooseVC.view removeFromSuperview];
            self.navigationItem.leftBarButtonItem = nil;
			//self.navigationItem.rightBarButtonItem = nil;
		}else if(selectedIndextmp == 3){
			self.navigationItem.titleView = nil;
			//self.title = @"会员中心";
			[chooseVC.view removeFromSuperview];
            self.navigationItem.leftBarButtonItem = nil;
			//self.navigationItem.rightBarButtonItem = nil;
            if (_isLogin == YES) {
				loginView.memberCenter.view.hidden = NO;
				[loginView.memberCenter viewAppearAction];
			}else {
				loginView.memberCenter.view.hidden = YES;
			}
		}else if(selectedIndextmp == 4){
			self.navigationItem.titleView = nil;
			self.title = @"百宝箱";
			[chooseVC.view removeFromSuperview];
            self.navigationItem.leftBarButtonItem = nil;
			self.navigationItem.rightBarButtonItem = nil;
		}
		
	}
	@catch (NSException *exception) {
		NSLog(@"tabchoose: Caught %@: %@", [exception name], [exception reason]);
		return;
	}
}

#pragma mark DDMenuControllerDelegate
- (void)menuController:(DDMenuController*)controller1 willShowViewController:(UIViewController*)controller2{
    
    if (controller2 == nil) {
        NSArray *arrayViewControllers = self.navigationController.viewControllers;
        if ([[arrayViewControllers objectAtIndex:0] isKindOfClass:[CustomTabBar class]])
        {
            //CustomTabBar *tabViewController = [arrayViewControllers objectAtIndex:0];
            //[tabViewController showTabBarWithAnimation];
        }
    }else{
        NSArray *arrayViewControllers = self.navigationController.viewControllers;
        if ([[arrayViewControllers objectAtIndex:0] isKindOfClass:[CustomTabBar class]])
        {
            //CustomTabBar *tabViewController = [arrayViewControllers objectAtIndex:0];
            //[tabViewController hideTabBarWithAnimation];
            
        }
        //self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height+49);
    }
}

- (void) handleToProduct:(UIButton*)button{
    int tag = button.tag;
    
    subCatProductViewController *subCatProductView = [[subCatProductViewController alloc] init];
    
    if (isFirstLoadTabBar) {
        //self.navigationController.view.frame = CGRectMake(self.navigationController.view.frame.origin.x, 20, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height+49);
    }
    isFirstLoadTabBar = NO;
    subCatProductView.catId = [NSString stringWithFormat:@"%d",tag];
    [self.navigationController pushViewController:subCatProductView animated:YES];
    [subCatProductView release];
    
    [self pvAction:tag];
}

- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{

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
