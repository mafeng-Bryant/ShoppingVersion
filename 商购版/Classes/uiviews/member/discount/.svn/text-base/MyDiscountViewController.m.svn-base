//
//  MyDiscountViewController.m
//  shopping
//
//  Created by 来 云 on 13-1-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MyDiscountViewController.h"
#import "Common.h"
#import "DBOperate.h"
#import "DataManager.h"
#import "MyDiscountCell.h"
#import "MyDiscountDetailViewController.h"
#import "UIImageScale.h"
#import "FileManager.h"
#import "downloadParam.h"
#import "imageDownLoadInWaitingObject.h"
@interface MyDiscountViewController ()

@end

@implementation MyDiscountViewController
@synthesize myTableView = _myTableView;
@synthesize listArray = __listArray;
@synthesize userId;
@synthesize commandOper;
@synthesize spinner;
@synthesize isSelectPromotion;
@synthesize myDelegate;
@synthesize imageDownloadsInProgressDic;
@synthesize imageDownloadsInWaitingArray;

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
	
    self.title = @"我的优惠卷";
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, 320, self.view.frame.size.height- 60) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTableView];
    self.myTableView.backgroundColor = [UIColor clearColor];
    
    _loadingMore = NO;
    _isAllowLoadingMore = NO;
    
    NSMutableDictionary *idip = [[NSMutableDictionary alloc]init];
	self.imageDownloadsInProgressDic = idip;
	[idip release];
	
	NSMutableArray *wait = [[NSMutableArray alloc]init];
	self.imageDownloadsInWaitingArray = wait;
	[wait release];
    
    picWidth = 304;
    picHeight = 85;
}

- (void)viewWillAppear:(BOOL)animated
{
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
    [self.view addSubview:self.spinner];
    [self.spinner startAnimating];
    [tempSpinner release];
    
    [self accessService];
}

