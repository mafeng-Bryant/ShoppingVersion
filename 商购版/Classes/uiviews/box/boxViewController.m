//
//  boxViewController.m
//  shopping
//
//  Created by lai yun on 12-12-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "boxViewController.h"
#import "aboutUsViewController.h"
#import "weiboSetViewController.h"
#import "feedbackViewController.h"
#import "recommendAppViewController.h"
#import "Common.h"
#import "FileManager.h"
#import "imageDownLoadInWaitingObject.h"
#import "Encry.h"
#import "downloadParam.h"
#import "callSystemApp.h"
#import "UIImageScale.h"
#import "MoreButtonViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BaiduMapViewController.h"
#import "alertView.h"
@interface boxViewController ()

@end

@implementation boxViewController
@synthesize mainScrollView;
@synthesize introductionView;
@synthesize moreView;
@synthesize spinner;
@synthesize listArray = __listArray;
@synthesize imageDownloadsInProgressDic;
@synthesize imageDownloadsInWaitingArray;
@synthesize iconDownLoad;

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
    
    iconWidth = 48.0f;
    iconHeight = 48.0f;
    
    iconBgWidth = 57.0f;
    iconBgHeight = 57.0f;
    
    __listArray = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *idip = [[NSMutableDictionary alloc]init];
	self.imageDownloadsInProgressDic = idip;
	[idip release];
	NSMutableArray *wait = [[NSMutableArray alloc]init];
	self.imageDownloadsInWaitingArray = wait;
	[wait release];
    
    UIScrollView *tempMainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake( 0.0f , 0.0f , self.view.frame.size.width, VIEW_HEIGHT - 20.0f)];
	tempMainScrollView.contentSize = CGSizeMake(self.view.frame.size.width, VIEW_HEIGHT - 20.0f);
	tempMainScrollView.pagingEnabled = NO;
	tempMainScrollView.showsHorizontalScrollIndicator = NO;
	tempMainScrollView.showsVerticalScrollIndicator = NO;
	tempMainScrollView.bounces = YES;
    self.mainScrollView = tempMainScrollView;
    [self.view addSubview:self.mainScrollView];
    [tempMainScrollView release];
    
    //介绍视图
    UIView *tempIntroductionView = [[UIView alloc] initWithFrame:CGRectZero];
    tempIntroductionView.backgroundColor = [UIColor clearColor];
    self.introductionView = tempIntroductionView;
    [self.mainScrollView addSubview:tempIntroductionView];
    [tempIntroductionView release];
    
    //更多功能视图
    UIView *tempMoreView = [[UIView alloc] initWithFrame:CGRectZero];
    tempMoreView.backgroundColor = [UIColor clearColor];
    self.moreView = tempMoreView;
    [self.mainScrollView addSubview:tempMoreView];
    [tempMoreView release];
    
    //添加loading图标
	UIActivityIndicatorView *tempSpinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
	[tempSpinner setCenter:CGPointMake(self.view.frame.size.width / 3, (self.view.frame.size.height - 44.0f - 49.0f) / 2.0)];
	self.spinner = tempSpinner;
	
	UILabel *loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 100, 20)];
	loadingLabel.font = [UIFont systemFontOfSize:14];
	loadingLabel.textColor = [UIColor colorWithRed:0.5 green: 0.5 blue: 0.5 alpha:1.0];
	loadingLabel.text = LOADING_TIPS;		
	loadingLabel.textAlignment = UITextAlignmentCenter;
	loadingLabel.backgroundColor = [UIColor clearColor];
	[self.spinner addSubview:loadingLabel];
	[self.view addSubview:self.spinner];
	[self.spinner startAnimating];
	[tempSpinner release];
    
    [self accessService];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.mainScrollView = nil;
    self.introductionView = nil;
    self.moreView = nil;
    self.spinner = nil;
    [btnBgImageView release];
    __listArray = nil;
    for (IconDownLoader *one in [imageDownloadsInProgressDic allValues]){
		one.delegate = nil;
	}
    imageDownloadsInProgressDic = nil;
    imageDownloadsInWaitingArray = nil;
    iconDownLoad = nil;
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    
    self.mainScrollView = nil;
    self.introductionView = nil;
    self.moreView = nil;
    self.spinner = nil;
    [btnBgImageView release];
    __listArray = nil;
    for (IconDownLoader *one in [imageDownloadsInProgressDic allValues]){
		one.delegate = nil;
	}
    imageDownloadsInProgressDic = nil;
    imageDownloadsInWaitingArray = nil;
    iconDownLoad = nil;
    
    [super dealloc];
}



