//
//  shoppingAppDelegate.m
//  shopping
//
//  Created by siphp on 12-12-20.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "shoppingAppDelegate.h"
#import "tabEntranceViewController.h"
#import "CustomTabBar.h"
#import "CustomNavigationController.h"
#import "DataManager.h"
#import "DBOperate.h"
#import "alertView.h"
#import "showPushAlert.h"
//#import "AlixPay.h"
//#import "AlixPayResult.h"
//#import "DataVerifier.h"
#import <AlipaySDK/AlipaySDK.h>

#import <sys/utsname.h>
#import "FileManager.h"
#import "WXApi.h"
#import "ShareAlertViewController.h"
#import "ShareSuccessAlertView.h"
#import "GetPromotionSuccessAlertView.h"
#import "GetPromotionCodeFailAlertView.h"
#import "IconDownLoader.h"
#import "imageDownLoadInWaitingObject.h"
#import "downloadParam.h"
#import "callSystemApp.h"
#import "MyOrdersViewController.h"
#import "SBJson.h"
#import "newsDetailViewController.h"
#import "ProductDetailViewController.h"
#import "MBProgressHUD.h"

@implementation shoppingAppDelegate

@synthesize window;
@synthesize navController;
@synthesize loginBtn;
@synthesize headerImage;
@synthesize myDeviceToken;
@synthesize province;
@synthesize city;
@synthesize LatitudeAndLongitude;
@synthesize pushAlert;
@synthesize userGuideView;
@synthesize guideScrollView;
@synthesize pageControll;
@synthesize shareAlertView;
@synthesize shareSuccessAlertView;
@synthesize imageDownloadsInProgress;
@synthesize imageDownloadsInWaiting;
@synthesize iconDownLoad;
@synthesize alertType;
@synthesize alertInfoId;
@synthesize delegate;

// dufu add 2013.06.14
// 数据库操作
- (void)operateDB
{
//    NSArray *ar_version = [DBOperate queryData:T_SYSTEM_CONFIG theColumn:@"tag" theColumnValue:APP_SOFTWARE_VER_KEY withAll:NO];
//	
//    int soft_ver = 0;
//	if ([ar_version count] > 0) {
//		NSArray *arr_version = [ar_version objectAtIndex:0];
//		soft_ver = [[arr_version objectAtIndex:system_config_value] intValue];
//	}
    int soft_ver = [[NSUserDefaults standardUserDefaults] integerForKey:APP_SOFTWARE_VER_KEY];
	
    NSLog(@"dddd = %d",soft_ver);
	
	if(soft_ver != CURRENT_APP_VERSION)
	{
		[FileManager removeFile:dataBaseFile];
		NSString *filepath = [FileManager getFilePath:@""];
        NSLog(@"filepath = %@",filepath);
		//获取所有下个目录下的文件名列表
		NSArray *fileList = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath: filepath error:nil];
		for(int i=0;i < [fileList count]; i++)
		{
			[FileManager removeFile:[fileList objectAtIndex:i]];
		}
        
        [[NSUserDefaults standardUserDefaults] setInteger:CURRENT_APP_VERSION forKey:APP_SOFTWARE_VER_KEY];
	}
    
    //创建表结构
	[DBOperate createTable];
    
