//
//  lotteryListViewController.m
//  shopping
//
//  Created by lai yun on 12-12-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "lotteryListViewController.h"
#import "Common.h"
#import "DBOperate.h"
#import "UIImageScale.h"
#import "FileManager.h"
#import "downloadParam.h"
#import "imageDownLoadInWaitingObject.h"
#import "lotteryCellViewController.h"
#import "shoppingAppDelegate.h"
#import "lotteryViewController.h"
#import "MyPrizeViewController.h"

@interface lotteryListViewController ()

@end

@implementation lotteryListViewController

@synthesize myTableView;
@synthesize lotteryItems;
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
    
    self.title = @"抽奖";
    
    NSMutableArray *tempLotteryItems = [[NSMutableArray alloc] init];
	self.lotteryItems = tempLotteryItems;
	[tempLotteryItems release];
    
    NSMutableDictionary *idip = [[NSMutableDictionary alloc]init];
	self.imageDownloadsInProgress = idip;
	[idip release];
	
	NSMutableArray *wait = [[NSMutableArray alloc]init];
	self.imageDownloadsInWaiting = wait;
	[wait release];
    
    picWidth = 300.0f;
    picHeight = 122.0f;
    
    //我的奖品按钮
//    UIImage *prizeImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"抽奖我的奖品按钮" ofType:@"png"]];
//	UIButton *prizeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//	prizeButton.frame = CGRectMake( 0.0f , 0.0f , 88.0f , 40.0f);
//	[prizeButton addTarget:self action:@selector(myPrize) forControlEvents:UIControlEventTouchUpInside];
//    [prizeButton setBackgroundImage:prizeImage forState:UIControlStateNormal];
//    [prizeImage release];
//    [prizeButton setTitle:@"我的奖品" forState:UIControlStateNormal];
//    prizeButton.titleLabel.textAlignment = UITextAlignmentCenter;
//    prizeButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0f];
//    UIBarButtonItem *prizeItem = [[UIBarButtonItem alloc] initWithCustomView:prizeButton]; 
//    self.navigationItem.rightBarButtonItem = prizeItem;
    
    UIBarButtonItem *prizeItem = [[UIBarButtonItem alloc] initWithTitle:@"我的奖品" style:UIBarButtonItemStyleBordered target:self action:@selector(myPrize)];
    self.navigationItem.rightBarButtonItem = prizeItem;
    [prizeItem release];
    
    //背景
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake( 0.0f , 0.0f , self.view.frame.size.width , self.view.frame.size.height)];
    backgroundView.layer.masksToBounds = YES;
    [self.view addSubview:backgroundView];
    [backgroundView release];
    
    UIImage *backgroundImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"抽奖背景" ofType:@"png"]];
    UIImageView *backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f , 0.0f , backgroundImage.size.width , backgroundImage.size.height)];
    backgroundImageView.image = backgroundImage;
    [backgroundImage release];
    [backgroundView addSubview:backgroundImageView];
	[backgroundImageView release];
    
}

-(void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
    
    //添加loading图标
    UIActivityIndicatorView *tempSpinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
    [tempSpinner setCenter:CGPointMake(self.view.frame.size.width / 3, (self.view.frame.size.height/2)-44.0f)];
    self.spinner = tempSpinner;
    
    UILabel *loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 100, 20)];
    loadingLabel.font = [UIFont systemFontOfSize:14];
    loadingLabel.textColor = [UIColor colorWithRed:1.0 green: 1.0 blue: 1.0 alpha:1.0];
    loadingLabel.text = LOADING_TIPS;		
    loadingLabel.textAlignment = UITextAlignmentCenter;
    loadingLabel.backgroundColor = [UIColor clearColor];
    [self.spinner addSubview:loadingLabel];
    [loadingLabel release];
    [self.view addSubview:self.spinner];
    [self.spinner startAnimating];
    [tempSpinner release];
    
    if ([self.myTableView isDescendantOfView:self.view]) 
    {
        self.myTableView.hidden = YES;
    }
    
    //网络获取
    [self accessItemService];
    
}

//我的奖品
-(void)myPrize
{
    //判断用户是否登陆
    if (_isLogin == YES) 
    {
        NSMutableArray *memberArray = (NSMutableArray *)[DBOperate queryData:T_MEMBER_INFO theColumn:@"" theColumnValue:@"" withAll:YES];
        if ([memberArray count] > 0) 
        {
            NSString *userId = [[memberArray objectAtIndex:0] objectAtIndex:member_info_memberId];
            MyPrizeViewController *prize = [[MyPrizeViewController alloc] init];
            prize.userId = userId;
            [self.navigationController pushViewController:prize animated:YES];
            [prize release];
        }
        else
        {
            LoginViewController *login = [[LoginViewController alloc] init];
            login.delegate = self;
            [self.navigationController pushViewController:login animated:YES];
            [login release];
        }
        
    }
    else 
    {
        LoginViewController *login = [[LoginViewController alloc] init];
        login.delegate = self;
        [self.navigationController pushViewController:login animated:YES];
        [login release];
    }
}

