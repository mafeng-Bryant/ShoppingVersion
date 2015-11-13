//
//  RegisterViewController.m
//  shopping
//
//  Created by 来 云 on 12-12-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RegisterViewController.h"
#import "MBProgressHUD.h"
#import "Encry.h"
#import "Common.h"
#import "DataManager.h"
#import "TencentViewController.h"
#import "SinaViewController.h"
#import "MenberCenterMainViewController.h"
#import "RegexKitLite.h"

#define kRowHeight 50.0f

@interface RegisterViewController ()

@end

@implementation RegisterViewController
@synthesize delegate;
@synthesize nameTextField;
@synthesize passwordTextField;
@synthesize progressHUD;

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
	self.title = @"免费注册";
	self.view.backgroundColor = [UIColor whiteColor];
    
//    UIBarButtonItem *mleftbto = [[UIBarButtonItem alloc]
//                                  initWithTitle:@"返回"
//                                  style:UIBarButtonItemStyleBordered
//                                  target:self
//                                  action:@selector(backAction)];
//    self.navigationItem.leftBarButtonItem = mleftbto;
//    [mleftbto release];
    
	UIView *mainView = [[UIView alloc] initWithFrame:self.view.bounds];
	[self.view addSubview:mainView];
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboardAction)];
	[mainView addGestureRecognizer:tapGesture];
	tapGesture.delegate = self;
	[mainView release];
	[tapGesture release];
	
	registTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 120) style:UITableViewStyleGrouped];
	registTableView.delegate = self;
	registTableView.dataSource = self;
	registTableView.rowHeight = kRowHeight;
	registTableView.scrollEnabled = NO;
	registTableView.backgroundColor = [UIColor whiteColor];
    registTableView.backgroundView = nil;
	[self.view addSubview:registTableView];
    
    if (IOS_VERSION >= 7.0) {
        registTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, registTableView.bounds.size.width, 10.f)];
    }
    
	UIImage *btnImage = [UIImage imageNamed:@"button_黄色.png"];
	UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
	loginButton.frame = CGRectMake(10, CGRectGetMaxY(registTableView.frame), 300, 40);
	[loginButton addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
	[loginButton setBackgroundImage:[btnImage  stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];
	[loginButton setTitle:@"确       认" forState:UIControlStateNormal];
	[self.view addSubview:loginButton];
	
	UILabel *strLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(loginButton.frame) +10, 320, 30)];
	strLabel.text = @"———— 用以下方式登录 ————";	
	strLabel.textColor = [UIColor grayColor];
	strLabel.font = [UIFont systemFontOfSize:14.0f];
	strLabel.textAlignment = UITextAlignmentCenter;
	strLabel.backgroundColor = [UIColor clearColor];
	[self.view addSubview:strLabel];
	[strLabel release];
	
	UIImage *sinaBtnImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_登录sina" ofType:@"png"]];
	UIButton *sinaButton = [UIButton buttonWithType:UIButtonTypeCustom];
	sinaButton.frame = CGRectMake(CGRectGetMinX(loginButton.frame) + 60 , CGRectGetMaxY(strLabel.frame) + 10, sinaBtnImage.size.width, sinaBtnImage.size.height);
	[sinaButton addTarget:self action:@selector(sinaWeiboAction) forControlEvents:UIControlEventTouchUpInside];
	[sinaButton setImage:sinaBtnImage forState:UIControlStateNormal];
	[self.view addSubview:sinaButton];
	[sinaBtnImage release];
	
	UILabel *sinaLabel = [[UILabel alloc] initWithFrame:CGRectMake(sinaButton.frame.origin.x, CGRectGetMaxY(sinaButton.frame) + 5 , sinaBtnImage.size.width, 20)];
	sinaLabel.text = @"新浪微博";	
	sinaLabel.textColor = [UIColor grayColor];
	sinaLabel.font = [UIFont systemFontOfSize:14.0f];
	sinaLabel.textAlignment = UITextAlignmentCenter;
	sinaLabel.backgroundColor = [UIColor clearColor];
	[self.view addSubview:sinaLabel];
	[sinaLabel release];
	
	UIImage *tencentBtnImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_登录腾讯" ofType:@"png"]];
	UIButton *tencentButton = [UIButton buttonWithType:UIButtonTypeCustom];
	tencentButton.frame = CGRectMake(CGRectGetMaxX(sinaButton.frame) + 60, CGRectGetMaxY(strLabel.frame) + 10, tencentBtnImage.size.width, tencentBtnImage.size.height);
	[tencentButton addTarget:self action:@selector(tencentWeiboAction) forControlEvents:UIControlEventTouchUpInside];
	[tencentButton setImage:tencentBtnImage forState:UIControlStateNormal];
	[self.view addSubview:tencentButton];
	[tencentBtnImage release];
	
	UILabel *tencentLabel = [[UILabel alloc] initWithFrame:CGRectMake(tencentButton.frame.origin.x, CGRectGetMaxY(sinaButton.frame) + 5, tencentBtnImage.size.width, 20)];
	tencentLabel.text = @"腾讯微博";	
	tencentLabel.textColor = [UIColor grayColor];
	tencentLabel.font = [UIFont systemFontOfSize:14.0f];
	tencentLabel.textAlignment = UITextAlignmentCenter;
	tencentLabel.backgroundColor = [UIColor clearColor];
	[self.view addSubview:tencentLabel];
	[tencentLabel release];
	
