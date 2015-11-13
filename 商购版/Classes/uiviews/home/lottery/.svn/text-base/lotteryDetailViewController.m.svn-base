//
//  lotteryDetailViewController.m
//  shopping
//
//  Created by lai yun on 13-1-25.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "lotteryDetailViewController.h"
#import "Common.h"
#import "DBOperate.h"
#import "UIImageScale.h"
#import "FileManager.h"
#import "downloadParam.h"
#import "imageDownLoadInWaitingObject.h"
#import "picDetailViewController.h"

@interface lotteryDetailViewController ()

@end

@implementation lotteryDetailViewController

@synthesize lotteryID;
@synthesize lotteryArray;
@synthesize lotteryPicArray;
@synthesize scrollView;
@synthesize showPicScrollView;
@synthesize pageControll;
@synthesize imageDownloadsInProgress;
@synthesize imageDownloadsInWaiting;

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
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
    self.title = @"奖品详情";
    
	photoWith = 220.0f;
	photoHigh = 220.0f;
	
	NSMutableDictionary *idip = [[NSMutableDictionary alloc]init];
	self.imageDownloadsInProgress = idip;
	[idip release];
	
	NSMutableArray *wait = [[NSMutableArray alloc]init];
	self.imageDownloadsInWaiting = wait;
	[wait release];
	
	UIScrollView *tmpScroll = [[UIScrollView alloc] initWithFrame:CGRectMake( 0, 0, self.view.frame.size.width, self.view.frame.size.height - 40.0f)];
	tmpScroll.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
	tmpScroll.pagingEnabled = NO;
	tmpScroll.delegate = self;
	tmpScroll.showsHorizontalScrollIndicator = NO;
	tmpScroll.showsVerticalScrollIndicator = NO;
	tmpScroll.bounces = YES;
	self.scrollView = tmpScroll;
	[self.view addSubview:self.scrollView];
	[tmpScroll release];  
	
	if (self.lotteryPicArray == nil || [self.lotteryPicArray count] == 0) 
	{
		scrollViewHeight = 0.0f;
	}
	else
	{
		scrollViewHeight = photoHigh;
		[self showLotteryPic];
	}
	
	
	UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, scrollViewHeight + 5, 300, 30)];
	[titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.0f]];
	titleLabel.textColor = [UIColor colorWithRed:0.1 green: 0.1 blue: 0.1 alpha:1.0];
	titleLabel.text = [self.lotteryArray objectAtIndex:lottery_name];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
	[self.scrollView addSubview:titleLabel];
	[titleLabel release];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame), 80, 20)];
	[nameLabel setFont:[UIFont systemFontOfSize:14.0f]];
	nameLabel.textColor = [UIColor colorWithRed:0.2 green: 0.2 blue: 0.2 alpha:1.0];
	nameLabel.text = @"奖       品 :";
	nameLabel.backgroundColor = [UIColor clearColor];
	[self.scrollView addSubview:nameLabel];
	[nameLabel release];
	
	UILabel *nameInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, CGRectGetMaxY(titleLabel.frame), 220, 20)];
	[nameInfoLabel setFont:[UIFont systemFontOfSize:14.0f]];
	nameInfoLabel.textColor = [UIColor colorWithRed:0.2 green: 0.2 blue: 0.2 alpha:1.0];
	nameInfoLabel.text = [self.lotteryArray objectAtIndex:lottery_product_name];
	nameInfoLabel.backgroundColor = [UIColor clearColor];
	[self.scrollView addSubview:nameInfoLabel];
	[nameInfoLabel release];
	
	UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(nameLabel.frame), 80, 20)];
	[priceLabel setFont:[UIFont systemFontOfSize:14.0f]];
	priceLabel.textColor = [UIColor colorWithRed:0.2 green: 0.2 blue: 0.2 alpha:1.0];
	priceLabel.text = @"奖品价值 :";
	priceLabel.backgroundColor = [UIColor clearColor];
	[self.scrollView addSubview:priceLabel];
	[priceLabel release];
	
	UILabel *priceInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, CGRectGetMaxY(nameLabel.frame), 220, 20)];
	[priceInfoLabel setFont:[UIFont systemFontOfSize:14.0f]];
	priceInfoLabel.textColor = [UIColor colorWithRed:1 green: 0.6 blue: 0 alpha:1.0];
	priceInfoLabel.text = [self.lotteryArray objectAtIndex:lottery_product_price];
	priceInfoLabel.backgroundColor = [UIColor clearColor];
	[self.scrollView addSubview:priceInfoLabel];
	[priceInfoLabel release];
    
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(priceLabel.frame), 80, 20)];
	[numLabel setFont:[UIFont systemFontOfSize:14.0f]];
	numLabel.textColor = [UIColor colorWithRed:0.2 green: 0.2 blue: 0.2 alpha:1.0];
	numLabel.text = @"奖品数量 :";
	numLabel.backgroundColor = [UIColor clearColor];
	[self.scrollView addSubview:numLabel];
	[numLabel release];
	
	UILabel *numInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, CGRectGetMaxY(priceLabel.frame), 220, 20)];
	[numInfoLabel setFont:[UIFont systemFontOfSize:14.0f]];
	numInfoLabel.textColor = [UIColor colorWithRed:0.2 green: 0.2 blue: 0.2 alpha:1.0];
	numInfoLabel.text = [self.lotteryArray objectAtIndex:lottery_product_sum];
	numInfoLabel.backgroundColor = [UIColor clearColor];
	[self.scrollView addSubview:numInfoLabel];
	[numInfoLabel release];
    
    UILabel *winNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(numLabel.frame), 80, 20)];
	[winNumLabel setFont:[UIFont systemFontOfSize:14.0f]];
	winNumLabel.textColor = [UIColor colorWithRed:0.2 green: 0.2 blue: 0.2 alpha:1.0];
	winNumLabel.text = @"中奖人数 :";
	winNumLabel.backgroundColor = [UIColor clearColor];
	[self.scrollView addSubview:winNumLabel];
	[winNumLabel release];
	
	UILabel *winNumInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, CGRectGetMaxY(numLabel.frame), 220, 20)];
	[winNumInfoLabel setFont:[UIFont systemFontOfSize:14.0f]];
	winNumInfoLabel.textColor = [UIColor colorWithRed:0.2 green: 0.2 blue: 0.2 alpha:1.0];
	winNumInfoLabel.text = [self.lotteryArray objectAtIndex:lottery_win_num];
	winNumInfoLabel.backgroundColor = [UIColor clearColor];
	[self.scrollView addSubview:winNumInfoLabel];
	[winNumInfoLabel release];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(winNumLabel.frame), 80, 20)];
	[timeLabel setFont:[UIFont systemFontOfSize:14.0f]];
	timeLabel.textColor = [UIColor colorWithRed:0.2 green: 0.2 blue: 0.2 alpha:1.0];
	timeLabel.text = @"活动期限 :";
	timeLabel.backgroundColor = [UIColor clearColor];
	[self.scrollView addSubview:timeLabel];
	[timeLabel release];
	
	UILabel *timeInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, CGRectGetMaxY(winNumLabel.frame), 220, 20)];
	[timeInfoLabel setFont:[UIFont systemFontOfSize:14.0f]];
	timeInfoLabel.textColor = [UIColor colorWithRed:0.2 green: 0.2 blue: 0.2 alpha:1.0];
    
    NSDate* startDate = [NSDate dateWithTimeIntervalSince1970:[[lotteryArray objectAtIndex:lottery_starttime] intValue]];
    NSDate* endDate = [NSDate dateWithTimeIntervalSince1970:[[lotteryArray objectAtIndex:lottery_endtime] intValue]];
    NSDateFormatter *outputFormat = [[NSDateFormatter alloc] init];
    [outputFormat setDateFormat:@"yyyy/MM/dd"];
    NSString *startDateString = [outputFormat stringFromDate:startDate];
    NSString *endDateString = [outputFormat stringFromDate:endDate];
    [outputFormat release];
    
	timeInfoLabel.text = [NSString stringWithFormat:@"%@ - %@",startDateString,endDateString];
	timeInfoLabel.backgroundColor = [UIColor clearColor];
	[self.scrollView addSubview:timeInfoLabel];
	[timeInfoLabel release];
	
	UILabel *descInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	[descInfoLabel setFont:[UIFont systemFontOfSize:14.0f]];
	descInfoLabel.textColor = [UIColor colorWithRed:0.2 green: 0.2 blue: 0.2 alpha:1.0];
	descInfoLabel.backgroundColor = [UIColor clearColor];
	descInfoLabel.lineBreakMode = UILineBreakModeWordWrap;
	descInfoLabel.numberOfLines = 0;
	NSString *descText = [NSString stringWithFormat:@"奖品介绍 : %@",[self.lotteryArray objectAtIndex:lottery_product_desc]];
	descInfoLabel.text = descText;
	CGSize constraint = CGSizeMake(300, 20000.0f);
	CGSize size = [descText sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
	float fixHeight = size.height + 10.0f;
	fixHeight = fixHeight == 0 ? 20.f : MAX(fixHeight,20.0f);
	[descInfoLabel setFrame:CGRectMake(10, CGRectGetMaxY(timeLabel.frame), 300, fixHeight)];
	[self.scrollView addSubview:descInfoLabel];
	[descInfoLabel release];
    
    //规则
    UIImage *lineImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"分割线_虚线" ofType:@"png"]];
    UIImageView *lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f , CGRectGetMaxY(descInfoLabel.frame) + 12.0f , lineImage.size.width , lineImage.size.height)];
    lineImageView.image = lineImage;
    [lineImage release];
    [self.scrollView addSubview:lineImageView];
	[lineImageView release];
    
    UIImage *tipsImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"小栏目背景" ofType:@"png"]];
    UIImageView *tipsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f , CGRectGetMaxY(descInfoLabel.frame) + 5.0f , tipsImage.size.width , tipsImage.size.height)];
    tipsImageView.image = tipsImage;
    [tipsImage release];
    [self.scrollView addSubview:tipsImageView];
	[tipsImageView release];
    
    UILabel *tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.0f , CGRectGetMaxY(descInfoLabel.frame) + 5.0f , tipsImage.size.width , tipsImage.size.height)];
	[tipsLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0f]];
	tipsLabel.textColor = [UIColor colorWithRed:1.0f green: 1.0f blue: 1.0f alpha:1.0];
	tipsLabel.text = @"抽奖规则";
	tipsLabel.backgroundColor = [UIColor clearColor];
	[self.scrollView addSubview:tipsLabel];
	[tipsLabel release];
    
    UILabel *lotteryDescLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	[lotteryDescLabel setFont:[UIFont systemFontOfSize:14.0f]];
	lotteryDescLabel.textColor = [UIColor colorWithRed:0.5 green: 0.5 blue: 0.5 alpha:1.0];
	lotteryDescLabel.backgroundColor = [UIColor clearColor];
	lotteryDescLabel.lineBreakMode = UILineBreakModeWordWrap;
	lotteryDescLabel.numberOfLines = 0;
	NSString *lotteryDescText = [self.lotteryArray objectAtIndex:lottery_desc];
	lotteryDescLabel.text = lotteryDescText;
	CGSize lotteryDescConstraint = CGSizeMake(300, 20000.0f);
	CGSize lotteryDescSize = [lotteryDescText sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:lotteryDescConstraint lineBreakMode:UILineBreakModeWordWrap];
	float lotteryDescFixHeight = lotteryDescSize.height + 10.0f;
	lotteryDescFixHeight = lotteryDescFixHeight == 0 ? 20.f : MAX(lotteryDescFixHeight,20.0f);
	[lotteryDescLabel setFrame:CGRectMake(10, CGRectGetMaxY(tipsImageView.frame), 300, lotteryDescFixHeight)];
	[self.scrollView addSubview:lotteryDescLabel];
	[lotteryDescLabel release];
    
    // 30 + 5 + (20 * 5) = 135
    scrollViewHeight = scrollViewHeight + 135.0f + fixHeight + 30.0f + lotteryDescFixHeight;
	
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, scrollViewHeight);
}

