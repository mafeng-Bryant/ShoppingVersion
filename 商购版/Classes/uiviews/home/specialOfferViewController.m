//
//  specialOfferViewController.m
//  shopping
//
//  Created by lai yun on 12-12-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "specialOfferViewController.h"
#import "Common.h"
#import "DBOperate.h"
#import "UIImageScale.h"
#import "FileManager.h"
#import "downloadParam.h"
#import "imageDownLoadInWaitingObject.h"
#import "specialOfferCellViewController.h"
#import "shoppingAppDelegate.h"
#import "specialListViewController.h"
#import "ProductDetailViewController.h"

@interface specialOfferViewController ()

@end

@implementation specialOfferViewController

@synthesize myTableView;
@synthesize specialOfferItems;
@synthesize spinner;
@synthesize moreLabel;
@synthesize _reloading;
@synthesize _loadingMore;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    NSMutableArray *tempSpecialOfferItems = [[NSMutableArray alloc] init];
	self.specialOfferItems = tempSpecialOfferItems;
	[tempSpecialOfferItems release];
    
    NSMutableDictionary *idip = [[NSMutableDictionary alloc]init];
	self.imageDownloadsInProgress = idip;
	[idip release];
	
	NSMutableArray *wait = [[NSMutableArray alloc]init];
	self.imageDownloadsInWaiting = wait;
	[wait release];
    
    bannerWidth = 302.0f;
    bannerHeight = 110.0f;
    
    picWidth = 100.0f;
    picHeight = 50.0f;
    
    //上bar
//    UIImage *topBarImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"上bar3" ofType:@"png"]];
    UIImage *topBarImage = nil;
    if (IOS_VERSION >= 7.0) {
        topBarImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:IOS7_NAV_BG_PIC ofType:nil]];
    }else{
        topBarImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NAV_BG_PIC ofType:nil]];
    }
    UIImageView *topBarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f , 0.0f , self.view.frame.size.width , topBarImage.size.height)];
	topBarImageView.image = topBarImage;
	[topBarImage release];
    
    //标题
    CGFloat yValue = IOS_VERSION < 7.0 ? 0.0f : 20.0f;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0f , yValue , topBarImageView.frame.size.width , topBarImageView.frame.size.height - yValue)];
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0f];
    titleLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    titleLabel.text = @"特价专区";		
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    [topBarImageView addSubview:titleLabel];
    [titleLabel release];
    
    [self.view addSubview:topBarImageView];
	[topBarImageView release];
    
    //增加的遮盖图层
    UIImage *coverImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"上bar底部遮盖" ofType:@"png"]];
    UIImageView *coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f , CGRectGetMaxY(topBarImageView.frame) , coverImage.size.width , coverImage.size.height)];
    coverImageView.image = coverImage;
    [coverImage release];
    [self.view addSubview:coverImageView];
	[coverImageView release];
    
}

-(void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
    
    //添加loading图标
    UIActivityIndicatorView *tempSpinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
    [tempSpinner setCenter:CGPointMake(self.view.frame.size.width / 3, self.view.frame.size.height / 2.0)];
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
    
    //从数据库 获取特价数据
    self.specialOfferItems = (NSMutableArray *)[DBOperate queryData:T_SPECIAL_OFFER theColumn:@"" theColumnValue:@"" orderBy:@"sort_order" orderType:@"desc" withAll:YES];
    
    if ([self.specialOfferItems count] > 0)
    {
        
        [self addTableView];
        
        //回归常态
        [self backNormal];
    }
    else
    {
        //网络获取
        [self accessItemService];
    }
}

