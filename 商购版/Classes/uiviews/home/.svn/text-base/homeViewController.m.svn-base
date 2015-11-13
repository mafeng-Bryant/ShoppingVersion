//
//  homeViewController.m
//  shopping
//
//  Created by lai yun on 12-12-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "homeViewController.h"
#import "Common.h"
#import "indexViewController.h"
#import "recommendViewController.h"
#import "specialOfferViewController.h"

@interface UINavigationItem (margin)

@end
@implementation UINavigationItem (margin)
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
- (void)setLeftBarButtonItem:(UIBarButtonItem *)_leftBarButtonItem
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -10;
        
        if (_leftBarButtonItem)
        {
            [self setLeftBarButtonItems:@[negativeSeperator, _leftBarButtonItem]];
        }
        else
        {
            [self setLeftBarButtonItems:@[negativeSeperator]];
        }
        [negativeSeperator release];
    }
    else
    {
        [self setLeftBarButtonItem:_leftBarButtonItem animated:NO];
    }
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)_rightBarButtonItem
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -10;
        
        if (_rightBarButtonItem)
        {
            [self setRightBarButtonItems:@[negativeSeperator, _rightBarButtonItem]];
        }
        else
        {
            [self setRightBarButtonItems:@[negativeSeperator]];
        }
        [negativeSeperator release];
    }
    else
    {
        [self setRightBarButtonItem:_rightBarButtonItem animated:NO];
    }
}
#endif
@end

@interface homeViewController ()

@end

@implementation homeViewController

@synthesize spinner;
@synthesize mainScrollView;
@synthesize pageControll;
@synthesize indexView;
@synthesize recommendView;
@synthesize specialOfferView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
	// Do any additional setup after loading the view.
    
    [self addMainScrollView];
    
    [self performSelector:@selector(updateNotifice) withObject:nil afterDelay:12];
}

-(void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
    if (IOS_VERSION >= 7.0) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }else {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    
    [self.navigationController.navigationBar setTranslucent:YES];
}

-(void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController.navigationBar setTranslucent:YES];
}

-(void) viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
    
    if (currentSelectingIndex != 1)
    {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [self.navigationController.navigationBar setTranslucent:NO];
    }
}

//添加主视图
- (void)addMainScrollView
{
    UIScrollView *tmpScroll = [[UIScrollView alloc] initWithFrame:CGRectMake( 0.0f , 0.0f , self.view.frame.size.width, self.view.frame.size.height)];
    tmpScroll.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    tmpScroll.pagingEnabled = YES;
    tmpScroll.delegate = self;
    tmpScroll.showsHorizontalScrollIndicator = NO;
    tmpScroll.showsVerticalScrollIndicator = NO;
    self.mainScrollView = tmpScroll;
    [tmpScroll release];
    
    [self.view addSubview:self.mainScrollView];
    
    //设置内容 
    [self addIndexView];

}

//设置首页内容
- (void)addIndexView
{
    //首页内容
    if (self.indexView == nil)
    {
        indexViewController *tempIndexView = [[indexViewController alloc] init];
        tempIndexView.view.frame = CGRectMake( 0.0f , 0.0f ,self.view.frame.size.width , self.view.frame.size.height);
        tempIndexView.delegate = self;
        self.indexView = tempIndexView;
        [tempIndexView release];
        [self.mainScrollView addSubview:self.indexView.view];
    }
}

