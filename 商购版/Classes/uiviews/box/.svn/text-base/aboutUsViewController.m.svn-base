    //
//  aboutUsViewController.m
//  Profession
//
//  Created by siphp on 12-8-24.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "aboutUsViewController.h"
#import "Common.h"
#import "UIImageScale.h"
#import "callSystemApp.h"
#import "FileManager.h"
#import "downloadParam.h"
#import "imageDownLoadInWaitingObject.h"
#import "browserViewController.h"
//#import "BaiduMapViewController.h"
@implementation aboutUsViewController

@synthesize scrollView;
@synthesize spinner;
@synthesize aboutUsItems;
@synthesize imageDownloadsInProgress;
@synthesize imageDownloadsInWaiting;

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
	UIImage *backgroundImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"表的背景" ofType:@"png"]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
	
	self.title = @"关于我们";
	
	logoWith = 300.0f;
	logoHigh = 80.0f;
	
	NSMutableDictionary *idip = [[NSMutableDictionary alloc]init];
	self.imageDownloadsInProgress = idip;
	[idip release];
	
	NSMutableArray *wait = [[NSMutableArray alloc]init];
	self.imageDownloadsInWaiting = wait;
	[wait release];
	
	//关于我们数据初始化
	NSMutableArray *tempAboutUsArray = [[NSMutableArray alloc] init];
	self.aboutUsItems = tempAboutUsArray;
	[tempAboutUsArray release];

	UIScrollView *tmpScroll = [[UIScrollView alloc] initWithFrame:CGRectMake( 0, 0, self.view.frame.size.width, VIEW_HEIGHT - 20.0f - 44.0f)];
	tmpScroll.contentSize = CGSizeMake(self.view.frame.size.width, VIEW_HEIGHT - 20.0f - 44.0f);
	tmpScroll.pagingEnabled = NO;
	tmpScroll.showsHorizontalScrollIndicator = NO;
	tmpScroll.showsVerticalScrollIndicator = NO;
	tmpScroll.bounces = YES;
	self.scrollView = tmpScroll;
	[self.view addSubview:self.scrollView];
	[tmpScroll release];  
	
	//添加loading图标
	UIActivityIndicatorView *tempSpinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
	[tempSpinner setCenter:CGPointMake(self.view.frame.size.width / 3, (VIEW_HEIGHT - 20.0f - 44.0f) / 2.0)];
	self.spinner = tempSpinner;
	
	UILabel *loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 100, 20)];
	loadingLabel.font = [UIFont systemFontOfSize:14];
	loadingLabel.textColor = [UIColor colorWithRed:0.5 green: 0.5 blue: 0.5 alpha:1.0];
	loadingLabel.text = LOADING_TIPS;		
	loadingLabel.textAlignment = UITextAlignmentCenter;
	loadingLabel.backgroundColor = [UIColor clearColor];
	[self.spinner addSubview:loadingLabel];
	[self.scrollView addSubview:self.spinner];
	[self.spinner startAnimating];
	[tempSpinner release];
	
	//网络获取
	[self accessItemService];
}

//拨打电话
-(void)callPhone:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [callSystemApp makeCall:[telArr objectAtIndex:btn.tag - 10]];
    
//	NSMutableArray *aboutUsInfo = [self.aboutUsItems objectAtIndex:0];
//	NSString *tel = [[aboutUsInfo objectAtIndex:aboutus_info_tel] length] > 1 ? [aboutUsInfo objectAtIndex:aboutus_info_tel] : [aboutUsInfo objectAtIndex:aboutus_info_mobile];
//	if (tel.length > 1)
//	{
//		[callSystemApp makeCall:tel];
//	}
}

//获取本地缓存的图片
-(UIImage*)getPhoto:(NSIndexPath *)indexPath
{
	NSMutableArray *aboutUsInfo = [self.aboutUsItems objectAtIndex:0];
	NSString *picName = [Common encodeBase64:(NSMutableData *)[[aboutUsInfo objectAtIndex:aboutus_info_logo] dataUsingEncoding: NSUTF8StringEncoding]];
	if (picName.length > 1) {
		return [FileManager getPhoto:picName];
	}
	else {
		return nil;
	}
}