//添加数据表视图
-(void)addTableView;
{
    //初始化tableView
    if ([self.myTableView isDescendantOfView:self.view]) 
    {
        [self.myTableView reloadData];
    }
    else
    {
        CGFloat yValue = IOS_VERSION < 7.0 ? 44.0f : 20.0f + 44.0f;
        UITableView *tempTableView = [[UITableView alloc] initWithFrame:CGRectMake( 0.0f , yValue , self.view.frame.size.width , VIEW_HEIGHT - 49.0f - yValue)];
        [tempTableView setDelegate:self];
        [tempTableView setDataSource:self];
        tempTableView.scrollsToTop = YES;
        self.myTableView = tempTableView;
        [tempTableView release];
        self.myTableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:myTableView];
        [self.view sendSubviewToBack:self.myTableView];
        [self.myTableView reloadData];
        
        //分割线
        self.myTableView.separatorColor = [UIColor clearColor];
        
        //遮盖物离顶部距离
        UIImage *coverImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"上bar底部遮盖" ofType:@"png"]];
        UIView *topMarginView = [[UIView alloc] initWithFrame:CGRectMake(0.0f , 0.0f , self.view.frame.size.width , coverImage.size.height)];
        [coverImage release];
        self.myTableView.tableHeaderView = topMarginView;
        [topMarginView release];
        
        //下拉更新
        _refreshHeaderView = nil;
        _reloading = NO;
        _loadingMore = NO;
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.myTableView.bounds.size.height, self.view.frame.size.width, self.myTableView.bounds.size.height)];
        view.delegate = self;
        [self.myTableView addSubview:view];
        _refreshHeaderView = view;
        [view release];
        [_refreshHeaderView refreshLastUpdatedDate];
    }
}

