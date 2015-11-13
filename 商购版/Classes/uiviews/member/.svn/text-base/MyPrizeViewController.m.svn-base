//
//  MyPrizeViewController.m
//  shopping
//
//  Created by 来 云 on 13-1-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MyPrizeViewController.h"
#import "Common.h"
#import "DataManager.h"
#import "DBOperate.h"
#import "UIImageScale.h"
#import "FileManager.h"
#import "downloadParam.h"
#import "imageDownLoadInWaitingObject.h"
#import "MyAddressViewController.h"
#import "lotteryDetailViewController.h"
@interface MyPrizeViewController ()

@end

@implementation MyPrizeViewController
@synthesize myTableView = _myTableView;
@synthesize listArray = __listArray;
@synthesize commandOper;
@synthesize imageDownloadsInProgressDic;
@synthesize imageDownloadsInWaitingArray;
@synthesize spinner;
@synthesize userId;

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
	self.title = @"我的奖品";
    
    NSMutableDictionary *idip = [[NSMutableDictionary alloc]init];
	self.imageDownloadsInProgressDic = idip;
	[idip release];
	
	NSMutableArray *wait = [[NSMutableArray alloc]init];
	self.imageDownloadsInWaitingArray = wait;
	[wait release];
    
    picWidth = 70.0f;
    picHeight = 70.0f;
    
    [self accessService];
    
    _loadingMore = NO;
    _isAllowLoadingMore = NO;
}