//添加数据表视图
-(void)addTableView;
{
    //初始化tableView
    if ([self.myTableView isDescendantOfView:self.view]) 
    {
        self.myTableView.hidden = NO;
        [self.myTableView reloadData];
    }
    else
    {
        UITableView *tempTableView = [[UITableView alloc] initWithFrame:CGRectMake( 0.0f , 0.0f , self.view.frame.size.width , self.view.frame.size.height)];
        [tempTableView setDelegate:self];
        [tempTableView setDataSource:self];
        tempTableView.scrollsToTop = YES;
        tempTableView.showsVerticalScrollIndicator = NO;
        self.myTableView = tempTableView;
        [tempTableView release];
        self.myTableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:myTableView];
        [self.myTableView reloadData];
        
        //分割线
        self.myTableView.separatorColor = [UIColor clearColor];
        
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
		int countItems = [self.lotteryItems count];
		if (countItems >[indexPath row])
		{
            
            NSArray *lotteryArray = [self.lotteryItems objectAtIndex:[indexPath row]];
            
            lotteryCellViewController *lotteryCell = (lotteryCellViewController *)[self.myTableView cellForRowAtIndexPath:indexPath];
            
            //图片
            NSString *picUrl = [lotteryArray objectAtIndex:lottery_pic];
            NSString *picName = [Common encodeBase64:(NSMutableData *)[picUrl dataUsingEncoding: NSUTF8StringEncoding]];
            lotteryCell.picView.imageId = [NSString stringWithFormat:@"%d",[indexPath row]];
            lotteryCell.picView.mydelegate = self;
            
            if (picUrl.length > 1) 
            {
                UIImage *pic = [[FileManager getPhoto:picName] fillSize:CGSizeMake(picWidth, picHeight)];
                if (pic.size.width > 2)
                {
                    lotteryCell.picView.image = pic;
                }
                else
                {
                    UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"抽奖奖品默认" ofType:@"png"]];
                    lotteryCell.picView.image = [defaultPic fillSize:CGSizeMake(picWidth, picHeight)];
                    
                    if (self.myTableView.dragging == NO && self.myTableView.decelerating == NO)
                    {
                        [lotteryCell.picView stopSpinner];
                        [lotteryCell.picView startSpinner];
                        [self startIconDownload:picUrl forIndexPath:indexPath];
                    }
                }
            }
            else
            {
                UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"抽奖奖品默认" ofType:@"png"]];
                lotteryCell.picView.image = [defaultPic fillSize:CGSizeMake(picWidth, picHeight)];
            }

        }
		
	}
}