//	//写入当前软件版本号
//	NSArray *ar_ver = [NSArray arrayWithObjects:APP_SOFTWARE_VER_KEY,[NSString stringWithFormat:@"%d",CURRENT_APP_VERSION], nil];
//	[DBOperate deleteData:T_SYSTEM_CONFIG tableColumn:@"tag" columnValue:APP_SOFTWARE_VER_KEY];
//	[DBOperate insertDataWithnotAutoID:ar_ver tableName:T_SYSTEM_CONFIG];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定generalDelegate参数
    BOOL ret = [_mapManager start:@"aD99cXbvKRLUfBoeKUAILHCG" generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    // 数据库操作
	[self operateDB];
    
    //网络线程初始化
	netWorkQueue = [[NSOperationQueue alloc] init];
	[netWorkQueue setMaxConcurrentOperationCount:2];
    
    netWorkQueueArray = [[NSMutableArray alloc] init];
    
    //图片下载类初始化
	NSMutableDictionary *idip = [[NSMutableDictionary alloc]init];
	self.imageDownloadsInProgress = idip;
	[idip release];
	NSMutableArray *wait = [[NSMutableArray alloc]init];
	self.imageDownloadsInWaiting = wait;
	[wait release];
    
    isFirstLoadTabBar = YES;
    
	//============================= UI 视图显示 ===========================================
    //显示状态栏
	[application setStatusBarHidden:NO withAnimation:NO];
    [application setStatusBarStyle: UIStatusBarStyleBlackOpaque];
	
    //设置背景
    float width = [UIScreen mainScreen].bounds.size.width;
	float height = [UIScreen mainScreen].bounds.size.height;
    CGFloat fixHeight = height < 548 ? -44.0f + 20.0f : 0.0f;
    UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:BG_IMAGE ofType:nil]];
	UIImageView *backiv = [[UIImageView alloc]initWithFrame:CGRectMake(0, fixHeight , img.size.width, img.size.height)];
	backiv.image = img;
	[img release];
    [window addSubview:backiv];
	[backiv release];
    
    //自动登陆
	[self isAutoLogin];
    
    //下bar初始化
    //tabEntranceViewController *tabViewController = [[tabEntranceViewController alloc]init];
    CustomTabBar *tabViewController = [[CustomTabBar alloc]init];
    
    //默认选中第一个 如果是使用tabEntranceViewController 非自定义的 需要把该代码也注释
    [tabViewController selectedTab:[tabViewController.buttons objectAtIndex:0]];

    UINavigationController *tabNavigation = [[CustomNavigationController alloc] initWithRootViewController:tabViewController];
    //NSLog(@"%@",[NSValue valueWithCGRect:tabNavigation.navigationBar.bounds]);
    [tabViewController release];
    
    //上bar 自定义
    UINavigationBar *navBar = [tabNavigation navigationBar];
    if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        // set globablly for all UINavBars
        UIImage *img = nil;
        if (IOS_VERSION >= 7.0) {
            img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:IOS7_NAV_BG_PIC ofType:nil]];
        }else{
            img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NAV_BG_PIC ofType:nil]];
        }
        [navBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
        [img release];
    }
    
    //上bar 背景
    tabNavigation.navigationBar.tintColor = [UIColor colorWithRed:0.0f green:0.4f blue:0.0f alpha:1];    
    self.navController = tabNavigation;	
    [window addSubview:tabNavigation.view];
    [tabNavigation release];
    
    if (IOS_VERSION >= 7.0) {
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
        
        tabViewController.edgesForExtendedLayout = UIRectEdgeNone;
        tabViewController.extendedLayoutIncludesOpaqueBars = NO;
        tabViewController.modalPresentationCapturesStatusBarAppearance = NO;
        tabViewController.navigationController.navigationBar.translucent = NO;
        tabViewController.tabBarController.tabBar.translucent = NO;
    }
    
    //向微信注册，使程序启动后微信终端能响应应用程序
    [WXApi registerApp:WEICHATID];
    
    //============================= 事务逻辑处理 ===========================================
    
    //经纬度初始化
    myLocation.latitude = 22.548604;
	myLocation.longitude = 114.064515;
    
    app_wechat_share_type = app_to_wechat;
    isShowPromotionAlert = NO;
    
    //设置 支持摇一摇
    application.applicationSupportsShakeToEdit = YES;
	
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) { 
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"]; 
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"]; 
    }
    
    //线程延迟 2 秒执行
	[NSThread sleepForTimeInterval:0];
	[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    //引导页面
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
    {
        //自定义引导页不开启
//        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"noShow"] == YES)
//        {
//            [self initApp];
//        }
//        else
//        {
//            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, heigth)];
//            view.backgroundColor = [UIColor whiteColor];
//            self.userGuideView = view;
//            [view release];
//            [self.window addSubview:userGuideView];
//            [self initUserGuideView];
//        }
        UIView *view = [[UIView alloc] init];
        if (height == 480) {
            view.frame = CGRectMake(0, - 44 + 20, width, 548);
        }else {
            view.frame = CGRectMake(0, 20, width, 548);
        }
        view.backgroundColor = [UIColor whiteColor];
        self.userGuideView = view;
        [view release];
        [self.window addSubview:userGuideView];
        [self initUserGuideView];
    }
    else
    {
        [self initApp];
    }
	
	[self.window makeKeyAndVisible];
    
    /*
	 *单任务handleURL处理
	 */
	if ([self isSingleTask]) {
		NSURL *url = [launchOptions objectForKey:@"UIApplicationLaunchOptionsURLKey"];
		
		if (nil != url) {
			[self parseURL:url application:application];
		}
	}
    
    //请求设备令牌接口
    [self apnsAccess];
    
    return YES;
	
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
    NSArray *appTime = [DBOperate queryData:T_TIME_ACCESS theColumn:nil theColumnValue:nil withAll:YES];
    if ([appTime count] > 0) {
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
        
        int timeValue = [[[appTime objectAtIndex:[appTime count] - 1] objectAtIndex:time_access_currentTime] intValue];
        int stay = [[[appTime objectAtIndex:[appTime count] - 1] objectAtIndex:time_access_stayTime] intValue];
        
        [DBOperate updateData:T_TIME_ACCESS tableColumn:@"stayTime" columnValue:[NSString stringWithFormat:@"%d",currentInt - timeValue + stay] conditionColumn:@"currentTime" conditionColumnValue:[NSString stringWithFormat:@"%d",timeValue]];
    }
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
    
    //selectedIndex
    
    [self isAutoLogin];
    
    [self pvAction];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

- (void)pvAction
{
    NSArray *configArr = [DBOperate queryData:T_SYSTEM_CONFIG theColumn:@"tag" theColumnValue:@"isAppAccessTime" withAll:NO];
    if ([configArr count] > 0) {
        //NSLog(@"hui=====%@",[DBOperate queryData:T_TIME_ACCESS theColumn:nil theColumnValue:nil withAll:YES]);
        
        int timeValue = [[[configArr objectAtIndex:0] objectAtIndex:system_config_value] intValue];
        NSLog(@"timeValue===%d",timeValue);
        
        NSDate* nowDate = [NSDate date];
        NSDateFormatter *outputFormat = [[NSDateFormatter alloc] init];
        [outputFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString = [outputFormat stringFromDate:nowDate];
        NSDate *currentDate = [outputFormat dateFromString:dateString];
        [outputFormat release];
        NSTimeInterval t = [currentDate timeIntervalSince1970];   // 转化为时间戳
        long long int time = (long long int)t;
        NSNumber *num = [NSNumber numberWithLongLong:time];
        int currentIntHMS = [num intValue];
        
        NSDate* date1 = [NSDate dateWithTimeIntervalSince1970:currentIntHMS];
        NSDateFormatter *outputFormat1 = [[NSDateFormatter alloc] init];
        [outputFormat1 setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString1 = [outputFormat1 stringFromDate:date1];
        NSDate *currentDate1 = [outputFormat1 dateFromString:dateString1];
        [outputFormat1 release];
        NSTimeInterval t1 = [currentDate1 timeIntervalSince1970];   //转化为时间戳
        long long int time1 = (long long int)t1;
        NSNumber *num1 = [NSNumber numberWithLongLong:time1];
        int currentInt = [num1 intValue];
        
        if (timeValue == currentInt) {
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
            //NSLog(@"dateString1 === %@",dateString1);
            NSDate *currentDate1 = [outputFormat1 dateFromString:dateString1];
            [outputFormat1 release];
            NSTimeInterval t1 = [currentDate1 timeIntervalSince1970];   //转化为时间戳
            long long int time1 = (long long int)t1;
            NSNumber *num1 = [NSNumber numberWithLongLong:time1];
            int leftInt = [num1 intValue];
            //NSLog(@"leftInt == %d",leftInt);
            int rightInt = leftInt + 60 * 60;
            //NSLog(@"rightInt == %d",rightInt);
            
            NSArray *arr = [DBOperate queryData:T_TIME_ACCESS oneColumn:@"currentTime" equalValue:[NSString stringWithFormat:@"%d",leftInt] twoColumn:@"currentTime" equalValue:[NSString stringWithFormat:@"%d",rightInt]];
            if ([arr count] == 0) {
                NSArray *item = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:currentInt],@"", nil];
                [DBOperate insertDataWithnotAutoID:item tableName:T_TIME_ACCESS];
            }else {
                [DBOperate deleteDataWithTwoConditions:T_TIME_ACCESS oneColumn:@"currentTime" oneValue:[NSString stringWithFormat:@"%d",leftInt] twoColumn:@"currentTime" twoValue:[NSString stringWithFormat:@"%d",rightInt]];
                
                NSMutableArray *listArr = [arr objectAtIndex:0];
                NSArray *item = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:currentInt],[NSNumber numberWithInt:[[listArr objectAtIndex:time_access_stayTime] intValue]], nil];
                [DBOperate insertDataWithnotAutoID:item tableName:T_TIME_ACCESS];
            }
            
            //把表里的数据发给服务器
            //[self pvAccess];
            
        }else {
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
            
            //-------更新标识表
            NSDate* date2 = [NSDate dateWithTimeIntervalSince1970:currentInt];
            NSDateFormatter *outputFormat2 = [[NSDateFormatter alloc] init];
            [outputFormat2 setDateFormat:@"yyyy-MM-dd"];
            NSString *dateString2 = [outputFormat2 stringFromDate:date2];
            NSDate *currentDate2 = [outputFormat2 dateFromString:dateString2];
            [outputFormat2 release];
            NSTimeInterval t2 = [currentDate2 timeIntervalSince1970];   //转化为时间戳
            long long int time2 = (long long int)t2;
            NSNumber *num2 = [NSNumber numberWithLongLong:time2];
            
            [DBOperate deleteData:T_SYSTEM_CONFIG tableColumn:@"tag" columnValue:@"isAppAccessTime"];
            NSMutableArray *nameArray = [[NSMutableArray alloc]init];
            [nameArray addObject:@"isAppAccessTime"];
            [nameArray addObject:num2];
            [DBOperate insertDataWithnotAutoID:nameArray tableName:T_SYSTEM_CONFIG];
            [nameArray release];
            //-------
            
            //把表里的数据发给服务器
            [self pvAccess];
            
        }
        
    }else {
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
        
        //-------更新标识表
        NSDate* date2 = [NSDate dateWithTimeIntervalSince1970:currentInt];
        NSDateFormatter *outputFormat2 = [[NSDateFormatter alloc] init];
        [outputFormat2 setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString2 = [outputFormat2 stringFromDate:date2];
        NSDate *currentDate2 = [outputFormat2 dateFromString:dateString2];
        [outputFormat2 release];
        NSTimeInterval t2 = [currentDate2 timeIntervalSince1970];   //转化为时间戳
        long long int time2 = (long long int)t2;
        NSNumber *num2 = [NSNumber numberWithLongLong:time2];
        
        [DBOperate deleteData:T_SYSTEM_CONFIG tableColumn:@"tag" columnValue:@"isAppAccessTime"];
        NSMutableArray *nameArray = [[NSMutableArray alloc]init];
        [nameArray addObject:@"isAppAccessTime"];
        [nameArray addObject:num2];
        [DBOperate insertDataWithnotAutoID:nameArray tableName:T_SYSTEM_CONFIG];
        [nameArray release];
        //-------
        
        NSArray *item = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:currentInt],@"", nil];
        [DBOperate insertDataWithnotAutoID:item tableName:T_TIME_ACCESS];
    }
}

