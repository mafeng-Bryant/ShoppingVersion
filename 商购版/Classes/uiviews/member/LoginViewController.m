//
//  LoginViewController.m
//  shopping
//
//  Created by 来 云 on 12-12-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "DBOperate.h"
#import "Encry.h"
#import "DataManager.h"
#import "Common.h"
#import "DBOperate.h"
#import "OpenSdkOauth.h"
#import "OpenApi.h"
#import "TencentViewController.h"
#import "SinaViewController.h"
#import "UIImageScale.h"
#import "FileManager.h"
#import "shoppingAppDelegate.h"

#define kRowHeight 50.0f

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize nameTextField;
@synthesize passwordTextField;
@synthesize mbProgressHUD;
@synthesize headImageView;
@synthesize progressHUD;
@synthesize memberCenter;
@synthesize img;
@synthesize delegate;
@synthesize upload;
@synthesize scaleImage;

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
    self.view.backgroundColor = [UIColor whiteColor];
    
	UIView *mainView = [[UIView alloc] initWithFrame:self.view.bounds];
	[self.view addSubview:mainView];
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboardAction)];
	[mainView addGestureRecognizer:tapGesture];
	tapGesture.delegate = self;
	[mainView release];
	[tapGesture release];
	
	loginTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 120) style:UITableViewStyleGrouped];
	loginTableView.delegate = self;
	loginTableView.dataSource = self;
	loginTableView.rowHeight = kRowHeight;
	loginTableView.scrollEnabled = NO;
	loginTableView.backgroundColor = [UIColor whiteColor];
    loginTableView.backgroundView = nil;
	[self.view addSubview:loginTableView];
    
    if (IOS_VERSION >= 7.0) {
        loginTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, loginTableView.bounds.size.width, 10.f)];
    }
    
    //-------------------------
    UIImage *btnImg1 = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"input_未选中" ofType:@"png"]];
    UIImage *btnImg2 = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"input_选中" ofType:@"png"]];
    
    showPwdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    showPwdButton.tag = 1;
    showPwdButton.frame = CGRectMake(30, CGRectGetMaxY(loginTableView.frame), btnImg1.size.width, btnImg1.size.height);
    [showPwdButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showPwdButton];
    [showPwdButton setImage:btnImg1 forState:UIControlStateNormal];
    
    UILabel *strLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(showPwdButton.frame), showPwdButton.frame.origin.y, 60, 16)];
    strLabel1.backgroundColor = [UIColor clearColor];
    strLabel1.text = @"显示密码";
    strLabel1.font = [UIFont systemFontOfSize:14];
    strLabel1.textAlignment = UITextAlignmentCenter;
    strLabel1.textColor = [UIColor darkGrayColor];
    [self.view addSubview:strLabel1];
    [strLabel1 release];

    rememberPwdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rememberPwdButton.tag = 2;
    rememberPwdButton.frame = CGRectMake(210, CGRectGetMaxY(loginTableView.frame), btnImg1.size.width, btnImg1.size.height);
    [rememberPwdButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rememberPwdButton];
    [rememberPwdButton setImage:btnImg2 forState:UIControlStateNormal];
    
    UILabel *strLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(rememberPwdButton.frame), rememberPwdButton.frame.origin.y, 60, 16)];
    strLabel2.backgroundColor = [UIColor clearColor];
    strLabel2.text = @"记住密码";
    strLabel2.font = [UIFont systemFontOfSize:14];
    strLabel2.textAlignment = UITextAlignmentCenter;
    strLabel2.textColor = [UIColor darkGrayColor];
    [self.view addSubview:strLabel2];
    [strLabel2 release];
    
    _isShow = NO;
    _isRemember = YES;
    //-------------------------
    
	UIImage *btnImage = [UIImage imageNamed:@"button_黄色.png"];
	UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
	loginButton.frame = CGRectMake(10, CGRectGetMaxY(rememberPwdButton.frame) + 8, 300, 40);
	[loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
	[loginButton setBackgroundImage:[btnImage stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];
	[loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
	[self.view addSubview:loginButton];
	
	UILabel *strLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(loginButton.frame) + 5, 320, 30)];
	strLabel.text = @"———— 用以下方式登录 ————";	
	strLabel.textColor = [UIColor grayColor];
	strLabel.font = [UIFont systemFontOfSize:14.0f];
	strLabel.textAlignment = UITextAlignmentCenter;
	strLabel.backgroundColor = [UIColor clearColor];
	[self.view addSubview:strLabel];
	[strLabel release];
	
	UIImage *sinaBtnImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_登录sina" ofType:@"png"]];
	UIButton *sinaButton = [UIButton buttonWithType:UIButtonTypeCustom];
	sinaButton.frame = CGRectMake(CGRectGetMinX(loginButton.frame) + 60 , CGRectGetMaxY(strLabel.frame) + 5, sinaBtnImage.size.width, sinaBtnImage.size.height);
	[sinaButton addTarget:self action:@selector(sinaWeiboAction) forControlEvents:UIControlEventTouchUpInside];
	[sinaButton setImage:sinaBtnImage forState:UIControlStateNormal];
	[self.view addSubview:sinaButton];
	[sinaBtnImage release];
	
	UILabel *sinaLabel = [[UILabel alloc] initWithFrame:CGRectMake(sinaButton.frame.origin.x, CGRectGetMaxY(sinaButton.frame) + 5 , sinaBtnImage.size.width, 20)];
	sinaLabel.text = @"新浪微博";	
	sinaLabel.textColor = [UIColor darkTextColor];
	sinaLabel.font = [UIFont systemFontOfSize:14.0f];
	sinaLabel.textAlignment = UITextAlignmentCenter;
	sinaLabel.backgroundColor = [UIColor clearColor];
	[self.view addSubview:sinaLabel];
	[sinaLabel release];
    
	UIImage *tencentBtnImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_登录腾讯" ofType:@"png"]];
	UIButton *tencentButton = [UIButton buttonWithType:UIButtonTypeCustom];
	tencentButton.frame = CGRectMake(CGRectGetMaxX(sinaButton.frame) + 60, CGRectGetMaxY(strLabel.frame) + 5, tencentBtnImage.size.width, tencentBtnImage.size.height);
	[tencentButton addTarget:self action:@selector(tencentWeiboAction) forControlEvents:UIControlEventTouchUpInside];
	[tencentButton setImage:tencentBtnImage forState:UIControlStateNormal];
	[self.view addSubview:tencentButton];
	[tencentBtnImage release];
    
	UILabel *tencentLabel = [[UILabel alloc] initWithFrame:CGRectMake(tencentButton.frame.origin.x, CGRectGetMaxY(sinaButton.frame) + 5, tencentBtnImage.size.width, 20)];
	tencentLabel.text = @"腾讯微博";
	tencentLabel.textColor = [UIColor darkTextColor];
	tencentLabel.font = [UIFont systemFontOfSize:14.0f];
	tencentLabel.textAlignment = UITextAlignmentCenter;
	tencentLabel.backgroundColor = [UIColor clearColor];
	[self.view addSubview:tencentLabel];
	[tencentLabel release];
	
	UIButton *registButton = [UIButton buttonWithType:UIButtonTypeCustom];
	registButton.frame = CGRectMake(10, CGRectGetMaxY(sinaLabel.frame) + 10, 300, 40);
	[registButton addTarget:self action:@selector(registAction) forControlEvents:UIControlEventTouchUpInside];
	[registButton setBackgroundImage:[btnImage stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];
	[registButton setTitle:@"我是新人" forState:UIControlStateNormal];
	[self.view addSubview:registButton];
    
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"新人" ofType:@"png"]];
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(80 , (40 - image.size.height) * 0.5 - 2, image.size.width, image.size.height)];
    [registButton addSubview:leftImageView];
    leftImageView.image = image;
    [image release];
    
    memberCenter = [[MenberCenterMainViewController alloc] init];
    memberCenter.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	memberCenter.loginViewController = self;
	memberCenter.delegate = self;
	[self.view addSubview:memberCenter.view];
    memberCenter.view.hidden = YES;
    
    barBtnItem = [[UIBarButtonItem alloc]
                  initWithTitle:@"注销"
                  style:UIBarButtonItemStyleBordered
                  target:self
                  action:@selector(cancelAction)];
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	if (_isLogin == YES) {
        
        self.tabBarController.title = @"会员中心";
        self.tabBarController.navigationItem.rightBarButtonItem = barBtnItem;
        
		memberCenter.view.hidden = NO;
		[memberCenter viewAppearAction];
		
    }else {
        self.tabBarController.title = @"登录";
        self.tabBarController.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    nameTextField = nil;
	passwordTextField = nil;
	mbProgressHUD = nil;
	progressHUD = nil;
	
	memberCenter = nil;
	headImageView = nil;
	img = nil;
	
	delegate = nil;
	upload = nil;
	scaleImage = nil;
}

