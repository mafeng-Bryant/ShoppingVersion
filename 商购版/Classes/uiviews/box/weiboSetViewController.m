    //
//  weiboSetViewController.m
//  Profession
//
//  Created by siphp on 12-8-24.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "weiboSetViewController.h"
#import "DBOperate.h"
#import "Common.h"

@implementation weiboSetViewController

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
	
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BG_IMAGE]];
	
	self.title = @"微博设置";
	
	//获取微博设置数据
	NSMutableArray *sinaItems = (NSMutableArray *)[DBOperate queryData:T_WEIBO_USERINFO theColumn:@"weiboType" theColumnValue:@"sina"  withAll:NO];
	
	BOOL isSetSina = [sinaItems count] != 0 ? YES : NO;
	
	NSMutableArray *tencentItems = (NSMutableArray *)[DBOperate queryData:T_WEIBO_USERINFO theColumn:@"weiboType" theColumnValue:@"tencent"  withAll:NO];
	
	BOOL isSetTencent = [tencentItems count] != 0 ? YES : NO;
	
	UIImage *weiboBackgroundImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"更多列表背景" ofType:@"png"]];
	
	//新浪微博
	UIImageView *sinaBackGround = [[UIImageView alloc]initWithFrame:CGRectMake(10.0f, 20.0f, 300.0f, 44.0f)];
	sinaBackGround.image = weiboBackgroundImage;
	[self.view addSubview:sinaBackGround];
	
	UIImageView *sinaIconImage = [[UIImageView alloc]initWithFrame:CGRectMake(7.0f, 7.0f, 30.0f, 30.0f)];
	sinaIconImage.image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"更多新浪微博icon" ofType:@"png"]];;
	[sinaBackGround addSubview:sinaIconImage];
	[sinaIconImage release];
	
	UILabel *sinaLabel = [[UILabel alloc]initWithFrame:CGRectMake(45.0f, 0.0f, 150.0f, 44.0f)];
	sinaLabel.font = [UIFont systemFontOfSize:20];
	sinaLabel.tag = 11;
	sinaLabel.textColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0];
	
	sinaLabel.textAlignment = UITextAlignmentLeft;
	sinaLabel.backgroundColor = [UIColor clearColor];
	[sinaBackGround addSubview:sinaLabel];
	[sinaLabel release];
	
	//开关
    int xValue = 0;
    if (IOS_VERSION >= 7.0) {
        xValue = 230;
    }else {
        xValue = 210;
    }
    
	sinaSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(xValue, 28.5f, 94.0f, 27.0f)];
	sinaSwitch.on = isSetSina;
	[sinaSwitch addTarget:self action:@selector(sinaSwitchChanged:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:sinaSwitch];
	[sinaSwitch release];
	
	[sinaBackGround release];
	
	//腾讯微博
	UIImageView *tencentBackGround = [[UIImageView alloc]initWithFrame:CGRectMake(10.0f, 74.0f, 300.0f, 44.0f)];
	tencentBackGround.image = weiboBackgroundImage;
	[self.view addSubview:tencentBackGround];
	
	UIImageView *tencentIconImage = [[UIImageView alloc]initWithFrame:CGRectMake(7.0f, 7.0f, 30.0f, 30.0f)];
	tencentIconImage.image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"更多腾讯微博icon" ofType:@"png"]];;
	[tencentBackGround addSubview:tencentIconImage];
	[tencentIconImage release];
	
	UILabel *tencentLabel = [[UILabel alloc]initWithFrame:CGRectMake(45.0f, 0.0f, 150.0f, 44.0f)];
	tencentLabel.font = [UIFont systemFontOfSize:20];
	tencentLabel.tag = 22;
	tencentLabel.textColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0];
	
	tencentLabel.textAlignment = UITextAlignmentLeft;
	tencentLabel.backgroundColor = [UIColor clearColor];
	[tencentBackGround addSubview:tencentLabel];
	[tencentLabel release];
	
	//开关
	tencentSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(xValue, 82.5f, 94.0f, 27.0f)];
	tencentSwitch.on = isSetTencent;
	[tencentSwitch addTarget:self action:@selector(tencentSwitchChanged:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:tencentSwitch];
	[tencentSwitch release];
	
	[tencentBackGround release];
	
	[weiboBackgroundImage release];
}

- (void)viewWillAppear:(BOOL)animated{
	UILabel *sinaLabel = (UILabel *)[self.view viewWithTag:11];
	if ([DBOperate queryData:T_WEIBO_USERINFO theColumn:@"weiboType" theColumnValue:@"sina"  withAll:NO].count != 0) {
		sinaLabel.text = [[[DBOperate queryData:T_WEIBO_USERINFO theColumn:@"weiboType" theColumnValue:@"sina"  withAll:NO] objectAtIndex:0] objectAtIndex:weibo_user_name];
		sinaSwitch.on = YES;
	}else {
		sinaLabel.text = @"新浪微博";
		sinaSwitch.on = NO;
	}
	
	UILabel *tencentLabel = (UILabel *)[self.view viewWithTag:22];
	if ([DBOperate queryData:T_WEIBO_USERINFO theColumn:@"weiboType" theColumnValue:@"tencent"  withAll:NO].count != 0) {
		tencentLabel.text = [[[DBOperate queryData:T_WEIBO_USERINFO theColumn:@"weiboType" theColumnValue:@"tencent"  withAll:NO] objectAtIndex:0] objectAtIndex:weibo_user_name];
		tencentSwitch.on = YES;
	}else {
		tencentLabel.text = @"腾讯微博";
		tencentSwitch.on = NO;
	}
}

//sina微博设置
-(void)sinaSwitchChanged:(id)sender
{
	UISwitch *sinaSwitch1 = sender;
	if (sinaSwitch1.isOn) 
	{
		//授权
		SinaViewController *sina = [[SinaViewController alloc] init];
		sina.isRequest = NO;
		[self.navigationController pushViewController:sina animated:YES];
	}
	else 
	{
		//取消授权
		sinaSwitch1.on = NO;
		[DBOperate deleteData:T_WEIBO_USERINFO tableColumn:@"weiboType" columnValue: SINA];
		UILabel *label = (UILabel *)[self.view viewWithTag:11];
		label.text = @"新浪微博";
		
	}
}

//tencent微博设置
-(void)tencentSwitchChanged:(id)sender
{
	UISwitch *tencentSwitch1 = sender;
	if (tencentSwitch1.isOn) 
	{   //授权
		TencentViewController *tencent = [[TencentViewController alloc] init];
		tencent.isRequest = NO;
		[self.navigationController pushViewController:tencent animated:YES];
	}
	else 
	{   //取消授权
		tencentSwitch1.on = NO;
		[DBOperate deleteData:T_WEIBO_USERINFO tableColumn:@"weiboType" columnValue: TENCENT];
		UILabel *label = (UILabel *)[self.view viewWithTag:22];
		label.text = @"腾讯微博";
	}
}

#pragma mark -
#pragma mark OauthSinaSeccessDelagate
- (void) oauthSinaSuccess{
	
}

#pragma mark OauthTencentSeccessDelagate
- (void) oauthTencentSuccess{
	
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
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
    [super dealloc];
}


@end