//滚动loading图片
- (void)loadImagesForOnscreenRows
{
    NSArray *visiblePaths = [self.myTableView indexPathsForVisibleRows];
	for (NSIndexPath *indexPath in visiblePaths)
	{
		int countItems = [self.specialOfferItems count];
		if (countItems >[indexPath row])
		{
            
            NSArray *specialOfferArray = [self.specialOfferItems objectAtIndex:[indexPath row]];
            
            specialOfferCellViewController *specialOfferCell = (specialOfferCellViewController *)[self.myTableView cellForRowAtIndexPath:indexPath];
            
            //标题
            specialOfferCell.titleLabel.text = [specialOfferArray objectAtIndex:special_offer_name];
            
            //banner图片
            NSString *bannerUrl = [specialOfferArray objectAtIndex:special_offer_banner];
            NSString *bannerName = [Common encodeBase64:(NSMutableData *)[bannerUrl dataUsingEncoding: NSUTF8StringEncoding]];
            specialOfferCell.bannerView.imageId = [NSString stringWithFormat:@"%d,%@,%@",1,[specialOfferArray objectAtIndex:special_offer_id],[specialOfferArray objectAtIndex:special_offer_name]];
            
            specialOfferCell.bannerView.mydelegate = self;
            
            if (bannerUrl.length > 1) 
            {
                UIImage *banner = [[FileManager getPhoto:bannerName] fillSize:CGSizeMake(bannerWidth, bannerHeight)];
                if (banner.size.width > 2)
                {
                    specialOfferCell.bannerView.image = banner;
                }
                else
                {
                    UIImage *defaultBanner = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"特价专区大图默认" ofType:@"png"]];
                    specialOfferCell.bannerView.image = [defaultBanner fillSize:CGSizeMake(bannerWidth, bannerHeight)];
                    
                    if (self.myTableView.dragging == NO && self.myTableView.decelerating == NO)
                    {
                        [self startIconDownload:bannerUrl forIndexPath:[NSIndexPath indexPathForRow:[indexPath row] inSection:0]];
                    }
                }
            }
            else
            {
                UIImage *defaultBanner = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"特价专区大图默认" ofType:@"png"]];
                specialOfferCell.bannerView.image = [defaultBanner fillSize:CGSizeMake(bannerWidth, bannerHeight)];
            }
            
            //小图片1
            NSString *picUrl1 = [specialOfferArray objectAtIndex:special_offer_img1];
            NSString *picName1 = [Common encodeBase64:(NSMutableData *)[picUrl1 dataUsingEncoding: NSUTF8StringEncoding]];
            specialOfferCell.picView1.imageId = [NSString stringWithFormat:@"%d,%@,%@",2,[specialOfferArray objectAtIndex:special_offer_info_id1],[specialOfferArray objectAtIndex:special_offer_name]];
            
            specialOfferCell.picView1.mydelegate = self;
            
            if (picUrl1.length > 1) 
            {
                UIImage *pic1 = [[FileManager getPhoto:picName1] fillSize:CGSizeMake(picWidth, picHeight)];
                if (pic1.size.width > 2)
                {
                    specialOfferCell.picView1.image = pic1;
                }
                else
                {
                    UIImage *defaultPic1 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"特价专区小图默认" ofType:@"png"]];
                    specialOfferCell.picView1.image = [defaultPic1 fillSize:CGSizeMake(picWidth, picHeight)];
                    
                    if (self.myTableView.dragging == NO && self.myTableView.decelerating == NO)
                    {
                        [self startIconDownload:picUrl1 forIndexPath:[NSIndexPath indexPathForRow:[indexPath row] inSection:1]];
                    }
                }
            }
            else
            {
                UIImage *defaultPic1 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"特价专区小图默认" ofType:@"png"]];
                specialOfferCell.picView1.image = [defaultPic1 fillSize:CGSizeMake(picWidth, picHeight)];
            }
            
            //小图片2
            NSString *picUrl2 = [specialOfferArray objectAtIndex:special_offer_img2];
            NSString *picName2 = [Common encodeBase64:(NSMutableData *)[picUrl2 dataUsingEncoding: NSUTF8StringEncoding]];
            specialOfferCell.picView2.imageId = [NSString stringWithFormat:@"%d,%@,%@",2,[specialOfferArray objectAtIndex:special_offer_info_id2],[specialOfferArray objectAtIndex:special_offer_name]];
            
            specialOfferCell.picView2.mydelegate = self;
            
            if (picUrl2.length > 1) 
            {
                UIImage *pic2 = [[FileManager getPhoto:picName2] fillSize:CGSizeMake(picWidth, picHeight)];
                if (pic2.size.width > 2)
                {
                    specialOfferCell.picView2.image = pic2;
                }
                else
                {
                    UIImage *defaultPic2 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"特价专区小图默认" ofType:@"png"]];
                    specialOfferCell.picView2.image = [defaultPic2 fillSize:CGSizeMake(picWidth, picHeight)];
                    
                    if (self.myTableView.dragging == NO && self.myTableView.decelerating == NO)
                    {
                        [self startIconDownload:picUrl2 forIndexPath:[NSIndexPath indexPathForRow:[indexPath row] inSection:2]];
                    }
                }
            }
            else
            {
                UIImage *defaultPic2 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"特价专区小图默认" ofType:@"png"]];
                specialOfferCell.picView2.image = [defaultPic2 fillSize:CGSizeMake(picWidth, picHeight)];
            }
            
            //小图片3
            NSString *picUrl3 = [specialOfferArray objectAtIndex:special_offer_img3];
            NSString *picName3 = [Common encodeBase64:(NSMutableData *)[picUrl3 dataUsingEncoding: NSUTF8StringEncoding]];
            specialOfferCell.picView3.imageId = [NSString stringWithFormat:@"%d,%@,%@",2,[specialOfferArray objectAtIndex:special_offer_info_id3],[specialOfferArray objectAtIndex:special_offer_name]];
            
            specialOfferCell.picView3.mydelegate = self;
            
            if (picUrl3.length > 1) 
            {
                UIImage *pic3 = [[FileManager getPhoto:picName3] fillSize:CGSizeMake(picWidth, picHeight)];
                if (pic3.size.width > 2)
                {
                    specialOfferCell.picView3.image = pic3;
                }
                else
                {
                    UIImage *defaultPic3 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"特价专区小图默认" ofType:@"png"]];
                    specialOfferCell.picView3.image = [defaultPic3 fillSize:CGSizeMake(picWidth, picHeight)];
                    
                    if (self.myTableView.dragging == NO && self.myTableView.decelerating == NO)
                    {
                        [self startIconDownload:picUrl3 forIndexPath:[NSIndexPath indexPathForRow:[indexPath row] inSection:3]];
                    }
                }
            }
            else
            {
                UIImage *defaultPic3 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"特价专区小图默认" ofType:@"png"]];
                specialOfferCell.picView3.image = [defaultPic3 fillSize:CGSizeMake(picWidth, picHeight)];
            }
		}
		
	}
}

