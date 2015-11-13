//
//  myWaterFlowViewController.m
//  myWaterFlow
//
//  Created by siphp on 12-12-14.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "myWaterFlowViewController.h"
#import "Common.h"
#import "DBOperate.h"
#import "UIImageScale.h"
#import "FileManager.h"
#import "downloadParam.h"
#import "imageDownLoadInWaitingObject.h"
#import "ProductDetailViewController.h"
#import "shoppingAppDelegate.h"

//外框间距
#define MARGIN_X 4.0f
#define MARGIN_Y 0.0f

//图片间距
#define PIC_MARGIN_X 11.0f
#define PIC_MARGIN_Y 7.0f

//外框尺寸
#define BIG_SIZE_WIDTH 312.0f
#define BIG_SIZE_HEIGHT 312.0f

//大图尺寸
#define BIG_PIC_SIZE_WIDTH 298.0f
#define BIG_PIC_SIZE_HEIGHT 298.0f

//外框尺寸
#define SMALL_SIZE_WIDTH 154.0f
#define SMALL_SIZE_HEIGHT 154.0f

//小图尺寸
#define SMALL_PIC_SIZE_WIDTH 140.0f
#define SMALL_PIC_SIZE_HEIGHT 140.0f


@implementation myWaterFlowViewController

@synthesize myTableView;
@synthesize productItems;
@synthesize tableItems;
@synthesize spinner;
@synthesize moreLabel;
@synthesize _reloading;
@synthesize _loadingMore;
@synthesize imageDownloadsInProgress;
@synthesize imageDownloadsInWaiting;
@synthesize currentCatId;
@synthesize myTableViewHeight;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    self.view.backgroundColor = [UIColor clearColor];
    
    NSMutableArray *tempProductItems = [[NSMutableArray alloc] init];
	self.productItems = tempProductItems;
	[tempProductItems release];
    
    NSMutableArray *tempTableItems = [[NSMutableArray alloc] init];
	self.tableItems = tempTableItems;
	[tempTableItems release];
    
    NSMutableDictionary *idip = [[NSMutableDictionary alloc]init];
	self.imageDownloadsInProgress = idip;
	[idip release];
	
	NSMutableArray *wait = [[NSMutableArray alloc]init];
	self.imageDownloadsInWaiting = wait;
	[wait release];
    
    myTableViewHeight = VIEW_HEIGHT - 20.0f - 44.0f - 40.0f - 49.0f;
    
}

- (void)viewWillAppear:(BOOL)animated
{
//    //转化tableView 数据
//    [self makeTableItems];
//    
//    [self addTableView];
}

//显示瀑布流
-(void)showWaterFlowView
{
    [self backNormal];
    
    if ([self.myTableView isDescendantOfView:self.view]) 
    {
        self.myTableView.hidden = YES;
    }
    
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
    
    //从数据库 获取该分类的产品数据
    //self.productItems = (NSMutableArray *)[DBOperate queryData:T_PRODUCT theColumn:@"cat_id" theColumnValue:currentCatId orderBy:@"sort_order" orderType:@"desc" withAll:NO];
    
//    self.productItems = (NSMutableArray *)[DBOperate queryData:T_PRODUCT thePicName:T_PRODUCT_PIC theColumn:@"cat_id" theColumnValue:currentCatId orderBy:@"sort_order" orderType:@"desc" withAll:NO];
//    
//    if ([self.productItems count] > 0)
//    {
//        //转化数据
//        [self makeTableItems];
//        
//        [self addTableView];
//        
//        //回归常态
//        [self backNormal];
//    }
//    else
//    {
//        //网络获取
//        [self accessItemService];
//    }
    //网络获取
    [self accessItemService];
}

