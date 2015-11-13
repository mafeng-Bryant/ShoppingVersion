    //
//  TencentViewController.m
//  Profession
//
//  Created by LuoHui on 12-8-23.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "TencentViewController.h"
#import "DataManager.h"
#import "Common.h"
#import "DBOperate.h"
#import "Encry.h"
#import "MenberCenterMainViewController.h"

#define oauthMode InWebView
#define oauth2TokenKey @"access_token="
#define oauth2OpenidKey @"openid="
#define oauth2OpenkeyKey @"openkey="
#define oauth2ExpireInKey @"expires_in="

@implementation TencentViewController
@synthesize _webView;
@synthesize progressHUD;
@synthesize expiresTime;
@synthesize headImageUrl;
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
	self.title = @"腾讯微博";
	
	short authorizeType = oauthMode; 
	
	//_isRequest = YES;
	
	_OpenSdkOauth = [[OpenSdkOauth alloc] initAppKey:[OpenSdkBase getAppKey] appSecret:[OpenSdkBase getAppSecret]];
	_OpenSdkOauth.oauthType = authorizeType;
	
	BOOL didOpenOtherApp = NO;
	switch (authorizeType) {
		case InSafari:  //浏览器方式登录授权，不建议使用
		{
			didOpenOtherApp = [_OpenSdkOauth doSafariAuthorize:didOpenOtherApp];
			break;
		}
		case InWebView:  //webView方式登录授权，采用oauth2.0授权鉴权方式
		{
			if(!didOpenOtherApp){
				if (([OpenSdkBase getAppKey] == (NSString *)[NSNull null]) || ([OpenSdkBase getAppKey].length == 0)) {
					NSLog(@"client_id is null");
					[OpenSdkBase showMessageBox:@"client_id为空，请到OPenSdkBase中填写您应用的appkey"];
				}
				else
				{
					UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
					self._webView = webView;
					[webView release];
					_webView.scalesPageToFit = YES;
					_webView.userInteractionEnabled = YES;
					_webView.delegate = self;
					_webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
					
					[self.view addSubview:_webView];
					
				}
				[_OpenSdkOauth doWebViewAuthorize:_webView];
				break;
			}
		}
		default:
			break;
	}
	
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
    _webView = nil;
	progressHUD = nil;
	delegate = nil;
	loginDelegate = nil;
}


- (void)dealloc {
	[_webView release];
	[progressHUD release];
	_webView = nil;
	progressHUD = nil;
	delegate = nil;
	loginDelegate = nil;
    [super dealloc];
}

#pragma mark  -----tencentWeibo  methods
/*
 * 当前网页视图被指示载入内容时得到通知，返回yes开始进行加载
 */
- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL* url = request.URL;
	
    NSLog(@"response url is %@", url);
	NSRange start = [[url absoluteString] rangeOfString:oauth2TokenKey];
    
    //如果找到tokenkey,就获取其他key的value值
	if (start.location != NSNotFound)
	{
        NSString *accessToken = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:oauth2TokenKey];
        NSString *openid = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:oauth2OpenidKey];
        NSString *openkey = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:oauth2OpenkeyKey];
		NSString *expireIn = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:oauth2ExpireInKey];
		
		NSDate *expirationDate =nil;
		if (expireIn != nil) {
			int expVal = [expireIn intValue];
			_OpenSdkOauth._expireIn_time = expVal;
			if (expVal == 0) {
				expirationDate = [NSDate distantFuture];
			} else {
				expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
			} 
		} 
        
        NSLog(@"token is %@, openid is %@, expireTime is %@", accessToken, openid, expirationDate);
        
        if ((accessToken == (NSString *) [NSNull null]) || (accessToken.length == 0) 
            || (openid == (NSString *) [NSNull null]) || (openkey.length == 0) 
            || (openkey == (NSString *) [NSNull null]) || (openid.length == 0)) {
            [_OpenSdkOauth oauthDidFail:InWebView success:YES netNotWork:NO];
        }
        else {
            [_OpenSdkOauth oauthDidSuccess:accessToken accessSecret:nil openid:openid openkey:openkey expireIn:expireIn];
			//授权成功，获取用户信息
			[self performSelectorOnMainThread:@selector(getUserInfo) withObject:nil waitUntilDone:NO];		
        }
        _webView.delegate = nil;
        [_webView setHidden:YES];
        
		return NO;
	}
	else
	{
        start = [[url absoluteString] rangeOfString:@"code="];
        if (start.location != NSNotFound) {
            [_OpenSdkOauth refuseOauth:url];
        }
	}
    return YES;
}

- (void) getUserInfo{
	//授权成功，获取用户数据
	if(_OpenApi == nil){
		_OpenApi = [[OpenApi alloc] initForApi:_OpenSdkOauth.appKey 
									 appSecret:_OpenSdkOauth.appSecret 
								   accessToken:_OpenSdkOauth.accessToken
								  accessSecret:_OpenSdkOauth.accessSecret
										openid:_OpenSdkOauth.openid oauthType:_OpenSdkOauth.oauthType];
		_OpenApi.delegate = self;
		//Todo:请填写调用user/info获取用户资料接口所需的参数值，具体请参考http://wiki.open.t.qq.com/index.php/API文档
		[_OpenApi getUserInfo:@"json"];  //获取用户信息
	}			
}

