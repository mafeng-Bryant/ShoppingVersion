//
//  recommendViewController.m
//  shopping
//
//  Created by lai yun on 12-12-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "recommendViewController.h"
#import "Common.h"
#import "DBOperate.h"
#import "UIImageScale.h"
#import "FileManager.h"
#import "downloadParam.h"
#import "imageDownLoadInWaitingObject.h"
#import "recommendCellViewController.h"
#import "ProductDetailViewController.h"
#import "shoppingAppDelegate.h"

@interface recommendViewController ()

@end

@implementation recommendViewController

@synthesize myTableView;
@synthesize productItems;
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
    
    NSMutableArray *tempProductItems = [[NSMutableArray alloc] init];
	self.productItems = tempProductItems;
	[tempProductItems release];
    
    NSMutableDictionary *idip = [[NSMutableDictionary alloc]init];
	self.imageDownloadsInProgress = idip;
	[idip release];
	
	NSMutableArray *wait = [[NSMutableArray alloc]init];
	self.imageDownloadsInWaiting = wait;
	[wait release];
    
    picWidth = 260.0f;
    picHeight = 260.0f;
    
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
    titleLabel.text = @"精品推荐";		
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
    //self.productItems = (NSMutableArray *)[DBOperate queryData:T_RECOMMEND_PRODUCT theColumn:@"" theColumnValue:@"" orderBy:@"sort_order" orderType:@"desc" withAll:YES];
    
    self.productItems = (NSMutableArray *)[DBOperate queryData:T_RECOMMEND_PRODUCT thePicName:T_RECOMMEND_PRODUCT_PIC theColumn:@"" theColumnValue:@"" orderBy:@"sort_order" orderType:@"desc" withAll:YES];
    
    if ([self.productItems count] > 0)
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
		int countItems = [self.productItems count];
		if (countItems >[indexPath row])
		{
            
            NSArray *productArray = [self.productItems objectAtIndex:[indexPath row]];
            
            recommendCellViewController *recommendCell = (recommendCellViewController *)[self.myTableView cellForRowAtIndexPath:indexPath];
            
            //图片
            NSString *picUrl = [productArray objectAtIndex:recommend_product_pic];
            NSString *picName = [Common encodeBase64:(NSMutableData *)[picUrl dataUsingEncoding: NSUTF8StringEncoding]];
            
            if (picUrl.length > 1) 
            {
                UIImage *pic = [[FileManager getPhoto:picName] fillSize:CGSizeMake(picWidth, picHeight)];
                if (pic.size.width > 2)
                {
                    recommendCell.picView.image = pic;
                }
                else
                {
                    UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"精品推荐商品默认" ofType:@"png"]];
                    recommendCell.picView.image = [defaultPic fillSize:CGSizeMake(picWidth, picHeight)];
                    
                    if (self.myTableView.dragging == NO && self.myTableView.decelerating == NO)
                    {
                        [recommendCell.picView stopSpinner];
                        [recommendCell.picView startSpinner];
                        [self startIconDownload:picUrl forIndexPath:indexPath];
                    }
                }
            }
            else
            {
                UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"精品推荐商品默认" ofType:@"png"]];
                recommendCell.picView.image = [defaultPic fillSize:CGSizeMake(picWidth, picHeight)];
            }

        }
		
	}
}

