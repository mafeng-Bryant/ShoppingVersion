    //
//  SinaViewController.m
//  Profession
//
//  Created by LuoHui on 12-9-5.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SinaViewController.h"
#import "Common.h"
#import "DataManager.h"
#import "shoppingAppDelegate.h"

@implementation SinaViewController
@synthesize weiBoEngine;
@synthesize sinaAccessToken;
@synthesize profile_image_url;
@synthesize expiresTime;
@synthesize progressHUD;
@synthesize isRequest = _isRequest;
@synthesize delegate;
@synthesize loginDelegate;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"新浪微博";
    hasOauth = NO;
	
//	WBEngine *engine = [[WBEngine alloc] initWithAppKey:SinaAppKey appSecret:SinaAppSecret];
//	[engine setRootViewController:self];
//	[engine setDelegate:self];
//	[engine setRedirectURI:redirectUrl];
//	[engine setIsUserExclusive:NO];
//	self.weiBoEngine = engine;
//	[engine release];
//	[weiBoEngine logIn:self.view.frame.size.height];

	
    shoppingAppDelegate *appdelegate =  (shoppingAppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.delegate = self;
    sinaWeibo = [[SinaWeibo alloc] initWithAppKey:SinaAppKey appSecret:SinaAppSecret appRedirectURI:redirectUrl andDelegate:self];
    sinaWeibo.superViewController = self;
    [sinaWeibo logIn];
    
	MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithView:self.view];
	self.progressHUD = progressHUDTmp;
	[progressHUDTmp release];	
	self.progressHUD.delegate = self;
	self.progressHUD.labelText = @"登录中...";
	[self.progressHUD show:YES];

}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	weiBoEngine = nil;
	sinaAccessToken = nil;
	delegate = nil;
	loginDelegate = nil;
}


- (void)dealloc {
	[weiBoEngine release];
	[sinaAccessToken release];
	
	weiBoEngine = nil;
	sinaAccessToken = nil;
	
	delegate = nil;
	loginDelegate = nil;
    [sinaWeibo release],sinaWeibo = nil;
    [super dealloc];
}

