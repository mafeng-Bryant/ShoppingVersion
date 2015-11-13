    //
//  browserViewController.m
//  Profession
//
//  Created by siphp on 12-8-25.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "browserViewController.h"
#import "Common.h"
#import "callSystemApp.h"
#import "LoginViewController.h"
#import "ShareToBlogViewController.h"
#import "SendMsgToWeChat.h"
#import "UIImageScale.h"

@implementation browserViewController

@synthesize webView;
@synthesize url;
@synthesize webTitle;
@synthesize shareImage;
@synthesize spinner;
@synthesize isShowTool;
@synthesize actionSheet;


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
    
    CGFloat fixHeight = VIEW_HEIGHT - 20.0f - 44.0f;
    
    if (isShowTool) 
    {
        fixHeight = VIEW_HEIGHT - 20.0f - 44.0f - 44.0f;
        [self showToolBar];
    }
	
	UIWebView *tempWebView = [[UIWebView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, 320.0f, fixHeight)];
	self.webView = tempWebView;
	webView.delegate = self;
	webView.scalesPageToFit = YES;
	[self.view addSubview:webView];
	[tempWebView release];
	if ([self.url length] > 1)
	{
		//开始请求连接
		NSURL *webUrl =[NSURL URLWithString:self.url];
		NSURLRequest *request =[NSURLRequest requestWithURL:webUrl];
		[webView loadRequest:request];
	}

}

//工具栏
-(void)showToolBar
{
    UIView *toolBarView = [[UIView alloc] initWithFrame:
                           CGRectMake(0.0f, VIEW_HEIGHT - 20.0f - 44.0f - 44.0f, 320.0f, 44.0f)];
    [self.view addSubview:toolBarView];
    
    UIImageView *toolBarBackgroundView = [[UIImageView alloc] initWithFrame:
								CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
	UIImage *rawBackground = [[UIImage alloc]initWithContentsOfFile:
					  [[NSBundle mainBundle] pathForResource:@"MessageEntryBackground" ofType:@"png"]];
    UIImage *image = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
	toolBarBackgroundView.backgroundColor = [UIColor clearColor];
	toolBarBackgroundView.userInteractionEnabled = YES;
    toolBarBackgroundView.image = image;
	[toolBarView addSubview:toolBarBackgroundView];
    [toolBarBackgroundView release];
    
    
    //添加按钮
    NSArray *toolItems = [NSArray arrayWithObjects:@"分享",@"刷新",nil];
    int itemsCouns = [toolItems count];
    int bTag = 1000;
    CGFloat oneButtonWidth = self.view.frame.size.width/itemsCouns;
    CGFloat marginWidth = oneButtonWidth/2;
    CGFloat fixWidth = 0.0f;
    for (NSString *itemTitle in toolItems) 
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = ++bTag;
        fixWidth = marginWidth + ((button.tag - 1000)-1) * oneButtonWidth;
		[button setFrame:CGRectMake(0.0f , 0.0f , 40.0f, 40.0f)];
        button.center = CGPointMake(fixWidth , 22.0f);
		[button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
        
        //设置背景图
        NSString *picName = [NSString stringWithFormat:@"工具栏%@icon",itemTitle];
        [button setBackgroundImage:[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:picName ofType:@"png"]] forState:UIControlStateNormal];
		
        /*
		UILabel *bTitle = [[UILabel alloc]initWithFrame:CGRectMake(0.0f , 22.0f , 44.0f , 20.0f)];
		bTitle.font = [UIFont boldSystemFontOfSize:12.0];
		bTitle.textAlignment = UITextAlignmentCenter;
		bTitle.backgroundColor = [UIColor clearColor];
        bTitle.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
		bTitle.text = itemTitle;
		[button addSubview:bTitle];
		[bTitle release];
         */
        [toolBarView addSubview:button];
        
    }
    
    [toolBarView release];
}

//功能按钮
-(void)buttonClick:(id)sender
{
	UIButton *currentButton = sender;
	switch (currentButton.tag) 
	{
		case 1001:
		{
            [self share];
			break;
		}
		case 1002:
		{
            [self reload];
			break;
		}
		default:
			break;
	}
	//[self topViewAnimation:@"up"];
}

//分享
-(void)share
{
    NSArray *actionSheetMenu = [NSArray arrayWithObjects:@"分享至微信朋友圈",@"微信分享给好友",@"分享到新浪微博",@"分享到腾讯微博",nil];
	manageActionSheet *tempActionsheet = [[manageActionSheet alloc]initActionSheetWithStrings:actionSheetMenu];
	tempActionsheet.manageDeleage = self;
	self.actionSheet = tempActionsheet;
	[tempActionsheet release];
	[tempActionsheet showActionSheet:self.view];
}

//刷新
-(void)reload
{
	[webView reload];
}
#pragma mark -
#pragma mark actionsheet委托

- (void) actionSheetAppear:(int)actionID actionSheet:(UIActionSheet *)actionSheet{
	
}