//关于我们
-(void)aboutUs
{
	aboutUsViewController *aboutUsDetail = [[aboutUsViewController alloc] init];			
	[self.navigationController pushViewController:aboutUsDetail animated:YES];
	[aboutUsDetail release];
}

//微博设置
-(void)weiboSet
{
	weiboSetViewController *weiboSetDetail = [[weiboSetViewController alloc] init];			
	[self.navigationController pushViewController:weiboSetDetail animated:YES];
	[weiboSetDetail release];
}

//在线反馈
-(void)feedback
{
	feedbackViewController *feedbackDetail = [[feedbackViewController alloc] init];			
	[self.navigationController pushViewController:feedbackDetail animated:YES];
	[feedbackDetail release];
}

//推荐应用
-(void)recommendApp
{
    recommendAppViewController *recommendApp = [[recommendAppViewController alloc] init];			
	[self.navigationController pushViewController:recommendApp animated:YES];
	[recommendApp release];
}

//分店地图
-(void)map
{
    BaiduMapViewController *map = [[BaiduMapViewController alloc] init];
    [self.navigationController pushViewController:map animated:YES];
    [map release];
}

- (void)fresh
{
    MBProgressHUD *progress = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0 ,320 , 380 )];
    progress.delegate = self;
    progress.labelText = @"新版本检测中...";
    [self.view addSubview:progress];
    [self.view bringSubviewToFront:progress];
    [progress show:YES];
    [progress hide:YES afterDelay:3.0f];
    [progress release];
}

- (void)comment
{
    NSMutableArray *gradeArray = (NSMutableArray *)[DBOperate queryData:T_APP_INFO
                                                              theColumn:@"type" theColumnValue:@"1" withAll:NO];
    if (gradeArray != nil && [gradeArray count] > 0) {
        NSArray *array = [gradeArray objectAtIndex:0];
        NSString *appGradeUrl = [array objectAtIndex:app_info_url];
        NSURL *url = [NSURL URLWithString:appGradeUrl];
        [[UIApplication sharedApplication] openURL:url];
    }
}
#pragma mark MBProgressHUD
- (void)hudWasHidden:(MBProgressHUD *)hud{
	[hud removeFromSuperview];
	
	NSMutableArray *updateArray = (NSMutableArray *)[DBOperate queryData:T_APP_INFO
                                                               theColumn:@"type" theColumnValue:@"0" withAll:NO];
	if (updateArray != nil && [updateArray count] > 0) {
		NSArray *array = [updateArray objectAtIndex:0];
		int newVersion = [[array objectAtIndex:app_info_ver] intValue];
		if (newVersion <= CURRENT_APP_VERSION) {
			[alertView showAlert:@"当前已经是最新版本了"];
		}else {
			//NSURL *url = [NSURL URLWithString:updateUrl];
			//[[UIApplication sharedApplication] openURL:url];
            //			UpdateAppAlert *alert = [[UpdateAppAlert alloc]
            //									 initWithContent:@"检测到新版本" content:@"资讯版有新版本了！是否马上更新升级到新版本？"
            //									 leftbtn:@"稍后再说 " rightbtn:@"立即更新" url:updateUrl onViewController:self.navigationController];
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:TIPS_NEWVERSION message:[array objectAtIndex:app_info_remark] delegate:self cancelButtonTitle:@"稍后提示我" otherButtonTitles:@"立即更新", nil];
            alertView.tag = 1;
            [alertView show];
            [alertView release];
		}
		
	}else{
		[alertView showAlert:@"当前已经是最新版本了"];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
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
}

#pragma mark ------private methods
- (void)accessService
{
	NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
								 [Common getSecureString],@"keyvalue",
                                 [Common getVersion:MORE_CAT_COMMAND_ID],@"ver",
								 [NSNumber numberWithInt: SITE_ID],@"site_id",nil];
	
	[[DataManager sharedManager] accessService:jsontestDic command:MORE_CAT_COMMAND_ID 
								  accessAdress:@"introduceCatList.do?param=%@" delegate:self withParam:nil];
}

- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver
{
	switch (commandid) 
    {
		case MORE_CAT_COMMAND_ID:
		{
            [self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
		}
            break;
        default:
			break;
	}
}

//创建介绍视图
-(void)createIntroductionView
{
    //顶部UI
    UIImage *lineImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"小栏目背景" ofType:@"png"]];
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f , 10.0f, lineImage.size.width, lineImage.size.height)];
    lineImageView.image = lineImage;
	[lineImage release];
	[self.introductionView addSubview:lineImageView];
	
    UILabel *strLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , lineImage.size.width, lineImage.size.height)];
	strLabel.text = @"商铺介绍";	
	strLabel.textColor = [UIColor whiteColor];
	strLabel.font = [UIFont systemFontOfSize:12.0f];
	strLabel.textAlignment = UITextAlignmentCenter;
	strLabel.backgroundColor = [UIColor clearColor];
	[lineImageView addSubview:strLabel];
	[strLabel release];
    [lineImageView release];
    
    //添加第一个 '关于我们' 按钮
    UIImage *btnBgImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"百宝箱_icon_百宝箱_icon背景" ofType:@"png"]];
    btnBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 37, btnBgImage.size.width, btnBgImage.size.height)];
    btnBgImageView.image = btnBgImage;
    [self.introductionView addSubview:btnBgImageView];
    [btnBgImage release];
    
    UIImage *aboutImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"百宝箱_icon_关于我们" ofType:@"png"]];
    UIImageView *aboutImageView = [[UIImageView alloc] initWithFrame:CGRectMake((iconBgWidth - iconWidth) * 0.5, (iconBgHeight - iconHeight) * 0.5, aboutImage.size.width, aboutImage.size.height)];
    aboutImageView.image = aboutImage;
    //aboutImageView.userInteractionEnabled = YES;
    [btnBgImageView addSubview:aboutImageView];
    [aboutImage release];
    [aboutImageView release];
    
	UIButton *aboutButton = [UIButton buttonWithType:UIButtonTypeCustom];
	aboutButton.frame = CGRectMake(10 , 37, iconBgWidth, iconBgHeight);
	[aboutButton addTarget:self action:@selector(aboutUs) forControlEvents:UIControlEventTouchUpInside];
	[self.introductionView addSubview:aboutButton];
	
    
    UILabel *aboutLabel = [[UILabel alloc] initWithFrame:CGRectMake(btnBgImageView.frame.origin.x, CGRectGetMaxY(btnBgImageView.frame) + 5 , btnBgImageView.frame.size.width, 20)];
	aboutLabel.text = @"关于我们";	
	aboutLabel.textColor = [UIColor blackColor];
	aboutLabel.font = [UIFont systemFontOfSize:12.0f];
	aboutLabel.textAlignment = UITextAlignmentCenter;
	aboutLabel.backgroundColor = [UIColor clearColor];
	[self.introductionView addSubview:aboutLabel];
	[aboutLabel release];
    
    //中间icon间隔
    CGFloat midIconWidth = ((self.view.frame.size.width - (4*iconBgWidth) - 20.0f) / 3);
    
    int listCount = [self.listArray count];
    int residueNum = 0;   //余数
    int divisibleNum = 0;     //整除数
    if (listCount > 0)
    {
        for (int i = 0; i < listCount; i ++) 
        {
            NSArray *ay = [self.listArray objectAtIndex:i];
            residueNum = (i + 1) % 4;
            divisibleNum = (i + 1) / 4;
            CGFloat fixMarginWidth = (residueNum * midIconWidth) + (iconBgWidth * residueNum) + 10.0f;
            CGFloat fixMarginheight = divisibleNum * 90.0f + 37.0f;
            
            //int catId = [[ay objectAtIndex:morecat_catId] intValue];
            UIImage *btnBgImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"百宝箱_icon_百宝箱_icon背景" ofType:@"png"]];
            UIImageView *tempBtnBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(fixMarginWidth , fixMarginheight , iconBgWidth , iconBgHeight)];
            tempBtnBgImageView.image = btnBgImage;
            [self.introductionView addSubview:tempBtnBgImageView];
            [btnBgImage release];
            
            UIButton *tempButton = [UIButton buttonWithType:UIButtonTypeCustom];
            tempButton.frame = CGRectMake(fixMarginWidth , fixMarginheight , iconBgWidth , iconBgHeight);
            [tempButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            tempButton.tag = 10000 + i;
            [self.introductionView addSubview:tempButton];
            
            UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:CGRectMake((iconBgWidth - iconWidth) * 0.5, (iconBgHeight - iconHeight) * 0.5, iconWidth, iconHeight)];
            tempImageView.userInteractionEnabled = YES;
            tempImageView.tag = 10000 + i;
            [tempBtnBgImageView addSubview:tempImageView];
            [tempImageView release];
            [tempBtnBgImageView release];
            
            //NSString *imageUrl = @"http://demo1.3g.yunlai.cn/userfiles/000/000/101/recent_img/112610324.jpg";
            NSString *imageUrl = [ay objectAtIndex:morecat_catImageurl];
			NSString *photoname = [ay objectAtIndex:morecat_catImagename];
			UIImage *tempImage = [FileManager getPhoto:photoname];//[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"百宝箱_icon_应用推荐" ofType:@"png"]];
			if (tempImage != nil) 
            {
                UIImageView *view = (UIImageView *)[self.introductionView viewWithTag:10000 + i];
                view.image = tempImage;
			}
            else
            {
				if (imageUrl.length > 0) 
                {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:10000 + i inSection:0];
                    
					[self startIconDownload:imageUrl forIndex:indexPath];
				}
			}
            
            UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(fixMarginWidth, CGRectGetMaxY(tempBtnBgImageView.frame) + 5 , tempBtnBgImageView.frame.size.width , 20)];
            tempLabel.text = [NSString stringWithFormat:@"%@",[ay objectAtIndex:morecat_catName]];	
            tempLabel.textColor = [UIColor blackColor];
            tempLabel.font = [UIFont systemFontOfSize:12.0f];
            tempLabel.textAlignment = UITextAlignmentCenter;
            tempLabel.backgroundColor = [UIColor clearColor];
            [self.introductionView addSubview:tempLabel];
            [tempLabel release];
        }
    }
    
    CGFloat floatListCount = [self.listArray count];
    CGFloat floatNum = ceil((floatListCount + 1.0) / 4.0);
    CGFloat introductionHeigh = floatNum * 80.0f + 57.0f;
    
    [self.introductionView setFrame:CGRectMake(0.0f , 0.0f, 320.0f, introductionHeigh)];
}