- (void)dealloc {
	[loginTableView release];
	[nameTextField release];
	[passwordTextField release];
	[mbProgressHUD release];
	
	[progressHUD release];
	
	[memberCenter release];
	[headImageView release];
	[img release];
	[upload release];
	[scaleImage release];
    
    [showPwdButton release];
    [rememberPwdButton release];
	
	loginTableView = nil;
	nameTextField = nil;
	passwordTextField = nil;
	mbProgressHUD = nil;
	progressHUD = nil;
	
	memberCenter = nil;
	headImageView = nil;
	img = nil;
	
	delegate = nil;
	upload = nil;
	scaleImage = nil;
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
            nameText.clearButtonMode = UITextFieldViewModeWhileEditing;
            self.nameTextField = nameText;
            nameTextField.delegate = self;
            nameTextField.borderStyle = UITextBorderStyleNone;
            nameTextField.backgroundColor = [UIColor clearColor];
            nameTextField.placeholder = @"手机号码";
            [self.nameTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            [cell.contentView addSubview:nameTextField];
            [nameText release];
            
            NSArray *isRememberNameArray = [DBOperate queryData:T_SYSTEM_CONFIG theColumn:@"tag" 
                                                 theColumnValue:@"isRememberName" withAll:NO];
            if ([isRememberNameArray count] > 0 ) {
                self.nameTextField.text = [[isRememberNameArray objectAtIndex:0] objectAtIndex:1];
            }
            
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
            passwordText.clearButtonMode = UITextFieldViewModeWhileEditing;
            self.passwordTextField = passwordText;
            passwordTextField.borderStyle = UITextBorderStyleNone;
            passwordTextField.backgroundColor = [UIColor clearColor];
            passwordTextField.placeholder = @"输入密码";
            [self.passwordTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            passwordTextField.secureTextEntry = YES;
            passwordTextField.delegate = self;
            [cell.contentView addSubview:passwordTextField];
            [passwordText release];
            
            NSArray *isRememberPasswordArray = [DBOperate queryData:T_SYSTEM_CONFIG theColumn:@"tag" 
                                                     theColumnValue:@"isRememberPassword" withAll:NO];
            if ([isRememberPasswordArray count] > 0 ) {
                self.passwordTextField.text = [[isRememberPasswordArray objectAtIndex:0] objectAtIndex:1];
            }
        }break;
            
        default:
            break;
    }
	
	return cell;
}