//保存缓存图片
-(bool)savePhoto:(UIImage*)photo atIndexPath:(NSIndexPath*)indexPath
{
    int countItems = [self.specialOfferItems count];
	
	if (countItems > [indexPath row]) 
	{
		NSArray *specialOfferArray = [self.specialOfferItems objectAtIndex:[indexPath row]];
        NSString *picUrl;
        int section = [indexPath section];
        
        switch(section)
		{
            //banner
			case 0:
            {
                picUrl = [specialOfferArray objectAtIndex:special_offer_banner];
                break;
            }
            //小图1
			case 1:
            {
                picUrl = [specialOfferArray objectAtIndex:special_offer_img1];
                break;
            }
            //小图2
			case 2:
            {
                picUrl = [specialOfferArray objectAtIndex:special_offer_img2];
                break;
            }
            //小图3
			case 3:
            {
                picUrl = [specialOfferArray objectAtIndex:special_offer_img3];
                break;
            }
			default:
                picUrl = @"";
                break;
		}
        
        NSString *picName = [Common encodeBase64:(NSMutableData *)[picUrl dataUsingEncoding: NSUTF8StringEncoding]];
		
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
        specialOfferCellViewController *specialOfferCell = (specialOfferCellViewController *)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[iconDownloader.indexPathInTableView row] inSection:0]];

        // Display the newly loaded image
		if(iconDownloader.cardIcon.size.width>2.0)
		{ 
			//保存图片
			[self savePhoto:iconDownloader.cardIcon atIndexPath:indexPath];

            int section = [indexPath section];
            
            switch(section)
            {
                    //banner
                case 0:
                {
                    UIImage *pic = [iconDownloader.cardIcon fillSize:CGSizeMake(bannerWidth, bannerHeight)];
                    specialOfferCell.bannerView.image = pic;
                    break;
                }
                    //小图1
                case 1:
                {
                    UIImage *pic = [iconDownloader.cardIcon fillSize:CGSizeMake(picWidth, picHeight)];
                    specialOfferCell.picView1.image = pic;
                    break;
                }
                    //小图2
                case 2:
                {
                    UIImage *pic = [iconDownloader.cardIcon fillSize:CGSizeMake(picWidth, picHeight)];
                    specialOfferCell.picView2.image = pic;
                    break;
                }
                    //小图3
                case 3:
                {
                    UIImage *pic = [iconDownloader.cardIcon fillSize:CGSizeMake(picWidth, picHeight)];
                    specialOfferCell.picView3.image = pic;
                    break;
                }
                default:
                    break;
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

//更新记录
-(void)update
{
    //从数据库 获取特价数据
    self.specialOfferItems = (NSMutableArray *)[DBOperate queryData:T_SPECIAL_OFFER theColumn:@"" theColumnValue:@"" orderBy:@"sort_order" orderType:@"desc" withAll:YES];
    
    //添加表
    [self addTableView];
    
    //回归常态
    [self backNormal];
    
}

//更多的操作
-(void)appendTableWith:(NSMutableArray *)data
{
    //合并数据
	if (data != nil && [data count] > 0) 
	{
		for (int i = 0; i < [data count];i++ ) 
		{
			NSArray *specialOfferArray = [data objectAtIndex:i];
			[self.specialOfferItems addObject:specialOfferArray];
		}
		
		NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:[data count]];
		for (int ind = 0; ind < [data count]; ind++) 
		{
			NSIndexPath *newPath = [NSIndexPath indexPathForRow:[self.specialOfferItems indexOfObject:[data objectAtIndex:ind]] inSection:0];
			[insertIndexPaths addObject:newPath];
		}
		[self.myTableView insertRowsAtIndexPaths:insertIndexPaths 
								withRowAnimation:UITableViewRowAnimationFade];
		
	}	
	
	[self moreBackNormal];
}


//网络获取数据
-(void)accessItemService
{
    NSString *reqUrl = @"index/specialOffers.do?param=%@";
	
	NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
								 [Common getSecureString],@"keyvalue",
								 [NSNumber numberWithInt: SITE_ID],@"site_id",
                                 [Common getVersion:OPERAT_SPECIAL_OFFER_REFRESH],@"ver",
								 [NSNumber numberWithInt: 0],@"sort_order",
								 nil];
	
	[[DataManager sharedManager] accessService:jsontestDic
									   command:OPERAT_SPECIAL_OFFER_REFRESH 
								  accessAdress:reqUrl 
									  delegate:self
									 withParam:nil];
}