//	UIButton *registButton = [UIButton buttonWithType:UIButtonTypeCustom];
//	registButton.frame = CGRectMake((320 - btnImage.size.width) * 0.5f, CGRectGetMaxY(sinaLabel.frame) + 20, btnImage.size.width, btnImage.size.height);
//	[registButton addTarget:self action:@selector(haveNameAction) forControlEvents:UIControlEventTouchUpInside];
//	[registButton setBackgroundImage:btnImage forState:UIControlStateNormal];
//	[registButton setTitle:@"我有帐号" forState:UIControlStateNormal];
//	[self.view addSubview:registButton];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    registTableView = nil;
    nameTextField = nil;
	passwordTextField = nil;
	progressHUD = nil;
}

- (void)dealloc {
	[registTableView release];
	[nameTextField release];
	[passwordTextField release];
	[progressHUD release];
    
	registTableView = nil;
	nameTextField = nil;
	passwordTextField = nil;
	progressHUD = nil;
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    //ios7新特性,解决分割线短一点
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];	
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		switch (indexPath.row) {
            case 0:
            {
				UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 60, 40)];
				name.text = @"帐 号：";			
				name.textAlignment = UITextAlignmentLeft;
				name.backgroundColor = [UIColor clearColor];
				[cell.contentView addSubview:name];
				[name release];
                
				UITextField *nameText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(name.frame), 10, 220, 30)];
				self.nameTextField = nameText;
				nameTextField.borderStyle = UITextBorderStyleNone;
				nameTextField.backgroundColor = [UIColor clearColor];
				nameTextField.keyboardType = UIKeyboardTypeNumberPad;
				[self.nameTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
				[cell.contentView addSubview:nameTextField];
				nameTextField.placeholder = @"使用手机号码3秒快速注册";
				[nameText release];
				
            }break;
            case 1:
            {
                UILabel *password = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 60, 40)];
				password.text = @"密 码：";
				password.textAlignment = UITextAlignmentLeft;
				password.backgroundColor = [UIColor clearColor];
				[cell.contentView addSubview:password];
				[password release];
				
				UITextField *passwordText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(password.frame), 10, 220, 30)];
				self.passwordTextField = passwordText;
				passwordTextField.borderStyle = UITextBorderStyleNone;
				passwordTextField.backgroundColor = [UIColor clearColor];
                [self.passwordTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
				[cell.contentView addSubview:passwordTextField];
				passwordTextField.placeholder = @"使用能记得住的哦";
				passwordTextField.secureTextEntry = YES;
				[passwordText release];
                
            }break;
				
            default:
                break;
        }
    }
	
	return cell;
}