#pragma mark -----UITextFieldDelegate  method
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nameTextField) {
        [self.nameTextField resignFirstResponder];
        [self.passwordTextField becomeFirstResponder];
    }else {
        [self loginAction];
    }
    return YES;
}

#pragma mark -----UIImagePickerControllerDelegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque];
    
	if(picker.sourceType==UIImagePickerControllerSourceTypeCamera){
		
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"是否上传到服务器？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
//		[alert show];
//		[alert release];
		
		[self dismissModalViewControllerAnimated:YES];
        
	}else {
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"是否上传到服务器？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
//		[alert show];
//		[alert release];
		
		[picker dismissModalViewControllerAnimated:YES];   
    }
    _isChangedImage = YES;
	shoppingAppDelegate *deleagte = (shoppingAppDelegate *)[UIApplication sharedApplication].delegate;
	deleagte.headerImage = image;
	[self.memberCenter.memberHeaderView setImage:deleagte.headerImage];
	self.img = deleagte.headerImage;
    
    
    MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithView:self.view];
    self.mbProgressHUD = progressHUDTmp;
    [progressHUDTmp release];
    self.mbProgressHUD.delegate = self;
    self.mbProgressHUD.labelText = @"正在上传...";
    [self.view addSubview:self.mbProgressHUD];
    [self.mbProgressHUD show:YES];
    
    int _userId = [[[[DBOperate queryData:T_MEMBER_INFO theColumn:nil theColumnValue:nil withAll:YES] objectAtIndex:0] objectAtIndex:member_info_memberId] intValue];
    
    NSMutableDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [Common getSecureString],@"keyvalue",
                                        [NSNumber numberWithInt: SITE_ID],@"site_id",
                                        [NSNumber numberWithInt:_userId],@"user_id",nil];
    
    NSString *reqstr = [Common TransformJson:jsontestDic withLinkStr: [ACCESS_SERVER_LINK stringByAppendingString:@"member/updateinfo.do?param=%@"]];
    self.scaleImage = [self.img scaleToSize:CGSizeMake(60, 60)];
    NSData *pictureData =UIImagePNGRepresentation(self.img);
    upload = [[EPUploader alloc] initWithURL:[NSURL URLWithString:reqstr] filePath:pictureData delegate:self doneSelector:@selector(onUploadDone:) errorSelector:@selector(onUploadError:)];
    upload.uploaderDelegate = self;
    
	
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque];
    
    [picker dismissModalViewControllerAnimated:YES];  
    
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([[[UIDevice currentDevice] systemVersion] intValue]>=7) {
        [navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    }
}