//设置精品推荐视图跟特价专区视图
- (void)reSetMainScrollView
{
    CGFloat scrollFixWidth = self.view.frame.size.width;
    
    //精品推荐
    //判读是否显示精品推荐
    NSArray *isShowRecommendArray = [DBOperate queryData:T_SYSTEM_CONFIG theColumn:@"tag" 
								theColumnValue:@"isShowRecommend" withAll:NO];
    
    
	int isShowRecommend = 0;
	if ([isShowRecommendArray count]>0) 
    {
		isShowRecommend = [[[isShowRecommendArray objectAtIndex:0] objectAtIndex:1] intValue];
	}
    
    if (isShowRecommend == 1) 
    {
        if (![self.recommendView.view isDescendantOfView:self.mainScrollView])
        {
            recommendViewController *tempRecommendView = [[recommendViewController alloc] init];
            tempRecommendView.view.frame = CGRectMake( scrollFixWidth , 0.0f ,self.view.frame.size.width , self.view.frame.size.height);
            self.recommendView = tempRecommendView;
            [tempRecommendView release];
            [self.mainScrollView addSubview:self.recommendView.view];
        }
        self.recommendView.view.frame = CGRectMake( scrollFixWidth , 0.0f ,self.view.frame.size.width , self.view.frame.size.height);
        scrollFixWidth = scrollFixWidth + self.view.frame.size.width;
    }
    else
    {
        if (self.recommendView != nil)
        {
            [self.recommendView.view removeFromSuperview];
        }
    }
    
    //特价专区
    //判断是否显示特价专区
    NSArray *isShowSpecialOfferArray = [DBOperate queryData:T_SYSTEM_CONFIG theColumn:@"tag" 
                                          theColumnValue:@"isShowSpecialOffer" withAll:NO];
	int isShowSpecialOffer = 0;
	if ([isShowSpecialOfferArray count]>0) 
    {
		isShowSpecialOffer = [[[isShowSpecialOfferArray objectAtIndex:0] objectAtIndex:1] intValue];
	}
    if (isShowSpecialOffer == 1) 
    {
        if (![self.specialOfferView.view isDescendantOfView:self.mainScrollView])
        {
            specialOfferViewController *tempSpecialOfferView = [[specialOfferViewController alloc] init];
            tempSpecialOfferView.view.frame = CGRectMake( scrollFixWidth , 0.0f ,self.view.frame.size.width , self.view.frame.size.height);
            self.specialOfferView = tempSpecialOfferView;
            [tempSpecialOfferView release];
            [self.mainScrollView addSubview:self.specialOfferView.view];
        }
        self.specialOfferView.view.frame = CGRectMake( scrollFixWidth , 0.0f ,self.view.frame.size.width , self.view.frame.size.height);
        scrollFixWidth = scrollFixWidth + self.view.frame.size.width;
    }
    else
    {
        if (self.specialOfferView != nil)
        {
            [self.specialOfferView.view removeFromSuperview];
        }
    }
    
    //设置scrollView宽度
    self.mainScrollView.contentSize = CGSizeMake(scrollFixWidth, self.view.frame.size.height);
    
    //添加页面
    int pageCount = scrollFixWidth / self.view.frame.size.width;
    
    if (pageCount > 1)
    {
        int pageUnitWidth = 20.0f;
        CGFloat pageControllWidth = pageUnitWidth * pageCount;
        CGFloat pageControllHeight = 15.0f;
        if(![self.pageControll isDescendantOfView:self.view])
        {
            UIPageControl *tempPageControll = [[UIPageControl alloc] initWithFrame:CGRectMake(self.view.center.x - (pageControllWidth/2.0), self.view.frame.size.height - 20.0f, pageControllWidth, pageControllHeight)];
            self.pageControll = tempPageControll;			
            [tempPageControll release];
            self.pageControll.layer.masksToBounds = YES;
            self.pageControll.layer.cornerRadius = 3;
            self.pageControll.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.25];
            [pageControll addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
            [self.view addSubview:self.pageControll];
            
        }
        
        self.pageControll.frame = CGRectMake(self.view.center.x - (pageControllWidth/2.0), self.view.frame.size.height - 20.0f, pageControllWidth, pageControllHeight);
        self.pageControll.numberOfPages = pageCount;
        self.pageControll.currentPage = 0;
    }
    else
    {
        if (self.pageControll != nil)
        {
            [self.pageControll removeFromSuperview];
        }
    }
}

//显示推荐
- (void)showRecommendView
{
    NSArray *isShowRecommendArray = [DBOperate queryData:T_SYSTEM_CONFIG theColumn:@"tag" 
                                          theColumnValue:@"isShowRecommend" withAll:NO];
    
	int isShowRecommend = 0;
	if ([isShowRecommendArray count]>0) 
    {
		isShowRecommend = [[[isShowRecommendArray objectAtIndex:0] objectAtIndex:1] intValue];
	}
    
    if (isShowRecommend == 1) 
    {
        int whichPage = 1;
        self.pageControll.currentPage = whichPage;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        self.mainScrollView.contentOffset = CGPointMake(self.view.frame.size.width * whichPage, 0.0f);
        [UIView commitAnimations];
    }
    
}