- (void)pvAccess
{
    int _userId = 0;
    if (_isLogin == YES) {
        _userId = [[[[DBOperate queryData:T_MEMBER_INFO theColumn:nil theColumnValue:nil withAll:YES] objectAtIndex:0] objectAtIndex:member_info_memberId] intValue];
    }else {
        _userId = 0;
    }
    
    SBJSON *json = [[SBJSON alloc] init];
    NSArray *productAccessArr = [DBOperate queryData:T_PRODUCTS_ACCESS theColumn:nil theColumnValue:nil withAll:YES];
    NSMutableArray *productArr = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < [productAccessArr count]; i ++) {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:[[[productAccessArr objectAtIndex:i] objectAtIndex:products_access_productId] intValue]],@"product_id",[NSNumber numberWithInt:[[[productAccessArr objectAtIndex:i] objectAtIndex:products_access_stayTime] intValue]],@"staytime",[NSNumber numberWithInt:[[[productAccessArr objectAtIndex:i] objectAtIndex:products_access_visitCount] intValue]],@"visit_count",[NSNumber numberWithInt:[[[productAccessArr objectAtIndex:i] objectAtIndex:products_access_type] intValue]],@"type",[NSNumber numberWithInt:[[[productAccessArr objectAtIndex:i] objectAtIndex:products_access_infoId] intValue]],@"info_id",[NSNumber numberWithInt:[[[productAccessArr objectAtIndex:i] objectAtIndex:products_access_currentTime] intValue]],@"created", nil];
        
        [productArr addObject:dict];
    }
    
    NSArray *catsAccessArr = [DBOperate queryData:T_CATS_ACCESS theColumn:nil theColumnValue:nil withAll:YES];
    NSMutableArray *catsArr = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < [catsAccessArr count]; i ++) {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:[[[catsAccessArr objectAtIndex:i] objectAtIndex:cats_access_catId] intValue]],@"product_cat_id",[NSNumber numberWithInt:[[[catsAccessArr objectAtIndex:i] objectAtIndex:cats_access_visitCount] intValue]],@"visit_count",[NSNumber numberWithInt:[[[catsAccessArr objectAtIndex:i] objectAtIndex:cats_access_currentTime] intValue]],@"created", nil];
        
        [catsArr addObject:dict];
    }
    
    NSArray *adsAccessArr = [DBOperate queryData:T_ADS_ACCESS theColumn:nil theColumnValue:nil withAll:YES];
    NSMutableArray *adsArr = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < [adsAccessArr count]; i ++) {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:[[[adsAccessArr objectAtIndex:i] objectAtIndex:ads_access_adId] intValue]],@"ad_id",[NSNumber numberWithInt:[[[adsAccessArr objectAtIndex:i] objectAtIndex:ads_access_visitCount] intValue]],@"visit_count",[NSNumber numberWithInt:[[[adsAccessArr objectAtIndex:i] objectAtIndex:ads_access_currentTime] intValue]],@"created", nil];
        
        [adsArr addObject:dict];
    }
    
    NSArray *timeAccessArr = [DBOperate queryData:T_TIME_ACCESS theColumn:nil theColumnValue:nil withAll:YES];
    NSMutableArray *timeArr = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < [timeAccessArr count]; i ++) {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:[[[timeAccessArr objectAtIndex:i] objectAtIndex:time_access_currentTime] intValue]],@"created",[NSNumber numberWithInt:[[[timeAccessArr objectAtIndex:i] objectAtIndex:time_access_stayTime] intValue]],@"staytime", nil];
        
        [timeArr addObject:dict];
    }
    
    NSArray *apnsAccessArr = [DBOperate queryData:T_APNS_ACCESS theColumn:nil theColumnValue:nil withAll:YES];
    NSMutableArray *apnsArr = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < [apnsAccessArr count]; i ++) {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:[[[apnsAccessArr objectAtIndex:i] objectAtIndex:apns_access_type] intValue]],@"type",[NSNumber numberWithInt:[[[apnsAccessArr objectAtIndex:i] objectAtIndex:apns_access_infoId] intValue]],@"info_id",[NSNumber numberWithInt:[[[apnsAccessArr objectAtIndex:i] objectAtIndex:apns_access_currentTime] intValue]],@"created", nil];
        
        [apnsArr addObject:dict];
    }
    
    self.province = self.province == nil ? @"广东省" : self.province;
    self.city = self.city == nil ? @"深圳市" : self.city;
    
    NSMutableDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [Common getSecureString],@"keyvalue",
                                        [NSNumber numberWithInt: SITE_ID],@"site_id",
                                        [Common getMacAddress],@"mac_address",
										self.province,@"province",
										self.city,@"city",
                                        [NSNumber numberWithInt:_userId],@"user_id",
                                        [NSNumber numberWithInt:0],@"platform",
                                        [json objectWithString:[json stringWithObject:productArr]],@"product_logs",
                                        [json objectWithString:[json stringWithObject:catsArr]],@"product_cat_logs",
                                        [json objectWithString:[json stringWithObject:adsArr]],@"ad_logs",
                                        [json objectWithString:[json stringWithObject:timeArr]],@"stay_logs",
                                        [json objectWithString:[json stringWithObject:apnsArr]],@"push_hit_logs",nil];
    
    NSString *reqstr = [Common TransformJson:jsontestDic withLinkStr:@"param=%@"];
   
    NSData *itemData = [reqstr dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    EPUploader *upload = [[EPUploader alloc] initWithURL1:[NSURL URLWithString:[NSString stringWithFormat:@"%@/dataStatistics.do",ACCESS_SERVER_LINK]] filePath:itemData delegate:self doneSelector:@selector(onUploadDone:) errorSelector:@selector(onUploadError:)];
    upload.uploaderDelegate = self;
}

#pragma mark ---EPUploaderDelegate method
- (void)receiveResult:(NSString *)result
{
    NSLog(@"result===%@",result);
    [DBOperate deleteData:T_TIME_ACCESS];
    [DBOperate deleteData:T_PRODUCTS_ACCESS];
    [DBOperate deleteData:T_CATS_ACCESS];
    [DBOperate deleteData:T_ADS_ACCESS];
    [DBOperate deleteData:T_APNS_ACCESS];
}