//保存缓存图片
-(bool)savePhoto:(UIImage*)photo atIndexPath:(NSIndexPath*)indexPath
{
	NSMutableArray *aboutUsInfo = [self.aboutUsItems objectAtIndex:0];
	NSString *picName = [Common encodeBase64:(NSMutableData *)[[aboutUsInfo objectAtIndex:aboutus_info_logo] dataUsingEncoding: NSUTF8StringEncoding]];
	
	//保存缓存图片
	if([FileManager savePhoto:picName withImage:photo])
	{
		return YES;
	}
	else 
	{
		return NO;
	}
}

//获取网络图片
- (void)startIconDownload:(NSString*)photoURL forIndexPath:(NSIndexPath*)indexPath
{
	IconDownLoader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil && photoURL != nil && photoURL.length > 1) 
    {
		if ([imageDownloadsInProgress count]>= 5) {
			imageDownLoadInWaitingObject *one = [[imageDownLoadInWaitingObject alloc]init:photoURL withIndexPath:indexPath withImageType:CUSTOMER_PHOTO];
			[imageDownloadsInWaiting addObject:one];
			[one release];
			return;
		}
        IconDownLoader *iconDownloader = [[IconDownLoader alloc] init];
        iconDownloader.downloadURL = photoURL;
        iconDownloader.indexPathInTableView = indexPath;
		iconDownloader.imageType = CUSTOMER_PHOTO;
        iconDownloader.delegate = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
        [iconDownloader release];
    }
}

//回调 获到网络图片后的回调函数
- (void)appImageDidLoad:(NSIndexPath *)indexPath withImageType:(int)Type
{
    IconDownLoader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        // Display the newly loaded image
		if(iconDownloader.cardIcon.size.width>2.0)
		{ 
			//保存图片
			[self savePhoto:iconDownloader.cardIcon atIndexPath:indexPath];
			
			UIImage *photo = [iconDownloader.cardIcon fillSize:CGSizeMake(logoWith, logoHigh)];
			UIImageView *picView = (UIImageView *)[self.scrollView viewWithTag:100];
			picView.image = photo;

		}
		
		[imageDownloadsInProgress removeObjectForKey:indexPath];
		if ([imageDownloadsInWaiting count]>0) 
		{
			imageDownLoadInWaitingObject *one = [imageDownloadsInWaiting objectAtIndex:0];
			[self startIconDownload:one.imageURL forIndexPath:one.indexPath];
			[imageDownloadsInWaiting removeObjectAtIndex:0];
		}
		
    }
}

//网络获取数据
-(void)accessItemService
{
	NSString *reqUrl = @"service/about.do?param=%@";
	
	NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
								 [Common getSecureString],@"keyvalue",
								 [Common getVersion:OPERAT_ABOUTUS_INFO],@"ver",
								 [NSNumber numberWithInt: SITE_ID],@"site_id",
								 nil];
	
	[[DataManager sharedManager] accessService:jsontestDic 
									   command:OPERAT_ABOUTUS_INFO
								  accessAdress:reqUrl 
									  delegate:self 
									 withParam:nil];
}

