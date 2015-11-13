//
//  MyOrdersViewController.m
//  shopping
//
//  Created by 来 云 on 13-1-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MyOrdersViewController.h"
#import "Common.h"
#import "DataManager.h"
#import "DBOperate.h"
#import "UIImageScale.h"
#import "FileManager.h"
#import "downloadParam.h"
#import "imageDownLoadInWaitingObject.h"
#import "MyOrdersCell.h"
#import "MyOrderDetailViewController.h"

@interface MyOrdersViewController ()

@end

@implementation MyOrdersViewController
@synthesize myTableView = _myTableView;
@synthesize listArray = __listArray;
@synthesize commandOper;
@synthesize imageDownloadsInProgressDic;
@synthesize imageDownloadsInWaitingArray;
@synthesize spinner;
@synthesize userId;
@synthesize type;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        __listArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"我的订单";
    
    UIImage *backgroundImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"表的背景" ofType:@"png"]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    
    NSMutableDictionary *idip = [[NSMutableDictionary alloc]init];
	self.imageDownloadsInProgressDic = idip;
	[idip release];
	
	NSMutableArray *wait = [[NSMutableArray alloc]init];
	self.imageDownloadsInWaitingArray = wait;
	[wait release];
    
    picWidth = 70.0f;
    picHeight = 70.0f;
    
    NSArray *imageArr = [[NSArray alloc] initWithObjects:@"切换标签1.png",@"切换标签2.png",nil];
    segmentView = [[CustomSegment alloc] initWithSelectedImgArray:imageArr point:CGPointMake(0, 0)titleArray:[NSArray arrayWithObjects:@"近三个月订单",@"三个月前订单", nil]];
    segmentView.delegate = self;
    [self.view addSubview:segmentView];
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(segmentView.frame), 320, self.view.frame.size.height - CGRectGetMaxY(segmentView.frame) - 44) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTableView];
    self.myTableView.backgroundColor = [UIColor clearColor];
    
    _loadingMore = NO;
    _isAllowLoadingMore = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [segmentView setSelectedIndex:0];
}
- (void)dealloc
{
    [_myTableView release];
    [__listArray release];
    [progressHUD release];
    self.commandOper.delegate = nil;
	self.commandOper = nil;
    [spinner release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.commandOper.delegate = nil;
	self.commandOper = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0) {
		return [self.listArray count];
	}else {
		return 0;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section ==0) {
		return 86.0f;
	}else {
		return 0;
	}	
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if (section == 1) {
		UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
		UILabel *moreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 320, 30)];
		moreLabel.text = @"上拉加载更多";
		moreLabel.tag = 200;
        moreLabel.font = [UIFont systemFontOfSize:14.0f];
		moreLabel.textColor = [UIColor colorWithRed:0.3 green: 0.3 blue: 0.3 alpha:1.0];
		moreLabel.textAlignment = UITextAlignmentCenter;
		moreLabel.backgroundColor = [UIColor clearColor];
		[vv addSubview:moreLabel];
		[moreLabel release];
		
		//添加loading图标
		indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
		[indicatorView setCenter:CGPointMake(320 / 3, 40 / 2.0)];
		indicatorView.hidesWhenStopped = YES;
		[vv addSubview:indicatorView];
		
		return vv;
	}else {
		return nil;		
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if (section == 1 && self.listArray.count >= 20) {
		return 40;
	}else {
		return 0;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	
	//NSInteger row = [indexPath row];
	
	MyOrdersCell *cell = (MyOrdersCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
        cell = [[[MyOrdersCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.cOrderTime.text = @"2013-1-14 16:05:33";
        cell.cOrderNumber.text = @"1234567890";
        cell.cOrderPrice.text = @"¥ 90.00";
        cell.cOrderSum.text = @"共4件商品";
    }
    if ([self.listArray count] > 0) {
        NSArray *cellArr = [self.listArray objectAtIndex:indexPath.row];
        
        int createTime = [[cellArr objectAtIndex:myorders_list_createtime] intValue];
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:createTime];
        NSDateFormatter *outputFormat = [[NSDateFormatter alloc] init];
        [outputFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString = [outputFormat stringFromDate:date];
        [outputFormat release];
        
        cell.cOrderTime.text = dateString;
        
        cell.cOrderNumber.text = [cellArr objectAtIndex:myorders_list_billno];
        cell.cOrderPrice.text = [NSString stringWithFormat:@"¥ %.2f",[[cellArr objectAtIndex:myorders_list_price] doubleValue]];
        cell.cOrderSum.text = [NSString stringWithFormat:@"共 %d 件商品",[[cellArr objectAtIndex:myorders_list_product_sum] intValue]];
        
        NSDate* nowDate = [NSDate date];
        NSDateFormatter *outputFormat1 = [[NSDateFormatter alloc] init];
        [outputFormat1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString1 = [outputFormat1 stringFromDate:nowDate];
        NSDate *currentDate1 = [outputFormat1 dateFromString:dateString1];
        [outputFormat1 release];
        NSTimeInterval t1 = [currentDate1 timeIntervalSince1970];   //转化为时间戳
        long long int time1 = (long long int)t1;
        NSNumber *num = [NSNumber numberWithLongLong:time1];
        int currentInt = [num intValue];
        //NSLog(@"===%d",currentInt);
        int intValue = [[cellArr objectAtIndex:myorders_list_closetime] intValue] * 24 * 60 * 60;
        //NSLog(@"intValue===%d",[[cellArr objectAtIndex:myorders_list_createtime] intValue] + intValue);
        int status = [[cellArr objectAtIndex:myorders_list_payresult] intValue];
        if (status == 0) {
            if ([[cellArr objectAtIndex:myorders_list_createtime] intValue] + intValue < currentInt) {
                cell.cTypeCancelImageView.hidden = NO;
                cell.cTypePayImageView.hidden = YES;
                cell.cTypeWaitSendImageView.hidden = YES;
                cell.cTypeSuccessImageView.hidden = YES;
                cell.cTypeWaitReceiveImageView.hidden = YES;
            }else {
                cell.cTypePayImageView.hidden = NO;
                cell.cTypeCancelImageView.hidden = YES;
                cell.cTypeWaitSendImageView.hidden = YES;
                cell.cTypeSuccessImageView.hidden = YES;
                cell.cTypeWaitReceiveImageView.hidden = YES;
            }
        }else if (status == 1) {
            cell.cTypeWaitSendImageView.hidden = NO;
            cell.cTypePayImageView.hidden = YES;
            cell.cTypeCancelImageView.hidden = YES;
            cell.cTypeSuccessImageView.hidden = YES;
            cell.cTypeWaitReceiveImageView.hidden = YES;
        }else if (status == 3) {
            cell.cTypeSuccessImageView.hidden = NO;
            cell.cTypePayImageView.hidden = YES;
            cell.cTypeCancelImageView.hidden = YES;
            cell.cTypeWaitSendImageView.hidden = YES;
            cell.cTypeWaitReceiveImageView.hidden = YES;
        }else if (status == 4) {
            cell.cTypeCancelImageView.hidden = NO;
            cell.cTypePayImageView.hidden = YES;
            cell.cTypeWaitSendImageView.hidden = YES;
            cell.cTypeSuccessImageView.hidden = YES;
            cell.cTypeWaitReceiveImageView.hidden = YES;
        }else {
            cell.cTypeWaitReceiveImageView.hidden = NO;
            cell.cTypeCancelImageView.hidden = YES;
            cell.cTypePayImageView.hidden = YES;
            cell.cTypeWaitSendImageView.hidden = YES;
            cell.cTypeSuccessImageView.hidden = YES;
        }
        
        //图片
        NSString *picUrl = [cellArr objectAtIndex:myorders_list_pic];
        NSString *picName = [Common encodeBase64:(NSMutableData *)[picUrl dataUsingEncoding: NSUTF8StringEncoding]];
        
        if (picUrl.length > 1) 
        {
            UIImage *pic = [[FileManager getPhoto:picName] fillSize:CGSizeMake(picWidth, picHeight)];
            if (pic.size.width > 2)
            {
                cell.cImageView.image = pic;
            }
            else
            {
                UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品列表默认图片" ofType:@"png"]];
                cell.cImageView.image = [defaultPic fillSize:CGSizeMake(picWidth, picHeight)];
                
				if (tableView.dragging == NO && tableView.decelerating == NO)
				{
                    [self startIconDownload:picUrl forIndex:indexPath];
				}
            }
        }
        else
        {
            UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品列表默认图片" ofType:@"png"]];
            cell.cImageView.image = [defaultPic fillSize:CGSizeMake(picWidth, picHeight)];
        }
    }
    
	return cell;	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int orderId = [[[self.listArray objectAtIndex:indexPath.row] objectAtIndex:myorders_list_id] intValue];
    MyOrderDetailViewController *orderDetail = [[MyOrderDetailViewController alloc] init];
    orderDetail.orderIdStr = [NSString stringWithFormat:@"%d",orderId];
    orderDetail.userId = self.userId;
    orderDetail.listArray = [self.listArray objectAtIndex:indexPath.row];
    orderDetail.productsArray = (NSMutableArray *)[DBOperate queryData:T_ORDER_PRODUCTS_LIST theColumn:@"memberId" equalValue:self.userId theColumn:@"order_id" equalValue:[NSString stringWithFormat:@"%d",orderId]];
    [self.navigationController pushViewController:orderDetail animated:YES];
    [orderDetail release];

}

#pragma mark ------ CustomSegmentDelegate method
- (void)segmentWithIndex:(int)index
{
    UILabel *label = (UILabel *)[self.view viewWithTag:111];
    if (label != nil) {
        if (label) {
            [label removeFromSuperview];
        }
    }
    
    if (self.spinner != nil) {
        if (self.spinner) {
            [self.spinner removeFromSuperview];
        }
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
    [self.view addSubview:self.spinner];
    [self.spinner startAnimating];
    [tempSpinner release];
    
    if (index == 0) {
        [self accessService1];
    }else {
        [self accessService2];
    }
}

#pragma mark ---- loadImage Method
- (void)startIconDownload:(NSString*)imageURL forIndex:(NSIndexPath*)index
{
	IconDownLoader *iconDownloader = [imageDownloadsInProgressDic objectForKey:index];
    if (iconDownloader == nil && imageURL != nil && imageURL.length > 1) 
    {
		if (imageURL != nil && imageURL.length > 1) 
		{
			if ([imageDownloadsInProgressDic count] >= DOWNLOAD_IMAGE_MAX_COUNT) {
				imageDownLoadInWaitingObject *one = [[imageDownLoadInWaitingObject alloc]init:imageURL withIndexPath:index withImageType:CUSTOMER_PHOTO];
				[imageDownloadsInWaitingArray addObject:one];
				[one release];
				return;
			}
			
			IconDownLoader *iconDownloader = [[IconDownLoader alloc] init];
			iconDownloader.downloadURL = imageURL;
			iconDownloader.indexPathInTableView = index;
			iconDownloader.imageType = CUSTOMER_PHOTO;
			iconDownloader.delegate = self;
			[imageDownloadsInProgressDic setObject:iconDownloader forKey:index];
			[iconDownloader startDownload];
			[iconDownloader release];   
		}
	}    
}
- (void)appImageDidLoad:(NSIndexPath *)indexPath withImageType:(int)Type
{
    IconDownLoader *iconDownloader = [imageDownloadsInProgressDic objectForKey:indexPath];
	MyOrdersCell *cell = (MyOrdersCell *)[self.myTableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
	
    if (iconDownloader != nil)
    {
		if(iconDownloader.cardIcon.size.width > 2.0){ 			
			UIImage *photo = iconDownloader.cardIcon;
			
            NSString *imageurl = [[self.listArray objectAtIndex:iconDownloader.indexPathInTableView.row] objectAtIndex:myorders_list_pic];
            NSString *photoname = [Common encodeBase64:(NSMutableData *)[imageurl dataUsingEncoding: NSUTF8StringEncoding]];
                
            if ([FileManager savePhoto:photoname withImage:photo]) {
                cell.cImageView.image = photo;
            }
		}
		[imageDownloadsInProgressDic removeObjectForKey:indexPath];
		if ([imageDownloadsInWaitingArray count] > 0) {
			imageDownLoadInWaitingObject *one = [imageDownloadsInWaitingArray objectAtIndex:0];
			[self startIconDownload:one.imageURL forIndex:one.indexPath];
			[imageDownloadsInWaitingArray removeObjectAtIndex:0];
		}		
    }
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_isAllowLoadingMore && !_loadingMore && [self.listArray count] > 0)
    {
        UILabel *label = (UILabel*)[self.myTableView viewWithTag:200];
        
        float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (bottomEdge > scrollView.contentSize.height + 10.0f) 
        {
            //松开 载入更多
            label.text=@"松开加载更多";
        }
        else
        {
            label.text=@"上拉加载更多";
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
    if (!decelerate)
	{
		//[self loadImagesForOnscreenRows];
    }
    
    if (_isAllowLoadingMore && !_loadingMore)
    {
        UILabel *label = (UILabel*)[self.myTableView viewWithTag:200];
        
        float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (bottomEdge > scrollView.contentSize.height + 10.0f) 
        {
            //松开 载入更多
            _loadingMore = YES;
            
            label.text=@" 加载中 ...";
            [indicatorView startAnimating];
            
            //数据
            [self accessMoreService];
        }
        else
        {
            label.text=@"上拉加载更多";
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (bottomEdge >= scrollView.contentSize.height && bottomEdge > self.myTableView.frame.size.height && [self.listArray count] >= 20) 
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
    //[self loadImagesForOnscreenRows];
}

#pragma mark -------private methods
- (void)accessMoreService
{
    int updatetime = [[[self.listArray objectAtIndex:[self.listArray count] - 1] objectAtIndex:myorders_list_createtime] intValue];
//    int status = [[[self.listArray objectAtIndex:[self.listArray count] - 1] objectAtIndex:myorders_list_payresult] intValue];
    
    NSMutableDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:-1],@"ver",
                                        [Common getSecureString],@"keyvalue",
                                        [NSNumber numberWithInt: SITE_ID],@"site_id",
                                        [NSNumber numberWithInt:[self.userId intValue]],@"user_id",
                                        [NSNumber numberWithInt:updatetime],@"createtime",
                                        [NSNumber numberWithInt:[self.type intValue]],@"condition",nil];

    [[DataManager sharedManager] accessService:jsontestDic command:MEMBER_ORDERSMORELIST_COMMAND_ID accessAdress:@"order/list.do?param=%@" delegate:self withParam:jsontestDic];
}

- (void)accessService1
{
    self.type = @"0";
    
    NSMutableDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [Common getMemberVersion:[self.userId intValue] commandID:MEMBER_ORDERSLIST_COMMAND_ID],@"ver",
                                        [Common getSecureString],@"keyvalue",
                                        [NSNumber numberWithInt: SITE_ID],@"site_id",
                                        [NSNumber numberWithInt:[self.userId intValue]],@"user_id",
                                        [NSNumber numberWithInt:0],@"condition",nil];
    
    [[DataManager sharedManager] accessService:jsontestDic command:MEMBER_ORDERSLIST_COMMAND_ID accessAdress:@"order/list.do?param=%@" delegate:self withParam:jsontestDic];
}

- (void)accessService2
{
    self.type = @"1";
    
    NSArray *ay = [DBOperate queryData:T_MYORDERS_LIST theColumn:@"memberId" theColumnValue:self.userId theColumn:@"type" theColumnValue:self.type orderByOne:@"createtime" orderTypeOne:@"DESC" orderByTwo:nil orderTypeTwo:nil withAll:NO];
    //NSLog(@"==%@",ay);
    
    NSMutableDictionary *jsontestDic = nil;
    if ([ay count] == 0) {
        jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                       [Common getSecureString],@"keyvalue",
                       [NSNumber numberWithInt: SITE_ID],@"site_id",
                       [NSNumber numberWithInt:[self.userId intValue]],@"user_id",
                       [NSNumber numberWithInt:1],@"condition",nil];
    }else {
        jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                       [Common getSecureString],@"keyvalue",
                       [NSNumber numberWithInt: SITE_ID],@"site_id",
                       [NSNumber numberWithInt:[self.userId intValue]],@"user_id",
                       [NSNumber numberWithInt:1],@"condition",
                       [NSNumber numberWithInt:[[[ay objectAtIndex:0] objectAtIndex:myorders_list_createtime] intValue]],@"lasttime",nil];
    }
    
    [[DataManager sharedManager] accessService:jsontestDic command:MEMBER_ORDERSLIST_COMMAND_ID accessAdress:@"order/list.do?param=%@" delegate:self withParam:jsontestDic];
}

- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
	NSLog(@"information finish");
	//NSLog(@"=====%@",resultArray);
    switch (commandid) {
        case MEMBER_ORDERSLIST_COMMAND_ID:
        {
            [self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
        }
            break;
        case MEMBER_ORDERSMORELIST_COMMAND_ID:
        {
            [self performSelectorOnMainThread:@selector(getMoreResult:) withObject:resultArray waitUntilDone:NO];
        }
            break;
        default:
            break;
    }
}

- (void)update
{
    //NSLog(@"self.type====%@",self.type);
    //移出loading
    [self.spinner removeFromSuperview];
    
    [self.listArray removeAllObjects];
    self.listArray = (NSMutableArray *)[DBOperate queryData:T_MYORDERS_LIST theColumn:@"memberId" theColumnValue:self.userId theColumn:@"type" theColumnValue:self.type orderByOne:@"createtime" orderTypeOne:@"DESC" withAll:NO];
    //NSLog(@"self.listArray========%@",self.listArray);
    
    if ([self.listArray count] == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 320, 40)];
        label.text = @"暂无订单信息，赶紧去逛逛吧";
        label.tag = 111;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.textAlignment = UITextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16.0f];
        [self.view addSubview:label];
        [label release];
    }
    
    [self.myTableView reloadData];
}

- (void)getMoreResult:(NSMutableArray *)resultArray
{
	UILabel *label = (UILabel*)[self.myTableView viewWithTag:200];
	label.text = @"上拉加载更多";	
	[indicatorView stopAnimating];
    
    _loadingMore = NO;
	
	for (int i = 0; i < [resultArray count];i++ ) 
	{
		NSMutableArray *item = [resultArray objectAtIndex:i];
		[self.listArray addObject:item];
	}
	//NSLog(@"self.listArray========%@",self.listArray);
	//NSLog(@"[self.listArray count]=====%d",[self.listArray count]);
	//[self.myTableView reloadData];
    NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:[resultArray count]];
    for (int ind = 0; ind < [resultArray count]; ind ++) 
    {
        NSIndexPath *newPath = [NSIndexPath indexPathForRow:
                                [self.listArray indexOfObject:[resultArray objectAtIndex:ind]] inSection:0];
        [insertIndexPaths addObject:newPath];
    }
    [self.myTableView insertRowsAtIndexPaths:insertIndexPaths 
                            withRowAnimation:UITableViewRowAnimationFade];
}
@end