#pragma mark APPlicationDelegate
- (void) handleCallBack:(NSDictionary*)param
{
    NSURL *url = [param objectForKey:@"url"];
    [sinaWeibo handleOpenURL:url];
    NSString *urlString = [url absoluteString];
    NSString *access_token = [SinaWeiboRequest getParamValueFromUrl:urlString paramName:@"access_token"];
    NSString *expires_in = [SinaWeiboRequest getParamValueFromUrl:urlString paramName:@"expires_in"];
    //NSString *remind_in = [SinaWeiboRequest getParamValueFromUrl:urlString paramName:@"remind_in"];
    NSString *uid = [SinaWeiboRequest getParamValueFromUrl:urlString paramName:@"uid"];
    //NSString *refresh_token = [SinaWeiboRequest getParamValueFromUrl:urlString paramName:@"refresh_token"];
    if (uid != nil && [uid length] > 0) {
        //授权完成，调用微博接口获取用户资料
        NSTimeInterval expireTime = [[NSDate date] timeIntervalSince1970] + [expires_in doubleValue];
        self.sinaAccessToken = access_token;
        self.expiresTime = expireTime;//(int)expireTime;
        //NSLog(@"expiresIn:%f",expiresTime);
        
        //用授权获取到的userID和accessToken，调用新浪微博接口获取用户资料.
        if(progressHUD != nil ){
            [self.view addSubview:self.progressHUD];
            [self.view bringSubviewToFront:self.progressHUD];
            [self.progressHUD show:YES];
        }
        //授权完成，调用微博接口获取新浪微博用户资料数据
        [sinaWeibo requestWithURL:@"users/show.json"
                           params:[NSMutableDictionary dictionaryWithObject:uid forKey:@"uid"]
                       httpMethod:@"GET"
                         delegate:self];
    }
//    else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}


- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo{
    //用授权获取到的userID和accessToken，调用新浪微博接口获取用户资料.
    self.sinaAccessToken = sinaWeibo.accessToken;
    self.expiresTime = [sinaWeibo.expirationDate timeIntervalSince1970];
    if(progressHUD != nil ){
        [self.view addSubview:self.progressHUD];
        [self.view bringSubviewToFront:self.progressHUD];
        [self.progressHUD show:YES];
    }
    //授权完成，调用微博接口获取新浪微博用户资料数据
    [sinaWeibo requestWithURL:@"users/show.json"
                       params:[NSMutableDictionary dictionaryWithObject:sinaWeibo.userID forKey:@"uid"]
                   httpMethod:@"GET"
                     delegate:self];
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - SinaWeiboRequest Delegate
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([request.url hasSuffix:@"users/show.json"])
    {
        [self uploadToServerWithResult:result];
    }
}

//获取到用户数据，上传至服务器
- (void)uploadToServerWithResult:(id)result
{
    //获取到用户数据，上传至服务器
	NSLog(@"requestDidSucceedWithResult");
	if ([result isKindOfClass:[NSDictionary class]] && !hasOauth)
    {
        //新浪微博授权，客户端跳转方式新浪回调会调两次
        hasOauth = YES;
		NSDictionary *dic = (NSDictionary*)result;
		NSString *userId = [dic objectForKey:@"id"];
		NSString *screen_name=[dic objectForKey:@"screen_name"];
		//NSString *name=[dic objectForKey:@"name"];
		//		NSString *province=[[dic objectForKey:@"province"]intValue];
		//		NSString *city=[[dic objectForKey:@"city"]intValue];
		//		NSString *location=[dic objectForKey:@"location"];
		//		NSString *description=[dic objectForKey:@"description"];
		//		NSString *url=[dic objectForKey:@"url"];
		self.profile_image_url=[dic objectForKey:@"profile_image_url"];
		//NSString *domain=[dic objectForKey:@"domain"];
		
		NSDate *todayDate = [NSDate date];
		NSLog(@"Date:%@",todayDate);
		NSTimeInterval inter = [todayDate timeIntervalSince1970];
		int time = inter;
		NSLog(@"TIME:%d",time);
		NSLog(@"profile_image_url====%@",profile_image_url);
		
		//获取到的用户资料保存至本地数据库
		NSMutableArray *ar_wp = [[NSMutableArray alloc]init];
		[ar_wp addObject:@"sina"];
		[ar_wp addObject:screen_name];
		[ar_wp addObject:userId];
		[ar_wp addObject:profile_image_url];
		[ar_wp addObject:@""];
		[ar_wp addObject:@""];
		[ar_wp addObject:sinaAccessToken];
		[ar_wp addObject:[NSNumber numberWithInt: expiresTime]];
		[ar_wp addObject:[NSNumber numberWithInt: 1]];
		[ar_wp addObject:[NSNumber numberWithInt: time]];
		[ar_wp addObject:@"openid"];
		[ar_wp addObject:@"openkey"];
		[DBOperate deleteData:T_WEIBO_USERINFO tableColumn:@"weiboType" columnValue:@"sina"];
		[DBOperate insertDataWithnotAutoID:ar_wp tableName:T_WEIBO_USERINFO];
		[ar_wp release];
		
		if (_isRequest == YES) {
			NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
										 [Common getSecureString],@"keyvalue",
										 [NSNumber numberWithInt: SITE_ID],@"site_id",
										 screen_name,@"login_name",
										 [NSNumber numberWithInt:1],@"is_weibo",
										 @"sina",@"weibo_type",
										 userId,@"weibo_id",nil];
			NSLog(@"======%@",jsontestDic);
			
			[[DataManager sharedManager] accessService:jsontestDic command:SINAWEI_COMMAND_ID
										  accessAdress:@"member/regist.do?param=%@" delegate:self withParam:nil];
		}else {
			if (delegate != nil) {
				NSInteger currentIndex = [self.navigationController.viewControllers indexOfObject:self];
				if( currentIndex-1 >= 0 ) {
					[self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:currentIndex-1] animated:NO];
				}
				[delegate oauthSinaSuccess];
			}else
			{
				[self.navigationController popViewControllerAnimated:YES];
			}
			
		}
	}
    
}