- (void) onUploadDone:(id)sender{
    
}
- (void) onUploadError:(id)sender{
    
}

#pragma mark 初始化app 注册消息推送以及地理位置获取
- (void) initApp{
    
    //推送通知注册
    NSArray *ar_token = [DBOperate queryData:T_DEVTOKEN theColumn:nil theColumnValue:nil  withAll:YES];
    if ([ar_token count]>0)
    {
		NSArray *arr_token = [ar_token objectAtIndex:0];
		self.myDeviceToken = [arr_token objectAtIndex:devtoken_token];
        
        //获取位置
        [self getLocation];
	}
    else
    {
        //注册消息通知 获取token号
        if (IOS_VERSION >=8) {
            NSLog(@"这是ios8通知新的api");
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
            
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        } else {
            NSLog(@"这是老的通知的api");
            
            [[UIApplication sharedApplication]registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
        }

    }
    
    //监听消息推送
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(launchNotification:)name:@"UIApplicationDidFinishLaunchingNotification" object:nil];
    
}

#pragma mark 初始化用户导航界面
- (void) initUserGuideView{
    NSArray *guideImagesArray = [DBOperate queryData:T_GUIDE_IMAGES theColumn:nil theColumnValue:nil withAll:YES];
    
    if ([guideImagesArray count] == 0) {
        UIScrollView *scv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.userGuideView.frame.size.width, self.userGuideView.frame.size.height)];
        scv.delegate = self;
        scv.pagingEnabled = YES;
        scv.scrollEnabled = YES;
        scv.showsHorizontalScrollIndicator = NO;
        scv.contentSize = CGSizeMake(self.userGuideView.frame.size.width * 5, self.userGuideView.frame.size.height);
        scv.backgroundColor = [UIColor clearColor];
        self.guideScrollView = scv;
        [scv release];
        [self.userGuideView addSubview:guideScrollView];
        
        UIImage *closeImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"引导页关闭" ofType:@"png"]];
        closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(guideScrollView.frame.size.width - closeImage.size.width,20,closeImage.size.width,closeImage.size.height);
        [closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        [closeBtn setImage:closeImage forState:UIControlStateNormal];
        [closeImage release];
        [self.window addSubview:closeBtn];
        
        for (int i = 1; i < 6; i++) {
            UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake((i-1)*self.userGuideView.frame.size.width,0, self.userGuideView.frame.size.width, self.userGuideView.frame.size.height)];
            UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@%d",@"gidue",i] ofType:@"png"]];
            imv.image = img;
            [img release];        
            [guideScrollView addSubview:imv];
            
            [imv release];
            
            if (i == 5) {
                UIButton *phoneBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
                phoneBtn1.frame = CGRectMake((i-1)*self.userGuideView.frame.size.width + 44,self.userGuideView.frame.size.height - 130,240,40);
                [phoneBtn1 addTarget:self action:@selector(onButtonClick)
                    forControlEvents:UIControlEventTouchUpInside];
                UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"立即体验" ofType:@"png"]];
                [phoneBtn1 setImage:img forState:UIControlStateNormal];
                [img release];
                [phoneBtn1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter]; 
                [guideScrollView addSubview:phoneBtn1];
            }
        }
        
        UIPageControl *pc = [[UIPageControl alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 30, [UIScreen mainScreen].bounds.size.width, 30)];
        pc.numberOfPages = 5;
        pc.currentPage = 0;
        pc.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        self.pageControll = pc;
        [pc release];
        [self.window addSubview:pageControll];
    }else {
        UIScrollView *scv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.userGuideView.frame.size.width, self.userGuideView.frame.size.height)];
        scv.delegate = self;
        scv.pagingEnabled = YES;
        scv.scrollEnabled = YES;
        scv.showsHorizontalScrollIndicator = NO;
        scv.contentSize = CGSizeMake(self.userGuideView.frame.size.width * [guideImagesArray count], self.userGuideView.frame.size.height);
        scv.backgroundColor = [UIColor clearColor];
        self.guideScrollView = scv;
        [scv release];
        [self.userGuideView addSubview:guideScrollView];
        
        UIImage *closeImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"引导页关闭" ofType:@"png"]];
        closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(guideScrollView.frame.size.width - closeImage.size.width,20,closeImage.size.width,closeImage.size.height);
        [closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        [closeBtn setImage:closeImage forState:UIControlStateNormal];
        [closeImage release];
        [self.window addSubview:closeBtn];
        
        for (int i = 0; i < [guideImagesArray count]; i++) {
            NSString *imageUrl = [[guideImagesArray objectAtIndex:i] objectAtIndex:guide_images_imageUrl];
            NSString *picName = [Common encodeBase64:(NSMutableData *)[imageUrl dataUsingEncoding: NSUTF8StringEncoding]];
            UIImage *image = [FileManager getPhoto:picName];
            if (image != nil) {
                UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.userGuideView.frame.size.width,0, self.userGuideView.frame.size.width, self.userGuideView.frame.size.height)];
                imv.image = image;
                [guideScrollView addSubview:imv];
                [imv release];
            }
            if (i == [guideImagesArray count] - 1) {
                UIButton *phoneBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
                phoneBtn1.frame = CGRectMake(i * self.userGuideView.frame.size.width + 44,self.userGuideView.frame.size.height - 130,240,40);
                [phoneBtn1 addTarget:self action:@selector(onButtonClick)
                    forControlEvents:UIControlEventTouchUpInside];
                UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"立即体验" ofType:@"png"]];
                [phoneBtn1 setImage:img forState:UIControlStateNormal];
                [img release];
                [phoneBtn1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter]; 
                [guideScrollView addSubview:phoneBtn1];
            }
        }
        
        UIPageControl *pc = [[UIPageControl alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 30, [UIScreen mainScreen].bounds.size.width, 30)];
        pc.numberOfPages = [guideImagesArray count];
        pc.currentPage = 0;
        pc.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        self.pageControll = pc;
        [pc release];
        [self.window addSubview:pageControll];
    }
    
    //获取位置
    [self getLocation];
}

- (void)closeClick
{
    [self onButtonClick];
//    [self.userGuideView removeFromSuperview];
//    [self initApp];
}

- (void) onButtonClick{
    [closeBtn removeFromSuperview];
    [self.pageControll removeFromSuperview];
    [self curtainRevealViewController:self.navController];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    [self performSelector:@selector(initApp) withObject:nil afterDelay:1.0];
}