#pragma mark ----MenberCenterMainViewControllerDelegate method
- (void)actionButtonIndex:(int)index imageView:(UIImageView *)imgView{
	self.headImageView = imgView;
	UIImagePickerController *myPicker  = [[UIImagePickerController alloc] init];
    myPicker.delegate = self;
    myPicker.editing = YES;
    switch (index) {
        case 0:
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                myPicker.sourceType=UIImagePickerControllerSourceTypeCamera;
				myPicker.allowsEditing = YES;
                [self presentModalViewController:myPicker animated:YES];
            }        
            break;
        case 1:
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
                myPicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
				myPicker.allowsEditing = YES;
                [self presentModalViewController:myPicker animated:YES];
            }
            
            break;
        default:
            break;
    }
	[myPicker release];
}

//#pragma mark ------UIAlertViewDelegate methods
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//	
//	if (buttonIndex == 0) {
//        
//        MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithView:self.view];
//		self.mbProgressHUD = progressHUDTmp;
//		[progressHUDTmp release];
//		self.mbProgressHUD.delegate = self;
//		self.mbProgressHUD.labelText = @"正在上传...";
//		[self.view addSubview:self.mbProgressHUD];
//		[self.mbProgressHUD show:YES];
//        
//		int _userId = [[[[DBOperate queryData:T_MEMBER_INFO theColumn:nil theColumnValue:nil withAll:YES] objectAtIndex:0] objectAtIndex:member_info_memberId] intValue];
//		
//		NSMutableDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                            [Common getSecureString],@"keyvalue",
//                                            [NSNumber numberWithInt: SITE_ID],@"site_id",
//                                            [NSNumber numberWithInt:_userId],@"user_id",nil];
//		
//		NSString *reqstr = [Common TransformJson:jsontestDic withLinkStr: [ACCESS_SERVER_LINK stringByAppendingString:@"member/updateinfo.do?param=%@"]];
//		self.scaleImage = [self.img scaleToSize:CGSizeMake(60, 60)];
//		NSData *pictureData =UIImagePNGRepresentation(self.img);
//		upload = [[EPUploader alloc] initWithURL:[NSURL URLWithString:reqstr] filePath:pictureData delegate:self doneSelector:@selector(onUploadDone:) errorSelector:@selector(onUploadError:)];
//	    upload.uploaderDelegate = self;
//	}
//}

#pragma mark ---EPUploaderDelegate method
- (void)receiveResult:(NSString *)result
{
	NSDictionary *resultDic = [result JSONValue];
	NSLog(@"resultDic===%@",resultDic);
	NSString *retStr = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"ret"]];
	NSString *urlStr = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"url"]];
	if ([retStr isEqualToString:@"1"] && urlStr.length > 0) {
        
		NSArray *dbArr = [[DBOperate queryData:T_MEMBER_INFO theColumn:nil theColumnValue:nil withAll:YES] objectAtIndex:0];
		NSString *name = [dbArr objectAtIndex:member_info_name];
		NSString *userId = [NSString stringWithFormat:@"%d",[[dbArr objectAtIndex:member_info_memberId] intValue]];
		
		NSString *photoname = [Common encodeBase64:(NSMutableData *)[urlStr dataUsingEncoding: NSUTF8StringEncoding]];
		
		if ([FileManager savePhoto:photoname withImage:self.scaleImage]) {
			[DBOperate updateWithTwoConditions:T_MEMBER_INFO theColumn:@"image" theColumnValue:urlStr ColumnOne:@"memberId" valueOne:userId columnTwo:@"memberName" valueTwo:name];
			
		}
	}	
}