//添加数据表视图
-(void)addTableView;
{
	//初始化tableView
    if ([self.myTableView isDescendantOfView:self.view]) 
    {
        [self.myTableView reloadData];
        //[self.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] 
        //                      atScrollPosition:UITableViewScrollPositionTop 
        //                              animated:NO];
        self.myTableView.contentOffset = CGPointMake(0.0f, 0.0f);
        self.myTableView.hidden = NO;
    }
    else
    {
        UITableView *tempTableView = [[UITableView alloc] initWithFrame:CGRectMake( 0.0f , 0.0f , self.view.frame.size.width , myTableViewHeight)];
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
    
    //注册消息通知 发送广播
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showProductTable" object:nil];
}

//转化tableView 数据
-(void)makeTableItems
{
    [self.tableItems removeAllObjects];
    int itemsCount = [self.productItems count];
    NSMutableArray *stackArray = [[NSMutableArray alloc]init];
    int stackRow = 0;
    if (itemsCount > 0)
    {
        for (int i = 0; i < itemsCount; i++)
        {
            NSMutableArray *productArray = [self.productItems objectAtIndex:i];
            
            //是否为大图
            if ([[productArray objectAtIndex:product_is_big_pic] intValue] == 1)
            {
                //大图
                NSMutableArray *bigArray = [[NSMutableArray alloc]init];
                [bigArray addObject:[productArray objectAtIndex:product_is_big_pic]];    //大图还是小图
                [bigArray addObject:[NSString stringWithFormat:@"%d",i]];   //原始数据行号
                [bigArray addObject:productArray];
                [self.tableItems addObject:bigArray];
                [bigArray release];
            }
            else
            {
                //小图
                if ([stackArray count] > 0)
                {
                    NSMutableArray *smallArray = [[NSMutableArray alloc]init];
                    [smallArray addObject:[productArray objectAtIndex:product_is_big_pic]];    //大图还是小图
                    [smallArray addObject:[NSString stringWithFormat:@"%d",stackRow]];   //1原始数据行号
                    [smallArray addObject:stackArray];
                    [smallArray addObject:[NSString stringWithFormat:@"%d",i]];   //2原始数据行号
                    [smallArray addObject:productArray];
                    [self.tableItems addObject:smallArray];
                    [smallArray release];
                    
                    stackArray = nil;
                }
                else
                {
                    stackArray = productArray;
                    stackRow = i;
                }
            }
        }
        
        //如果最后多出一张小图 也需要显示
        if ([stackArray count] > 0)
        {
            NSMutableArray *smallArray = [[NSMutableArray alloc]init];
            [smallArray addObject:@"0"];    //大图还是小图
            [smallArray addObject:[NSString stringWithFormat:@"%d",stackRow]];   //1原始数据行号
            [smallArray addObject:stackArray];
            [smallArray addObject:[NSNull null]];   //2原始数据行号
            [smallArray addObject:[NSNull null]];
            [self.tableItems addObject:smallArray];
            [smallArray release];
            
            stackArray = nil;
        }
    }

}

//滚动loading图片
- (void)loadImagesForOnscreenRows
{
	NSArray *visiblePaths = [self.myTableView indexPathsForVisibleRows];
	for (NSIndexPath *indexPath in visiblePaths)
	{
		int countItems = [self.tableItems count];
		if (countItems >[indexPath row])
		{
			NSMutableArray *productArray = [self.tableItems objectAtIndex:[indexPath row]];
            UITableViewCell *cell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[indexPath row] inSection:0]];
            
            if ([[productArray objectAtIndex:big_product_is_big_pic] intValue] == 1) 
            {
                //===========大图===========
                myImageView *bigImageView = (myImageView *)[cell.contentView viewWithTag:1000];
                NSString *photoUrl = [[productArray objectAtIndex:big_product_info] objectAtIndex:product_pic];
                
                //在此 取缓存图片 网络load图片
                NSString *picName = [Common encodeBase64:(NSMutableData *)[photoUrl dataUsingEncoding: NSUTF8StringEncoding]];
                
                UIImage *photo = [FileManager getPhoto:picName];
                if (photo.size.width > 2)
                {
                    bigImageView.image = [photo fillSize:CGSizeMake(BIG_PIC_SIZE_WIDTH,BIG_PIC_SIZE_HEIGHT)];
                }
                else
                {
                    if (self.myTableView.dragging == NO && self.myTableView.decelerating == NO)
                    {
                        //[bigImageView startSpinner];
                        [self startIconDownload:photoUrl forIndexPath:indexPath];
                    }
                }
            }
            else 
            {
                //===========小图===========
                
                //左边
                myImageView *smallImageView1 = (myImageView *)[cell.contentView viewWithTag:2000];
                NSString *photoUrl1 = [[productArray objectAtIndex:small_product_info1] objectAtIndex:product_pic];
                
                
                
                //在此 取缓存图片 网络load图片
                NSString *picName = [Common encodeBase64:(NSMutableData *)[photoUrl1 dataUsingEncoding: NSUTF8StringEncoding]];
                
                UIImage *photo = [FileManager getPhoto:picName];
                if (photo.size.width > 2)
                {
                    smallImageView1.image = [photo fillSize:CGSizeMake(SMALL_PIC_SIZE_WIDTH,SMALL_PIC_SIZE_HEIGHT)];
                }
                else
                {
                    if (self.myTableView.dragging == NO && self.myTableView.decelerating == NO)
                    {
                        //[bigImageView startSpinner];
                        [self startIconDownload:photoUrl1 forIndexPath:[NSIndexPath indexPathForRow:[indexPath row] inSection:1]];
                    }
                }
                
                //右边
                if ([productArray objectAtIndex:small_product_row2] != [NSNull null] && [productArray objectAtIndex:small_product_info2] != [NSNull null])
                {
                    myImageView *smallImageView2 = (myImageView *)[cell.contentView viewWithTag:3000];
                    NSString *photoUrl2 = [[productArray objectAtIndex:small_product_info2] objectAtIndex:product_pic];
                    
                    //在此 取缓存图片 网络load图片
                    NSString *picName = [Common encodeBase64:(NSMutableData *)[photoUrl2 dataUsingEncoding: NSUTF8StringEncoding]];
                    
                    UIImage *photo = [FileManager getPhoto:picName];
                    if (photo.size.width > 2)
                    {
                        smallImageView2.image = [photo fillSize:CGSizeMake(SMALL_PIC_SIZE_WIDTH,SMALL_PIC_SIZE_HEIGHT)];
                    }
                    else
                    {
                        if (self.myTableView.dragging == NO && self.myTableView.decelerating == NO)
                        {
                            //[bigImageView startSpinner];
                            [self startIconDownload:photoUrl2 forIndexPath:[NSIndexPath indexPathForRow:[indexPath row] inSection:2]];
                        }
                    }
                }
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
        NSString *picName = [Common encodeBase64:(NSMutableData *)[[productArray objectAtIndex:product_pic] dataUsingEncoding: NSUTF8StringEncoding]];
        
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
    IconDownLoader *iconDownloader = [imageDownloadsInProgress objectForKey:[NSString stringWithFormat:@"%d,%@",[currentCatId intValue],indexPath]];
    if (iconDownloader == nil && photoURL != nil && photoURL.length > 1) 
    {
		if ([imageDownloadsInProgress count]>= 5) {
			imageDownLoadInWaitingObject *one = [[imageDownLoadInWaitingObject alloc]init:photoURL withIndexPath:indexPath withImageType:[currentCatId intValue]];
			[imageDownloadsInWaiting addObject:one];
			[one release];
			return;
		}
        IconDownLoader *iconDownloader = [[IconDownLoader alloc] init];
        iconDownloader.downloadURL = photoURL;
        iconDownloader.indexPathInTableView = indexPath;
		iconDownloader.imageType = [currentCatId intValue];
        iconDownloader.delegate = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:[NSString stringWithFormat:@"%d,%@",[currentCatId intValue],indexPath]];
        [iconDownloader startDownload];
        [iconDownloader release];
    }
}

//回调 获到网络图片后的回调函数
//- (void)appImageDidLoad:(NSIndexPath *)indexPath withImageType:(int)Type
//{
//    IconDownLoader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
//    if (iconDownloader != nil)
//    {
//        // Display the newly loaded image
//		if(iconDownloader.cardIcon.size.width>2.0)
//		{
//            NSMutableArray *productArray = [self.tableItems objectAtIndex:[indexPath row]];
//            UITableViewCell *cell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[indexPath row] inSection:0]];
//            
//            if ([[productArray objectAtIndex:big_product_is_big_pic] intValue] == 1) 
//            {
//                //===========大图===========
//                //保存图片 传productItems 的行数过去
//                [self savePhoto:iconDownloader.cardIcon atIndexPath:[NSIndexPath indexPathForRow:[[productArray objectAtIndex:big_product_row] intValue] inSection:0]];
//            
//                UIImage *photo = [iconDownloader.cardIcon fillSize:CGSizeMake(BIG_PIC_SIZE_WIDTH, BIG_PIC_SIZE_HEIGHT)];
//                myImageView *bigImageView = (myImageView *)[cell.contentView viewWithTag:1000];
//                bigImageView.image = photo;
//                [bigImageView stopSpinner];
//            }
//            else 
//            {
//                //===========小图===========
//                
//                if ([indexPath section] == 1)
//                {
//                    //左边
//                    [self savePhoto:iconDownloader.cardIcon atIndexPath:[NSIndexPath indexPathForRow:[[productArray objectAtIndex:small_product_row1] intValue] inSection:0]];
//                    
//                    UIImage *photo = [iconDownloader.cardIcon fillSize:CGSizeMake(SMALL_PIC_SIZE_WIDTH, SMALL_PIC_SIZE_HEIGHT)];
//                    myImageView *smallImageView1 = (myImageView *)[cell.contentView viewWithTag:2000];
//                    smallImageView1.image = photo;
//                    [smallImageView1 stopSpinner];
//                }
//                else if([indexPath section] == 2)
//                {
//                    //右边
//                    if ([productArray objectAtIndex:small_product_row2] != [NSNull null] && [productArray objectAtIndex:small_product_info2] != [NSNull null])
//                    {
//                        [self savePhoto:iconDownloader.cardIcon atIndexPath:[NSIndexPath indexPathForRow:[[productArray objectAtIndex:small_product_row2] intValue] inSection:0]];
//                        
//                        UIImage *photo = [iconDownloader.cardIcon fillSize:CGSizeMake(SMALL_PIC_SIZE_WIDTH, SMALL_PIC_SIZE_HEIGHT)];
//                        myImageView *smallImageView2 = (myImageView *)[cell.contentView viewWithTag:3000];
//                        smallImageView2.image = photo;
//                        [smallImageView2 stopSpinner];
//                    }
//                }
//            }
//            
//		}
//		
//		[imageDownloadsInProgress removeObjectForKey:indexPath];
//		if ([imageDownloadsInWaiting count]>0) 
//		{
//			imageDownLoadInWaitingObject *one = [imageDownloadsInWaiting objectAtIndex:0];
//			[self startIconDownload:one.imageURL forIndexPath:one.indexPath];
//			[imageDownloadsInWaiting removeObjectAtIndex:0];
//		}
//		
//    }
//}

- (void)appImageDidLoad:(NSIndexPath *)indexPath withImageType:(int)Type
{
    IconDownLoader *iconDownloader = [imageDownloadsInProgress objectForKey:[NSString stringWithFormat:@"%d,%@",Type,indexPath]];
    if (iconDownloader != nil)
    {
        // Display the newly loaded image
		if(iconDownloader.cardIcon.size.width>2.0)
		{
            NSString *picName = [Common encodeBase64:(NSMutableData *)[iconDownloader.downloadURL dataUsingEncoding: NSUTF8StringEncoding]];
			
            //保存图片
			[FileManager savePhoto:picName withImage:iconDownloader.cardIcon];
            
            if (Type == [currentCatId intValue])
            {
                NSMutableArray *productArray = [self.tableItems objectAtIndex:[indexPath row]];
                UITableViewCell *cell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[indexPath row] inSection:0]];
                
                if ([[productArray objectAtIndex:big_product_is_big_pic] intValue] == 1)
                {
                    //===========大图===========
                    UIImage *photo = [iconDownloader.cardIcon fillSize:CGSizeMake(BIG_PIC_SIZE_WIDTH, BIG_PIC_SIZE_HEIGHT)];
                    myImageView *bigImageView = (myImageView *)[cell.contentView viewWithTag:1000];
                    bigImageView.image = photo;
                    [bigImageView stopSpinner];
                }
                else
                {
                    //===========小图===========
                    
                    if ([indexPath section] == 1)
                    {
                        UIImage *photo = [iconDownloader.cardIcon fillSize:CGSizeMake(SMALL_PIC_SIZE_WIDTH, SMALL_PIC_SIZE_HEIGHT)];
                        myImageView *smallImageView1 = (myImageView *)[cell.contentView viewWithTag:2000];
                        smallImageView1.image = photo;
                        [smallImageView1 stopSpinner];
                    }
                    else if([indexPath section] == 2)
                    {
                        //右边
                        if ([productArray objectAtIndex:small_product_row2] != [NSNull null] && [productArray objectAtIndex:small_product_info2] != [NSNull null])
                        {
                            UIImage *photo = [iconDownloader.cardIcon fillSize:CGSizeMake(SMALL_PIC_SIZE_WIDTH, SMALL_PIC_SIZE_HEIGHT)];
                            myImageView *smallImageView2 = (myImageView *)[cell.contentView viewWithTag:3000];
                            smallImageView2.image = photo;
                            [smallImageView2 stopSpinner];
                        }
                    }
                }
            }
            
		}
		
		[imageDownloadsInProgress removeObjectForKey:[NSString stringWithFormat:@"%d,%@",Type,indexPath]];
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
    
    //从数据库 获取该分类的产品数据
    //self.productItems = (NSMutableArray *)[DBOperate queryData:T_PRODUCT theColumn:@"cat_id" theColumnValue:currentCatId orderBy:@"sort_order" orderType:@"desc" withAll:NO];
    
    self.productItems = (NSMutableArray *)[DBOperate queryData:T_PRODUCT thePicName:T_PRODUCT_PIC theColumn:@"cat_id" theColumnValue:currentCatId orderBy:@"sort_order" orderType:@"desc" withAll:NO];
    
    [self makeTableItems];
    //重新reload
    //[self.myTableView reloadData];
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
		//模拟数据 添加数据 网络请求回来更多的数据 在这里添加到self.productItems
        for (int i = 0; i < [data count]; i++) 
        {
            NSArray *productArray = [data objectAtIndex:i];
            [self.productItems addObject:productArray];
        }
        
        //之前的行数
        int oldTableItemsCount = [self.tableItems count];
        
        //转化数据
        [self makeTableItems];
        
        //转化后行数
        int newTableItemsCount = [self.tableItems count];
		
		NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:(newTableItemsCount - oldTableItemsCount)];
		for (int ind = oldTableItemsCount; ind < newTableItemsCount; ind++) 
		{
			NSIndexPath *newPath = [NSIndexPath indexPathForRow:ind inSection:0];
			[insertIndexPaths addObject:newPath];
		}
        
        //插入新增的行
		[self.myTableView insertRowsAtIndexPaths:insertIndexPaths 
								withRowAnimation:UITableViewRowAnimationFade];
        
        //更新原来最后一行
        NSMutableArray *reloadIndexPaths = [NSMutableArray arrayWithCapacity:1];
        NSIndexPath *oldLastPath = [NSIndexPath indexPathForRow:(oldTableItemsCount - 1) inSection:0];
        [reloadIndexPaths addObject:oldLastPath];
        [self.myTableView reloadRowsAtIndexPaths:reloadIndexPaths 
								withRowAnimation:UITableViewRowAnimationNone];
		
	}	
	
	[self moreBackNormal];
}


