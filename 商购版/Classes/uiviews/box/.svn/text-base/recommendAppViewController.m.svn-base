//
//  recommendAppViewController.m
//  Profession
//
//  Created by MC374 on 12-10-10.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "recommendAppViewController.h"
#import "Common.h"
#import "DBOperate.h"
#import "FileManager.h"
#import "downloadParam.h"
#import "UIImageScale.h"
#import "imageDownLoadInWaitingObject.h"

#define MARGIN 10.0f

@implementation recommendAppViewController

@synthesize myTableView;
@synthesize recommendAppItems;
@synthesize recommendAppAdItems;
@synthesize imageDownloadsInProgress;
@synthesize imageDownloadsInWaiting;
@synthesize spinner;
@synthesize moreLabel;

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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BG_IMAGE]];
    
    self.title = @"推荐应用";
	
	photoWith = 60;
	photoHigh = 60;
    
    bannerWidth = self.view.frame.size.width;
    bannerHeight = 130.0f;
    
    _loadingMore = NO;
	
	NSMutableDictionary *idip = [[NSMutableDictionary alloc]init];
	self.imageDownloadsInProgress = idip;
	[idip release];
	
	NSMutableArray *wait = [[NSMutableArray alloc]init];
	self.imageDownloadsInWaiting = wait;
	[wait release];
	
	//推荐应用数据初始化
	NSMutableArray *tempRecommendAppArray = [[NSMutableArray alloc] init];
	self.recommendAppItems = tempRecommendAppArray;
	[tempRecommendAppArray release];
	
    //添加loading图标
    UIActivityIndicatorView *tempSpinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
    [tempSpinner setCenter:CGPointMake(self.view.frame.size.width / 3, (self.view.frame.size.height - 44.0f) / 2.0)];
    self.spinner = tempSpinner;
    
    UILabel *loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 100, 20)];
    loadingLabel.font = [UIFont systemFontOfSize:14];
    loadingLabel.textColor = [UIColor colorWithRed:0.5 green: 0.5 blue: 0.5 alpha:1.0];
    loadingLabel.text = LOADING_TIPS;		
    loadingLabel.textAlignment = UITextAlignmentCenter;
    loadingLabel.backgroundColor = [UIColor clearColor];
    [self.spinner addSubview:loadingLabel];
    [self.view addSubview:self.spinner];
    [self.spinner startAnimating];
    [tempSpinner release];
    
    //从网络中获取检查有没有更新的数据
    [self accessItemService];

}