#pragma mark -----private methods
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dismissKeyboardAction
{
	[nameTextField resignFirstResponder];
	[passwordTextField resignFirstResponder];
}
- (void)finishAction
{
	[nameTextField resignFirstResponder];
	[passwordTextField resignFirstResponder];
    
	if (nameTextField.text.length == 0 || passwordTextField.text.length == 0) {
		//UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"信息" ofType:@"png"]]];
        
		MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithView:self.view];
		self.progressHUD = progressHUDTmp;
		[progressHUDTmp release];
		self.progressHUD.delegate = self;
		self.progressHUD.customView= [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-信息.png"]] autorelease];
		self.progressHUD.mode = MBProgressHUDModeCustomView; 
		self.progressHUD.labelText = @"帐号和密码不能为空";
		[self.view addSubview:self.progressHUD];
		[self.view bringSubviewToFront:self.progressHUD];
		[self.progressHUD show:YES];
		[self.progressHUD hide:YES afterDelay:1];		
	}else if (!(nameTextField.text.length == 11)) {
		MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithView:self.view];
		self.progressHUD = progressHUDTmp;
		[progressHUDTmp release];
		self.progressHUD.delegate = self;
		self.progressHUD.customView= [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-信息.png"]] autorelease];
		self.progressHUD.mode = MBProgressHUDModeCustomView; 
		self.progressHUD.labelText = @"请输入正确的手机号码";
		[self.view addSubview:self.progressHUD];
		[self.view bringSubviewToFront:self.progressHUD];
		[self.progressHUD show:YES];
		[self.progressHUD hide:YES afterDelay:1];
	}else if ([self validateRegexPassword:passwordTextField.text] == NO) {
		MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithView:self.view];
		self.progressHUD = progressHUDTmp;
		[progressHUDTmp release];
		self.progressHUD.delegate = self;
		self.progressHUD.customView= [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-信息.png"]] autorelease];
		self.progressHUD.mode = MBProgressHUDModeCustomView; 
		self.progressHUD.labelText = @"密码为6-20个英文字母或数字";
		[self.view addSubview:self.progressHUD];
		[self.view bringSubviewToFront:self.progressHUD];
		[self.progressHUD show:YES];
		[self.progressHUD hide:YES afterDelay:1];
	} else {
		[self accessService];
		
		MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithView:self.view];
		self.progressHUD = progressHUDTmp;
		[progressHUDTmp release];
		self.progressHUD.delegate = self;
		self.progressHUD.labelText = @"登录中...";
		[self.view addSubview:self.progressHUD];
		[self.view bringSubviewToFront:self.progressHUD];
		[self.progressHUD show:YES];
	}	
}

- (void)sinaWeiboAction
{
	SinaViewController *sina = [[SinaViewController alloc] init];
	sina.isRequest = YES;
	[self.navigationController pushViewController:sina animated:YES];
	
	[self checkWeiboExpiredAction];
}

- (void)tencentWeiboAction
{
	TencentViewController *tencent = [[TencentViewController alloc] init];
	tencent.isRequest = YES;
	[self.navigationController pushViewController:tencent animated:YES];
	
	[self checkWeiboExpiredAction];
}

- (void)haveNameAction
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)checkWeiboExpiredAction
{
	//检测微博是否已经过期，如果过期的就删除
	NSArray *array = [DBOperate queryData:T_WEIBO_USERINFO theColumn:nil theColumnValue:nil  withAll:YES];
	if(array != nil && [array count] > 0){
		for (int i = 0; i < [array count];i++ ) {
			NSArray *wbArray = [array objectAtIndex:i];
			NSString *type = [wbArray objectAtIndex:weibo_type];
			if ([type isEqualToString:SINA]) {
				int oauthTime = [[wbArray objectAtIndex:weibo_oauth_time] intValue];
				int expiredTime = [[wbArray objectAtIndex:weibo_expires_time] intValue];			
				NSDate *todayDate = [NSDate date]; 
				NSLog(@"Date:%@",todayDate);
				NSTimeInterval inter = [todayDate timeIntervalSince1970]; 
				int time = inter;
				NSLog(@"current time:%d",time);
				NSLog(@"expiresTime:%d",expiredTime);
				NSLog(@"time - oauthTime:%d",time - oauthTime);
				if(expiredTime - (time - oauthTime) <= 0){
					[DBOperate deleteData:T_WEIBO_USERINFO tableColumn:@"weiboType" columnValue:type];
				}
			}else if ([type isEqualToString:TENCENT]) {
				int expiredTime = [[wbArray objectAtIndex:weibo_expires_time] intValue];
				NSDate *todayDate = [NSDate date]; 
				NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:expiredTime];
				NSLog(@"todayDate:%@",todayDate);
				NSLog(@"expirationDate:%@",expirationDate);
				if([todayDate compare:expirationDate] == NSOrderedSame){
					[DBOperate deleteData:T_WEIBO_USERINFO tableColumn:@"weiboType" columnValue:type];
				}else {
					NSLog(@"not expired");
				}
				
			}
			
		}
	}
	
}