#pragma mark 当前屏幕的截屏
- (UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark 从导航页到主页面，开门效果
- (void)curtainRevealViewController:(UIViewController *)viewControllerToReveal{
    UIImage *selfPortrait = [self imageWithView:window];
    UIImage *controllerScreenshot = [self imageWithView:viewControllerToReveal.view];
    
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, selfPortrait.size.width, selfPortrait.size.height)];
    coverView.backgroundColor = [UIColor blackColor];
    [window addSubview:coverView];
    
    int offset = 20;
    if (controllerScreenshot.size.height == [UIScreen mainScreen].bounds.size.height) {
        offset = 0;
    }
    
    float padding = [UIScreen mainScreen].bounds.size.width * 0.3;
    
    UIImageView *fadedView = [[UIImageView alloc] initWithFrame:CGRectMake(padding, padding + offset, controllerScreenshot.size.width - padding * 2, controllerScreenshot.size.height - padding * 2 - 20)];
    fadedView.image = controllerScreenshot;
    fadedView.alpha = 0.4;
    [coverView addSubview:fadedView];
    
    UIImageView *leftCurtain = [[UIImageView alloc] initWithFrame:CGRectNull];
    leftCurtain.image = selfPortrait;
    leftCurtain.clipsToBounds = YES;
    
    UIImageView *rightCurtain = [[UIImageView alloc] initWithFrame:CGRectNull];
    rightCurtain.image = selfPortrait;
    rightCurtain.clipsToBounds = YES;
    
    leftCurtain.contentMode = UIViewContentModeLeft;
    leftCurtain.frame = CGRectMake(0, 0, selfPortrait.size.width / 2, selfPortrait.size.height);
    rightCurtain.contentMode = UIViewContentModeRight;
    rightCurtain.frame = CGRectMake(selfPortrait.size.width / 2, 0, selfPortrait.size.width / 2, selfPortrait.size.height);
    
    [coverView addSubview:leftCurtain];
    [coverView addSubview:rightCurtain];
    
    [UIView animateWithDuration:0.9 delay:0 options:UIViewAnimationCurveEaseIn animations:^{
        leftCurtain.frame = CGRectMake(- selfPortrait.size.width / 2, 0, selfPortrait.size.width / 2, selfPortrait.size.height);
        rightCurtain.frame = CGRectMake(selfPortrait.size.width, 0, selfPortrait.size.width / 2, selfPortrait.size.height);
    } completion:nil];
    
    [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationCurveEaseIn animations:^{
        fadedView.frame = CGRectMake(0, offset, controllerScreenshot.size.width, controllerScreenshot.size.height);
        fadedView.alpha = 1;
    } completion:^(BOOL finished){
        [leftCurtain removeFromSuperview];
        [rightCurtain removeFromSuperview];
        [fadedView removeFromSuperview];
        [coverView removeFromSuperview];
        [self.userGuideView removeFromSuperview];
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollview
{	
    CGFloat pageWidth = self.userGuideView.frame.size.width;
    int page = floor((scrollview.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControll.currentPage = page;
}

//获取地理位置
- (void)getLocation
{
//    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
//    {
//        locManager = [[CLLocationManager alloc] init];
//        locManager.desiredAccuracy = kCLLocationAccuracyBest;
//        locManager.delegate = self;
//        [locManager startUpdatingLocation];
//    }
//    else 
//    {
//        //定位没打开 默认地址发送
//        [self apnsAccess];
//    }
    locManager = [[CLLocationManager alloc] init];
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [locManager requestWhenInUseAuthorization];
        //定位没打开 默认地址发送
        [self apnsAccess];
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
        locManager.desiredAccuracy = kCLLocationAccuracyBest;
        locManager.delegate = self;
        [locManager startUpdatingLocation];
        
    }
}

//自动登陆
- (void)isAutoLogin
{
	NSArray *dbArray = [DBOperate queryData:T_MEMBER_INFO theColumn:nil theColumnValue:nil withAll:YES];
	if ([dbArray count] != 0) {
        
		NSArray *memberArray = [dbArray objectAtIndex:0];
        if ([memberArray count] > 0) {
            
            NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [Common getSecureString],@"keyvalue",
                                         [NSNumber numberWithInt: SITE_ID],@"site_id",
                                         [memberArray objectAtIndex:member_info_name],@"login_name",
                                         [memberArray objectAtIndex:member_info_password],@"login_pwd",nil];
            
            [[DataManager sharedManager] accessService:jsontestDic command:MEMBER_LOGIN_COMMAND_ID 
                                          accessAdress:@"member/login.do?param=%@" delegate:self withParam:nil];
        }
	}else{
        
		_isLogin = NO;
    }	
}

- (void)apnsAccess
{
    //上传token和统计信息给服务器
    LatitudeAndLongitude = LatitudeAndLongitude == nil ? @"114.064515,22.548604" : LatitudeAndLongitude;
    self.province = self.province == nil ? @"广东省" : self.province;
    self.city = self.city == nil ? @"深圳市" : self.city;
    self.myDeviceToken = self.myDeviceToken == nil ? @"" : self.myDeviceToken;
    
//    self.province = @"guangdong";
//    self.city = @"shenzhen";
    
    //自动升级 版本号
    int  promoteVer;
    NSArray *promoteArr = [DBOperate queryData:T_APP_INFO theColumn:@"type" theColumnValue:@"0" withAll:NO];
    if ([promoteArr count] > 0) {
        promoteVer = [[[promoteArr objectAtIndex:0] objectAtIndex:app_info_ver] intValue];
    }else {
        promoteVer = 0;
    }
    
    //评分提醒 版本号
    int  gradeVer;
    NSArray *gradeArr = [DBOperate queryData:T_APP_INFO theColumn:@"type" theColumnValue:@"1" withAll:NO];
    if ([gradeArr count] > 0) {
        gradeVer = [[[gradeArr objectAtIndex:0] objectAtIndex:app_info_ver] intValue];
    }else {
        gradeVer = 0;
    }
    
    NSMutableDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
										[Common getSecureString],@"keyvalue",
										self.myDeviceToken,@"token",
										self.province,@"pro",
										self.city,@"city",
										[NSNumber numberWithInt: SITE_ID],@"site_id",
										[Common getMacAddress],@"mac-addr",
										LatitudeAndLongitude,@"lat-and-long",
										[NSNumber numberWithInt:0],@"platform",
                                        [Common getVersion:SHARE_CLIENT_PROMOTION_ID],@"pri_ver1",
                                        [Common getVersion:SHARE_PRODUCT_PROMOTION_ID],@"pri_ver2",
                                        [Common getVersion:FULL_PROMOTION_ID],@"ful_ver",
                                        [Common getVersion:POST_VER],@"post_ver",
                                        [Common getVersion:GUIDE_COMMAND_ID],@"guide_ver",
                                        [NSNumber numberWithInt: promoteVer],@"promote_ver",
                                        [NSNumber numberWithInt: gradeVer],@"grade_ver",nil];
	
	[[DataManager sharedManager] accessService:jsontestDic command:APNS_COMMAND_ID 
								  accessAdress:@"apns.do?param=%@" delegate:self withParam:nil];
    
    //数据统计
    [self pvAction];
}

- (void)accessServiceGuide
{
    NSMutableDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
										[Common getSecureString],@"keyvalue",
										[NSNumber numberWithInt: SITE_ID],@"site_id",nil];
	
	[[DataManager sharedManager] accessService:jsontestDic command:GUIDE_COMMAND_ID 
								  accessAdress:@"guide.do?param=%@" delegate:self withParam:nil];
}

- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
    switch(commandid)
    {
        //自动登陆
        case MEMBER_LOGIN_COMMAND_ID:
        {
            [self performSelectorOnMainThread:@selector(updateAction:) withObject:resultArray waitUntilDone:NO];
            break;
        }
        //设备令牌
        case APNS_COMMAND_ID:
        {
            if (ver == NEED_UPDATE) {
                [self performSelectorOnMainThread:@selector(accessServiceGuide) withObject:nil waitUntilDone:NO];
            }else {
                [self performSelectorOnMainThread:@selector(apnsResult:) withObject:resultArray waitUntilDone:NO];
            }

            //执行分享客户端获取优惠券方法
            [self performSelector:@selector(showPromotionAlert) withObject:nil afterDelay:0.5];
            
            //自动升级 评分提醒
            //[self performSelector:@selector(updateNotifice) withObject:nil afterDelay:0.5];
            
        }
            break;
        case GUIDE_COMMAND_ID:{
            [self performSelectorOnMainThread:@selector(guideResult) withObject:nil waitUntilDone:NO];
        }
            break;
        case COFIRM_ORDER_PAY:{
             [self performSelectorOnMainThread:@selector(payResult:) withObject:resultArray waitUntilDone:NO];
        }
            break;
        case PV_COMMAND_ID:{
            [self performSelectorOnMainThread:@selector(pvAccessResult) withObject:nil waitUntilDone:NO];
        }
            break;
        default:
            break;
    }
}

- (void)guideResult
{
    NSArray *ay = [DBOperate queryData:T_GUIDE_IMAGES theColumn:nil theColumnValue:nil withAll:YES];
    if (ay != nil && [ay count] > 0) {
        for (int i = 0 ; i < [ay count]; i ++) {
            NSArray *itemArray = [ay objectAtIndex:i];
            
            NSString *imageUrl = [itemArray objectAtIndex:guide_images_imageUrl];
            if (imageUrl != nil)
            {
                [self startIconDownload:imageUrl forIndex:[NSIndexPath indexPathForRow:3000 + i inSection:0]];
            }
        }
    }
}

- (void) payResult:(NSMutableArray*)array{
    [mprogressHUD removeFromSuperview];
    [mprogressHUD release],mprogressHUD = nil;
    //int ret = [[array objectAtIndex:0] intValue];
    //if (ret == 1) {//确认成功
    [self.navController popViewControllerAnimated:NO];
        
    int _userId = [[[[DBOperate queryData:T_MEMBER_INFO theColumn:nil theColumnValue:nil withAll:YES] objectAtIndex:0] objectAtIndex:member_info_memberId] intValue];
    MyOrdersViewController *orders = [[MyOrdersViewController alloc] init];
    orders.userId = [NSString stringWithFormat:@"%d",_userId];
    [self.navController pushViewController:orders animated:YES];
    [orders release];
    //}else{
    
    //}
}

- (void) showPromotionAlert{
    
}

- (void)updateAction:(NSMutableArray *)array{
    
    NSString *resultstr = [[array objectAtIndex:0] objectAtIndex:0];
	if ([resultstr isEqualToString:@"1"]) {
        
		_isLogin = YES;
        
	}else {
        
		_isLogin = NO;
	}
}

- (void)apnsResult:(NSMutableArray *)array
{
    //执行分享客户端获取优惠券方法
    //[self performSelector:@selector(showPromotionAlert) withObject:nil afterDelay:0.5];
}

#pragma mark -
#pragma mark Application lifecycle

// Handle an actual notification
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
	[self showString:userInfo];	
}

-(void)showString:(NSDictionary*)userInfo{
    NSLog(@"userInfo====%@",userInfo);
	NSDictionary *content = [userInfo objectForKey:@"aps"];
    //NSLog(@"receive E %@",content);
    
    NSString *type = [userInfo objectForKey:@"type"];
    
    NSString *infoId = [userInfo objectForKey:@"info_id"];
    
    if (type != nil) {
        if ([type intValue] == 0) {
            showPushAlert *pusha = [[showPushAlert alloc]initWithContent:[content objectForKey:@"alert"] onViewController:navController];
            self.pushAlert = pusha;
            [pusha release];
            [pushAlert showAlert];
            
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
            
            NSArray *item = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt: SITE_ID],[NSNumber numberWithInt:[self.alertType intValue]],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:currentInt], nil];
            [DBOperate insertDataWithnotAutoID:item tableName:T_APNS_ACCESS];
        }else {
            self.alertType = type;
            self.alertInfoId = infoId;
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[content objectForKey:@"alert"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            alert.tag = 3;
            [alert show];
            [alert release];
        }
    }
}

-(void)launchNotification:(NSNotification*)notification{
	
	[self showString:[[notification userInfo]objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"]];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error 
{
	//NSString *status = [NSString stringWithFormat:@"%@\nRegistration failed.\n\nError: %@", pushStatus(), [error localizedDescription]];
	//[self showString:status];
	//NSLog(@"status %@",status);
    NSLog(@"Error in registration. Error: %@", error); 
    
    //获取位置
    [self getLocation];

} 

//获取token号回调
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
	NSString *mydevicetoken = [[[NSMutableString stringWithFormat:@"%@",deviceToken]stringByReplacingOccurrencesOfString:@"<" withString:@""]stringByReplacingOccurrencesOfString:@">" withString:@""];
	self.myDeviceToken = mydevicetoken;
    
    NSLog(@"self.myDeviceToken=======%@",self.myDeviceToken);
	NSArray *arr = [[NSArray alloc] initWithObjects:self.myDeviceToken, nil];
    [DBOperate insertData:arr tableName:T_DEVTOKEN];
    
    //获取位置
    [self getLocation];
}

#pragma mark -
#pragma mark locationManager

-(NSString*)coordToString:(CLLocationCoordinate2D)coord{
	NSString *key = @"ABQIAAAAi0wvL4p1DYOdJ0iL-v2_sxR-h6gSv-DalIHlg2rPU6QFhO9KcRRTQ8IhBeqcKLxlL3lMxiK9r4f7Ug";
	NSString *urlStr = [NSString stringWithFormat:@"http://ditu.google.cn/maps/geo?output=csv&key=%@&q=%lf,%lf&hl=zh-CN",key,coord.latitude,coord.longitude];
	//NSString *urlStr = [NSString stringWithFormat:@"http://maps.google.cn/maps/geo?output=csv&key=%@&q=%lf,%lf&hl=zh-CN",key,coord.latitude,coord.longitude];
	NSURL *url = [NSURL URLWithString:urlStr];
    NSString *retstr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSArray *resultArray = [retstr componentsSeparatedByString:@","];
	NSLog(@"result %@",resultArray);
	return [resultArray objectAtIndex:2];
}

//定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	[locManager stopUpdatingLocation];
	locManager.delegate = nil;
	//self.locManager = nil;
	@try
    {
		double latitude = newLocation.coordinate.latitude;
		double longitude = newLocation.coordinate.longitude;
        
		myLocation.latitude = latitude;
		myLocation.longitude = longitude;
		LatitudeAndLongitude = [NSString stringWithFormat:@"%f,%f",longitude,latitude];
        NSString *address = [self coordToString:newLocation.coordinate];
        NSRange range1 = [address rangeOfString:@"国"];
        NSRange range2 = [address rangeOfString:@"省"];
        NSRange range3 = [address rangeOfString:@"市"];
        if (range2.location == NSNotFound)
        {
            NSRange rangepro = NSMakeRange(range1.location +1, range3.location-range1.location);
            self.province = [address substringWithRange:rangepro];
            self.city = province;
            
        }
        else
        {
            NSRange rangepro = NSMakeRange(range1.location +1, range2.location-range1.location);
            self.province = [address substringWithRange:rangepro];
            NSRange rangecity = NSMakeRange(range2.location +1, range3.location-range2.location);
            self.city = [address substringWithRange:rangecity];		
        }
        NSLog(@"province %lu city %lu ",(unsigned long)province.length,(unsigned long)city.length);
	}
	@catch (NSException *exception) 
    {
        //请求设备令牌接口
        [self apnsAccess];
        NSLog(@"========获取位置======失败");
		return;
	}
}

//定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error 
{
    [locManager stopUpdatingLocation];
	locManager.delegate = nil;
    
    //请求设备令牌接口
    [self apnsAccess];
}

- (BOOL)isSingleTask{
	struct utsname name;
	uname(&name);
	float version = [[UIDevice currentDevice].systemVersion floatValue];//判定系统版本。
	if (version < 4.0 || strstr(name.machine, "iPod1,1") != 0 || strstr(name.machine, "iPod2,1") != 0) {
		return YES;
	}
	else {
		return NO;
	}
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	NSString *urlstring = [url absoluteString];
    NSLog(@"urlstring:%@",urlstring);
    //微信分享
    if([urlstring isEqualToString:@"wx06aade63031e0298://"]){
        return  [WXApi handleOpenURL:url delegate:self];
    }else{  //支付回调
        [self parseURL:url application:application];
    }
	
	return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSDictionary *param;
    NSLog(@"sourceApplication:%@",sourceApplication);
    if (url != nil) {
        param = [NSDictionary dictionaryWithObjectsAndKeys:
                 url,@"url", nil];
    }
    if ([sourceApplication isEqualToString:@"com.sina.weibo"]) {
        if (delegate != nil && [delegate respondsToSelector:@selector(handleCallBack:)]) {
            [delegate handleCallBack:param];
        }
        delegate = nil;
        return YES;
    }//微信分享
    else if([sourceApplication isEqualToString:@"com.tencent.xin"]){
        return  [WXApi handleOpenURL:url delegate:self];
    }else if([url.host isEqualToString:@"safepay"]){  //支付回调
        [self parseURL:url application:application];
    
        return YES;
    }
    return NO;
}

-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        [self onRequestAppMessage];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        [self onShowMediaMessage:temp.message];
    }
    
}