//添加数据表视图
-(void)addTableView;
{
    if ([self.myTableView isDescendantOfView:self.view]) 
	{
		[self.myTableView removeFromSuperview];
	}
    
	//初始化tableView
	UITableView *tempTableView = [[UITableView alloc] initWithFrame:CGRectMake( 0.0f , 0.0f , self.view.frame.size.width , self.view.frame.size.height)];
	[tempTableView setDelegate:self];
	[tempTableView setDataSource:self];
	self.myTableView = tempTableView;
	[tempTableView release];
	self.myTableView.backgroundColor = [UIColor colorWithRed:TAB_COLOR_RED green:TAB_COLOR_GREEN blue:TAB_COLOR_BLUE alpha:1.0];
    
    //判断是否有广告
    if ([self.recommendAppAdItems count] > 0)
    {
        myImageView *myiv = [[myImageView alloc]initWithFrame:
                             CGRectMake( 0.0f , 0.0f, bannerWidth , bannerHeight) withImageId:0];
        UIImage *img = [[UIImage alloc]initWithContentsOfFile:
                        [[NSBundle mainBundle] pathForResource:@"默认图banner" ofType:@"png"]];
        myiv.image = img;
        [img release];
        myiv.mydelegate = self;
        NSString *photoUrl = [self.recommendAppAdItems objectAtIndex:recommend_app_ad_img];
        NSString *picName = [Common encodeBase64:(NSMutableData *)[photoUrl dataUsingEncoding: NSUTF8StringEncoding]];
        
        if (photoUrl.length > 1) 
        {
            UIImage *photo = [FileManager getPhoto:picName];
            if (photo.size.width > 2)
            {
                myiv.image = [photo fillSize:CGSizeMake(bannerWidth,bannerHeight)];
            }
            else
            {
                [myiv startSpinner];
                [self startIconDownload:photoUrl forIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            }
        }
        self.myTableView.tableHeaderView = myiv;
        [myiv release];
    }
    
	[self.view addSubview:myTableView];
	[self.view sendSubviewToBack:self.myTableView];
	[self.myTableView reloadData];

}

//滚动loading图片
- (void)loadImagesForOnscreenRows
{
	//NSLog(@"load images for on screen");
	NSArray *visiblePaths = [self.myTableView indexPathsForVisibleRows];
	for (NSIndexPath *indexPath in visiblePaths)
	{
		int countItems = [self.recommendAppItems count];
		if (countItems >[indexPath row])
		{
			
			//获取本地图片缓存
			UIImage *cardIcon = [[self getPhoto:indexPath]fillSize:CGSizeMake(photoWith, photoHigh)];
			
			UITableViewCell *cell = [self.myTableView cellForRowAtIndexPath:indexPath];
			UIImageView *picView = (UIImageView *)[cell.contentView viewWithTag:100];
			
			if (cardIcon == nil)
			{
				if (self.myTableView.dragging == NO && self.myTableView.decelerating == NO)
				{
					NSString *photoURL = [self getPhotoURL:indexPath];
					[self startIconDownload:photoURL forIndexPath:indexPath];
				}
			}
			else
			{
				picView.image = cardIcon;
			}
			
		}
		
	}
}

//获取图片链接
-(NSString*)getPhotoURL:(NSIndexPath *)indexPath
{
	NSArray *recommendAppArray = [self.recommendAppItems objectAtIndex:[indexPath row]];
	return [recommendAppArray objectAtIndex:recommand_app_icon];
}

//获取本地缓存的图片
-(UIImage*)getPhoto:(NSIndexPath *)indexPath
{
	
	int countItems = [self.recommendAppItems count];
	
	if (countItems > [indexPath row]) 
	{
		NSArray *recommendAppArray = [self.recommendAppItems objectAtIndex:[indexPath row]];
		NSString *picName = [Common encodeBase64:(NSMutableData *)[[recommendAppArray objectAtIndex:recommand_app_icon] dataUsingEncoding: NSUTF8StringEncoding]];
		if (picName.length > 1) {
			return [FileManager getPhoto:picName];
		}
		else {
			return nil;
		}
	}
	else {
		
		return nil;
	}
	
}

//保存缓存图片
-(bool)savePhoto:(UIImage*)photo atIndexPath:(NSIndexPath*)indexPath
{
	if ([indexPath section] == 1)
    {
        //广告图片保存
        if ([self.recommendAppAdItems count] > 0)
        {
            NSString *photoUrl = [self.recommendAppAdItems objectAtIndex:recommend_app_ad_img];
            NSString *picName = [Common encodeBase64:(NSMutableData *)[photoUrl dataUsingEncoding: NSUTF8StringEncoding]];
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
    }
    else
    {
        int countItems = [self.recommendAppItems count];
        
        if (countItems > [indexPath row]) 
        {
            NSArray *recommendAppArray = [self.recommendAppItems objectAtIndex:[indexPath row]];
            NSString *picName = [Common encodeBase64:(NSMutableData *)[[recommendAppArray objectAtIndex:recommand_app_icon] dataUsingEncoding: NSUTF8StringEncoding]];
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
			
            //广告图片
            if ([indexPath section] == 1)
            {
                UIImage *photo = [iconDownloader.cardIcon fillSize:CGSizeMake(bannerWidth, bannerHeight)];
                myImageView *picView = (myImageView *)self.myTableView.tableHeaderView;
                picView.image = photo;
                [picView stopSpinner];
            }
            else
            {
                UITableViewCell *cell = [self.myTableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
                UIImage *photo = [iconDownloader.cardIcon fillSize:CGSizeMake(photoWith, photoHigh)];
                UIImageView *picView = (UIImageView *)[cell.contentView viewWithTag:100];
                picView.image = photo;
            }
            
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
	NSString *reqUrl = @"appCenters.do?param=%@";
	
	NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
								 [Common getSecureString],@"keyvalue",
                                 [NSNumber numberWithInt: SITE_ID],@"site_id",
                                 [NSNumber numberWithInt: 1],@"platform",
								 [Common getVersion:OPERAT_RECOMMEND_APP_REFRESH],@"app_ver",
								 [Common getVersion:OPERAT_RECOMMEND_APP_AD_REFRESH],@"ad_ver",
								 [NSNumber numberWithInt: 0],@"sort_order",
								 nil];
	
	[[DataManager sharedManager] accessService:jsontestDic
									   command:OPERAT_RECOMMEND_APP_REFRESH 
								  accessAdress:reqUrl 
									  delegate:self
									 withParam:nil];
}

//网络获取更多数据
-(void)accessMoreService
{
	NSString *reqUrl = @"appCenters.do?param=%@";
    
    NSArray *recommendAppArray = [self.recommendAppItems objectAtIndex:[self.recommendAppItems count]-1];
    int order = [[recommendAppArray objectAtIndex:recommand_app_sort_order] intValue];
	
	NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
								 [Common getSecureString],@"keyvalue",
                                 [NSNumber numberWithInt: SITE_ID],@"site_id",
                                 [NSNumber numberWithInt: 1],@"platform",
								 [NSNumber numberWithInt: -1],@"app_ver",
								 [NSNumber numberWithInt: order],@"sort_order",
								 nil];
	
	[[DataManager sharedManager] accessService:jsontestDic
									   command:OPERAT_RECOMMEND_APP_MORE 
								  accessAdress:reqUrl 
									  delegate:self
									 withParam:nil];
}

//更新推荐应用的操作
-(void)updateRecommendApp
{
	//重新更新数据
    self.recommendAppItems = (NSMutableArray *)[DBOperate queryData:T_RECOMMEND_APP theColumn:@"" theColumnValue:@"" orderBy:@"sort_order" orderType:@"desc" withAll:YES];
    
    NSMutableArray *adArray = (NSMutableArray *)[DBOperate queryData:T_RECOMMEND_APP_AD theColumn:@"" theColumnValue:@""  withAll:YES];
    
    //广告
    if ([adArray count] > 0)
    {
        self.recommendAppAdItems = [adArray objectAtIndex:0];
    }
	
	//添加表视图
    [self addTableView];
    
	//移出loading
    [self.spinner removeFromSuperview];
}

//更多的操作
-(void)appendTableWith:(NSMutableArray *)data
{
	//合并数据
	if (data != nil && [data count] > 0) 
	{
		for (int i = 0; i < [data count];i++ ) 
		{
			NSArray *recommendAppArray = [data objectAtIndex:i];
			[self.recommendAppItems addObject:recommendAppArray];
		}
		
		NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:[data count]];
		for (int ind = 0; ind < [data count]; ind++) 
		{
			NSIndexPath *newPath = [NSIndexPath indexPathForRow:[self.recommendAppItems indexOfObject:[data objectAtIndex:ind]] inSection:0];
			[insertIndexPaths addObject:newPath];
		}
		[self.myTableView insertRowsAtIndexPaths:insertIndexPaths 
								withRowAnimation:UITableViewRowAnimationFade];
		
	}	
	
	[self moreBackNormal];
}

//更多回归常态
-(void)moreBackNormal
{
    _loadingMore = NO;
    
	//loading图标移除
	if (self.spinner != nil) {
		[self.spinner stopAnimating];
	}
    
	if (self.moreLabel) {
        self.moreLabel.text = @"上拉加载更多";	
    }
	
}

//网络请求回调函数
- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver;
{
    switch(commandid)
    {
            //推荐应用刷新
        case OPERAT_RECOMMEND_APP_REFRESH:
            [self performSelectorOnMainThread:@selector(updateRecommendApp) withObject:nil waitUntilDone:NO];
            break;
            
            //推荐应用更多
        case OPERAT_RECOMMEND_APP_MORE:
            [self performSelectorOnMainThread:@selector(appendTableWith:) withObject:resultArray waitUntilDone:NO];
            break;
            
        default:   ;
    }
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
    if ([self.recommendAppItems count] >= 20)
    {
        return [self.recommendAppItems count] + 1;
    }
    else
    {
        if ([self.recommendAppItems count] == 0)
        {
            return 1;
        }
        else
        {
            return [self.recommendAppItems count];
        }
    }
	
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.recommendAppItems != nil && [self.recommendAppItems count] > 0)
    {
        if ([indexPath row] == [self.recommendAppItems count])
        {
            //点击更多
            return 50.0f;
        }
        else 
        {
            //记录
            return 82.0f;
        }
    }
    else
    {
        //没有记录
        return 50.0f;
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	static NSString *CellIdentifier = @"";
	UITableViewCell *cell;
	
    //ios7新特性,解决分割线短一点
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
	NSMutableArray *items = self.recommendAppItems;
	int countItems =  [self.recommendAppItems count];
	
    if (items != nil && countItems > 0)
    {
        if ([indexPath row] == countItems)
        {
            //点击更多
            CellIdentifier = @"moreCell";
        }
        else 
        {
            //记录
            CellIdentifier = @"listCell";
        }
    }
    else
    {
        //没有记录
        CellIdentifier = @"noneCell";
    }
	
	cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) 
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		self.myTableView.separatorColor = [UIColor colorWithRed:0.83 green:0.83 blue:0.83 alpha:1.0f];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		//cell.backgroundView = 
		//cell.selectedBackgroundView = 
        
        if (items != nil && countItems > 0)
        {
            self.myTableView.separatorColor = [UIColor clearColor];
            
            if([indexPath row] == countItems)
            {
                UILabel *tempMoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(105, 10, 120, 30)];
                tempMoreLabel.tag = 200;
                [tempMoreLabel setFont:[UIFont systemFontOfSize:14.0f]];
				tempMoreLabel.textColor = [UIColor colorWithRed:0.3 green: 0.3 blue: 0.3 alpha:1.0];
                tempMoreLabel.text = @"上拉加载更多";			
                tempMoreLabel.textAlignment = UITextAlignmentCenter;
                tempMoreLabel.backgroundColor = [UIColor clearColor];
                self.moreLabel = tempMoreLabel;
                [tempMoreLabel release];
                [cell.contentView addSubview:self.moreLabel];
                cell.tag = 201;
            }
            else
            {
                UIImageView *lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake( 0.0f , 80.0f, cell.frame.size.width, 2.0f)];
                UIImage * lineImg = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"线" ofType:@"png"]];
                lineImageView.image = lineImg;
                [lineImg release];
                [cell.contentView addSubview:lineImageView];
                [lineImageView release];
                
                UIImageView *rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(280, 23, 30, 30)];
                UIImage *rimg;
                rimg = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"推荐应用下载按钮" ofType:@"png"]];
                rightImage.image = rimg;
                [rimg release];
                [cell.contentView addSubview:rightImage];
                [rightImage release];
                
                UIImageView *picView = [[UIImageView alloc]initWithFrame:CGRectZero];
                picView.tag = 100;
                picView.layer.masksToBounds = YES;
                picView.layer.cornerRadius = 10;
                [cell.contentView addSubview:picView];
                [picView release];
                
                UILabel *recommendAppTitle = [[UILabel alloc]initWithFrame:CGRectZero];
                recommendAppTitle.backgroundColor = [UIColor clearColor];
                recommendAppTitle.tag = 101;
                recommendAppTitle.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
                recommendAppTitle.font = [UIFont systemFontOfSize:16];
                recommendAppTitle.textColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1];
                [cell.contentView addSubview:recommendAppTitle];
                [recommendAppTitle release];
                
                UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectZero];
                descLabel.backgroundColor = [UIColor clearColor];
                descLabel.tag = 102;
                descLabel.numberOfLines = 2;
                descLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
                descLabel.font = [UIFont systemFontOfSize:14];
                descLabel.textColor = [UIColor colorWithRed:0.5 green: 0.5 blue: 0.5 alpha:1.0];
                [cell.contentView addSubview:descLabel];
                [descLabel release];
                
                cell.backgroundColor = [UIColor clearColor];
                
            }
        }
        else
        {
            UILabel *noneLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 300, 30)];
            noneLabel.tag = 201;
            [noneLabel setFont:[UIFont systemFontOfSize:12.0f]];
            noneLabel.textColor = [UIColor colorWithRed:0.3 green: 0.3 blue: 0.3 alpha:1.0];
            noneLabel.text = @"没有推荐应用信息！";			
            noneLabel.textAlignment = UITextAlignmentCenter;
            noneLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:noneLabel];
            [noneLabel release];
        }
	}
	
	if ([indexPath row] != countItems && countItems != 0){
		
		UIImageView *picView = (UIImageView *)[cell.contentView viewWithTag:100];
		UILabel *recommendAppTitle = (UILabel *)[cell.contentView viewWithTag:101];
		UILabel *descLabel = (UILabel *)[cell.contentView viewWithTag:102];
		
		NSArray *recommendAppArray = [items objectAtIndex:[indexPath row]];
		NSString *piclink = [recommendAppArray objectAtIndex:recommand_app_icon];
		if (piclink)
		{
			[recommendAppTitle setFrame:CGRectMake(MARGIN * 2 + 60.0f, MARGIN, cell.frame.size.width-60.0f-6 * MARGIN, 20)];
			
			[descLabel setFrame:CGRectMake(MARGIN * 2 + 60.0f, MARGIN * 3 + 5.0f, cell.frame.size.width-60.0f-6 * MARGIN, 35)];
			
			[picView setFrame:CGRectMake(MARGIN, MARGIN, photoWith, photoHigh)];
			
			//获取本地图片缓存
			UIImage *cardIcon = [[self getPhoto:indexPath]fillSize:CGSizeMake(photoWith, photoHigh)];
			
			if (cardIcon == nil)
			{
				UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"应用推荐默认图标" ofType:@"png"]];
				picView.image = [img fillSize:CGSizeMake(photoWith, photoHigh)];
				[img release];
				if (self.myTableView.dragging == NO && self.myTableView.decelerating == NO)
				{
					NSString *photoURL = [self getPhotoURL:indexPath];
					[self startIconDownload:photoURL forIndexPath:indexPath];
				}
			}
			else
			{
				picView.image = cardIcon;
			}
			
		}
		else 
		{
			[recommendAppTitle setFrame:CGRectMake(MARGIN * 2, MARGIN * 3, cell.frame.size.width-10 * MARGIN, 20)];
			[descLabel setFrame:CGRectMake(MARGIN * 2, MARGIN * 8, cell.frame.size.width-10 * MARGIN, 35)];
		}
		
		recommendAppTitle.text = [recommendAppArray objectAtIndex:recommand_app_name];
		descLabel.text = [recommendAppArray objectAtIndex:recommand_app_desc];
	}
	
    return cell; 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int countItems = [self.recommendAppItems count];
	
	if (countItems > [indexPath row]) 
    {
        NSArray *recommendAppArray = [self.recommendAppItems objectAtIndex:[indexPath row]];
        NSString *appUrl = [recommendAppArray objectAtIndex:recommand_app_url];
        
        if (![appUrl isEqualToString:@""]) 
        {
            NSURL *url = [NSURL URLWithString:appUrl];
            [[UIApplication sharedApplication] openURL:url];
        }
        
    }
    
}