- (void) pageTurn: (UIPageControl *) aPageControl
{
	int whichPage = aPageControl.currentPage;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	self.mainScrollView.contentOffset = CGPointMake(self.view.frame.size.width * whichPage, 0.0f);
	[UIView commitAnimations];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView{	
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	//[super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView
{
    CGPoint offset = aScrollView.contentOffset;
    self.pageControll.currentPage = offset.x / self.view.frame.size.width;
}

#pragma mark ---- 自动升级 评分提醒 ----
- (void) updateNotifice{
	NSArray *updateArray = [DBOperate queryData:T_APP_INFO theColumn:@"type" theColumnValue:@"0" withAll:NO];
	if(updateArray != nil && [updateArray count] > 0){
		NSArray *array = [updateArray objectAtIndex:0];
		int reminde = [[array objectAtIndex:app_info_remide] intValue];
		int newUpdateVersion = [[array objectAtIndex:app_info_ver] intValue];
        
		if (CURRENT_APP_VERSION != newUpdateVersion) {
			if (reminde != 1) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:TIPS_NEWVERSION message:[array objectAtIndex:app_info_remark] delegate:self cancelButtonTitle:@"稍后提示我" otherButtonTitles:@"立即更新", nil];
                alertView.tag = 1;
                [alertView show];
                [alertView release];
                return;
            }
		}
	}
    
    NSArray *gradeArray = [DBOperate queryData:T_APP_INFO theColumn:@"type" theColumnValue:@"1"withAll:NO];
    if (gradeArray != nil && [gradeArray count] > 0) {
        NSArray *array = [gradeArray objectAtIndex:0];
        int remind = [[array objectAtIndex:app_info_remide] intValue];
        
        NSString *updateGradeUrl = [array objectAtIndex:app_info_url];
        if (updateGradeUrl != nil && [updateGradeUrl length] > 0) {
            NSDate *senddate = [NSDate date];
            NSCalendar *cal = [NSCalendar  currentCalendar];
            NSUInteger unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
            NSDateComponents *conponent = [cal components:unitFlags fromDate:senddate];
            NSInteger year = [conponent year];
            NSInteger month = [conponent month];
            NSInteger day = [conponent day];
            
            NSInteger years = [[NSUserDefaults standardUserDefaults] integerForKey:@"year"];
            NSInteger months = [[NSUserDefaults standardUserDefaults] integerForKey:@"month"];
            NSInteger days = [[NSUserDefaults standardUserDefaults] integerForKey:@"day"];
            
            if (remind == 1) {
                return;
            }
            
            if (years != year || months != month || days <= day-7) {
                [[NSUserDefaults standardUserDefaults] setInteger:year forKey:@"year"];
                [[NSUserDefaults standardUserDefaults] setInteger:month forKey:@"month"];
                [[NSUserDefaults standardUserDefaults] setInteger:day forKey:@"day"];
                
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"喜欢我，就来评分吧！" message:@"" delegate:self cancelButtonTitle:@"下次再说" otherButtonTitles:@"鼓励一下",@"不再提醒", nil];
                alertView.tag = 2;
                [alertView show];
                [alertView release];
            }
        }
	}
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            NSArray *updateArray = [DBOperate queryData:T_APP_INFO theColumn:@"type" theColumnValue:@"0" withAll:NO];
            if(updateArray != nil && [updateArray count] > 0){
                NSArray *array = [updateArray objectAtIndex:0];
                NSString *url = [array objectAtIndex:app_info_url];
                [DBOperate updateData:T_APP_INFO tableColumn:@"remide" columnValue:@"1"
                      conditionColumn:@"type" conditionColumnValue:[NSNumber numberWithInt:0]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }
        } else if (buttonIndex == 2) {
            [DBOperate updateData:T_APP_INFO tableColumn:@"remide" columnValue:@"1"
                  conditionColumn:@"type" conditionColumnValue:[NSNumber numberWithInt:0]];
        }
    } else if (alertView.tag == 2){
        if (buttonIndex == 1) {
            NSArray *gradeArray = [DBOperate queryData:T_APP_INFO theColumn:@"type" theColumnValue:@"1"withAll:NO];
            if (gradeArray != nil && [gradeArray count] > 0) {
                NSArray *array = [gradeArray objectAtIndex:0];
                NSString *url = [array objectAtIndex:app_info_url];
                [DBOperate updateData:T_APP_INFO tableColumn:@"remide" columnValue:@"1"
                      conditionColumn:@"type" conditionColumnValue:[NSNumber numberWithInt:1]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }
        } else if (buttonIndex == 2) {
            [DBOperate updateData:T_APP_INFO tableColumn:@"remide" columnValue:@"1"
                  conditionColumn:@"type" conditionColumnValue:[NSNumber numberWithInt:1]];
        }
    }
}

#pragma mark -UIAlertViewDelegate
- (void)willPresentAlertView:(UIAlertView *)alertView
{
    if (IOS_VERSION < 7)
    {
        UIView * view = [alertView.subviews objectAtIndex:2];
        if([view isKindOfClass:[UILabel class]])
        {
            UILabel* label = (UILabel*) view;
            label.textAlignment = UITextAlignmentLeft;
        }
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.spinner = nil;
    self.mainScrollView.delegate = nil;
    self.mainScrollView = nil;
    self.pageControll = nil;
    self.indexView = nil;
    self.recommendView = nil;
    self.specialOfferView = nil;
}

- (void)dealloc 
{
    self.spinner = nil;
    self.mainScrollView.delegate = nil;
    self.mainScrollView = nil;
    self.pageControll = nil;
    self.indexView = nil;
    self.recommendView = nil;
    self.specialOfferView = nil;
    [super dealloc];
}

@end