- (void)getChoosedIndex:(int)actionID chooseIndex:(int)index
{
	NSString *link = self.url;
	NSString *content = @"";//self.webTitle;
	NSString *allContent = [NSString stringWithFormat:@"%@%@",content,link];
	
	switch (index) {
		case 0:
		{
			SendMsgToWeChat *sendMsg = [[SendMsgToWeChat alloc] init];
            UIImage *simg = [[self imageWithView:self.webView] fillSize:CGSizeMake(114, 114)];
            if (app_wechat_share_type == app_to_wechat) {
                [sendMsg sendNewsContent:content newsDescription:allContent newsImage:simg newUrl:link shareType:index];
            }else if (app_wechat_share_type == wechat_to_app) {
                [sendMsg RespNewsContent:content newsDescription:allContent newsImage:simg newUrl:link];
            }
            [sendMsg release];
		}
			break;
		case 1:
		{
			SendMsgToWeChat *sendMsg = [[SendMsgToWeChat alloc] init];
            UIImage *simg = [[self imageWithView:self.webView] fillSize:CGSizeMake(114, 114)];
            if (app_wechat_share_type == app_to_wechat) {
                [sendMsg sendNewsContent:content newsDescription:allContent newsImage:simg newUrl:link shareType:index];
            }else if (app_wechat_share_type == wechat_to_app) {
                [sendMsg RespNewsContent:content newsDescription:allContent newsImage:simg newUrl:link];
            }
            [sendMsg release];
		}
			break;
		case 2:
		{
			//这里是新浪微博分享
			NSArray *weiboArray = [DBOperate queryData:T_WEIBO_USERINFO theColumn:@"weiboType" 
										theColumnValue:SINA withAll:NO];
			if (weiboArray != nil && [weiboArray count] > 0)
			{
				ShareToBlogViewController *share = [[ShareToBlogViewController alloc] init];
				share.weiBoType = 0;
				
				if (self.shareImage.size.width > 2) 
				{
					share.shareImage = self.shareImage;
					share.checkBoxSelected = YES;
				}
				else 
				{
					share.shareImage = nil;
					share.checkBoxSelected = NO;
				}
				share.defaultContent = [NSString stringWithFormat:@"%@   %@",allContent,SHARE_CONTENTS];
                
				[self.navigationController pushViewController:share animated:YES];
				[share release];
			}
			else 
			{
				SinaViewController *sc = [[SinaViewController alloc] init];
				sc.delegate = self;
				[self.navigationController pushViewController:sc animated:YES];
				[sc release];
			}
			break;
			
		}
		case 3:
		{
			NSArray *weiboArray = [DBOperate queryData:T_WEIBO_USERINFO theColumn:@"weiboType" 
										theColumnValue:TENCENT withAll:NO];
			if (weiboArray != nil && [weiboArray count] > 0)
			{
				ShareToBlogViewController *share = [[ShareToBlogViewController alloc] init];
				share.weiBoType = 1;
				
				if (self.shareImage.size.width > 2)
				{
					share.shareImage = self.shareImage;
					share.checkBoxSelected = YES;
				}
				else 
				{
					share.shareImage = nil;
					share.checkBoxSelected = NO;
				}
				share.defaultContent = [NSString stringWithFormat:@"%@   %@",allContent,SHARE_CONTENTS];
				
				[self.navigationController pushViewController:share animated:YES];
				[share release];
			}
			else 
			{
				TencentViewController *tc = [[TencentViewController alloc] init];
				tc.delegate = self;
				[self.navigationController pushViewController:tc animated:YES];
				[tc release];
			}
			break;
			
		}
		default:
			break;
	}
}

- (UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark -
#pragma mark OauthSinaSeccessDelagate
- (void) oauthSinaSuccess{
	[self getChoosedIndex:0 chooseIndex:2];
}

#pragma mark OauthTencentSeccessDelagate
- (void) oauthTencentSuccess{
	[self getChoosedIndex:0 chooseIndex:3];
}

#pragma mark -
#pragma mark webView委托

//当网页视图被指示载入内容而得到通知
-(BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*) reuqest navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString *reuqestString = [NSString stringWithFormat:@"%@",reuqest.URL];
    NSString *appleDownUrl1 = @"https://itunes.apple.com/";
    NSString *appleDownUrl2 = @"http://itunes.apple.com/";
    if ([reuqestString rangeOfString:appleDownUrl1 options:NSCaseInsensitiveSearch].location == NSNotFound && [reuqestString rangeOfString:appleDownUrl2 options:NSCaseInsensitiveSearch].location == NSNotFound)
    {
        return YES;
    }
    else 
    {
        [[UIApplication sharedApplication] openURL:reuqest.URL];
        return NO;
    }

}

//当网页视图已经开始加载一个请求后，得到通知。
-(void)webViewDidStartLoad:(UIWebView*)webView
{
	//添加loading图标
	UIActivityIndicatorView *tempSpinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
	[tempSpinner setCenter:CGPointMake(self.view.frame.size.width / 3, self.webView.frame.size.height / 2.0)];
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
}

//当网页视图结束加载一个请求之后，得到通知。 
-(void)webViewDidFinishLoad:(UIWebView*)webView
{
	[self.spinner removeFromSuperview];
}

//当在请求加载中发生错误时，得到通知。会提供一个NSSError对象，以标识所发生错误类型。  
-(void)webView:(UIWebView*)webView  DidFailLoadWithError:(NSError*)error
{
	NSLog(@"浏览器浏览发生错误...");
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
    self.webView = nil;
	self.url = nil;
    self.webTitle = nil;
    self.shareImage = nil;
	self.spinner = nil;
    self.actionSheet.manageDeleage = nil;
	self.actionSheet = nil;
}


- (void)dealloc {
	self.webView = nil;
	self.url = nil;
    self.webTitle = nil;
    self.shareImage = nil;
	self.spinner = nil;
    self.actionSheet.manageDeleage = nil;
	self.actionSheet = nil;
    [super dealloc];
}


@end