- (void)dealloc
{
    [_myTableView release];
    [__listArray release];
    [indicatorView release];
    [userId release];
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
		return 85.0f;
	}else {
		return 0;
	}	
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if (section == 1) {
		UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        
        UIImage *bgImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"代金券背景" ofType:@"png"]];
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake((320 - bgImage.size.width) * 0.5 , 0 , bgImage.size.width, bgImage.size.height)];
        bgImageView.image = bgImage;
        bgImageView.userInteractionEnabled = YES;
        [vv addSubview:bgImageView];
        [bgImage release];
        
		UILabel *moreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 320, 30)];
		moreLabel.text = @"上拉加载更多";
		moreLabel.tag = 200;
        moreLabel.font = [UIFont systemFontOfSize:14.0f];
		moreLabel.textColor = [UIColor colorWithRed:0.3 green: 0.3 blue: 0.3 alpha:1.0];
		moreLabel.textAlignment = UITextAlignmentCenter;
		moreLabel.backgroundColor = [UIColor clearColor];
		[bgImageView addSubview:moreLabel];
		[moreLabel release];
		
		//添加loading图标
		indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
		[indicatorView setCenter:CGPointMake(320 / 3, 40 / 2.0)];
		indicatorView.hidesWhenStopped = YES;
		[bgImageView addSubview:indicatorView];
        [bgImageView release];
		
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
	
	MyDiscountCell *cell = (MyDiscountCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[[MyDiscountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
		cell.cName.text = @"";
		cell.cPrice.text = @"";
		cell.cPriceName.text = @"";
		cell.cStartTime.text = @"";
        cell.cEndTime.text = @"";
    }
	//cell.backgroundColor = [UIColor colorWithRed:0.935 green:0.935 blue:0.935 alpha:1.0f];
	
	if (self.listArray != nil && indexPath.row < [self.listArray count]) {
		NSArray *ay = [self.listArray objectAtIndex:indexPath.row];
        
		cell.cName.text = [NSString stringWithFormat:@"%@",[ay objectAtIndex:mydiscountlist_name]];
		cell.cPrice.text = [NSString stringWithFormat:@"%@",[ay objectAtIndex:mydiscountlist_price]];
		cell.cPriceName.text = [NSString stringWithFormat:@"%@",[ay objectAtIndex:mydiscountlist_unitname]];
        
        int createTime1 = [[ay objectAtIndex:mydiscountlist_starttime] intValue];
        NSDate* date1 = [NSDate dateWithTimeIntervalSince1970:createTime1];
        NSDateFormatter *outputFormat1 = [[NSDateFormatter alloc] init];
        [outputFormat1 setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString1 = [outputFormat1 stringFromDate:date1];
        [outputFormat1 release];
		cell.cStartTime.text = dateString1;
        
        int createTime2 = [[ay objectAtIndex:mydiscountlist_endtime] intValue];
        NSDate* date2 = [NSDate dateWithTimeIntervalSince1970:createTime2];
        NSDateFormatter *outputFormat2 = [[NSDateFormatter alloc] init];
        [outputFormat2 setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString2 = [outputFormat2 stringFromDate:date2];
        [outputFormat2 release];
        cell.cEndTime.text = dateString2;
		
		if ([[ay objectAtIndex:mydiscountlist_status] intValue] == 1)
		{
			cell.recommendImageViewUsed.hidden = NO;
            cell.recommendImageViewEnd.hidden = YES;
		}
		else if ([[ay objectAtIndex:mydiscountlist_status] intValue] == 2) 
		{
            cell.recommendImageViewUsed.hidden = YES;
			cell.recommendImageViewEnd.hidden = NO;
		}else {
            cell.recommendImageViewUsed.hidden = YES;
            cell.recommendImageViewEnd.hidden = YES;
        }
        
        //图片
        NSString *picUrl = [ay objectAtIndex:mydiscountlist_imageurl];
        NSString *picName = [Common encodeBase64:(NSMutableData *)[picUrl dataUsingEncoding: NSUTF8StringEncoding]];
        
        if (picUrl.length > 1)
        {
            UIImage *pic = [[FileManager getPhoto:picName] fillSize:CGSizeMake(picWidth, picHeight)];
            if (pic.size.width > 2)
            {
                cell.cBgView.image = pic;
            }
            else
            {
				if (tableView.dragging == NO && tableView.decelerating == NO)
				{
                    [self startIconDownload:picUrl forIndex:indexPath];
				}
            }
        }

	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isSelectPromotion) {
        if ([[[self.listArray objectAtIndex:indexPath.row] objectAtIndex:mydiscountlist_status] intValue] == 0) {
            promotionDataArray = [[NSArray alloc] init];
            promotionDataArray = [self.listArray objectAtIndex:indexPath.row];
            if (myDelegate != nil) {
                [myDelegate getPromotionArray:promotionDataArray];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithView:self.view];
            progressHUDTmp.delegate = self;
            progressHUDTmp.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-信息.png"]] autorelease];
            progressHUDTmp.mode = MBProgressHUDModeCustomView;
            progressHUDTmp.labelText = @"此优惠卷不能使用";
            [self.view addSubview:progressHUDTmp];
            [progressHUDTmp show:YES];
            [progressHUDTmp hide:YES afterDelay:1.5];
            [progressHUDTmp release];
        }
        
    }else{
        MyDiscountDetailViewController *discountDetail = [[MyDiscountDetailViewController alloc] init];
        discountDetail.detailArray = [self.listArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:discountDetail animated:YES];
        [discountDetail release];
    }
    
}

//ios7 去掉cell背景色
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
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
	MyDiscountCell *cell = (MyDiscountCell *)[self.myTableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
	
    if (iconDownloader != nil)
    {
		if(iconDownloader.cardIcon.size.width > 2.0){
			UIImage *photo = iconDownloader.cardIcon;
			
            NSString *imageurl = [[self.listArray objectAtIndex:iconDownloader.indexPathInTableView.row] objectAtIndex:mydiscountlist_imageurl];
            NSString *photoname = [Common encodeBase64:(NSMutableData *)[imageurl dataUsingEncoding: NSUTF8StringEncoding]];
            
            if ([FileManager savePhoto:photoname withImage:photo]) {
                cell.cBgView.image = [photo fillSize:CGSizeMake(picWidth, picHeight)];
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
    int updatetime = [[[self.listArray objectAtIndex:[self.listArray count] - 1] objectAtIndex:mydiscountlist_updatetime] intValue];
    int status = [[[self.listArray objectAtIndex:[self.listArray count] - 1] objectAtIndex:mydiscountlist_status] intValue];
    
    NSMutableDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [Common getSecureString],@"keyvalue",
                                        [NSNumber numberWithInt: SITE_ID],@"site_id",
                                        [NSNumber numberWithInt:[self.userId intValue]],@"user_id",
                                        [NSNumber numberWithInt:status],@"status",
                                        [NSNumber numberWithInt:updatetime],@"updatetime",nil];
    
    [[DataManager sharedManager] accessService:jsontestDic command:MEMBER_DISCOUNTMORELIST_COMMAND_ID accessAdress:@"book/prilist.do?param=%@" delegate:self withParam:jsontestDic];
}

- (void)accessService
{
    NSMutableDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [Common getSecureString],@"keyvalue",
                                        [NSNumber numberWithInt: SITE_ID],@"site_id",
                                        [NSNumber numberWithInt:[self.userId intValue]],@"user_id",nil];
    
    [[DataManager sharedManager] accessService:jsontestDic command:MEMBER_DISCOUNTLIST_COMMAND_ID accessAdress:@"book/prilist.do?param=%@" delegate:self withParam:jsontestDic];
}

- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
	NSLog(@"information finish");
	NSLog(@"=====%@",resultArray);
    switch (commandid) {
        case MEMBER_DISCOUNTLIST_COMMAND_ID:
        {
            [self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
        }
            break;
        case MEMBER_DISCOUNTMORELIST_COMMAND_ID:
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
    
    self.listArray = (NSMutableArray *)[DBOperate queryData:T_MYDISCOUNT_LIST theColumn:@"memberId" theColumnValue:self.userId orderByOne:@"status" orderTypeOne:@"ASC" orderByTwo:@"updatetime" orderTypeTwo:@"DESC" withAll:NO];
	
	if ([self.listArray count] == 0) {
		self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
		label.text = @"您还未获得优惠券，赶紧去分享获取吧";
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