//ios7去掉cell背景色
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (_isAllowLoadingMore && !_loadingMore)
    {
        float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (bottomEdge > scrollView.contentSize.height + 10.0f) 
        {
            //松开 载入更多
            self.moreLabel.text=@"松开加载更多";
            
        }
        else
        {
            self.moreLabel.text=@"上拉加载更多";
        }
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	//[super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    if (!decelerate)
	{
		[self loadImagesForOnscreenRows];
    }
    
    if (_isAllowLoadingMore && !_loadingMore)
    {
        float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (bottomEdge > scrollView.contentSize.height + 10.0f) 
        {
            //松开 载入更多
            _loadingMore = YES;
            
            self.moreLabel.text=@" 加载中 ...";
            
            UITableViewCell *cell = (UITableViewCell *)[self.myTableView viewWithTag:201];
            
            //添加loading图标
            UIActivityIndicatorView *tempSpinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
            [tempSpinner setCenter:CGPointMake(cell.frame.size.width / 3, cell.frame.size.height / 2.0)];
            self.spinner = tempSpinner;
            [cell.contentView addSubview:self.spinner];
            [self.spinner startAnimating];
            [tempSpinner release];
            
            //数据
            [self accessMoreService];
        }
        else
        {
            self.moreLabel.text=@"上拉加载更多";
        }
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (bottomEdge >= scrollView.contentSize.height && bottomEdge > self.myTableView.frame.size.height && [self.recommendAppItems count] >= 20) 
    {
        _isAllowLoadingMore = YES;
    }
    else 
    {
        _isAllowLoadingMore = NO;
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

#pragma mark -
#pragma mark 图片滚动委托
- (void)imageViewTouchesEnd:(NSString *)imageId
{
    NSString *appUrl = [self.recommendAppAdItems objectAtIndex:recommend_app_ad_url];
    
    if (![appUrl isEqualToString:@""]) 
    {
        NSURL *url = [NSURL URLWithString:appUrl];
        [[UIApplication sharedApplication] openURL:url];
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
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.recommendAppItems = nil;
    self.recommendAppAdItems = nil;
	self.myTableView.delegate = nil;
	self.myTableView = nil;
	for (IconDownLoader *one in [imageDownloadsInProgress allValues]){
		one.delegate = nil;
	}
	self.imageDownloadsInProgress = nil;
	self.imageDownloadsInWaiting = nil;
	self.spinner = nil;
    self.moreLabel = nil;
}


- (void)dealloc {
	self.recommendAppItems = nil;
    self.recommendAppAdItems = nil;
	self.myTableView.delegate = nil;
	self.myTableView = nil;
	for (IconDownLoader *one in [imageDownloadsInProgress allValues]){
		one.delegate = nil;
	}
	self.imageDownloadsInProgress = nil;
	self.imageDownloadsInWaiting = nil;
	self.spinner = nil;
    self.moreLabel = nil;
    [super dealloc];
}


@end