//更新数据的操作
-(void)updateAboutUs
{
	//移出loading提示
	[self.spinner removeFromSuperview];
	
	//读取关于我们数据
	self.aboutUsItems = (NSMutableArray *)[DBOperate queryData:T_ABOUTUS_INFO theColumn:@"" theColumnValue:@""  withAll:YES];
	
	if ([self.aboutUsItems count] != 0) 
	{
		NSMutableArray *aboutUsInfo = [self.aboutUsItems objectAtIndex:0];
		
		//构建视图
		UIImageView *picView = [[UIImageView alloc]initWithFrame:CGRectMake(10.0f, 10.0f, logoWith, logoHigh)];
		picView.tag = 100;
		[self.scrollView addSubview:picView];
		[picView release];
		
		//loading商铺logo图片
		UIImageView *logoPicView = (UIImageView *)[self.scrollView viewWithTag:100];
		NSString *logoUrl = [aboutUsInfo objectAtIndex:aboutus_info_logo];
		if (logoUrl.length > 1) 
		{
			NSIndexPath *logoIndexPath = [NSIndexPath indexPathForRow:10000 inSection:0];
			
			//获取本地图片缓存
			UIImage *cardIcon = [[self getPhoto:logoIndexPath]fillSize:CGSizeMake(logoWith, logoHigh)];
			if (cardIcon == nil)
			{
				UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"百宝箱_关于我们默认logo" ofType:@"png"]];
				logoPicView.image = [img fillSize:CGSizeMake(logoWith, logoHigh)];
				[img release];
				
				[self startIconDownload:logoUrl forIndexPath:logoIndexPath];
			}
			else
			{
				logoPicView.image = cardIcon;
			}
			
		}
		else
		{
			UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"百宝箱_关于我们默认logo" ofType:@"png"]];
			logoPicView.image = [img fillSize:CGSizeMake(logoWith, logoHigh)];
			[img release];
		}
        
        UIImage *lineImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"小栏目背景" ofType:@"png"]];
        UIImageView *lineImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f , 100.0f, lineImage.size.width, lineImage.size.height)];
        lineImageView1.image = lineImage;
        [self.scrollView addSubview:lineImageView1];
        
        UILabel *strLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0 , lineImage.size.width - 10, lineImage.size.height)];
        strLabel1.text = @"简介";	
        strLabel1.textColor = [UIColor whiteColor];
        strLabel1.font = [UIFont systemFontOfSize:12.0f];
        strLabel1.textAlignment = UITextAlignmentLeft;
        strLabel1.backgroundColor = [UIColor clearColor];
        [lineImageView1 addSubview:strLabel1];
        [strLabel1 release];
        [lineImageView1 release];
        
        //内容
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[contentLabel setFont:[UIFont systemFontOfSize:14.0f]];
		contentLabel.textColor = [UIColor colorWithRed:0.3 green: 0.3 blue: 0.3 alpha:1.0];
		contentLabel.backgroundColor = [UIColor clearColor];
		contentLabel.lineBreakMode = UILineBreakModeWordWrap;
		contentLabel.numberOfLines = 0;
		NSString *contentText = [aboutUsInfo objectAtIndex:aboutus_info_description];
		contentLabel.text = contentText;
		CGSize constraint = CGSizeMake(280.0f, 20000.0f);
		CGSize size = [contentText sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
		float fixHeight = size.height + 10.0f;
		fixHeight = fixHeight == 0 ? 30.f : MAX(fixHeight,30.0f);
		[contentLabel setFrame:CGRectMake(20.0f, CGRectGetMaxY(lineImageView1.frame) + 10, 280.0f, fixHeight)];
		[self.scrollView addSubview:contentLabel];
		[contentLabel release];
        
        UIImageView *lineImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f , CGRectGetMaxY(contentLabel.frame) + 10, lineImage.size.width, lineImage.size.height)];
        lineImageView2.image = lineImage;
        [self.scrollView addSubview:lineImageView2];
        
        UILabel *strLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0 , lineImage.size.width -10, lineImage.size.height)];
        strLabel2.text = @"联系我们";	
        strLabel2.textColor = [UIColor whiteColor];
        strLabel2.font = [UIFont systemFontOfSize:12.0f];
        strLabel2.textAlignment = UITextAlignmentLeft;
        strLabel2.backgroundColor = [UIColor clearColor];
        [lineImageView2 addSubview:strLabel2];
        [strLabel2 release];
        [lineImageView2 release];
        
        telArr = [[NSArray alloc] initWithObjects:[aboutUsInfo objectAtIndex:aboutus_info_mobile],[aboutUsInfo objectAtIndex:aboutus_info_tel], nil];
        
        for (int i = 0; i < [telArr count]; i ++) {
            UIImage *img = [UIImage imageNamed:@"button_白色.png"];
            img = [img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:img.size.height/2];
            
            UIImageView *phoneImageView = [[UIImageView alloc] initWithImage:img];
            phoneImageView.frame = CGRectMake(30, CGRectGetMaxY(lineImageView2.frame) + 10 + 40 *i + 10 * i, 260, 40);
            [self.scrollView addSubview:phoneImageView]; 
            
            UIButton *telButton = [UIButton buttonWithType:UIButtonTypeCustom];
            telButton.frame = CGRectMake(phoneImageView.frame.origin.x, phoneImageView.frame.origin.y, 260.0f,40.0f);
            [telButton addTarget:self action:@selector(callPhone:) forControlEvents:UIControlEventTouchUpInside];
            telButton.tag = i + 10;
            [self.scrollView addSubview:telButton];
            
            UIImage *phoneImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"百宝箱_关于我们Phone-Hook" ofType:@"png"]];
            UIImageView *phoneView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f , 10.0f, phoneImage.size.width, phoneImage.size.height)];
            phoneView.image = phoneImage;
            [phoneImage release];
            [phoneImageView addSubview:phoneView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneView.frame) + 30, 0, 180, 40)];
            label.textAlignment = UITextAlignmentLeft;
            label.backgroundColor = [UIColor clearColor];
            label.text = [telArr objectAtIndex:i];
            label.font = [UIFont systemFontOfSize:16];
            [phoneImageView addSubview:label];
            [label release];
            
            [phoneImageView release];
        }
        
        
        UIImageView *lineImageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f , CGRectGetMaxY(lineImageView2.frame) + 120, lineImage.size.width, lineImage.size.height)];
        lineImageView3.image = lineImage;
        [self.scrollView addSubview:lineImageView3];
        
        UILabel *strLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0 , lineImage.size.width - 10, lineImage.size.height)];
        strLabel3.text = @"传真邮箱";	
        strLabel3.textColor = [UIColor whiteColor];
        strLabel3.font = [UIFont systemFontOfSize:12.0f];
        strLabel3.textAlignment = UITextAlignmentLeft;
        strLabel3.backgroundColor = [UIColor clearColor];
        [lineImageView3 addSubview:strLabel3];
        [strLabel3 release];
        [lineImageView3 release];
        		
        UILabel *faxLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(lineImageView3.frame) + 10 , 280, 30)];
        faxLabel.text = [NSString stringWithFormat:@"客服传真   %@",[aboutUsInfo objectAtIndex:aboutus_info_fax]];	
        faxLabel.textColor = [UIColor darkTextColor];
        faxLabel.font = [UIFont systemFontOfSize:14.0f];
        faxLabel.textAlignment = UITextAlignmentLeft;
        faxLabel.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:faxLabel];
        [faxLabel release];
       
        UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(faxLabel.frame) , 280, 30)];
        emailLabel.text = [NSString stringWithFormat:@"邮箱地址   %@",[aboutUsInfo objectAtIndex:aboutus_info_email]];	
        emailLabel.textColor = [UIColor darkTextColor];
        emailLabel.font = [UIFont systemFontOfSize:14.0f];
        emailLabel.textAlignment = UITextAlignmentLeft;
        emailLabel.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:emailLabel];
        [emailLabel release];
        
		self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(emailLabel.frame) + 10.0f);
		[lineImage release];
	}
	
}

//网络请求回调函数
- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver
{
	[self performSelectorOnMainThread:@selector(updateAboutUs) withObject:nil waitUntilDone:NO];
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
    self.scrollView = nil;
	self.spinner = nil;
	self.aboutUsItems = nil;
	for (IconDownLoader *one in [imageDownloadsInProgress allValues]){
		one.delegate = nil;
	}
	self.imageDownloadsInProgress = nil;
	self.imageDownloadsInWaiting = nil;
}


- (void)dealloc {
	self.scrollView = nil;
	self.spinner = nil;
	self.aboutUsItems = nil;
	for (IconDownLoader *one in [imageDownloadsInProgress allValues]){
		one.delegate = nil;
	}
	self.imageDownloadsInProgress = nil;
	self.imageDownloadsInWaiting = nil;
    [super dealloc];
}


@end