#pragma mark -----WBEngineDelegate methods
- (void)engineDidLogIn:(WBEngine *)engine didSucceedWithAccessToken:(NSString *)accessToken userID:(NSString *)userID expiresIn:(NSInteger)seconds
{
	//NSTimeInterval expireTime = [[NSDate date] timeIntervalSince1970] + seconds;
	self.sinaAccessToken = accessToken;
	self.expiresTime = seconds;//(int)expireTime;
	NSLog(@"loginViewController");
	NSLog(@"accessToken:%@",accessToken);
	NSLog(@"userID:%@",userID);
	//NSLog(@"expiresIn:%f",expiresTime);
	
	//用授权获取到的userID和accessToken，调用新浪微博接口获取用户资料.
	if(progressHUD != nil ){
		[self.view addSubview:self.progressHUD];
		[self.view bringSubviewToFront:self.progressHUD];
		[self.progressHUD show:YES];
	}
	//授权完成，调用微博接口获取新浪微博用户资料数据
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:userID, @"uid",nil];
	[weiBoEngine loadRequestWithMethodName:@"users/show.json" httpMethod:@"GET" params:params postDataType:kWBRequestPostDataTypeNormal httpHeaderFields:nil];
}

- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
	//获取到用户数据，上传至服务器
	NSLog(@"requestDidSucceedWithResult");
	if ([result isKindOfClass:[NSDictionary class]])
    {
		NSDictionary *dic = (NSDictionary*)result;
		NSString *userId = [dic objectForKey:@"id"];
		NSString *screen_name=[dic objectForKey:@"screen_name"];
		//NSString *name=[dic objectForKey:@"name"];
		//		NSString *province=[[dic objectForKey:@"province"]intValue];
		//		NSString *city=[[dic objectForKey:@"city"]intValue];
		//		NSString *location=[dic objectForKey:@"location"];
		//		NSString *description=[dic objectForKey:@"description"];
		//		NSString *url=[dic objectForKey:@"url"];
		self.profile_image_url=[dic objectForKey:@"profile_image_url"];
		//NSString *domain=[dic objectForKey:@"domain"];
		
		NSDate *todayDate = [NSDate date]; 
		NSLog(@"Date:%@",todayDate);
		NSTimeInterval inter = [todayDate timeIntervalSince1970]; 
		int time = inter;
		NSLog(@"TIME:%d",time);
		NSLog(@"profile_image_url====%@",profile_image_url);
		
		//获取到的用户资料保存至本地数据库
		NSMutableArray *ar_wp = [[NSMutableArray alloc]init];
		[ar_wp addObject:@"sina"];
		[ar_wp addObject:screen_name];
		[ar_wp addObject:userId];
		[ar_wp addObject:profile_image_url];
		[ar_wp addObject:@""];
		[ar_wp addObject:@""];
		[ar_wp addObject:sinaAccessToken];
		[ar_wp addObject:[NSNumber numberWithInt: expiresTime]];
		[ar_wp addObject:[NSNumber numberWithInt: 1]];
		[ar_wp addObject:[NSNumber numberWithInt: time]];
		[ar_wp addObject:@"openid"];
		[ar_wp addObject:@"openkey"];
		[DBOperate deleteData:T_WEIBO_USERINFO tableColumn:@"weiboType" columnValue:@"sina"];
		[DBOperate insertDataWithnotAutoID:ar_wp tableName:T_WEIBO_USERINFO];
		[ar_wp release];
		
		if (_isRequest == YES) {
			NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
										 [Common getSecureString],@"keyvalue",
										 [NSNumber numberWithInt: SITE_ID],@"site_id",
										 screen_name,@"login_name",
										 [NSNumber numberWithInt:1],@"is_weibo",
										 @"sina",@"weibo_type",
										 userId,@"weibo_id",nil];
			NSLog(@"======%@",jsontestDic);
			
			[[DataManager sharedManager] accessService:jsontestDic command:SINAWEI_COMMAND_ID 
										  accessAdress:@"member/regist.do?param=%@" delegate:self withParam:nil];
		}else {
			if (delegate != nil) {
				NSInteger currentIndex = [self.navigationController.viewControllers indexOfObject:self];
				if( currentIndex-1 >= 0 ) {
					[self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:currentIndex-1] animated:NO];
				}
				[delegate oauthSinaSuccess];
			}else
			{
				[self.navigationController popViewControllerAnimated:YES];
			}
			
		}

	}	
}

- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
	NSLog(@"information finish");
		
	[self performSelectorOnMainThread:@selector(sinaLogin:) withObject:resultArray waitUntilDone:NO];
	
}

- (void)sinaLogin:(NSMutableArray*)resultArray{
	NSString *retStr = [[resultArray objectAtIndex:0] objectAtIndex:0];
    //NSLog(@"===%@",retStr);
	NSMutableArray *dbArray = [resultArray objectAtIndex:1];
    
	if (dbArray != nil) {
		//[dbArray replaceObjectAtIndex:3 withObject:profile_image_url];
        if ([[dbArray objectAtIndex:3] isEqualToString:@""]) {
            [dbArray replaceObjectAtIndex:3 withObject:profile_image_url];
        }
		//NSLog(@"dbArray====%@",dbArray);
		[DBOperate deleteData:T_MEMBER_INFO];
		[DBOperate insertData:dbArray tableName:T_MEMBER_INFO];
	}
	
	_isLogin = YES;
	self.progressHUD.hidden = YES;
    
//    //------更新标识表
//    NSArray *arr = [[DBOperate queryData:T_MEMBER_INFO theColumn:nil theColumnValue:nil withAll:YES] objectAtIndex:0];
//    [DBOperate deleteData:T_SYSTEM_CONFIG tableColumn:@"tag" columnValue:@"isRememberName"];
//    [DBOperate deleteData:T_SYSTEM_CONFIG tableColumn:@"tag" columnValue:@"isRememberPassword"];
//    
//    NSMutableArray *nameArray = [[NSMutableArray alloc]init];
//    [nameArray addObject:@"isRememberName"];
//    [nameArray addObject:[arr objectAtIndex:member_info_name]];
//    [DBOperate insertDataWithnotAutoID:nameArray tableName:T_SYSTEM_CONFIG];
//    [nameArray release];
//    
//    NSMutableArray *passwordArray = [[NSMutableArray alloc]init];
//    [passwordArray addObject:@"isRememberPassword"];
//    [passwordArray addObject:[arr objectAtIndex:member_info_password]];
//    [DBOperate insertDataWithnotAutoID:passwordArray tableName:T_SYSTEM_CONFIG];
//    [passwordArray release];
//    //---------
    
    if ([retStr isEqualToString:@"1"]) {
        NSString *name = [[[DBOperate queryData:T_MEMBER_INFO theColumn:nil theColumnValue:nil withAll:YES] objectAtIndex:0] objectAtIndex:member_info_name];
        NSString *pwd = [[[DBOperate queryData:T_MEMBER_INFO theColumn:nil theColumnValue:nil withAll:YES] objectAtIndex:0] objectAtIndex:member_info_password];
    
        NSString *msg = [NSString stringWithFormat:@"微博登录成功\n您的会员账号：%@\n系统初始密码：%@\n祝您使用愉快",name,pwd];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"恭喜您" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.contentMode = UIViewContentModeLeft;
        [alert show];
        [alert release];
    }else {
        if (loginDelegate != nil) {
            NSInteger currentIndex = [self.navigationController.viewControllers indexOfObject:self];
            if( currentIndex-2 >= 0 ) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:currentIndex-2] animated:NO];
            }
            [loginDelegate loginWithResult:YES];
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    
	
}

#pragma mark ----UIAlertViewDelegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (loginDelegate != nil) {
		NSInteger currentIndex = [self.navigationController.viewControllers indexOfObject:self];
		if( currentIndex-2 >= 0 ) {
			[self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:currentIndex-2] animated:NO];
		}
		[loginDelegate loginWithResult:YES];
	}else{
		[self.navigationController popToRootViewControllerAnimated:YES];
	}

}
@end