//网络获取更多数据
-(void)accessMoreService
{
    NSString *reqUrl = @"index/specialOffers.do?param=%@";
    
    NSArray *specialOfferArray = [self.specialOfferItems objectAtIndex:[self.specialOfferItems count]-1];
    int sort_order = [[specialOfferArray objectAtIndex:special_offer_sort_order] intValue];
	
	NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
								 [Common getSecureString],@"keyvalue",
								 [NSNumber numberWithInt: SITE_ID],@"site_id",
                                 [NSNumber numberWithInt: -1],@"ver",
								 [NSNumber numberWithInt: sort_order],@"sort_order",
								 nil];
	
	[[DataManager sharedManager] accessService:jsontestDic
									   command:OPERAT_SPECIAL_OFFER_MORE
								  accessAdress:reqUrl 
									  delegate:self
									 withParam:nil];
    
}

//回归常态
-(void)backNormal
{
    //移出loading
    [self.spinner removeFromSuperview];
    
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:NO];
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
- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver
{
    switch(commandid)
    {
            //搜索刷新
        case OPERAT_SPECIAL_OFFER_REFRESH:
            [self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
            break;
            
            //搜索更多
        case OPERAT_SPECIAL_OFFER_MORE:
            [self performSelectorOnMainThread:@selector(appendTableWith:) withObject:resultArray waitUntilDone:NO];
            break;
            
        default:   ;
    }
}

#pragma mark -
#pragma mark 图片委托
- (void)imageViewTouchesEnd:(NSString *)imageId
{
    if (imageId.length > 0)
    {
        NSArray *array = [imageId componentsSeparatedByString:@","];
        if ([[array objectAtIndex:special_offer_content_type] intValue] == 1)
        {
            //banner列表
            shoppingAppDelegate *shoppingDelegate = (shoppingAppDelegate *)[UIApplication sharedApplication].delegate;
            specialListViewController *specialListView = [[specialListViewController alloc] init];
            specialListView.contentType = 2;
            specialListView.specialId = [array objectAtIndex:special_offer_content_info_id];
            specialListView.titleString = [array objectAtIndex:special_offer_content_name];
            [shoppingDelegate.navController pushViewController:specialListView animated:YES];
            [specialListView release];
            
        }
        else if([[array objectAtIndex:special_offer_content_type] intValue] == 2) 
        {
            //产品详情
            //NSLog(@"===============%@",[array objectAtIndex:special_offer_content_info_id]);
            if ([[array objectAtIndex:special_offer_content_info_id] intValue] != 0)
            {
                shoppingAppDelegate *shoppingDelegate = (shoppingAppDelegate *)[UIApplication sharedApplication].delegate;
                ProductDetailViewController *ProductDetailView = [[ProductDetailViewController alloc] init];
                ProductDetailView.productID = [[array objectAtIndex:special_offer_content_info_id] intValue];
                ProductDetailView.pvType = @"2";
                [shoppingDelegate.navController pushViewController:ProductDetailView animated:YES];
                [ProductDetailView release];
            }
        }
    }
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.specialOfferItems count] >= 10)
    {
        return [self.specialOfferItems count] + 1;
    }
    else
    {
        if ([self.specialOfferItems count] == 0)
        {
            return 1;
        }
        else
        {
            return [self.specialOfferItems count];
        }
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.specialOfferItems != nil && [self.specialOfferItems count] > 0)
    {
        if ([indexPath row] == [self.specialOfferItems count])
        {
            //更多
            return 50.0f;
        }
        else 
        {
            //记录 206 + 5
            return 211.0f;
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
	
	int specialOfferItemsCount =  [self.specialOfferItems count];
    int cellType;
    if (self.specialOfferItems != nil && specialOfferItemsCount > 0)
    {
        if ([indexPath row] == specialOfferItemsCount)
        {
            //更多
            CellIdentifier = @"moreCell";
            cellType = 1;
        }
        else 
        {
            //记录
            CellIdentifier = @"listCell";
            cellType = 2;
        }
    }
    else
    {
        //没有记录
        CellIdentifier = @"noneCell";
        cellType = 0;
    }
	
	cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) 
	{
        switch(cellType)
		{
                //没有记录
			case 0:
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                self.myTableView.separatorColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UILabel *noneLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 300, 30)];
				noneLabel.tag = 101;
				[noneLabel setFont:[UIFont systemFontOfSize:12.0f]];
				noneLabel.textColor = [UIColor colorWithRed:0.3 green: 0.3 blue: 0.3 alpha:1.0];
				noneLabel.text = @"没有特价！";			
				noneLabel.textAlignment = UITextAlignmentCenter;
				noneLabel.backgroundColor = [UIColor clearColor];
				[cell.contentView addSubview:noneLabel];
				[noneLabel release];
                
                break;
            }
                //更多
			case 1:
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                self.myTableView.separatorColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
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
                break;
            }
                //记录
			case 2:
            {
                cell = [[[specialOfferCellViewController alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                
                break;
            }
				
			default:   ;
		}
        
        cell.backgroundColor = [UIColor clearColor];
	}
	
	if (cellType == 2)
    {
        //数据填充
        NSArray *specialOfferArray = [self.specialOfferItems objectAtIndex:[indexPath row]];
        
        specialOfferCellViewController *specialOfferCell = (specialOfferCellViewController *)cell;
        
        //标题
        specialOfferCell.titleLabel.text = [specialOfferArray objectAtIndex:special_offer_name];
        
        //banner图片
        NSString *bannerUrl = [specialOfferArray objectAtIndex:special_offer_banner];
        NSString *bannerName = [Common encodeBase64:(NSMutableData *)[bannerUrl dataUsingEncoding: NSUTF8StringEncoding]];
        specialOfferCell.bannerView.imageId = [NSString stringWithFormat:@"%d,%@,%@",1,[specialOfferArray objectAtIndex:special_offer_id],[specialOfferArray objectAtIndex:special_offer_name]];
        
        specialOfferCell.bannerView.mydelegate = self;
        
        if (bannerUrl.length > 1) 
        {
            UIImage *banner = [[FileManager getPhoto:bannerName] fillSize:CGSizeMake(bannerWidth, bannerHeight)];
            if (banner.size.width > 2)
            {
                specialOfferCell.bannerView.image = banner;
            }
            else
            {
                UIImage *defaultBanner = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"特价专区大图默认" ofType:@"png"]];
                specialOfferCell.bannerView.image = [defaultBanner fillSize:CGSizeMake(bannerWidth, bannerHeight)];
                
				if (tableView.dragging == NO && tableView.decelerating == NO)
				{
					[self startIconDownload:bannerUrl forIndexPath:[NSIndexPath indexPathForRow:[indexPath row] inSection:0]];
				}
            }
        }
        else
        {
            UIImage *defaultBanner = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"特价专区大图默认" ofType:@"png"]];
            specialOfferCell.bannerView.image = [defaultBanner fillSize:CGSizeMake(bannerWidth, bannerHeight)];
        }
        
        //小图片1
        NSString *picUrl1 = [specialOfferArray objectAtIndex:special_offer_img1];
        NSString *picName1 = [Common encodeBase64:(NSMutableData *)[picUrl1 dataUsingEncoding: NSUTF8StringEncoding]];
        specialOfferCell.picView1.imageId = [NSString stringWithFormat:@"%d,%@,%@",2,[specialOfferArray objectAtIndex:special_offer_info_id1],[specialOfferArray objectAtIndex:special_offer_name]];
        
        specialOfferCell.picView1.mydelegate = self;
        
        if (picUrl1.length > 1) 
        {
            UIImage *pic1 = [[FileManager getPhoto:picName1] fillSize:CGSizeMake(picWidth, picHeight)];
            if (pic1.size.width > 2)
            {
                specialOfferCell.picView1.image = pic1;
            }
            else
            {
                UIImage *defaultPic1 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"特价专区小图默认" ofType:@"png"]];
                specialOfferCell.picView1.image = [defaultPic1 fillSize:CGSizeMake(picWidth, picHeight)];
                
				if (tableView.dragging == NO && tableView.decelerating == NO)
				{
					[self startIconDownload:picUrl1 forIndexPath:[NSIndexPath indexPathForRow:[indexPath row] inSection:1]];
				}
            }
        }
        else
        {
            UIImage *defaultPic1 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"特价专区小图默认" ofType:@"png"]];
            specialOfferCell.picView1.image = [defaultPic1 fillSize:CGSizeMake(picWidth, picHeight)];
        }
        
        //小图片2
        NSString *picUrl2 = [specialOfferArray objectAtIndex:special_offer_img2];
        NSString *picName2 = [Common encodeBase64:(NSMutableData *)[picUrl2 dataUsingEncoding: NSUTF8StringEncoding]];
        specialOfferCell.picView2.imageId = [NSString stringWithFormat:@"%d,%@,%@",2,[specialOfferArray objectAtIndex:special_offer_info_id2],[specialOfferArray objectAtIndex:special_offer_name]];
        
        specialOfferCell.picView2.mydelegate = self;
        
        if (picUrl2.length > 1) 
        {
            UIImage *pic2 = [[FileManager getPhoto:picName2] fillSize:CGSizeMake(picWidth, picHeight)];
            if (pic2.size.width > 2)
            {
                specialOfferCell.picView2.image = pic2;
            }
            else
            {
                UIImage *defaultPic2 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"特价专区小图默认" ofType:@"png"]];
                specialOfferCell.picView2.image = [defaultPic2 fillSize:CGSizeMake(picWidth, picHeight)];
                
				if (tableView.dragging == NO && tableView.decelerating == NO)
				{
					[self startIconDownload:picUrl2 forIndexPath:[NSIndexPath indexPathForRow:[indexPath row] inSection:2]];
				}
            }
        }
        else
        {
            UIImage *defaultPic2 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"特价专区小图默认" ofType:@"png"]];
            specialOfferCell.picView2.image = [defaultPic2 fillSize:CGSizeMake(picWidth, picHeight)];
        }
        
        //小图片3
        NSString *picUrl3 = [specialOfferArray objectAtIndex:special_offer_img3];
        NSString *picName3 = [Common encodeBase64:(NSMutableData *)[picUrl3 dataUsingEncoding: NSUTF8StringEncoding]];
        specialOfferCell.picView3.imageId = [NSString stringWithFormat:@"%d,%@,%@",2,[specialOfferArray objectAtIndex:special_offer_info_id3],[specialOfferArray objectAtIndex:special_offer_name]];
        
        specialOfferCell.picView3.mydelegate = self;
        
        if (picUrl3.length > 1) 
        {
            UIImage *pic3 = [[FileManager getPhoto:picName3] fillSize:CGSizeMake(picWidth, picHeight)];
            if (pic3.size.width > 2)
            {
                specialOfferCell.picView3.image = pic3;
            }
            else
            {
                UIImage *defaultPic3 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"特价专区小图默认" ofType:@"png"]];
                specialOfferCell.picView3.image = [defaultPic3 fillSize:CGSizeMake(picWidth, picHeight)];
                
				if (tableView.dragging == NO && tableView.decelerating == NO)
				{
					[self startIconDownload:picUrl3 forIndexPath:[NSIndexPath indexPathForRow:[indexPath row] inSection:3]];
				}
            }
        }
        else
        {
            UIImage *defaultPic3 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"特价专区小图默认" ofType:@"png"]];
            specialOfferCell.picView3.image = [defaultPic3 fillSize:CGSizeMake(picWidth, picHeight)];
        }
        
        return specialOfferCell;
        
	}
    
    return cell; 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //do nothing;
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
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
	
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
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
    if (bottomEdge >= scrollView.contentSize.height && bottomEdge > self.myTableView.frame.size.height && [self.specialOfferItems count] >= 10) 
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
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.myTableView];
    
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
    
    //网络获取
    [self accessItemService];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
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
    
	self.myTableView.delegate = nil;
	self.myTableView = nil;
    self.specialOfferItems = nil;
	self.spinner = nil;
    self.moreLabel = nil;
    for (IconDownLoader *one in [imageDownloadsInProgress allValues]){
		one.delegate = nil;
	}
	self.imageDownloadsInProgress = nil;
	self.imageDownloadsInWaiting = nil;
}


- (void)dealloc {
	self.myTableView.delegate = nil;
	self.myTableView = nil;
    self.specialOfferItems = nil;
	self.spinner = nil;
    self.moreLabel = nil;
    for (IconDownLoader *one in [imageDownloadsInProgress allValues]){
		one.delegate = nil;
	}
	self.imageDownloadsInProgress = nil;
	self.imageDownloadsInWaiting = nil;
    [super dealloc];
}

@end