#pragma mark 微信分享，内容请求客户端反应
-(void) onRequestAppMessage
{
    // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
	app_wechat_share_type = wechat_to_app;
}

#pragma mark 分享至微信的结果返回
-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        if (resp.errCode == 0 && isShowPromotionAlert) {
            
            NSArray *clientPromotion = [DBOperate queryData:T_SHARE_PRODUCT_PROMOTION theColumn:nil theColumnValue:nil withAll:YES];
            if (clientPromotion != nil && [clientPromotion count] > 0) {
                NSArray *ay = [clientPromotion objectAtIndex:0];
                int startTime;
                int endTime;
                startTime = [[ay objectAtIndex:shareproductpromotion_startTime] intValue];
                endTime = [[ay objectAtIndex:shareproductpromotion_endTime] intValue];
                
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
                NSLog(@"currentInt====%d",currentInt);
                if (currentInt >= startTime && currentInt <= endTime) {
                    UIImage *image = [FileManager getPhoto:[ay objectAtIndex:shareproductpromotion_image_name]];
                    if (image != nil) {
                        [self showShareSuccessAlert];
                    }else{
                        NSString *imageUrl = [ay objectAtIndex:shareproductpromotion_image];
                        
                        [self startIconDownload:imageUrl forIndex:[NSIndexPath indexPathForRow:2000 inSection:0]];
                    }
                }
            }
        }
    }
//    else if([resp isKindOfClass:[SendAuthResp class]])
//    {
//        NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
//        NSString *strMsg = [NSString stringWithFormat:@"Auth结果:%d", resp.errCode];
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        //        [alert show];
//        [alert release];
//    }
}

- (void)parseURL:(NSURL *)url application:(UIApplication *)application {
    
    [[AlipaySDK defaultService]
     processOrderWithPaymentResult:url
     standbyCallback:^(NSDictionary *resultDic) {
         NSLog(@"result = %@", resultDic);
         int resurtInt = [[resultDic objectForKey:@"resultStatus"] intValue];
         if (resurtInt == 9000) {
             NSLog(@"支付成功");
                //调用订单更改接口通知服务器订单支付完成
                [self accessPayOrderSuccess];
         } else {
             NSLog(@"支付失败");
         
         }
         
     }];

//	AlixPay *alixpay = [AlixPay shared];
//	AlixPayResult *result = [alixpay handleOpenURL:url];
//	if (result) {
//		//是否支付成功
//		if (9000 == result.statusCode) {
//			/*
//			 *用公钥验证签名
//			 */
//            id<DataVerifier> verifier = CreateRSADataVerifier([[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSA public key"]);
//			if ([verifier verifyString:result.resultString withSign:result.signString]) {
////				UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
////																	 message:result.statusMessage
////																	delegate:nil
////														   cancelButtonTitle:@"确定"
////														   otherButtonTitles:nil];
////				[alertView show];
////				[alertView release];
//                //调用订单更改接口通知服务器订单支付完成
//                [self accessPayOrderSuccess];
//			}//验签错误
//			else {
//				UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
//																	 message:@"签名错误"
//																	delegate:nil
//														   cancelButtonTitle:@"确定"
//														   otherButtonTitles:nil];
//				[alertView show];
//				[alertView release];
//			}
//		}
//		//如果支付失败,可以通过result.statusCode查询错误码
//		else {
////			UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
////																 message:result.statusMessage
////																delegate:nil
////													   cancelButtonTitle:@"确定"
////													   otherButtonTitles:nil];
////			[alertView show];
////			[alertView release];
//            [self.navController popViewControllerAnimated:NO];
//            
//            int _userId = [[[[DBOperate queryData:T_MEMBER_INFO theColumn:nil theColumnValue:nil withAll:YES] objectAtIndex:0] objectAtIndex:member_info_memberId] intValue];
//            MyOrdersViewController *orders = [[MyOrdersViewController alloc] init];
//            orders.userId = [NSString stringWithFormat:@"%d",_userId];
//            [self.navController pushViewController:orders animated:YES];
//            [orders release];
//		}
//		
//	}
}

- (void) accessPayOrderSuccess{
    //获取当前用户的user_id
    NSDate* nowDate = [NSDate date];
    NSDateFormatter *outputFormat = [[NSDateFormatter alloc] init];
    [outputFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [outputFormat stringFromDate:nowDate];
    NSDate *currentDate = [outputFormat dateFromString:dateString];
    [outputFormat release];
    NSTimeInterval t = [currentDate timeIntervalSince1970];   //转化为时间戳
    long long int ttime = (long long int)t;
    NSNumber *num = [NSNumber numberWithLongLong:ttime];
    int currentInt = [num intValue];
    
    NSString *userId;
    NSMutableArray *memberArray = (NSMutableArray *)[DBOperate queryData:T_MEMBER_INFO theColumn:@"" theColumnValue:@"" withAll:YES];
    if ([memberArray count] > 0)
    {
        userId = [[memberArray objectAtIndex:0] objectAtIndex:member_info_memberId];
    }
    NSLog(@"orderID:%@",orderID);
    mprogressHUD = [[MBProgressHUD alloc] initWithView:self.navController.view];
    mprogressHUD.labelText = @"云端同步中";
    [self.navController.view addSubview:mprogressHUD];
    [self.navController.view bringSubviewToFront:mprogressHUD];
    [mprogressHUD show:YES];
    
    NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [Common getSecureString],@"keyvalue",
                                 [NSNumber numberWithInt: SITE_ID],@"site_id",
                                 userId,@"user_id",
                                 orderID,@"billno",
                                 [NSNumber numberWithInt:currentInt],@"paytime",
                                 nil];
    
    NSString *reqUrl = @"book/updateorder.do?param=%@";
    [[DataManager sharedManager] accessService:jsontestDic
                                       command:COFIRM_ORDER_PAY
                                  accessAdress:reqUrl
                                      delegate:self
                                     withParam:nil];
}