//网络获取数据
-(void)accessItemService
{
    NSString *reqUrl = @"product/list.do?param=%@";
    
    NSMutableArray *catItems = (NSMutableArray *)[DBOperate queryData:T_PRODUCT_CAT theColumn:@"id" theColumnValue:currentCatId withAll:NO];
    int catVer = 0;
    if ([catItems count] > 0)
    {
        NSMutableArray *catArray = [catItems objectAtIndex:0];
        catVer = [[catArray objectAtIndex:product_cat_version] intValue];
    }
	
	NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
								 [Common getSecureString],@"keyvalue",
								 [NSNumber numberWithInt: catVer],@"ver",
								 [NSNumber numberWithInt: SITE_ID],@"site_id",
                                 [NSNumber numberWithInt: [currentCatId intValue]],@"cate_id",
								 [NSNumber numberWithInt: 0],@"sort_order",
								 nil];
	
	NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								  self.currentCatId,@"cat_id",
								  nil];
	
	[[DataManager sharedManager] accessService:jsontestDic
									   command:OPERAT_PRODUCT_REFRESH 
								  accessAdress:reqUrl 
									  delegate:self
									 withParam:param];
}

//网络获取更多数据
-(void)accessMoreService
{
    NSString *reqUrl = @"product/list.do?param=%@";
    
    NSArray *productArray = [self.productItems objectAtIndex:[self.productItems count]-1];
    int sort_order = [[productArray objectAtIndex:product_sort_order] intValue];
    ;
	NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
								 [Common getSecureString],@"keyvalue",
								 [NSNumber numberWithInt: -1],@"ver",
								 [NSNumber numberWithInt: SITE_ID],@"site_id",
                                 [NSNumber numberWithInt: [currentCatId intValue]],@"cate_id",
								 [NSNumber numberWithInt: sort_order],@"sort_order",
								 nil];
	
	NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								  self.currentCatId,@"cat_id",
								  nil];
	
	[[DataManager sharedManager] accessService:jsontestDic
									   command:OPERAT_PRODUCT_MORE 
								  accessAdress:reqUrl 
									  delegate:self
									 withParam:param];

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
        //商品刷新
        case OPERAT_PRODUCT_REFRESH:
            [self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
            break;
            
        //商品更多
        case OPERAT_PRODUCT_MORE:
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
    
    // [self.tableItems count] >= 20
    if ([self.productItems count] >= 20)
    {
        return [self.tableItems count] + 1;
    }
    else
    {
        if ([self.tableItems count] == 0)
        {
            return 1;
        }
        else
        {
            return [self.tableItems count];
        }
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableItems != nil && [self.tableItems count] > 0)
    {
        if ([indexPath row] == [self.tableItems count])
        {
            //更多
            return 40.0f;
        }
        else 
        {
            NSMutableArray *productArray = [self.tableItems objectAtIndex:[indexPath row]];
            
            if ([[productArray objectAtIndex:big_product_is_big_pic] intValue] == 1)
            {
                //大图
                return BIG_SIZE_WIDTH + 4.0f;
            }
            else 
            {
                //小图
                return SMALL_SIZE_WIDTH + 4.0f;
            }
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
	
	int tableItemsCount =  [self.tableItems count];
    int cellType;
    if (self.tableItems != nil && tableItemsCount > 0)
    {
        if ([indexPath row] == tableItemsCount)
        {
            //更多
            CellIdentifier = @"moreCell";
            cellType = 1;
        }
        else 
        {
            NSMutableArray *productArray = [self.tableItems objectAtIndex:[indexPath row]];
            
            if ([[productArray objectAtIndex:big_product_is_big_pic] intValue] == 1)
            {
                //大图
                CellIdentifier = @"bigPicCell";
                cellType = 2;
            }
            else 
            {
                //小图
                CellIdentifier = @"smallPicCell";
                cellType = 3;
            }
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
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		self.myTableView.separatorColor = [UIColor clearColor];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		//cell.backgroundView = 
		//cell.selectedBackgroundView = 

        switch(cellType)
		{
            //没有记录
			case 0:
            {
                UILabel *noneLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 300, 30)];
				noneLabel.tag = 101;
				[noneLabel setFont:[UIFont systemFontOfSize:12.0f]];
				noneLabel.textColor = [UIColor colorWithRed:0.3 green: 0.3 blue: 0.3 alpha:1.0];
				noneLabel.text = @"该分类下暂无任何商品信息";			
				noneLabel.textAlignment = UITextAlignmentCenter;
				noneLabel.backgroundColor = [UIColor clearColor];
				[cell.contentView addSubview:noneLabel];
				[noneLabel release];
                
                break;
            }
            //更多
			case 1:
            {
                UILabel *tempMoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(105, 0, 120, 30)];
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
            //大图
			case 2:
            {
                UIImage *bigBackgroundImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"瀑布流商品大图外框" ofType:@"png"]];
                UIImageView *bigBackgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake( MARGIN_X , MARGIN_Y , BIG_SIZE_WIDTH , BIG_SIZE_HEIGHT)];
                bigBackgroundImageView.image = bigBackgroundImage;
                [bigBackgroundImage release];
                [cell.contentView addSubview:bigBackgroundImageView];
                [bigBackgroundImageView release];
                
                myImageView *bigImageView = [[myImageView alloc]initWithFrame:CGRectMake( PIC_MARGIN_X , PIC_MARGIN_Y , BIG_PIC_SIZE_WIDTH , BIG_PIC_SIZE_HEIGHT) withImageId:[NSString stringWithFormat:@"%d",0]];
                bigImageView.tag = 1000;
                bigImageView.mydelegate = self;
                //bigImageView.layer.borderWidth = 1.0f;
                //bigImageView.layer.borderColor = [[UIColor colorWithRed:0.0 green: 0.0 blue: 0.0 alpha:0.1] CGColor];
                [cell.contentView addSubview:bigImageView];
                [bigImageView release];
                
                //属性 添加在该层中 descView
                UIView *descView = [[UIView alloc]initWithFrame:CGRectMake( 0.0f , BIG_PIC_SIZE_HEIGHT-20.0f , bigImageView.frame.size.width , 20.0f)];
                descView.backgroundColor = [UIColor colorWithRed:0.0 green: 0.0 blue: 0.0 alpha:0.3];
                descView.tag = 1001;
                [bigImageView addSubview:descView];
                [descView release];
                
                //价格标签
                UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake( 5.0f , 0.0f , (descView.frame.size.width/2) , descView.frame.size.height )];
                priceLabel.backgroundColor = [UIColor clearColor];
                priceLabel.tag = 100;
                priceLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
                priceLabel.font = [UIFont systemFontOfSize:12.0f];
                priceLabel.textColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1];
                priceLabel.text = @"";
                [descView addSubview:priceLabel];
                [priceLabel release];
                
                //喜欢
                UIImage *likeImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品瀑布流喜欢icon" ofType:@"png"]];
                UIImageView *likeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(priceLabel.frame) + 30.0f , 6.0f , 10.0f , 10.0f)];
                likeImageView.image = likeImage;
                likeImageView.tag = 101;
                [likeImage release];
                [descView addSubview:likeImageView];
                [likeImageView release];
                
                UILabel *likeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(likeImageView.frame) + 5.0f , 0.0f , 40.0f , 20.0f)];
                likeLabel.backgroundColor = [UIColor clearColor];
                likeLabel.tag = 102;
                likeLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
                likeLabel.font = [UIFont systemFontOfSize:12.0f];
                likeLabel.textColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1];
                likeLabel.text = @"";
                [descView addSubview:likeLabel];
                [likeLabel release];
                
                //评论
                UIImage *commentImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品瀑布流评论icon" ofType:@"png"]];
                UIImageView *commentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(likeLabel.frame) + 10.0f , 6.0f , 10.0f , 10.0f)];
                commentImageView.image = commentImage;
                commentImageView.tag = 103;
                [commentImage release];
                [descView addSubview:commentImageView];
                [commentImageView release];
                
                UILabel *commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(commentImageView.frame) + 5.0f , 0.0f , 40.0f , 20.0f)];
                commentLabel.backgroundColor = [UIColor clearColor];
                commentLabel.tag = 104;
                commentLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
                commentLabel.font = [UIFont systemFontOfSize:12.0f];
                commentLabel.textColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1];
                commentLabel.text = @"";
                [descView addSubview:commentLabel];
                [commentLabel release];
                
                break;
            }
            
            //小图
			case 3:
            {
                //======左边图片=======
                UIImage *smallBackgroundImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"瀑布流商品小图外框" ofType:@"png"]];
                UIImageView *smallBackgroundImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake( MARGIN_X , MARGIN_Y , SMALL_SIZE_WIDTH , SMALL_SIZE_HEIGHT)];
                smallBackgroundImageView1.image = smallBackgroundImage;
                [cell.contentView addSubview:smallBackgroundImageView1];
                [smallBackgroundImageView1 release];
                
                
                myImageView *smallImageView1 = [[myImageView alloc]initWithFrame:CGRectMake( PIC_MARGIN_X , PIC_MARGIN_Y, SMALL_PIC_SIZE_WIDTH , SMALL_PIC_SIZE_HEIGHT)withImageId:[NSString stringWithFormat:@"%d",0]];
                smallImageView1.tag = 2000;
                smallImageView1.mydelegate = self;
                //smallImageView1.layer.borderWidth = 1.0f;
                //smallImageView1.layer.borderColor = [[UIColor colorWithRed:0.0 green: 0.0 blue: 0.0 alpha:0.1] CGColor];
                [cell.contentView addSubview:smallImageView1];
                [smallImageView1 release];
                
                //属性 添加在该层中 descView
                UIView *descView1 = [[UIView alloc]initWithFrame:CGRectMake( 0.0f , SMALL_PIC_SIZE_HEIGHT-20.0f , smallImageView1.frame.size.width , 20.0f )];
                descView1.backgroundColor = [UIColor colorWithRed:0.0 green: 0.0 blue: 0.0 alpha:0.3];
                descView1.tag = 2001;
                [smallImageView1 addSubview:descView1];
                [descView1 release];
                
                //价格标签
                UILabel *priceLabel1 = [[UILabel alloc]initWithFrame:CGRectMake( 5.0f , 0.0f , (descView1.frame.size.width/3) , descView1.frame.size.height )];
                priceLabel1.backgroundColor = [UIColor clearColor];
                priceLabel1.tag = 100;
                priceLabel1.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
                priceLabel1.font = [UIFont systemFontOfSize:12.0f];
                priceLabel1.textColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1];
                [descView1 addSubview:priceLabel1];
                [priceLabel1 release];
                
                //喜欢
                UIImage *likeImage1 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品瀑布流喜欢icon" ofType:@"png"]];
                UIImageView *likeImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(priceLabel1.frame) , 6.0f , 10.0f , 10.0f)];
                likeImageView1.image = likeImage1;
                likeImageView1.tag = 101;
                [likeImage1 release];
                [descView1 addSubview:likeImageView1];
                [likeImageView1 release];
                
                UILabel *likeLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(likeImageView1.frame) + 5.0f , 0.0f , 30.0f , 20.0f)];
                likeLabel1.backgroundColor = [UIColor clearColor];
                likeLabel1.tag = 102;
                likeLabel1.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
                likeLabel1.font = [UIFont systemFontOfSize:12.0f];
                likeLabel1.textColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1];
                [descView1 addSubview:likeLabel1];
                [likeLabel1 release];
                
                //评论
                UIImage *commentImage1 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品瀑布流评论icon" ofType:@"png"]];
                UIImageView *commentImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(likeLabel1.frame) , 6.0f , 10.0f , 10.0f)];
                commentImageView1.image = commentImage1;
                commentImageView1.tag = 103;
                [commentImage1 release];
                [descView1 addSubview:commentImageView1];
                [commentImageView1 release];
                
                UILabel *commentLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(commentImageView1.frame) + 5.0f , 0.0f , 30.0f , 20.0f)];
                commentLabel1.backgroundColor = [UIColor clearColor];
                commentLabel1.tag = 104;
                commentLabel1.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
                commentLabel1.font = [UIFont systemFontOfSize:12.0f];
                commentLabel1.textColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1];
                [descView1 addSubview:commentLabel1];
                [commentLabel1 release];
                
                //======右边图片=======
                UIImageView *smallBackgroundImageView2 = [[UIImageView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(smallBackgroundImageView1.frame) + MARGIN_X , MARGIN_Y , SMALL_SIZE_WIDTH , SMALL_SIZE_WIDTH)];
                smallBackgroundImageView2.image = smallBackgroundImage;
                [smallBackgroundImage release];
                smallBackgroundImageView2.tag = 3003;
                [cell.contentView addSubview:smallBackgroundImageView2];
                [smallBackgroundImageView2 release];
                
                myImageView *smallImageView2 = [[myImageView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(smallBackgroundImageView1.frame) + PIC_MARGIN_X , PIC_MARGIN_Y , SMALL_PIC_SIZE_WIDTH , SMALL_PIC_SIZE_HEIGHT)withImageId:[NSString stringWithFormat:@"%d",0]];
                smallImageView2.tag = 3000;
                smallImageView2.mydelegate = self;
                //smallImageView2.layer.borderWidth = 1.0f;
                //smallImageView2.layer.borderColor = [[UIColor colorWithRed:0.0 green: 0.0 blue: 0.0 alpha:0.1] CGColor];
                [cell.contentView addSubview:smallImageView2];
                [smallImageView2 release];
                
                //属性 添加在该层中 descView
                UIView *descView2 = [[UIView alloc]initWithFrame:CGRectMake( 0.0f , SMALL_PIC_SIZE_HEIGHT-20.0f , smallImageView2.frame.size.width , 20.0f )];
                descView2.backgroundColor = [UIColor colorWithRed:0.0 green: 0.0 blue: 0.0 alpha:0.3];
                descView2.tag = 3001;
                [smallImageView2 addSubview:descView2];
                [descView2 release];
                
                //价格标签
                UILabel *priceLabel2 = [[UILabel alloc]initWithFrame:CGRectMake( 5.0f , 0.0f , (descView2.frame.size.width/3) , descView2.frame.size.height )];
                priceLabel2.backgroundColor = [UIColor clearColor];
                priceLabel2.tag = 100;
                priceLabel2.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
                priceLabel2.font = [UIFont systemFontOfSize:12.0f];
                priceLabel2.textColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1];
                priceLabel2.text = @"";
                [descView2 addSubview:priceLabel2];
                [priceLabel2 release];
                
                //喜欢
                UIImage *likeImage2 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品瀑布流喜欢icon" ofType:@"png"]];
                UIImageView *likeImageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(priceLabel2.frame) , 6.0f , 10.0f , 10.0f)];
                likeImageView2.image = likeImage2;
                likeImageView2.tag = 101;
                [likeImage2 release];
                [descView2 addSubview:likeImageView2];
                [likeImageView2 release];
                
                UILabel *likeLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(likeImageView2.frame) + 5.0f , 0.0f , 30.0f , 20.0f)];
                likeLabel2.backgroundColor = [UIColor clearColor];
                likeLabel2.tag = 102;
                likeLabel2.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
                likeLabel2.font = [UIFont systemFontOfSize:12.0f];
                likeLabel2.textColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1];
                [descView2 addSubview:likeLabel2];
                [likeLabel2 release];
                
                //评论
                UIImage *commentImage2 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品瀑布流评论icon" ofType:@"png"]];
                UIImageView *commentImageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(likeLabel2.frame) , 6.0f , 10.0f , 10.0f)];
                commentImageView2.image = commentImage2;
                commentImageView2.tag = 103;
                [commentImage2 release];
                [descView2 addSubview:commentImageView2];
                [commentImageView2 release];
                
                UILabel *commentLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(commentImageView2.frame) + 5.0f , 0.0f , 30.0f , 20.0f)];
                commentLabel2.backgroundColor = [UIColor clearColor];
                commentLabel2.tag = 104;
                commentLabel2.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
                commentLabel2.font = [UIFont systemFontOfSize:12.0f];
                commentLabel2.textColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1];
                [descView2 addSubview:commentLabel2];
                [commentLabel2 release];
                
                break;   
            }
				
			default:   ;
		}
        
        cell.backgroundColor = [UIColor clearColor];
	}
	
	if (cellType == 2)
    {
        //数据
        NSMutableArray *productArray = [self.tableItems objectAtIndex:[indexPath row]];
        
        //===============================大图===============================
		//图片 
		myImageView *bigImageView = (myImageView *)[cell.contentView viewWithTag:1000];
        
        //属性层
        UIView *descView = (UIView *)[bigImageView viewWithTag:1001];
        
        //把原始数据的行号设置为imgID
        bigImageView.imageId = [productArray objectAtIndex:big_product_row];
        
        NSString *photoUrl = [[productArray objectAtIndex:big_product_info] objectAtIndex:product_pic];
        
        //在此 取缓存图片 网络load图片
        //获取本地图片缓存
        NSString *picName = [Common encodeBase64:(NSMutableData *)[photoUrl dataUsingEncoding: NSUTF8StringEncoding]];
        
        if (photoUrl.length > 1) 
        {
            UIImage *photo = [FileManager getPhoto:picName];
            if (photo.size.width > 2)
            {
                bigImageView.image = [photo fillSize:CGSizeMake(BIG_PIC_SIZE_WIDTH,BIG_PIC_SIZE_HEIGHT)];
            }
            else
            {
                UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"瀑布流商品大图默认" ofType:@"png"]];
                bigImageView.image = [img fillSize:CGSizeMake(BIG_PIC_SIZE_WIDTH, BIG_PIC_SIZE_HEIGHT)];
                [img release];
                if (tableView.dragging == NO && tableView.decelerating == NO)
                {
                    //[bigImageView startSpinner];
                    [self startIconDownload:photoUrl forIndexPath:indexPath];
                }
            }
        }
        else
        {
            UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"瀑布流商品大图默认" ofType:@"png"]];
            bigImageView.image = [img fillSize:CGSizeMake(BIG_PIC_SIZE_HEIGHT, BIG_PIC_SIZE_HEIGHT)];
            [img release];
        }
        
        //在此设置属性内容
        UILabel *priceLabel = (UILabel *)[descView viewWithTag:100];
        UILabel *likeLabel = (UILabel *)[descView viewWithTag:102];
        UILabel *commentLabel = (UILabel *)[descView viewWithTag:104];
        
        //价格
        priceLabel.text = ([[[productArray objectAtIndex:big_product_info] objectAtIndex:product_promotion_price] intValue] != 0 && [[[productArray objectAtIndex:big_product_info] objectAtIndex:product_promotion_price] length] > 0) ? [NSString stringWithFormat:@"￥%@",[[productArray objectAtIndex:big_product_info] objectAtIndex:product_promotion_price]] : [NSString stringWithFormat:@"￥%@",[[productArray objectAtIndex:big_product_info] objectAtIndex:product_price]];
        
        //喜欢数
        likeLabel.text = [[productArray objectAtIndex:big_product_info] objectAtIndex:product_likes];
        
        //评论数
        commentLabel.text = [[productArray objectAtIndex:big_product_info] objectAtIndex:product_comment_num];
        
        
	}
    else if(cellType == 3)
    {
        //数据
        NSMutableArray *productArray = [self.tableItems objectAtIndex:[indexPath row]];
        
        //===============================左边===============================
        
        //图片 
		myImageView *smallImageView1 = (myImageView *)[cell.contentView viewWithTag:2000];
        
        //属性层
        UIView *descView1 = (UIView *)[smallImageView1 viewWithTag:2001];
        
        //把原始数据的行号设置为imgID
        smallImageView1.imageId = [productArray objectAtIndex:small_product_row1];
        
        NSString *photoUrl1 = [[productArray objectAtIndex:small_product_info1] objectAtIndex:product_pic];
        
        //在此 取缓存图片 网络load图片
        NSString *picName = [Common encodeBase64:(NSMutableData *)[photoUrl1 dataUsingEncoding: NSUTF8StringEncoding]];
        
        if (photoUrl1.length > 1) 
        {
            UIImage *photo = [FileManager getPhoto:picName];
            if (photo.size.width > 2)
            {
                smallImageView1.image = [photo fillSize:CGSizeMake(SMALL_PIC_SIZE_WIDTH,SMALL_PIC_SIZE_HEIGHT)];
            }
            else
            {
                UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"瀑布流商品小图默认" ofType:@"png"]];
                smallImageView1.image = [img fillSize:CGSizeMake(SMALL_PIC_SIZE_WIDTH, SMALL_PIC_SIZE_HEIGHT)];
                [img release];
                if (tableView.dragging == NO && tableView.decelerating == NO)
                {
                    //[bigImageView startSpinner];
                    [self startIconDownload:photoUrl1 forIndexPath:[NSIndexPath indexPathForRow:[indexPath row] inSection:1]];
                }
            }
        }
        else
        {
            UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"瀑布流商品小图默认" ofType:@"png"]];
            smallImageView1.image = [img fillSize:CGSizeMake(SMALL_PIC_SIZE_WIDTH, SMALL_PIC_SIZE_HEIGHT)];
            [img release];
        }

        
        //在此设置属性内容
        UILabel *priceLabel1 = (UILabel *)[descView1 viewWithTag:100];
        UILabel *likeLabel1 = (UILabel *)[descView1 viewWithTag:102];
        UILabel *commentLabel1 = (UILabel *)[descView1 viewWithTag:104];
        
        //价格
        priceLabel1.text = ([[[productArray objectAtIndex:small_product_info1] objectAtIndex:product_promotion_price] intValue] != 0 && [[[productArray objectAtIndex:small_product_info1] objectAtIndex:product_promotion_price] length] > 0) ? [NSString stringWithFormat:@"￥%@",[[productArray objectAtIndex:small_product_info1] objectAtIndex:product_promotion_price]] : [NSString stringWithFormat:@"￥%@",[[productArray objectAtIndex:small_product_info1] objectAtIndex:product_price]];
        
        //喜欢数
        likeLabel1.text = [[productArray objectAtIndex:small_product_info1] objectAtIndex:product_likes];
        
        //评论数
        commentLabel1.text = [[productArray objectAtIndex:small_product_info1] objectAtIndex:product_comment_num];
        
        //===============================右边===============================
        //图片 
        UIImageView *smallBackgroundImageView2 = (myImageView *)[cell.contentView viewWithTag:3003];
		myImageView *smallImageView2 = (myImageView *)[cell.contentView viewWithTag:3000];
        
        //如果右边不为空
        if ([productArray objectAtIndex:small_product_row2] == [NSNull null] || [productArray objectAtIndex:small_product_info2]  == [NSNull null])
        {
            smallImageView2.hidden = YES;
            smallBackgroundImageView2.hidden = YES;
        }
        else
        {
            //属性层
            UIView *descView2 = (UIView *)[smallImageView2 viewWithTag:3001];
            
            //把原始数据的行号设置为imgID
            smallImageView2.imageId = [productArray objectAtIndex:small_product_row2];
            
            NSString *photoUrl2 = [[productArray objectAtIndex:small_product_info2] objectAtIndex:product_pic];
            
            //在此 取缓存图片 网络load图片
            NSString *picName = [Common encodeBase64:(NSMutableData *)[photoUrl2 dataUsingEncoding: NSUTF8StringEncoding]];
            
            if (photoUrl2.length > 1) 
            {
                UIImage *photo = [FileManager getPhoto:picName];
                if (photo.size.width > 2)
                {
                    smallImageView2.image = [photo fillSize:CGSizeMake(SMALL_PIC_SIZE_WIDTH,SMALL_PIC_SIZE_HEIGHT)];
                }
                else
                {
                    UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"瀑布流商品小图默认" ofType:@"png"]];
                    smallImageView2.image = [img fillSize:CGSizeMake(SMALL_PIC_SIZE_WIDTH, SMALL_PIC_SIZE_HEIGHT)];
                    [img release];
                    if (tableView.dragging == NO && tableView.decelerating == NO)
                    {
                        //[bigImageView startSpinner];
                        [self startIconDownload:photoUrl2 forIndexPath:[NSIndexPath indexPathForRow:[indexPath row] inSection:2]];
                    }
                }
            }
            else
            {
                UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"瀑布流商品小图默认" ofType:@"png"]];
                smallImageView2.image = [img fillSize:CGSizeMake(SMALL_PIC_SIZE_WIDTH, SMALL_PIC_SIZE_HEIGHT)];
                [img release];
            }
            
            //在此设置属性内容
            UILabel *priceLabel2 = (UILabel *)[descView2 viewWithTag:100];
            UILabel *likeLabel2 = (UILabel *)[descView2 viewWithTag:102];
            UILabel *commentLabel2 = (UILabel *)[descView2 viewWithTag:104];
            
            //价格
            priceLabel2.text = ([[[productArray objectAtIndex:small_product_info2] objectAtIndex:product_promotion_price] intValue] != 0 && [[[productArray objectAtIndex:small_product_info2] objectAtIndex:product_promotion_price] length] > 0) ? [NSString stringWithFormat:@"￥%@",[[productArray objectAtIndex:small_product_info2] objectAtIndex:product_promotion_price]] : [NSString stringWithFormat:@"￥%@",[[productArray objectAtIndex:small_product_info2] objectAtIndex:product_price]];
            
            //喜欢数
            likeLabel2.text = [[productArray objectAtIndex:small_product_info2] objectAtIndex:product_likes];
            
            //评论数
            commentLabel2.text = [[productArray objectAtIndex:small_product_info2] objectAtIndex:product_comment_num];
            
            smallImageView2.hidden = NO;
            smallBackgroundImageView2.hidden = NO;
        }
        
    }
	
    return cell; 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
    //do nothing...
    
}