//保存缓存图片
-(bool)savePhoto:(UIImage*)photo atIndexPath:(NSIndexPath*)indexPath
{
    int countItems = [self.productItems count];
	
	if (countItems > [indexPath row]) 
	{
		NSArray *productArray = [self.productItems objectAtIndex:[indexPath row]];
        NSString *picUrl = [productArray objectAtIndex:recommend_product_pic];
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
        recommendCellViewController *recommendCell = (recommendCellViewController *)[self.myTableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        
        // Display the newly loaded image
		if(iconDownloader.cardIcon.size.width>2.0)
		{ 
			//保存图片
			[self savePhoto:iconDownloader.cardIcon atIndexPath:indexPath];
            
            UIImage *pic = [iconDownloader.cardIcon fillSize:CGSizeMake(picWidth, picHeight)];
            recommendCell.picView.image = pic;
            [recommendCell.picView stopSpinner];
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
    //self.productItems = (NSMutableArray *)[DBOperate queryData:T_RECOMMEND_PRODUCT theColumn:@"" theColumnValue:@"" orderBy:@"sort_order" orderType:@"desc" withAll:YES];
    
    self.productItems = (NSMutableArray *)[DBOperate queryData:T_RECOMMEND_PRODUCT thePicName:T_RECOMMEND_PRODUCT_PIC theColumn:@"" theColumnValue:@"" orderBy:@"sort_order" orderType:@"desc" withAll:YES];
    
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
			NSArray *productArray = [data objectAtIndex:i];
			[self.productItems addObject:productArray];
		}
		
		NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:[data count]];
		for (int ind = 0; ind < [data count]; ind++) 
		{
			NSIndexPath *newPath = [NSIndexPath indexPathForRow:[self.productItems indexOfObject:[data objectAtIndex:ind]] inSection:0];
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
    NSString *reqUrl = @"index/boutiQue.do?param=%@";
	
	NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
								 [Common getSecureString],@"keyvalue",
								 [NSNumber numberWithInt: SITE_ID],@"site_id",
                                 [Common getVersion:OPERAT_RECOMMEND_LIST_REFRESH],@"ver",
								 [NSNumber numberWithInt: 0],@"sort_order",
								 nil];
	
	[[DataManager sharedManager] accessService:jsontestDic
									   command:OPERAT_RECOMMEND_LIST_REFRESH 
								  accessAdress:reqUrl 
									  delegate:self
									 withParam:nil];
}

//网络获取更多数据
-(void)accessMoreService
{
    NSString *reqUrl = @"index/boutiQue.do?param=%@";
    
    NSArray *productArray = [self.productItems objectAtIndex:[self.productItems count]-1];
    int sort_order = [[productArray objectAtIndex:recommend_product_sort_order] intValue];
	
	NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
								 [Common getSecureString],@"keyvalue",
								 [NSNumber numberWithInt: SITE_ID],@"site_id",
                                 [NSNumber numberWithInt: -1],@"ver",
								 [NSNumber numberWithInt: sort_order],@"sort_order",
								 nil];
	
	[[DataManager sharedManager] accessService:jsontestDic
									   command:OPERAT_RECOMMEND_LIST_MORE
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
        case OPERAT_RECOMMEND_LIST_REFRESH:
            [self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
            break;
            
            //搜索更多
        case OPERAT_RECOMMEND_LIST_MORE:
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
    
    if ([self.productItems count] >= 10)
    {
        return [self.productItems count] + 1;
    }
    else
    {
        if ([self.productItems count] == 0)
        {
            return 1;
        }
        else
        {
            return [self.productItems count];
        }
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.productItems != nil && [self.productItems count] > 0)
    {
        if ([indexPath row] == [self.productItems count])
        {
            //更多
            return 50.0f;
        }
        else 
        {
            //记录 340 + 15
            return 355.0f;
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
	
	int productItemsCount =  [self.productItems count];
    int cellType;
    if (self.productItems != nil && productItemsCount > 0)
    {
        if ([indexPath row] == productItemsCount)
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
				noneLabel.text = @"没有精品推荐！";			
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
                cell = [[[recommendCellViewController alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                
                break;
            }
				
			default:   ;
		}
        
        cell.backgroundColor = [UIColor clearColor];
	}
	
	if (cellType == 2)
    {
        if (self.productItems.count > 0) {
            //数据填充
            NSArray *productArray = [self.productItems objectAtIndex:[indexPath row]];
            
            recommendCellViewController *recommendCell = (recommendCellViewController *)cell;
            
            //标题
            recommendCell.titleLabel.text = [productArray objectAtIndex:recommend_product_title];
            
            //价格判断
            NSString *priceString;
            if ([[productArray objectAtIndex:recommend_product_promotion_price] intValue] != 0 && [[productArray objectAtIndex:recommend_product_promotion_price] length] > 0)
            {
                //有优惠价格
                priceString = [NSString stringWithFormat:@"￥%.2f",[[productArray objectAtIndex:recommend_product_promotion_price] floatValue]];
            }
            else
            {
                //没有优惠价格
                priceString = [NSString stringWithFormat:@"￥%.2f",[[productArray objectAtIndex:recommend_product_price] floatValue]];
            }
            
            CGSize constraint = CGSizeMake(20000.0f, 30.0f);
            CGSize size = [priceString sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            CGFloat fixWidth = (size.width + 5.0f) > 100.0f ? 100.0f : (size.width + 5.0f);
            recommendCell.priceLabel.frame = CGRectMake( recommendCell.priceLabel.frame.origin.x, recommendCell.priceLabel.frame.origin.y , fixWidth , recommendCell.priceLabel.frame.size.height);
            recommendCell.priceLabel.text = priceString;
            
            //标签自适应
            recommendCell.priceImageView.frame = CGRectMake( recommendCell.priceImageView.frame.origin.x, recommendCell.priceImageView.frame.origin.y , fixWidth + 20.0f , recommendCell.priceImageView.frame.size.height);
            
            //喜欢
            recommendCell.likeLabel.text = [productArray objectAtIndex:recommend_product_likes];
            
            //评论
            recommendCell.commentLabel.text = [productArray objectAtIndex:recommend_product_comment_num];
            
            //图片
            NSString *picUrl = [productArray objectAtIndex:recommend_product_pic];
            NSString *picName = [Common encodeBase64:(NSMutableData *)[picUrl dataUsingEncoding: NSUTF8StringEncoding]];
            
            if (picUrl.length > 1)
            {
                UIImage *pic = [[FileManager getPhoto:picName] fillSize:CGSizeMake(picWidth, picHeight)];
                if (pic.size.width > 2)
                {
                    recommendCell.picView.image = pic;
                }
                else
                {
                    UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"精品推荐商品默认" ofType:@"png"]];
                    recommendCell.picView.image = [defaultPic fillSize:CGSizeMake(picWidth, picHeight)];
                    
                    if (tableView.dragging == NO && tableView.decelerating == NO)
                    {
                        [recommendCell.picView stopSpinner];
                        [recommendCell.picView startSpinner];
                        [self startIconDownload:picUrl forIndexPath:indexPath];
                    }
                }
            }
            else
            {
                UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"精品推荐商品默认" ofType:@"png"]];
                recommendCell.picView.image = [defaultPic fillSize:CGSizeMake(picWidth, picHeight)];
            }
            
            return recommendCell;
        }
        
	}
    
    return cell; 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int countItems = [self.productItems count];
	
	if (countItems > [indexPath row]) 
    {
        shoppingAppDelegate *shoppingDelegate = (shoppingAppDelegate *)[UIApplication sharedApplication].delegate;
        
        NSArray *productArray = [self.productItems objectAtIndex:[indexPath row]];
        ProductDetailViewController *ProductDetailView = [[ProductDetailViewController alloc] init];
        ProductDetailView.productID = [[productArray objectAtIndex:product_id] intValue];
        ProductDetailView.productList = self.productItems;
        ProductDetailView.selectIndex = [indexPath row];
        ProductDetailView.pvType = @"1";
        [shoppingDelegate.navController pushViewController:ProductDetailView animated:YES];
        [ProductDetailView release];
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
    if (bottomEdge >= scrollView.contentSize.height && bottomEdge > self.myTableView.frame.size.height && [self.productItems count] >= 10)
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
    self.productItems = nil;
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
    self.productItems= nil;
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