#pragma mark -----private methods
- (void) onUploadDone:(id)sender{
    
    [self.mbProgressHUD hide:YES];
    [self.mbProgressHUD removeFromSuperViewOnHide];
	
	MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithView:self.view];	
	progressHUDTmp.delegate = self;
	progressHUDTmp.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-ok.png"]] autorelease];
	progressHUDTmp.mode = MBProgressHUDModeCustomView;
	progressHUDTmp.labelText = @"上传成功";
	[self.view addSubview:progressHUDTmp];
	[progressHUDTmp show:YES];
	[progressHUDTmp hide:YES afterDelay:2];	
    [progressHUDTmp release];
}
- (void) onUploadError:(id)sender{
    [self.mbProgressHUD hide:YES];
    [self.mbProgressHUD removeFromSuperViewOnHide];
	
	MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithView:self.view];
	progressHUDTmp.delegate = self;
	progressHUDTmp.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-信息.png"]] autorelease];
	progressHUDTmp.mode = MBProgressHUDModeCustomView;
	progressHUDTmp.labelText = @"上传失败";
	[self.view addSubview:progressHUDTmp];
	[progressHUDTmp show:YES];
	[progressHUDTmp hide:YES afterDelay:2];	
    [progressHUDTmp release];
}

- (void)dismissKeyboardAction
{
	[nameTextField resignFirstResponder];
	[passwordTextField resignFirstResponder];
}

- (void)loginAction
{
	[nameTextField resignFirstResponder];
	[passwordTextField resignFirstResponder];
	
	if (nameTextField.text.length == 0 || passwordTextField.text.length == 0) {
		MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithView:self.view];
		self.mbProgressHUD = progressHUDTmp;
		[progressHUDTmp release];
		self.mbProgressHUD.delegate = self;
		self.mbProgressHUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-信息.png"]] autorelease];
		self.mbProgressHUD.mode = MBProgressHUDModeCustomView;
		self.mbProgressHUD.labelText = @"帐号和密码不能为空";
		[self.view addSubview:self.mbProgressHUD];
		[self.mbProgressHUD show:YES];
		[self.mbProgressHUD hide:YES afterDelay:1];
		
	}else {
		MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithView:self.view];
		self.mbProgressHUD = progressHUDTmp;
		[progressHUDTmp release];
		self.mbProgressHUD.delegate = self;
		self.mbProgressHUD.labelText = @"登录中...";
		[self.view addSubview:self.mbProgressHUD];
		[self.mbProgressHUD show:YES];
		
		[self accessService];
	}
    
}

- (void)sinaWeiboAction
{
    [self checkWeiboExpiredAction];
	SinaViewController *sinaViewController = [[SinaViewController alloc] init];
	sinaViewController.isRequest = YES;
	sinaViewController.loginDelegate = delegate;
    sinaViewController.delegate = self;
	[self.navigationController pushViewController:sinaViewController animated:YES];
}

- (void)tencentWeiboAction
{
	[self checkWeiboExpiredAction];
	
	TencentViewController *tencentViewController = [[TencentViewController alloc] init];
	tencentViewController.isRequest = YES;
	tencentViewController.loginDelegate = delegate;
	[self.navigationController pushViewController:tencentViewController animated:YES];
}

- (void)registAction
{
	RegisterViewController *registViewController = [[RegisterViewController alloc] init];
    registViewController.delegate = self;
	[self.navigationController pushViewController:registViewController animated:YES];
	[registViewController release];
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
								 [NSNumber numberWithInt: SITE_ID],@"site_id",
								 nameTextField.text,@"login_name",
								 passwordTextField.text,@"login_pwd",nil];
	
	[[DataManager sharedManager] accessService:jsontestDic command:MEMBER_LOGIN_COMMAND_ID 
								  accessAdress:@"member/login.do?param=%@" delegate:self withParam:nil];
}

- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
	NSLog(@"information finish");
	switch (commandid) {
		case MEMBER_LOGIN_COMMAND_ID:
		{
			NSString *resultstr = [[resultArray objectAtIndex:0] objectAtIndex:0];
			if ([resultstr isEqualToString:@"1"]) {
				[self performSelectorOnMainThread:@selector(loginSuccess:) withObject:resultArray waitUntilDone:NO];
			}else {
				[self performSelectorOnMainThread:@selector(loginFail) withObject:nil waitUntilDone:NO];
			}
		}break;
          
		default:
			break;
	}
	
	if (progressHUD != nil) {
		[progressHUD removeFromSuperViewOnHide];
	}
}


- (void)loginSuccess:(NSMutableArray*)resultArray
{
	self.mbProgressHUD.hidden = YES;
	
	_isLogin = YES;
    
    self.tabBarController.title = @"会员中心";
    self.tabBarController.navigationItem.rightBarButtonItem = barBtnItem;
	
	NSMutableArray *infoArray = [resultArray objectAtIndex:1];
	[infoArray removeObjectAtIndex:1];
	[infoArray insertObject:nameTextField.text atIndex:1];
	[infoArray removeObjectAtIndex:2];
	[infoArray insertObject:passwordTextField.text atIndex:2];
	//NSLog(@"infoArray====%@",infoArray);
	[DBOperate deleteData:T_MEMBER_INFO];
	[DBOperate insertData:infoArray tableName:T_MEMBER_INFO];
    
    if (_isRemember == YES) {
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
    }else {
        [DBOperate deleteData:T_SYSTEM_CONFIG tableColumn:@"tag" columnValue:@"isRememberName"];
        [DBOperate deleteData:T_SYSTEM_CONFIG tableColumn:@"tag" columnValue:@"isRememberPassword"];
    }
    
	nameTextField.text = nil;
	passwordTextField.text = nil;
	
	if (delegate != nil) {
		[self.navigationController popViewControllerAnimated:YES];		
		[delegate loginWithResult:YES];
	}
	
    _isChangedImage = NO;
    self.memberCenter.view.hidden = NO;
	[self.view bringSubviewToFront:self.memberCenter.view];
	[memberCenter viewAppearAction];
}

- (void)loginFail
{
	_isLogin = NO;
	self.mbProgressHUD.hidden = YES;
	
	MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithView:self.view];
	progressHUDTmp.delegate = self;
	progressHUDTmp.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-信息.png"]] autorelease];
	progressHUDTmp.mode = MBProgressHUDModeCustomView;
	progressHUDTmp.labelText = @"用户名和密码错误，请重新输入";
	[self.view addSubview:progressHUDTmp];
	[progressHUDTmp show:YES];
	[progressHUDTmp hide:YES afterDelay:1.5];
	[progressHUDTmp release];
	
	if (delegate != nil) {
		[delegate loginWithResult:NO];
	}
}

- (void)cancelAction
{
	[DBOperate deleteData:T_MEMBER_INFO];
	
	self.memberCenter.view.hidden = YES;
	_isLogin = NO;
	
    self.tabBarController.title = @"登录";
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    
    [loginTableView reloadData];
    
	shoppingAppDelegate *deleagte = (shoppingAppDelegate *)[UIApplication sharedApplication].delegate;
	deleagte.headerImage = nil;
	self.headImageView.image = deleagte.headerImage;
}

- (void)selectAction:(id)sender
{
    [self.nameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    UIImage *btnImg1 = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"input_未选中" ofType:@"png"]];
    UIImage *btnImg2 = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"input_选中" ofType:@"png"]];
    
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 1) {
        if (_isShow == NO) {
            [showPwdButton setImage:btnImg2 forState:UIControlStateNormal];
            self.passwordTextField.secureTextEntry = NO;
            _isShow = YES;
        }else {
            [showPwdButton setImage:btnImg1 forState:UIControlStateNormal];
            self.passwordTextField.secureTextEntry = YES;
            _isShow = NO;
        }
    }else {
        if (_isRemember == YES) {
            [rememberPwdButton setImage:btnImg1 forState:UIControlStateNormal];
            _isRemember = NO;
        }else {
            [rememberPwdButton setImage:btnImg2 forState:UIControlStateNormal];
            _isRemember = YES;
        }
    }
}

#pragma mark ----registerViewDelegate method
- (void)registerSuccess{
    [delegate loginWithResult:YES];
}

@end