//创建更多功能视图
-(void)createMoreView
{
    //顶部分割线
    UIImage *lineImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"小栏目背景" ofType:@"png"]];
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f , 0.0f, lineImage.size.width, lineImage.size.height)];
    lineImageView.image = lineImage;
	[lineImage release];
	[self.moreView addSubview:lineImageView];
	
    UILabel *strLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , lineImage.size.width, lineImage.size.height)];
	strLabel.text = @"更多设置";	
	strLabel.textColor = [UIColor whiteColor];
	strLabel.font = [UIFont systemFontOfSize:12.0f];
	strLabel.textAlignment = UITextAlignmentCenter;
	strLabel.backgroundColor = [UIColor clearColor];
	[lineImageView addSubview:strLabel];
	[strLabel release];
    [lineImageView release];
    
    //中间icon间隔
    CGFloat midIconWidth = ((self.view.frame.size.width - (4*iconBgWidth) - 20.0f) / 3);
    
    //反馈
    UIImage *btnBgImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"百宝箱_icon_百宝箱_icon背景" ofType:@"png"]];
    UIImageView *feedbackBg = [[UIImageView alloc] initWithFrame:CGRectMake(10 , CGRectGetMaxY(lineImageView.frame) + 10, iconBgWidth, iconBgHeight)];
    feedbackBg.image = btnBgImage;
    [self.moreView addSubview:feedbackBg];
    
    UIImage *feedbackImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"百宝箱_icon_在线反馈" ofType:@"png"]];
    UIImageView *feedbackImageView = [[UIImageView alloc] initWithFrame:CGRectMake((iconBgWidth - iconWidth) * 0.5, (iconBgHeight - iconHeight) * 0.5, feedbackImage.size.width, feedbackImage.size.height)];
    feedbackImageView.image = feedbackImage;
    [feedbackBg addSubview:feedbackImageView];
    [feedbackImage release];
    [feedbackImageView release];
    
	UIButton *feedbackButton = [UIButton buttonWithType:UIButtonTypeCustom];
	feedbackButton.frame = CGRectMake(feedbackBg.frame.origin.x , feedbackBg.frame.origin.y, iconBgWidth, iconBgHeight);
	[feedbackButton addTarget:self action:@selector(feedback) forControlEvents:UIControlEventTouchUpInside];
	[self.moreView addSubview:feedbackButton];
    
    UILabel *feedbackLabel = [[UILabel alloc] initWithFrame:CGRectMake(feedbackBg.frame.origin.x, CGRectGetMaxY(feedbackBg.frame) + 5 , feedbackBg.frame.size.width, 20)];
	feedbackLabel.text = @"意见反馈";	
	feedbackLabel.textColor = [UIColor blackColor];
	feedbackLabel.font = [UIFont systemFontOfSize:12.0f];
	feedbackLabel.textAlignment = UITextAlignmentCenter;
	feedbackLabel.backgroundColor = [UIColor clearColor];
	[self.moreView addSubview:feedbackLabel];
	[feedbackLabel release];

    //微博
    UIImageView *weiboBg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(feedbackBg.frame) + midIconWidth , CGRectGetMaxY(lineImageView.frame) + 10, feedbackBg.frame.size.width, feedbackBg.frame.size.height)];
    weiboBg.image = btnBgImage;
    [self.moreView addSubview:weiboBg];
    
    UIImage *weiboImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"百宝箱_icon_系统设置" ofType:@"png"]];
    UIImageView *weiboImageView = [[UIImageView alloc] initWithFrame:CGRectMake((iconBgWidth - iconWidth) * 0.5, (iconBgHeight - iconHeight) * 0.5, weiboImage.size.width, weiboImage.size.height)];
    weiboImageView.image = weiboImage;
    [weiboBg addSubview:weiboImageView];
    [weiboImage release];
    [weiboImageView release];
    
	UIButton *weiboButton = [UIButton buttonWithType:UIButtonTypeCustom];
	weiboButton.frame = CGRectMake(weiboBg.frame.origin.x , weiboBg.frame.origin.y, iconBgWidth, iconBgHeight);
	[weiboButton addTarget:self action:@selector(weiboSet) forControlEvents:UIControlEventTouchUpInside];
	[self.moreView addSubview:weiboButton];
    
    UILabel *weiboLabel = [[UILabel alloc] initWithFrame:CGRectMake(weiboBg.frame.origin.x, CGRectGetMaxY(weiboBg.frame) + 5 , weiboBg.frame.size.width, 20)];
	weiboLabel.text = @"系统设置";	
	weiboLabel.textColor = [UIColor blackColor];
	weiboLabel.font = [UIFont systemFontOfSize:12.0f];
	weiboLabel.textAlignment = UITextAlignmentCenter;
	weiboLabel.backgroundColor = [UIColor clearColor];
	[self.moreView addSubview:weiboLabel];
	[weiboLabel release];
    
    //推荐应用
    UIImageView *recommendAppBg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(weiboBg.frame) + midIconWidth , CGRectGetMaxY(lineImageView.frame) + 10, weiboBg.frame.size.width, weiboBg.frame.size.height)];
    recommendAppBg.image = btnBgImage;
    [self.moreView addSubview:recommendAppBg];
    
    UIImage *recommendAppImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"百宝箱_icon_应用推荐" ofType:@"png"]];
    UIImageView *recommendAppImageView = [[UIImageView alloc] initWithFrame:CGRectMake((iconBgWidth - iconWidth) * 0.5, (iconBgHeight - iconHeight) * 0.5, recommendAppImage.size.width, recommendAppImage.size.height)];
    recommendAppImageView.image = recommendAppImage;
    [recommendAppBg addSubview:recommendAppImageView];
    [recommendAppImage release];
    [recommendAppImageView release];
    
	UIButton *recommendAppButton = [UIButton buttonWithType:UIButtonTypeCustom];
	recommendAppButton.frame = CGRectMake(recommendAppBg.frame.origin.x , recommendAppBg.frame.origin.y, iconBgWidth, iconBgHeight);
	[recommendAppButton addTarget:self action:@selector(recommendApp) forControlEvents:UIControlEventTouchUpInside];
	[self.moreView addSubview:recommendAppButton];
    
    UILabel *recommendAppLabel = [[UILabel alloc] initWithFrame:CGRectMake(recommendAppBg.frame.origin.x, CGRectGetMaxY(recommendAppBg.frame) + 5 , recommendAppBg.frame.size.width, 20)];
	recommendAppLabel.text = @"推荐应用";	
	recommendAppLabel.textColor = [UIColor blackColor];
	recommendAppLabel.font = [UIFont systemFontOfSize:12.0f];
	recommendAppLabel.textAlignment = UITextAlignmentCenter;
	recommendAppLabel.backgroundColor = [UIColor clearColor];
	[self.moreView addSubview:recommendAppLabel];
	[recommendAppLabel release];
    
    //检测新版本
    UIImageView *freshBg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(recommendAppBg.frame) + midIconWidth , CGRectGetMaxY(lineImageView.frame) + 10, weiboBg.frame.size.width, weiboBg.frame.size.height)];
    freshBg.image = btnBgImage;
    [self.moreView addSubview:freshBg];
    
    UIImage *freshImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"百宝箱-更新" ofType:@"png"]];
    UIImageView *freshImageView = [[UIImageView alloc] initWithFrame:CGRectMake((iconBgWidth - iconWidth) * 0.5, (iconBgHeight - iconHeight) * 0.5, freshImage.size.width, freshImage.size.height)];
    freshImageView.image = freshImage;
    [freshBg addSubview:freshImageView];
    [freshImage release];
    [freshImageView release];
    
	UIButton *freshButton = [UIButton buttonWithType:UIButtonTypeCustom];
	freshButton.frame = CGRectMake(freshBg.frame.origin.x , freshBg.frame.origin.y, iconBgWidth, iconBgHeight);
	[freshButton addTarget:self action:@selector(fresh) forControlEvents:UIControlEventTouchUpInside];
	[self.moreView addSubview:freshButton];
    
    UILabel *freshLabel = [[UILabel alloc] initWithFrame:CGRectMake(freshBg.frame.origin.x, CGRectGetMaxY(freshBg.frame) + 5 , freshBg.frame.size.width, 20)];
	freshLabel.text = @"检查更新";
	freshLabel.textColor = [UIColor blackColor];
	freshLabel.font = [UIFont systemFontOfSize:12.0f];
	freshLabel.textAlignment = UITextAlignmentCenter;
	freshLabel.backgroundColor = [UIColor clearColor];
	[self.moreView addSubview:freshLabel];
	[freshLabel release];
    
    //评分
    NSMutableArray *gradeArray = (NSMutableArray *)[DBOperate queryData:T_APP_INFO
                                                              theColumn:@"type" theColumnValue:@"1" withAll:NO];
    UIImageView *commentBg = [[UIImageView alloc] init];
    UIButton *commentButton;
    UILabel *commentLabel = [[UILabel alloc] init];
    if (gradeArray != nil && [gradeArray count] > 0) {
        NSString *updateGradeUrl = [[gradeArray objectAtIndex:0] objectAtIndex:app_info_url];
        if (updateGradeUrl != nil && [updateGradeUrl length] > 0) {
            commentBg.frame = CGRectMake(10, CGRectGetMaxY(feedbackLabel.frame) + 10, iconBgWidth, iconBgHeight);
            commentBg.image = btnBgImage;
            [self.moreView addSubview:commentBg];
            
            UIImage *commentImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"百宝箱-评分" ofType:@"png"]];
            UIImageView *commentImageView = [[UIImageView alloc] initWithFrame:CGRectMake((iconBgWidth - iconWidth) * 0.5, (iconBgHeight - iconHeight) * 0.5, commentImage.size.width, commentImage.size.height)];
            commentImageView.image = commentImage;
            [commentBg addSubview:commentImageView];
            [commentImage release];
            [commentImageView release];
            
            commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
            commentButton.frame = commentBg.frame;
            [commentButton addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
            [self.moreView addSubview:commentButton];
            
            commentLabel.frame = CGRectMake(commentBg.frame.origin.x, CGRectGetMaxY(commentBg.frame) + 5 , commentBg.frame.size.width, 20);
            commentLabel.text = @"为我打分";
            commentLabel.textColor = [UIColor blackColor];
            commentLabel.font = [UIFont systemFontOfSize:12.0f];
            commentLabel.textAlignment = UITextAlignmentCenter;
            commentLabel.backgroundColor = [UIColor clearColor];
            [self.moreView addSubview:commentLabel];
        }
    }
    [commentBg release];
    [commentLabel release];

    if (HOME_IS_SHOW_MAP == 0)
    {
        //分店地图
        UIImageView *mapBg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(recommendAppBg.frame) + midIconWidth , CGRectGetMaxY(lineImageView.frame) + 10, recommendAppBg.frame.size.width, recommendAppBg.frame.size.height)];
        mapBg.image = btnBgImage;
        [self.moreView addSubview:mapBg];
        
        UIImage *mapImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"百宝箱-分店地图ion" ofType:@"png"]];
        UIImageView *mapImageView = [[UIImageView alloc] initWithFrame:CGRectMake((iconBgWidth - iconWidth) * 0.5, (iconBgHeight - iconHeight) * 0.5, mapImage.size.width, mapImage.size.height)];
        mapImageView.image = mapImage;
        [mapBg addSubview:mapImageView];
        [mapImage release];
        [mapImageView release];
        
        UIButton *mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        mapButton.frame = CGRectMake(mapBg.frame.origin.x , mapBg.frame.origin.y, iconBgWidth, iconBgHeight);
        [mapButton addTarget:self action:@selector(map) forControlEvents:UIControlEventTouchUpInside];
        [self.moreView addSubview:mapButton];
        
        UILabel *mapLabel = [[UILabel alloc] initWithFrame:CGRectMake(mapBg.frame.origin.x, CGRectGetMaxY(mapBg.frame) + 5 , mapBg.frame.size.width, 20)];
        mapLabel.text = @"分店地图";
        mapLabel.textColor = [UIColor blackColor];
        mapLabel.font = [UIFont systemFontOfSize:12.0f];
        mapLabel.textAlignment = UITextAlignmentCenter;
        mapLabel.backgroundColor = [UIColor clearColor];
        [self.moreView addSubview:mapLabel];
        [mapLabel release];
        
        freshBg.frame = CGRectMake(10 , CGRectGetMaxY(feedbackLabel.frame) + 10, iconBgWidth, iconBgHeight);
        freshButton.frame = freshBg.frame;
        freshLabel.frame = CGRectMake(freshBg.frame.origin.x, CGRectGetMaxY(freshBg.frame) + 5 , freshBg.frame.size.width, 20);
        commentBg.frame = CGRectMake(CGRectGetMaxX(freshBg.frame) + midIconWidth, CGRectGetMaxY(feedbackLabel.frame) + 10, iconBgWidth, iconBgHeight);
        commentButton.frame = commentBg.frame;
        commentLabel.frame = CGRectMake(commentBg.frame.origin.x, CGRectGetMaxY(commentBg.frame) + 5 , commentBg.frame.size.width, 20);
    }
    
    CGFloat floatNum = ceil(6.0 / 4.0);
    CGFloat moreHeigh = floatNum * 80.0f + 37.0f;
    
    [self.moreView setFrame:CGRectMake(0.0f , CGRectGetMaxY(self.introductionView.frame), 320.0f, moreHeigh)];
    
    [btnBgImage release];
}