- (void)dealloc
{
    [_myTableView release];
    [__listArray release];
    [progressHUD release];
    self.commandOper.delegate = nil;
	self.commandOper = nil;
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
	
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImage *bgImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品列表背景" ofType:@"png"]];
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0 , bgImage.size.width, bgImage.size.height)];
        bgImageView.userInteractionEnabled = YES;
        [cell.contentView addSubview:bgImageView];
        bgImageView.image = bgImage;
        [bgImage release];
        
		UIImageView *cImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 , (86 - 70) * 0.5 , 70, 70)];
        cImageView.tag = 10;
        cImageView.backgroundColor = [UIColor redColor];
		[bgImageView addSubview:cImageView];
		
        UILabel *cName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cImageView.frame) + 10, 15, 140, 20)];
		cName.text = @"[芒果缤纷]";
        cName.textColor = [UIColor darkTextColor];
        cName.tag = 11;
		cName.font = [UIFont systemFontOfSize:16.0f];
		cName.textAlignment = UITextAlignmentLeft;
		cName.backgroundColor = [UIColor clearColor];
		[bgImageView addSubview:cName];
        [cName release];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cImageView.frame) + 10, CGRectGetMaxY(cName.frame), 40, 20)];
		label1.text = @"价值 ¥";
        label1.textColor = [UIColor darkTextColor];
		label1.font = [UIFont systemFontOfSize:14.0f];
		label1.textAlignment = UITextAlignmentLeft;
		label1.backgroundColor = [UIColor clearColor];
		[bgImageView addSubview:label1];
        [label1 release];
        
        UILabel *money = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame), CGRectGetMaxY(cName.frame), 150, 20)];
		money.text = @"90.00";
        money.textColor = [UIColor darkTextColor];
        money.tag = 12;
		money.font = [UIFont systemFontOfSize:14.0f];
		money.textAlignment = UITextAlignmentLeft;
		money.backgroundColor = [UIColor clearColor];
		[bgImageView addSubview:money];
        [money release];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cImageView.frame) + 10, CGRectGetMaxY(label1.frame), 55, 20)];
		label2.text = @"有效期:";
        label2.textColor = [UIColor darkTextColor];
		label2.font = [UIFont systemFontOfSize:14.0f];
		label2.textAlignment = UITextAlignmentLeft;
		label2.backgroundColor = [UIColor clearColor];
		[bgImageView addSubview:label2];
        [label2 release];
        
        UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label2.frame), CGRectGetMaxY(label1.frame), 180, 20)];
		time.text = @"2013/1/7 - 2013/1/31";
        time.textColor = [UIColor darkTextColor];
        time.tag = 13;
		time.font = [UIFont systemFontOfSize:14.0f];
		time.textAlignment = UITextAlignmentLeft;
		time.backgroundColor = [UIColor clearColor];
		[bgImageView addSubview:time];
        [time release];
        
        UIImage *rimg = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"右箭头" ofType:@"png"]];
        UIImageView *rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(297, (86 - rimg.size.height) * 0.5, 16, 11)];
        rightImage.image = rimg;
        [rimg release];
        [bgImageView addSubview:rightImage];
        [rightImage release];
        
        [bgImageView release];
    }
    if ([self.listArray count] > 0 && indexPath.row < [self.listArray count]) {
        NSArray *cellArr = [self.listArray objectAtIndex:indexPath.row];
        
        UILabel *label1 = (UILabel *)[cell.contentView viewWithTag:11];
        label1.text = [cellArr objectAtIndex:my_prizes_name];
        UILabel *label2 = (UILabel *)[cell.contentView viewWithTag:12];
        label2.text = [NSString stringWithFormat:@"%d.00",[[cellArr objectAtIndex:my_prizes_product_price] intValue]];
        
        int createTime1 = [[cellArr objectAtIndex:my_prizes_starttime] intValue];
        NSDate* date1 = [NSDate dateWithTimeIntervalSince1970:createTime1];
        NSDateFormatter *outputFormat1 = [[NSDateFormatter alloc] init];
        [outputFormat1 setDateFormat:@"yyyy/MM/dd"];
        NSString *dateString1 = [outputFormat1 stringFromDate:date1];
        [outputFormat1 release];
        
        int createTime2 = [[cellArr objectAtIndex:my_prizes_endtime] intValue];
        NSDate* date2 = [NSDate dateWithTimeIntervalSince1970:createTime2];
        NSDateFormatter *outputFormat2 = [[NSDateFormatter alloc] init];
        [outputFormat2 setDateFormat:@"yyyy/MM/dd"];
        NSString *dateString2 = [outputFormat2 stringFromDate:date2];
        [outputFormat2 release];
        
        UILabel *label3 = (UILabel *)[cell.contentView viewWithTag:13];
        label3.text = [NSString stringWithFormat:@"%@ - %@",dateString1,dateString2];
        
        
        NSString *picUrl = [cellArr objectAtIndex:my_prizes_pic];
        NSString *picName = [Common encodeBase64:(NSMutableData *)[picUrl dataUsingEncoding: NSUTF8StringEncoding]];
        
        if (picUrl.length > 1) 
        {
            UIImage *pic = [[FileManager getPhoto:picName] fillSize:CGSizeMake(picWidth, picHeight)];
            if (pic.size.width > 2)
            {
                UIImageView *vi = (UIImageView *)[cell.contentView viewWithTag:10];
                vi.image = pic;
            }
            else
            {
                UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品列表默认图片" ofType:@"png"]];
                UIImageView *vi = (UIImageView *)[cell.contentView viewWithTag:10];
                vi.image = [defaultPic fillSize:CGSizeMake(picWidth, picHeight)];
                
				if (tableView.dragging == NO && tableView.decelerating == NO)
				{
                    [self startIconDownload:picUrl forIndex:indexPath];
				}
            }
        }
        else
        {
            UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品列表默认图片" ofType:@"png"]];
            UIImageView *vi = (UIImageView *)[cell.contentView viewWithTag:10];
            vi.image = [defaultPic fillSize:CGSizeMake(picWidth, picHeight)];
        }
    }
    
	return cell;	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *cellArr = [self.listArray objectAtIndex:indexPath.row];
    NSLog(@"cellArr===%@",cellArr);
    
    NSString *prizeId = [NSString stringWithFormat:@"%d",[[cellArr objectAtIndex:my_prizes_id] intValue]];

    lotteryDetailViewController *lotteryDetailView = [[lotteryDetailViewController alloc] init];
    lotteryDetailView.lotteryID = prizeId;
    
    NSMutableArray *lotteryArray = [[NSMutableArray alloc] init];
    [lotteryArray addObject:prizeId];
    [lotteryArray addObject:[cellArr objectAtIndex:my_prizes_name]];
    [lotteryArray addObject:[cellArr objectAtIndex:my_prizes_starttime]];
    [lotteryArray addObject:[cellArr objectAtIndex:my_prizes_endtime]];
    [lotteryArray addObject:[cellArr objectAtIndex:my_prizes_des]];
    [lotteryArray addObject:[cellArr objectAtIndex:my_prizes_product_name]];
    [lotteryArray addObject:[cellArr objectAtIndex:my_prizes_product_des]];
    [lotteryArray addObject:[cellArr objectAtIndex:my_prizes_product_price]];
    [lotteryArray addObject:[cellArr objectAtIndex:my_prizes_product_sum]];
    [lotteryArray addObject:@""];
    [lotteryArray addObject:@""];
    [lotteryArray addObject:@""];
    [lotteryArray addObject:@""];
    [lotteryArray addObject:@""];
    [lotteryArray addObject:@""];
    [lotteryArray addObject:[cellArr objectAtIndex:my_prizes_pic]];
    [lotteryArray addObject:@""];
    
    lotteryDetailView.lotteryArray = lotteryArray;
    
    if ([[cellArr objectAtIndex:my_prizes_pics] isKindOfClass:[NSMutableArray class]])
    {
        lotteryDetailView.lotteryPicArray = [cellArr objectAtIndex:my_prizes_pics];
    }
    else
    {
        NSMutableArray *picArray = (NSMutableArray *)[DBOperate queryData:T_MY_PRIZES_PIC theColumn:@"prizeId" theColumnValue:prizeId orderBy:@"id" orderType:@"asc" withAll:NO];
        lotteryDetailView.lotteryPicArray = picArray;
    }
    
    [self.navigationController pushViewController:lotteryDetailView animated:YES];
    [lotteryDetailView release];
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
	UITableViewCell *cell = (UITableViewCell *)[self.myTableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
	
    if (iconDownloader != nil)
    {
		if(iconDownloader.cardIcon.size.width > 2.0){ 			
			UIImage *photo = iconDownloader.cardIcon;
			
            NSString *imageurl = [[self.listArray objectAtIndex:iconDownloader.indexPathInTableView.row] objectAtIndex:my_prizes_pic];
            NSString *photoname = [Common encodeBase64:(NSMutableData *)[imageurl dataUsingEncoding: NSUTF8StringEncoding]];
        
			if ([FileManager savePhoto:photoname withImage:photo]) {
				
                UIImageView *vi = (UIImageView *)[cell.contentView viewWithTag:10];
                vi.image = photo;      
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
- (void)selectAddrAction
{
    MyAddressViewController *address = [[MyAddressViewController alloc] init];
    address._isHidden = NO;
    address.fromType = FromTypePrize;
    address.userId = self.userId;
    [self.navigationController pushViewController:address animated:YES];
    [address release];
}

- (void)accessMoreService
{
    int _isreceive = [[[self.listArray objectAtIndex:[self.listArray count] - 1] objectAtIndex:my_prizes_isreceive] intValue];
    int _created = [[[self.listArray objectAtIndex:[self.listArray count] - 1] objectAtIndex:my_prizes_created] intValue];
    
    NSMutableDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [Common getSecureString],@"keyvalue",
                                            [NSNumber numberWithInt:-1],@"ver",
                                            [NSNumber numberWithInt: SITE_ID],@"site_id",
                                            [NSNumber numberWithInt:[self.userId intValue]],@"user_id",
                                            [NSNumber numberWithInt:_isreceive],@"isreceive",
                                            [NSNumber numberWithInt:_created],@"created",nil];
    	
    [[DataManager sharedManager] accessService:jsontestDic command:MEMBER_PRIZEMORELIST_COMMAND_ID accessAdress:@"luckdraw/myluckdraw.do?param=%@" delegate:self withParam:jsontestDic];
}

- (void)accessService
{
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
    
    NSMutableDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [Common getSecureString],@"keyvalue",
                                        [Common getMemberVersion:[self.userId intValue] commandID:MEMBER_PRIZELIST_COMMAND_ID],@"ver",
                                        [NSNumber numberWithInt: SITE_ID],@"site_id",
                                        [NSNumber numberWithInt:[self.userId intValue]],@"user_id",nil];
    
    [[DataManager sharedManager] accessService:jsontestDic command:MEMBER_PRIZELIST_COMMAND_ID accessAdress:@"luckdraw/myluckdraw.do?param=%@" delegate:self withParam:jsontestDic];
}

- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
	NSLog(@"information finish");
	//NSLog(@"=====%@",resultArray);
    switch (commandid) {
        case MEMBER_PRIZELIST_COMMAND_ID:
        {
            [self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
        }
            break;
        case MEMBER_PRIZEMORELIST_COMMAND_ID:
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
    //移出loading
    [self.spinner removeFromSuperview];
    
    self.listArray = (NSMutableArray *)[DBOperate queryData:T_MY_PRIZES theColumn:@"memberId" theColumnValue:self.userId orderByOne:@"isreceive" orderTypeOne:@"ASC" orderByTwo:@"created" orderTypeTwo:@"DESC" withAll:NO];
//    self.listArray = (NSMutableArray *)[DBOperate queryData:T_MY_PRIZES thePicName:T_MY_PRIZES_PIC theColumn:@"memberId" theColumnValue:self.userId  orderByOne:@"isreceive" orderTypeOne:@"ASC" orderByTwo:@"created" orderTypeTwo:@"DESC" withAll:NO];
    
    //NSLog(@"[self.listArray count]=====%d",[self.listArray count]);
    
    if ([self.listArray count] == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        label.text = @"您还未曾中奖，不要泄气，继续加油哦";
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.textAlignment = UITextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16.0f];
        [self.view addSubview:label];
        [label release];
    }else {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 5, 320, self.view.frame.size.height - 5) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_myTableView];
        self.myTableView.backgroundColor = [UIColor clearColor];
        
        UIBarButtonItem *mrightbto = [[UIBarButtonItem alloc]
                                      initWithTitle:@"选择地址"
                                      style:UIBarButtonItemStyleBordered
                                      target:self
                                      action:@selector(selectAddrAction)];
        self.navigationItem.rightBarButtonItem = mrightbto;
        [mrightbto release];
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