#pragma mark -
#pragma mark 图片滚动委托
- (void)imageViewTouchesEnd:(NSString *)imageId
{
    shoppingAppDelegate *shoppingDelegate = (shoppingAppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSArray *productArray = [self.productItems objectAtIndex:[imageId intValue]];
    ProductDetailViewController *ProductDetailView = [[ProductDetailViewController alloc] init];
    ProductDetailView.productID = [[productArray objectAtIndex:product_id] intValue];
    ProductDetailView.productList = self.productItems;
    ProductDetailView.selectIndex = [imageId intValue];
    ProductDetailView.currentCatId = self.currentCatId;
    [shoppingDelegate.navController pushViewController:ProductDetailView animated:YES];
    [ProductDetailView release];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
    
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
    if (_isAllowLoadingMore && !_loadingMore && [self.tableItems count] > 0)
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
            
            //模拟数据
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
    //self.tableItems >= 20
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (bottomEdge >= scrollView.contentSize.height && bottomEdge > self.myTableView.frame.size.height && [self.productItems count] >= 20)
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
    self.tableItems = nil;
	self.spinner = nil;
    self.moreLabel = nil;
    _refreshHeaderView.delegate = nil;
	_refreshHeaderView = nil;
    for (IconDownLoader *one in [imageDownloadsInProgress allValues]){
		one.delegate = nil;
	}
	self.imageDownloadsInProgress = nil;
	self.imageDownloadsInWaiting = nil;
    self.currentCatId = nil;
}


- (void)dealloc {
	self.myTableView.delegate = nil;
	self.myTableView = nil;
    self.productItems = nil;
    self.tableItems = nil;
	self.spinner = nil;
    self.moreLabel = nil;
    _refreshHeaderView.delegate = nil;
	_refreshHeaderView = nil;
    for (IconDownLoader *one in [imageDownloadsInProgress allValues]){
		one.delegate = nil;
	}
	self.imageDownloadsInProgress = nil;
	self.imageDownloadsInWaiting = nil;
    self.currentCatId = nil;
    [super dealloc];
}

@end