- (void)update
{
    self.listArray = (NSMutableArray *)[DBOperate queryData:T_MORE_CAT theColumn:nil theColumnValue:nil orderBy:@"sort" orderType:@"DESC" withAll:YES];    
    
//    //模拟数据
//    for (int i=0; i<3; i++)
//    {
//        NSString *name = @"";
//        if (i==0)
//        {
//            name = @"商铺荣誉";
//        }
//        else if(i==1) {
//            name = @"商铺资格";
//        }
//        else if(i==2) {
//            name = @"活动现场";
//        }
//        
//        NSMutableArray *infoArray = [[NSMutableArray alloc]init];
//        [infoArray addObject:[NSString stringWithFormat:@"%d",i]];
//        [infoArray addObject:@"1"];
//        [infoArray addObject:name];
//        [infoArray addObject:@""];
//        [infoArray addObject:@""];
//        [infoArray addObject:@""];
//        [self.listArray addObject:infoArray];
//        [infoArray release];
//    }
    
    
    //创建介绍视图
    [self createIntroductionView];
    
    //更多功能按钮
    [self createMoreView];
    
    //设置总体高度
    self.mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.introductionView.frame.size.height + self.moreView.frame.size.height + 44.0f + 49.0f);
    
    //移出loading图标
    [self.spinner removeFromSuperview];
    
}