- (void)accessService
{
	NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
								 [Common getSecureString],@"keyvalue",
								 [NSString stringWithFormat:@"%d",SITE_ID],@"site_id",
								 nameTextField.text,@"login_name",
								 passwordTextField.text,@"login_pwd",
								 @"0",@"is_weibo",nil];
	
	[[DataManager sharedManager] accessService:jsontestDic command:MEMBER_REGIST_COMMAND_ID 
								  accessAdress:@"member/regist.do?param=%@" delegate:self withParam:nil];
}

- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
	NSLog(@"information finish");
	int resultInt = [[[resultArray objectAtIndex:0] objectAtIndex:0]intValue];
	
	switch (commandid) {
		case MEMBER_REGIST_COMMAND_ID:
		{
			if (resultInt == 0) {
				[self performSelectorOnMainThread:@selector(error) withObject:nil waitUntilDone:NO];
			}else if (resultInt == 1) {
                
				[self performSelectorOnMainThread:@selector(success:) withObject:resultArray waitUntilDone:NO];
                
			}else if (resultInt == 2) {
				[self performSelectorOnMainThread:@selector(isExistName) withObject:nil waitUntilDone:NO];
			}
			
		}break;
        default:
			break;
	}
}

- (void) success:(NSMutableArray*)resultArray{
	self.progressHUD.hidden = YES;
	[self.progressHUD removeFromSuperview];
	
	_isLogin = YES;
	
	NSMutableArray *infoArray = [resultArray objectAtIndex:1];
	[infoArray removeObjectAtIndex:2];
	[infoArray insertObject:passwordTextField.text atIndex:2];
	NSLog(@"infoArray====%@",infoArray);
	[DBOperate deleteData:T_MEMBER_INFO];
	[DBOperate insertData:infoArray tableName:T_MEMBER_INFO];
    
    //------
    [DBOperate deleteData:T_SYSTEM_CONFIG tableColumn:@"tag" columnValue:@"isRememberName"];
    [DBOperate deleteData:T_SYSTEM_CONFIG tableColumn:@"tag" columnValue:@"isRememberPassword"];
    
    NSMutableArray *nameArray = [[NSMutableArray alloc]init];
    [nameArray addObject:@"isRememberName"];
    [nameArray addObject:nameTextField.text];
    [DBOperate insertDataWithnotAutoID:nameArray tableName:T_SYSTEM_CONFIG];
    [nameArray release];
    
    NSMutableArray *passwordArray = [[NSMutableArray alloc]init];
    [passwordArray addObject:@"isRememberPassword"];
    [passwordArray addObject:passwordTextField.text];
    [DBOperate insertDataWithnotAutoID:passwordArray tableName:T_SYSTEM_CONFIG];
    [passwordArray release];
    //---------
    
    NSArray *arr = self.navigationController.viewControllers;
    NSLog(@"[arr count]====%d",[arr count]);
    if ([arr count] == 2 || [arr count] == 3) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }else if ([arr count] >= 4){
        [self.navigationController popToViewController:[arr objectAtIndex:arr.count-3] animated:YES];
        //return;
    }
    if (delegate != nil) {
        [delegate registerSuccess];
    }
}

- (void)error
{
	_isLogin = NO;
	self.progressHUD.customView= [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-信息.png"]] autorelease];
	self.progressHUD.mode = MBProgressHUDModeCustomView; 
	self.progressHUD.labelText = @"注册失败";
	[self.progressHUD hide:YES afterDelay:1];
}

- (void)isExistName
{
	_isLogin = NO;
	self.progressHUD.customView= [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-信息.png"]] autorelease];
	self.progressHUD.mode = MBProgressHUDModeCustomView; 
	self.progressHUD.labelText = @"该用户名已存在，请重新注册";
	[self.progressHUD hide:YES afterDelay:1];
	
	nameTextField.text = nil;
}

- (BOOL)validateRegexPassword:(NSString *)password
{
    if (!password) {
        return FALSE;
    }
    return [password isMatchedByRegex:@"\\b[a-zA-Z0-9]{6,20}\\b"];
}
@end
