    //
//  imageDetailViewController.m
//  Profession
//
//  Created by siphp on 12-8-14.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "imageDetailViewController.h"
#import "Common.h"
#import "UIImageScale.h"
#import "FileManager.h"
#import "downloadParam.h"
#import "imageDownLoadInWaitingObject.h"
#import "LoginViewController.h"
#import "ShareToBlogViewController.h"
#import "callSystemApp.h"

@implementation imageDetailViewController

@synthesize picArray;
@synthesize showPicScrollView;
@synthesize imageDownloadsInProgress;
@synthesize imageDownloadsInWaiting;
@synthesize actionSheet;
@synthesize chooseIndex;

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
	
	self.view.backgroundColor = [UIColor blackColor];
	[self.navigationController.navigationBar setTranslucent:YES];
	
	photoWith = 320.0f;
	photoHigh = 320.0f;
	
	NSMutableDictionary *idip = [[NSMutableDictionary alloc]init];
	self.imageDownloadsInProgress = idip;
	[idip release];
	
	NSMutableArray *wait = [[NSMutableArray alloc]init];
	self.imageDownloadsInWaiting = wait;
	[wait release];
	
	if (self.picArray != nil || [self.picArray count] != 0) 
	{
		[self showPic];
	}
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];  
    shareButton.frame = CGRectMake(0.0f, 0.0f, 40.0f, 40.0f);
    [shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchDown];
    [shareButton setBackgroundImage:[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"分享操作icon" ofType:@"png"]] forState:UIControlStateNormal];
    
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton]; 
    self.navigationItem.rightBarButtonItem = shareItem;
    
    //设置返回本类按钮
    UIBarButtonItem * tempButtonItem = [[ UIBarButtonItem alloc] init]; 
    tempButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = tempButtonItem ; 
    [tempButtonItem release];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:YES];
}

-(void) viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	//self.navigationController.navigationBarHidden=NO;
	[self.navigationController.navigationBar setTranslucent:NO];
}

-(void)showPic
{	
	int pageCount = [self.picArray count];
	
	if (self.showPicScrollView == nil && self.picArray != nil && pageCount > 0)
	{
		UIScrollView *tmpScroll = [[UIScrollView alloc] initWithFrame:CGRectMake( 0, (([UIScreen mainScreen].bounds.size.height - 20.0f - 44.0f - 460.0f) / 2), self.view.frame.size.width, 460.0f)];
		tmpScroll.contentSize = CGSizeMake(pageCount * self.view.frame.size.width, photoHigh);
		tmpScroll.pagingEnabled = YES;
		tmpScroll.delegate = self;
		tmpScroll.showsHorizontalScrollIndicator = NO;
		tmpScroll.showsVerticalScrollIndicator = NO;
		tmpScroll.tag = 100;
		self.showPicScrollView=tmpScroll;
		[tmpScroll release];                
		
		for(int i = 0;i < pageCount;i++)
		{
            UIScrollView *tmpImageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(i * self.showPicScrollView.frame.size.width,0.0f,photoWith, 460)];
            tmpImageScroll.contentSize = CGSizeMake(photoWith, 460);
            tmpImageScroll.pagingEnabled = NO;
            tmpImageScroll.delegate = self;
            tmpImageScroll.maximumZoomScale = 2.0;
            tmpImageScroll.minimumZoomScale = 1.0;
            tmpImageScroll.showsHorizontalScrollIndicator = NO;
            tmpImageScroll.showsVerticalScrollIndicator = NO;
            tmpImageScroll.tag = 200+i;
            
            myImageView *myiv = [[myImageView alloc]initWithFrame:
								 CGRectMake(0.0f , 70.0f,
											photoWith, photoHigh) withImageId:[NSString stringWithFormat:@"%d",i]];
			UIImage *img = [[UIImage alloc]initWithContentsOfFile:
							[[NSBundle mainBundle] pathForResource:@"商品详情大图默认" ofType:@"png"]];
			myiv.image = img;
			[img release];
			myiv.mydelegate = self;
			myiv.tag = 2000;
			
			[tmpImageScroll addSubview:myiv];
            [myiv release];
            [self.showPicScrollView addSubview:tmpImageScroll];
            [tmpImageScroll release];
			
			if (self.picArray != nil && pageCount > 0 && i < pageCount) 
			{
				NSArray *pic = [self.picArray objectAtIndex:i];
				
				NSString *photoUrl = [pic objectAtIndex:morecatinfo_catImageurl];
				
				NSString *picName = [Common encodeBase64:(NSMutableData *)[photoUrl dataUsingEncoding: NSUTF8StringEncoding]];
				
				if (photoUrl.length > 1) 
				{
					UIImage *photo = [FileManager getPhoto:picName];
					if (photo.size.width > 2)
					{
						myiv.image = [photo fillSize:CGSizeMake(photoWith,photoHigh)];
					}
					else
					{
						[myiv startSpinner];
						[self startIconDownload:photoUrl forIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
					}
				}
			}
		}		
	}
	self.showPicScrollView.contentOffset = CGPointMake(self.view.frame.size.width * chooseIndex, 0.0f);
	
	[self.view addSubview:self.showPicScrollView];
	
	self.title = [NSString stringWithFormat:@"%d / %d",chooseIndex+1,[self.picArray count]];
	
}