-(void)showLotteryPic
{
	UIImageView *showBackGround = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, photoHigh)];
	UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品详情图片背景" ofType:@"png"]];
	
	showBackGround.image = [img fillSize:CGSizeMake(self.view.frame.size.width, photoHigh)];
	[img release];
	[self.scrollView addSubview:showBackGround];
	[showBackGround release];
	
	int pageCount = [self.lotteryPicArray count];
	
	if (self.showPicScrollView == nil && self.lotteryPicArray != nil && pageCount > 0)
	{
		UIScrollView *tmpScroll = [[UIScrollView alloc] initWithFrame:CGRectMake( 0, 0, self.view.frame.size.width, photoHigh)];
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
			myImageView *myiv = [[myImageView alloc]initWithFrame:
								 CGRectMake(i * self.showPicScrollView.frame.size.width + 50,0,
											photoWith, photoHigh) withImageId:[NSString stringWithFormat:@"%d",i]];
			UIImage *img = [[UIImage alloc]initWithContentsOfFile:
							[[NSBundle mainBundle] pathForResource:@"商品详情默认图片" ofType:@"png"]];
			myiv.image = img;
			[img release];
			myiv.mydelegate = self;
			myiv.tag = 200+i;                                        
			
			[self.showPicScrollView addSubview:myiv];
			[myiv release];
			
			if (self.lotteryPicArray != nil && pageCount > 0 && i < pageCount) 
			{
				NSArray *lotteryPic = [self.lotteryPicArray objectAtIndex:i];
				
				NSString *photoUrl = [lotteryPic objectAtIndex:lottery_pic_pic];
				
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
	if(self.pageControll == nil && self.lotteryPicArray != nil && pageCount > 0)
	{
		UIPageControl *pc = [[UIPageControl alloc] initWithFrame:CGRectMake(120, 200, 80, 16)];
		self.pageControll = pc;			
		[pc release];
		self.pageControll.backgroundColor = [UIColor clearColor];
		self.pageControll.numberOfPages = pageCount;
		self.pageControll.currentPage = 0;
		[pageControll addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
		
	}
	[self.scrollView addSubview:self.showPicScrollView];
	[self.scrollView addSubview:self.pageControll]; 
	
}

//保存缓存图片
-(BOOL)savePhoto:(UIImage*)photo atIndexPath:(NSIndexPath*)indexPath
{
	
	int countItems = [self.lotteryPicArray count];
	
	if (countItems > [indexPath row]) 
	{
		NSArray *lotteryPic = [self.lotteryPicArray objectAtIndex:[indexPath row]];
		NSString *picName = [Common encodeBase64:(NSMutableData *)[[lotteryPic objectAtIndex:lottery_pic_pic] dataUsingEncoding: NSUTF8StringEncoding]];
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
			myImageView *currentMyImageView = (myImageView *)[self.view viewWithTag:200+[indexPath row]];
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

#pragma mark -
#pragma mark 图片滚动委托

- (void)imageViewTouchesEnd:(NSString *)picId
{	
	picDetailViewController *picDetail = [[picDetailViewController alloc] init];			
	picDetail.picArray = self.lotteryPicArray;
	picDetail.chooseIndex = [picId intValue];
	[self.navigationController pushViewController:picDetail animated:YES];
	[picDetail release];
}

- (void) pageTurn: (UIPageControl *) aPageControl
{
	int whichPage = aPageControl.currentPage;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	self.showPicScrollView.contentOffset = CGPointMake(self.view.frame.size.width * whichPage, 0.0f);
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
    if (aScrollView == self.showPicScrollView) {
		CGPoint offset = aScrollView.contentOffset;
		self.pageControll.currentPage = offset.x / self.view.frame.size.width;
	}
}

- (void)viewDidUnload {
    
    [super viewDidUnload];
    
	self.lotteryID = nil;
	self.lotteryArray = nil;
	self.lotteryPicArray = nil;
	self.scrollView.delegate = nil;
	self.scrollView = nil;
	self.showPicScrollView.delegate = nil;
	self.showPicScrollView = nil;
	self.pageControll = nil;
	for (IconDownLoader *one in [imageDownloadsInProgress allValues]){
		one.delegate = nil;
	}
	self.imageDownloadsInProgress = nil;
	self.imageDownloadsInWaiting = nil;
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[lotteryID release];
    [lotteryArray release];
    [lotteryPicArray release];
	self.scrollView.delegate = nil;
	self.scrollView = nil;
	self.showPicScrollView.delegate = nil;
	self.showPicScrollView = nil;
	self.pageControll = nil;
	for (IconDownLoader *one in [imageDownloadsInProgress allValues]){
		one.delegate = nil;
	}
	self.imageDownloadsInProgress = nil;
	self.imageDownloadsInWaiting = nil;
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