- (void) getUserInfoSuccess:(NSString*)userInfo{
	NSLog(@"tencent weibo userinfo:%@",userInfo);
	
	SBJSON *jsonParser = [[SBJSON alloc]init];
	NSError *parseError = nil;
	id result = [jsonParser objectWithString:userInfo error:&parseError];
	NSDictionary *dic = [result objectForKey:@"data"];
	if (dic != nil) {
		NSString *headImage = [dic objectForKey:@"head"];
		self.headImageUrl = [NSString stringWithFormat:@"%@%@",headImage,@"/100"];
		NSString *openid=[dic objectForKey:@"openid"];
		NSString *name=[dic objectForKey:@"name"];
		NSLog(@"headImage:%@",headImageUrl);
		NSLog(@"openid:%@",openid);
		NSLog(@"name:%@",name);
		NSLog(@"accessToken:%@",_OpenSdkOauth.accessToken);
		[jsonParser release];
		
		NSDate *todayDate = [NSDate date]; 
		NSTimeInterval inter = [todayDate timeIntervalSince1970]; 
		int time = inter;
		
		//获取到的用户资料保存至本地数据库并上传至服务器
		NSMutableArray *ar_wp = [[NSMutableArray alloc]init];
		[ar_wp addObject:@"tencent"];
		[ar_wp addObject:name];
		[ar_wp addObject:openid];
		[ar_wp addObject:headImageUrl];
		[ar_wp addObject:@"accessToken"];
		[ar_wp addObject:@"accessSecret"];
		[ar_wp addObject:_OpenSdkOauth.accessToken];
		[ar_wp addObject:[NSNumber numberWithInt: _OpenSdkOauth._expireIn_time]];
		[ar_wp addObject:[NSNumber numberWithInt: 1]];
		[ar_wp addObject:[NSNumber numberWithInt: time]];
		[ar_wp addObject:_OpenSdkOauth.openid];
		[ar_wp addObject:_OpenSdkOauth.openkey];
		[DBOperate deleteData:T_WEIBO_USERINFO tableColumn:@"weiboType" columnValue:@"tencent"];
		[DBOperate insertDataWithnotAutoID:ar_wp tableName:T_WEIBO_USERINFO];
		[ar_wp release];
		
		if(progressHUD != nil){
			[self.view addSubview:self.progressHUD];
			[self.view bringSubviewToFront:self.progressHUD];
			[self.progressHUD show:YES];
		}
		
		if (_isRequest == YES) {
			NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
										 [Common getSecureString],@"keyvalue",
										 [NSNumber numberWithInt: SITE_ID],@"site_id",
										 name,@"login_name",
										 [NSNumber numberWithInt:1],@"is_weibo",
										 @"tencent",@"weibo_type",
										 openid,@"weibo_id",nil];
			
			[[DataManager sharedManager] accessService:jsontestDic command:TENCENTWEI_COMMAND_ID 
										  accessAdress:@"member/regist.do?param=%@" delegate:self withParam:nil];
			
		}else {
			if (delegate != nil) {
				NSInteger currentIndex = [self.navigationController.viewControllers indexOfObject:self];
				if( currentIndex-1 >= 0 ) {
					[self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:currentIndex-1] animated:NO];
				}
				[delegate oauthTencentSuccess];
			}
			[self.navigationController popViewControllerAnimated:YES];
		}
		
	}
}


- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
	NSLog(@"information finish");
	[self performSelectorOnMainThread:@selector(tencentLogin:) withObject:resultArray waitUntilDone:NO];
	
}

- (void)tencentLogin:(NSMutableArray*)resultArray{
    NSString *retStr = [[resultArray objectAtIndex:0] objectAtIndex:0];
    //NSLog(@"===%@",retStr);
	NSMutableArray *dbArray = [resultArray objectAtIndex:1];
	if (dbArray != nil) {
        if ([[dbArray objectAtIndex:3] isEqualToString:@""]) {
            [dbArray replaceObjectAtIndex:3 withObject:self.headImageUrl];
        }
		//NSLog(@"dbArray====%@",dbArray);
		[DBOperate deleteData:T_MEMBER_INFO];
		[DBOperate insertData:dbArray tableName:T_MEMBER_INFO];
	}
	
	_isLogin = YES;
	self.progressHUD.hidden = YES;
    
    if ([retStr isEqualToString:@"1"]) {
        NSString *name = [[[DBOperate queryData:T_MEMBER_INFO theColumn:nil theColumnValue:nil withAll:YES] objectAtIndex:0] objectAtIndex:member_info_name];
        NSString *pwd = [[[DBOperate queryData:T_MEMBER_INFO theColumn:nil theColumnValue:nil withAll:YES] objectAtIndex:0] objectAtIndex:member_info_password];
        NSString *msg = [NSString stringWithFormat:@"微博登录成功\n您的会员账号：%@\n系统初始密码：%@\n祝您使用愉快",name,pwd];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"恭喜您" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