//保存缓存图片
-(bool)savePhoto:(UIImage*)photo atIndexPath:(NSIndexPath*)indexPath
{
    int countItems = [self.lotteryItems count];
	
	if (countItems > [indexPath row]) 
	{
		NSArray *lotteryArray = [self.lotteryItems objectAtIndex:[indexPath row]];
        NSString *picUrl = [lotteryArray objectAtIndex:lottery_pic];
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
        lotteryCellViewController *lotteryCell = (lotteryCellViewController *)[self.myTableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        
        // Display the newly loaded image
		if(iconDownloader.cardIcon.size.width>2.0)
		{ 
			//保存图片
			[self savePhoto:iconDownloader.cardIcon atIndexPath:indexPath];
            
            UIImage *pic = [iconDownloader.cardIcon fillSize:CGSizeMake(picWidth, picHeight)];
            lotteryCell.picView.image = pic;
            [lotteryCell.picView stopSpinner];
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
    self.lotteryItems = (NSMutableArray *)[DBOperate queryData:T_LOTTERY theColumn:@"" theColumnValue:@"" orderBy:@"sort_order" orderType:@"desc" withAll:YES];
    
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
			NSArray *lotteryArray = [data objectAtIndex:i];
			[self.lotteryItems addObject:lotteryArray];
		}
		
		NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:[data count]];
		for (int ind = 0; ind < [data count]; ind++) 
		{
			NSIndexPath *newPath = [NSIndexPath indexPathForRow:[self.lotteryItems indexOfObject:[data objectAtIndex:ind]] inSection:0];
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
    NSString *reqUrl = @"luckdraw/list.do?param=%@";
	
	NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
								 [Common getSecureString],@"keyvalue",
								 [NSNumber numberWithInt: SITE_ID],@"site_id",
                                 [Common getVersion:OPERAT_LOTTERY_LIST_REFRESH],@"ver",
								 [NSNumber numberWithInt: 0],@"sort_order",
								 nil];
	
	[[DataManager sharedManager] accessService:jsontestDic
									   command:OPERAT_LOTTERY_LIST_REFRESH 
								  accessAdress:reqUrl 
									  delegate:self
									 withParam:nil];
}

//网络获取更多数据
-(void)accessMoreService
{
    NSString *reqUrl = @"luckdraw/list.do?param=%@";
    
    NSArray *lotteryArray = [self.lotteryItems objectAtIndex:[self.lotteryItems count]-1];
    int sort_order = [[lotteryArray objectAtIndex:lottery_sort_order] intValue];
	
	NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
								 [Common getSecureString],@"keyvalue",
								 [NSNumber numberWithInt: SITE_ID],@"site_id",
                                 [NSNumber numberWithInt: -1],@"ver",
								 [NSNumber numberWithInt: sort_order],@"sort_order",
								 nil];
	
	[[DataManager sharedManager] accessService:jsontestDic
									   command:OPERAT_LOTTERY_LIST_MORE
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
        //抽奖列表刷新
        case OPERAT_LOTTERY_LIST_REFRESH:
            [self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
            break;
            
        //抽奖列表更多
        case OPERAT_LOTTERY_LIST_MORE:
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
        int countItems = [self.lotteryItems count];
        
        if (countItems > [imageId intValue]) 
        {
            NSMutableArray *lotteryArray = [self.lotteryItems objectAtIndex:[imageId intValue]];
            
            lotteryViewController *lotteryView = [[lotteryViewController alloc] init];
            lotteryView.lotteryID = [lotteryArray objectAtIndex:lottery_id];
            lotteryView.lotteryArray = lotteryArray;
            if ([[lotteryArray objectAtIndex:lottery_pics] isKindOfClass:[NSMutableArray class]])
            {
                lotteryView.lotteryPicArray= [lotteryArray objectAtIndex:lottery_pics];
            }
            
            [self.navigationController pushViewController:lotteryView animated:YES];
            [lotteryView release];
        }
    }
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.lotteryItems count] >= 20)
    {
        return [self.lotteryItems count] + 1;
    }
    else
    {
        if ([self.lotteryItems count] == 0)
        {
            return 1;
        }
        else
        {
            return [self.lotteryItems count];
        }
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.lotteryItems != nil && [self.lotteryItems count] > 0)
    {
        if ([indexPath row] == [self.lotteryItems count])
        {
            //更多
            return 50.0f;
        }
        else 
        {
            //记录 122 + 40 + 40 + 10
            return 212.0f;
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
	
	int lotteryItemsCount =  [self.lotteryItems count];
    int cellType;
    if (self.lotteryItems != nil && lotteryItemsCount > 0)
    {
        if ([indexPath row] == lotteryItemsCount)
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
				noneLabel.textColor = [UIColor colorWithRed:1.0 green: 1.0 blue: 1.0 alpha:1.0];
				noneLabel.text = @"没有抽奖！";			
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
                cell = [[[lotteryCellViewController alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                
                break;
            }
				
			default:   ;
		}
        
        cell.backgroundColor = [UIColor clearColor];
	}
	
	if (cellType == 2)
    {
        //数据填充
        NSArray *lotteryArray = [self.lotteryItems objectAtIndex:[indexPath row]];
        
        lotteryCellViewController *lotteryCell = (lotteryCellViewController *)cell;
        
        //标题
        lotteryCell.titleLabel.text = [lotteryArray objectAtIndex:lottery_name];
        
        //价格
        lotteryCell.priceLabel.text = [NSString stringWithFormat:@" ￥%@",[lotteryArray objectAtIndex:lottery_product_price]];
        
        //中奖人数
        lotteryCell.winNumLabel.text = [lotteryArray objectAtIndex:lottery_win_num];
        
        //判断当前状态
        NSTimeInterval cTime = [[NSDate date] timeIntervalSince1970];
        long long int currentTime = (long long int)cTime;
        int stauts = [[lotteryArray objectAtIndex:lottery_status] intValue];
        int startTime = [[lotteryArray objectAtIndex:lottery_starttime] intValue];
        int endTime = [[lotteryArray objectAtIndex:lottery_endtime] intValue];
        
        if (stauts == 1)
        {
            if (startTime > currentTime)
            {
                //即将开始
                lotteryCell.statusImageView.hidden = NO;
                UIImage *statusImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"抽奖即将开始" ofType:@"png"]];
                lotteryCell.statusImageView.image = statusImage;
                lotteryCell.statusLabel.text = @"即将开始";
                lotteryCell.statusLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1];
                lotteryCell.timeTitleLabel.hidden = YES;
                lotteryCell.timeLabel.hidden = YES;
            }
            else if(startTime <= currentTime && endTime > currentTime)
            {
                //正在进行
                lotteryCell.statusImageView.hidden = NO;
                UIImage *statusImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"抽奖立即抽奖" ofType:@"png"]];
                lotteryCell.statusImageView.image = statusImage;
                lotteryCell.statusLabel.text = @"立即抽奖";
                lotteryCell.statusLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1];
                lotteryCell.timeTitleLabel.hidden = NO;
                lotteryCell.timeLabel.hidden = NO;
                
                //时间
                NSDate* date = [NSDate dateWithTimeIntervalSince1970:[[lotteryArray objectAtIndex:lottery_endtime] intValue]];
                NSDateFormatter *outputFormat = [[NSDateFormatter alloc] init];
                [outputFormat setDateFormat:@"yyyy-MM-dd"];
                NSString *dateString = [outputFormat stringFromDate:date];
                [outputFormat release];
                lotteryCell.timeLabel.text = dateString;
            }
            else
            {
                //已下架
                lotteryCell.statusImageView.hidden = YES;
                lotteryCell.statusLabel.text = @"已经结束";
                lotteryCell.statusLabel.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
                lotteryCell.timeTitleLabel.hidden = YES;
                lotteryCell.timeLabel.hidden = YES;
            }
        }
        else
        {
            //已下架
            lotteryCell.statusImageView.hidden = YES;
            lotteryCell.statusLabel.text = @"已经结束";
            lotteryCell.statusLabel.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
            lotteryCell.timeTitleLabel.hidden = YES;
            lotteryCell.timeLabel.hidden = YES;
        }
        
        //图片
        NSString *picUrl = [lotteryArray objectAtIndex:lottery_pic];
        NSString *picName = [Common encodeBase64:(NSMutableData *)[picUrl dataUsingEncoding: NSUTF8StringEncoding]];
        lotteryCell.picView.imageId = [NSString stringWithFormat:@"%d",[indexPath row]];
        lotteryCell.picView.mydelegate = self;
        
        if (picUrl.length > 1) 
        {
            UIImage *pic = [[FileManager getPhoto:picName] fillSize:CGSizeMake(picWidth, picHeight)];
            if (pic.size.width > 2)
            {
                lotteryCell.picView.image = pic;
            }
            else
            {
                UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"抽奖奖品默认" ofType:@"png"]];
                lotteryCell.picView.image = [defaultPic fillSize:CGSizeMake(picWidth, picHeight)];
                
				if (tableView.dragging == NO && tableView.decelerating == NO)
				{
                    [lotteryCell.picView stopSpinner];
                    [lotteryCell.picView startSpinner];
					[self startIconDownload:picUrl forIndexPath:indexPath];
				}
            }
        }
        else
        {
            UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"抽奖奖品默认" ofType:@"png"]];
            lotteryCell.picView.image = [defaultPic fillSize:CGSizeMake(picWidth, picHeight)];
        }
        
        return lotteryCell;
        
	}
    
    return cell; 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int countItems = [self.lotteryItems count];
	
	if (countItems > [indexPath row]) 
    {
        NSMutableArray *lotteryArray = [self.lotteryItems objectAtIndex:[indexPath row]];
        
        lotteryViewController *lotteryView = [[lotteryViewController alloc] init];
        lotteryView.lotteryID = [lotteryArray objectAtIndex:lottery_id];
        lotteryView.lotteryArray = lotteryArray;
        if ([[lotteryArray objectAtIndex:lottery_pics] isKindOfClass:[NSMutableArray class]])
        {
            lotteryView.lotteryPicArray= [lotteryArray objectAtIndex:lottery_pics];
        }
        
        [self.navigationController pushViewController:lotteryView animated:YES];
        [lotteryView release];
    }
    
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
    if (bottomEdge >= scrollView.contentSize.height && bottomEdge > self.myTableView.frame.size.height && [self.lotteryItems count] >= 20) 
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

#pragma mark -
#pragma mark 登录接口回调
- (void)loginWithResult:(BOOL)isLoginSuccess{
    
	if (isLoginSuccess) 
    {
        [self performSelector:@selector(myPrize) withObject:nil afterDelay:0.5];
	}
    
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
    self.lotteryItems = nil;
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
    self.lotteryItems= nil;
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