#pragma mark 分享微博成功弹出框
- (void) showShareSuccessAlert{
    ShareSuccessAlertView *ssav = [[ShareSuccessAlertView alloc] initWithFrame:window.bounds];
    ssav.myNavigationController = self.navController;
    self.shareSuccessAlertView = nil;
    self.shareSuccessAlertView = ssav;
    [ssav release],ssav = nil;
    [window addSubview:shareSuccessAlertView];
    [shareAlertView showFromPoint:[self.window center]];
}

#pragma mark 成功领取优惠券弹出框
- (void) showGetPromotionCodeSuccessAlert{
    GetPromotionSuccessAlertView *gpsav = [[[GetPromotionSuccessAlertView alloc] initWithFrame:window.bounds] autorelease];
    gpsav.myNavigationController = self.navController;
    [window addSubview:gpsav];
    [gpsav showFromPoint:[self.window center]];
}

#pragma mark 领取优惠券失败弹出框
- (void) showGetPromotionCodeFailedAlert:(int)type{
    GetPromotionCodeFailAlertView *gpfav = [[[GetPromotionCodeFailAlertView alloc] initWithFrame:window.bounds showType:type] autorelease];
    [window addSubview:gpfav];
    [gpfav showFromPoint:[self.window center]];
}

#pragma mark 图片下载方法
- (void)startIconDownload:(NSString*)imageURL forIndex:(NSIndexPath*)index
{
	IconDownLoader *iconDownloader = [imageDownloadsInProgress objectForKey:index];
    if (iconDownloader == nil && imageURL != nil && imageURL.length > 1)
    {
		if (imageURL != nil && imageURL.length > 1)
		{
			if ([imageDownloadsInProgress count] >= DOWNLOAD_IMAGE_MAX_COUNT) {
				imageDownLoadInWaitingObject *one = [[imageDownLoadInWaitingObject alloc]init:imageURL
																				withIndexPath:index
																				withImageType:CUSTOMER_PHOTO];
				[imageDownloadsInWaiting addObject:one];
				[one release];
				return;
			}
			
			IconDownLoader *iconDownloader = [[IconDownLoader alloc] init];
			iconDownloader.downloadURL = imageURL;
			iconDownloader.indexPathInTableView = index;
			iconDownloader.imageType = CUSTOMER_PHOTO;
			iconDownloader.delegate = self;
			[imageDownloadsInProgress setObject:iconDownloader forKey:index];
			[iconDownloader startDownload];
			[iconDownloader release];
		}
	}
}

#pragma mark 图片下载完成回调方法
- (void)appImageDidLoad:(NSIndexPath *)indexPath withImageType:(int)Type{
    int index = [indexPath row];
    IconDownLoader *iconDownloader = nil;
    if ([imageDownloadsInProgress count] > 0) {
        iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    }
    
    if (iconDownloader != nil)
    {
        if(iconDownloader.cardIcon != nil){
            UIImage *photo = iconDownloader.cardIcon;
            if (index >= 3000) {
                NSArray *dy = [DBOperate queryData:T_GUIDE_IMAGES theColumn:nil theColumnValue:nil withAll:YES];
                //NSLog(@"%d",index);
                NSArray *one = [dy objectAtIndex:index - 3000];
                NSString *picurl = [one objectAtIndex:guide_images_imageUrl];
                NSString *picName = [Common encodeBase64:(NSMutableData *)[picurl dataUsingEncoding: NSUTF8StringEncoding]];
                [FileManager savePhoto:picName withImage:photo];
            }else {
                NSString *photoname = [callSystemApp getCurrentTime];
                
                if ([FileManager savePhoto:photoname withImage:photo]) {
                    NSArray *productPromotionAy = [DBOperate queryData:T_SHARE_PRODUCT_PROMOTION theColumn:nil theColumnValue:nil withAll:YES];
                    
                    if (productPromotionAy != nil && [productPromotionAy count] > 0) {
                        
                        NSArray *ay = [productPromotionAy objectAtIndex:0];
                        int proid = [[ay objectAtIndex:shareproductpromotion_proid] intValue];
                        [DBOperate updateData:T_SHARE_PRODUCT_PROMOTION
                                  tableColumn:@"imageName" columnValue:photoname
                              conditionColumn:@"proid" conditionColumnValue:[NSNumber numberWithInt:proid]];
                        [self showShareSuccessAlert];
                    }
                }
            }
            
        }
        
        [imageDownloadsInProgress removeObjectForKey:indexPath];
		if ([imageDownloadsInWaiting count]>0)
		{
			imageDownLoadInWaitingObject *one = [imageDownloadsInWaiting objectAtIndex:0];
            [self startIconDownload:one.imageURL forIndex:one.indexPath];
			[imageDownloadsInWaiting removeObjectAtIndex:0];
		}
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
     if (alertView.tag == 3){
        if (buttonIndex == 0) {
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
            
            NSArray *item = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:[self.alertType intValue]],[NSNumber numberWithInt:[self.alertInfoId intValue]],[NSNumber numberWithInt:currentInt], nil];
            [DBOperate insertDataWithnotAutoID:item tableName:T_APNS_ACCESS];
            
            if ([self.alertType intValue] == 1){
                newsDetailViewController *newsDetail = [[newsDetailViewController alloc] init];
                newsDetail.newsId = self.alertInfoId;
                newsDetail.view.frame = [UIScreen mainScreen].bounds;
                [self.navController pushViewController:newsDetail animated:YES];
                [newsDetail release];
            }else {
                ProductDetailViewController *productDetail = [[ProductDetailViewController alloc] init];
                productDetail.productID = [self.alertInfoId intValue];
                [self.navController pushViewController:productDetail animated:YES];
                [productDetail release];
            }
        }
    }
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (void)dealloc {
    [window release];
	[navController release];
    [loginBtn release];
    //	[netWorkQueue release];
    //	netWorkQueue = nil;
	[headerImage release];
	[myDeviceToken release],myDeviceToken = nil;
    province = nil;
    city = nil;
    LatitudeAndLongitude = nil;
	[pushAlert release],pushAlert = nil;
    [shareAlertView release],shareAlertView = nil;
    [shareSuccessAlertView release],shareSuccessAlertView = nil;
    for (IconDownLoader *one in [imageDownloadsInProgress allValues]){
		one.delegate = nil;
	}
    imageDownloadsInProgress = nil;
    imageDownloadsInWaiting = nil;
    iconDownLoad = nil;
    [super dealloc];
}

@end