#pragma mark ---- loadImage Method
- (void)startIconDownload:(NSString*)imageURL forIndex:(NSIndexPath*)index
{
    //NSLog(@"%@",index);
	IconDownLoader *iconDownloader = [imageDownloadsInProgressDic objectForKey:index];
    if (iconDownloader == nil && imageURL != nil && imageURL.length > 1) 
    {
		if (imageURL != nil && imageURL.length > 1) 
		{
			if ([imageDownloadsInProgressDic count] >= DOWNLOAD_IMAGE_MAX_COUNT) {
				imageDownLoadInWaitingObject *one = [[imageDownLoadInWaitingObject alloc]init:imageURL withIndexPath:index withImageType:CUSTOMER_PHOTO];
				[imageDownloadsInWaitingArray addObject:one];
				[one release];
				return;
			}
			
			IconDownLoader *iconDownloader = [[IconDownLoader alloc] init];
			iconDownloader.downloadURL = imageURL;
			iconDownloader.indexPathInTableView = index;
			iconDownloader.imageType = CUSTOMER_PHOTO;
			iconDownloader.delegate = self;
			[imageDownloadsInProgressDic setObject:iconDownloader forKey:index];
			[iconDownloader startDownload];
			[iconDownloader release];   
		}
	}    
}
- (void)appImageDidLoad:(NSIndexPath *)indexPath withImageType:(int)Type
{
    IconDownLoader *iconDownloader = [imageDownloadsInProgressDic objectForKey:indexPath];
    
    if (iconDownloader != nil)
    {
		if(iconDownloader.cardIcon.size.width > 2.0){ 			
			UIImage *photo = iconDownloader.cardIcon;
			NSString *photoname = [callSystemApp getCurrentTime];
			if ([FileManager savePhoto:photoname withImage:photo])
            {
				NSArray *one = [self.listArray objectAtIndex:iconDownloader.indexPathInTableView.row - 10000]; 
				NSNumber *value = [one objectAtIndex:morecat_catId];
			    [DBOperate updateData:T_MORE_CAT tableColumn:@"imagename" 
						  columnValue:photoname conditionColumn:@"catId" conditionColumnValue:value];
                self.listArray = (NSMutableArray *)[DBOperate queryData:T_MORE_CAT 
                                                              theColumn:nil theColumnValue:nil withAll:YES];
			}
            UIImageView *view = (UIImageView *)[self.introductionView viewWithTag:indexPath.row];
            view.image = [photo fillSize:CGSizeMake(iconWidth, iconHeight)];
		}
		[imageDownloadsInProgressDic removeObjectForKey:indexPath];
		if ([imageDownloadsInWaitingArray count] > 0) {
			imageDownLoadInWaitingObject *one = [imageDownloadsInWaitingArray objectAtIndex:0];
			[self startIconDownload:one.imageURL forIndex:one.indexPath];
			[imageDownloadsInWaitingArray removeObjectAtIndex:0];
		}		
    }
}

- (void)buttonAction:(UIButton *)sender
{
    int index = sender.tag;
    NSArray *ay = [self.listArray objectAtIndex:index - 10000];
    
    MoreButtonViewController *btnViewController = [[MoreButtonViewController alloc] init];
    btnViewController.catStr = [NSString stringWithFormat:@"%d",[[ay objectAtIndex:morecat_catId] intValue]];
    btnViewController.titleStr = [NSString stringWithFormat:@"%@",[ay objectAtIndex:morecat_catName]];
    [self.navigationController pushViewController:btnViewController animated:YES];
    //[btnViewController release];
}

@end