//保存缓存图片
-(bool)savePhoto:(UIImage*)photo atIndexPath:(NSIndexPath*)indexPath
{
	
	int countItems = [self.picArray count];
	
	if (countItems > [indexPath row]) 
	{
		NSArray *pic = [self.picArray objectAtIndex:[indexPath row]];
		NSString *picName = [Common encodeBase64:(NSMutableData *)[[pic objectAtIndex:morecatinfo_catImageurl] dataUsingEncoding: NSUTF8StringEncoding]];
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
	return NO;
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
			UIImage *photo = [iconDownloader.cardIcon fillSize:CGSizeMake(photoWith, photoHigh)];
            
            UIScrollView *imageScroll = (UIScrollView *)[self.showPicScrollView viewWithTag:200+[indexPath row]];
			myImageView *currentMyImageView = (myImageView *)[imageScroll viewWithTag:2000];
			currentMyImageView.image = photo;
			[currentMyImageView stopSpinner];
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

//分享
-(void)share
{
	NSArray *actionSheetMenu = [NSArray arrayWithObjects:@"分享给手机用户",@"分享给邮箱联系人",@"分享到新浪微博",@"分享到腾讯微博",nil];
	manageActionSheet *tempActionsheet = [[manageActionSheet alloc]initActionSheetWithStrings:actionSheetMenu];
	tempActionsheet.manageDeleage = self;
	self.actionSheet = tempActionsheet;
	[tempActionsheet release];
	[tempActionsheet showActionSheet:self.view];
	
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark 图片滚动委托
- (void)imageViewTouchesEnd:(NSString *)picId
{	
	BOOL navBarState = [self.navigationController isNavigationBarHidden];
	[self.navigationController setNavigationBarHidden:!navBarState animated:YES];
}

- (void)imageViewDoubleTouchesEnd:(NSString *)picId
{	
    UIScrollView *imageScroll = (UIScrollView *)[self.showPicScrollView viewWithTag:200+[picId intValue]];
    
    CGFloat zs = imageScroll.zoomScale;
	zs = (zs == imageScroll.minimumZoomScale) ? imageScroll.maximumZoomScale : imageScroll.minimumZoomScale;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];            
	imageScroll.zoomScale = zs;    
	[UIView commitAnimations];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView{	
	
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	//[super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView{
    if (aScrollView.tag == 100) {
		CGPoint offset = aScrollView.contentOffset;
		int currentPage = offset.x / self.view.frame.size.width;
        chooseIndex = currentPage;
		self.title = [NSString stringWithFormat:@"%d / %d",currentPage+1,[self.picArray count]];
        
        int pageCount = [self.picArray count];
		for(int i = 0;i < pageCount;i++)
		{
            UIScrollView *imageScroll = (UIScrollView *)[self.showPicScrollView viewWithTag:200+i];
            imageScroll.zoomScale = imageScroll.minimumZoomScale;
        }
	}
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)aScrollView
{
    if (aScrollView.tag != 100)
    {
        UIImageView *imageview = (UIImageView *)[aScrollView viewWithTag:2000];
        return imageview;
    }
    return nil;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)aScrollView withView:(UIView *)view atScale:(float)scale
{
	if (aScrollView.tag != 100) 
    {
		float pwidth = aScrollView.frame.size.width*scale;
		float pheigth = aScrollView.frame.size.height*scale;
		aScrollView.contentSize = CGSizeMake(pwidth,pheigth);
	}	
}


#pragma mark -
#pragma mark actionsheet委托

- (void) actionSheetAppear:(int)actionID actionSheet:(UIActionSheet *)actionSheet{
	
}

- (void)getChoosedIndex:(int)actionID chooseIndex:(int)index
{
    NSArray *pic = [self.picArray objectAtIndex:chooseIndex];
    NSString *content = [pic objectAtIndex:morecatinfo_desc];
	
	switch (index) {
		case 0:
		{
			[callSystemApp sendMessageTo:@"" inUIViewController:self withContent:content];
			break;
		}
		case 1:
		{	
			//收件人，cc：抄送  subject：主题   body：内容
			[callSystemApp sendEmail:@"" cc:@"" subject:DETAIL_SHARE_LINK body:content];
			break;
		}
		case 2:
		{
			//这里是新浪微博分享
			NSArray *weiboArray = [DBOperate queryData:T_WEIBO_USERINFO theColumn:@"weiboType" 
										theColumnValue:SINA withAll:NO];
			if (weiboArray != nil && [weiboArray count] > 0)
			{
				ShareToBlogViewController *share = [[ShareToBlogViewController alloc] init];
				share.weiBoType = 0;
				
				NSString *photoUrl = [pic objectAtIndex:morecatinfo_catImageurl];
				
				NSString *picName = [Common encodeBase64:(NSMutableData *)[photoUrl dataUsingEncoding: NSUTF8StringEncoding]];
				
				if (photoUrl.length > 1) 
				{
					UIImage *photo = [FileManager getPhoto:picName];
					share.shareImage = photo;
					share.checkBoxSelected = YES;
				}
				else 
				{
					share.shareImage = nil;
					share.checkBoxSelected = NO;
				}
				share.defaultContent = content;
                
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
				
				NSString *photoUrl = [pic objectAtIndex:morecatinfo_catImageurl];
				
				NSString *picName = [Common encodeBase64:(NSMutableData *)[photoUrl dataUsingEncoding: NSUTF8StringEncoding]];
				
				if (photoUrl.length > 1) 
				{
					UIImage *photo = [FileManager getPhoto:picName];
					share.shareImage = photo;
					share.checkBoxSelected = YES;
				}
				else 
				{
					share.shareImage = nil;
					share.checkBoxSelected = NO;
				}
				share.defaultContent = content;
				
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

#pragma mark -
#pragma mark OauthSinaSeccessDelagate
- (void) oauthSinaSuccess{
	[self getChoosedIndex:0 chooseIndex:2];
}

#pragma mark OauthTencentSeccessDelagate
- (void) oauthTencentSuccess{
	[self getChoosedIndex:0 chooseIndex:3];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.picArray = nil;
	self.showPicScrollView.delegate = nil;
	self.showPicScrollView = nil;
	for (IconDownLoader *one in [imageDownloadsInProgress allValues]){
		one.delegate = nil;
	}
	self.imageDownloadsInProgress = nil;
	self.imageDownloadsInWaiting = nil;
    self.actionSheet.manageDeleage = nil;
	self.actionSheet = nil;
}


- (void)dealloc {
	self.picArray = nil;
	self.showPicScrollView.delegate = nil;
	self.showPicScrollView = nil;
	for (IconDownLoader *one in [imageDownloadsInProgress allValues]){
		one.delegate = nil;
	}
	self.imageDownloadsInProgress = nil;
	self.imageDownloadsInWaiting = nil;
    self.actionSheet.manageDeleage = nil;
	self.actionSheet = nil;
    [super dealloc];
}


@end
