//
//  MyNewsViewController.m
//  shopping
//
//  Created by 来 云 on 13-1-9.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MyNewsViewController.h"
#import "Common.h"
#import "DataManager.h"
#import "DBOperate.h"
#import "UIImageScale.h"
#import "FileManager.h"
#import "downloadParam.h"
#import "imageDownLoadInWaitingObject.h"
#import "newsCellViewController.h"
#import "IconDownLoader.h"
#import "newsDetailViewController.h"
#import "MyCollectionViewController.h"
@interface MyNewsViewController ()

@end

@implementation MyNewsViewController
@synthesize myTableView = _myTableView;
@synthesize listArray = __listArray;
@synthesize commandOper;
@synthesize imageDownloadsInProgressDic;
@synthesize imageDownloadsInWaitingArray;
@synthesize spinner;
@synthesize collectView;

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
	NSMutableDictionary *idip = [[NSMutableDictionary alloc]init];
	self.imageDownloadsInProgressDic = idip;
	[idip release];
	
	NSMutableArray *wait = [[NSMutableArray alloc]init];
	self.imageDownloadsInWaitingArray = wait;
	[wait release];
    
    picWidth = 76.0f;
    picHeight = 56.0f;
    
    _loadingMore = NO;
    _isAllowLoadingMore = NO;
}

- (void)addView
{
    if (noLabel != nil) {
        [noLabel removeFromSuperview];
    }
    if (_myTableView != nil) {
        [_myTableView removeFromSuperview];
    }
    [self accessService];
}

- (void)dealloc
{
    [_myTableView release];
    [__listArray release];
    [progressHUD release];
    self.commandOper.delegate = nil;
	self.commandOper = nil;
    [spinner release];
    [noLabel release];
    [super dealloc];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.commandOper.delegate = nil;
	self.commandOper = nil;
    progressHUD.delegate = nil;
    progressHUD = nil;
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
		return 75.0f;
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
	
	newsCellViewController *cell = (newsCellViewController *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
        cell = [[[newsCellViewController alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.titleLabel.text = @"";
        cell.descLabel.text = @"";
    }
    if ([self.listArray count] > 0 && indexPath.row < [self.listArray count]) {
        NSArray *newsArray = [self.listArray objectAtIndex:[indexPath row]];
        
        //标题
        cell.titleLabel.text = [newsArray objectAtIndex:favoritenews_title];
        
        //描述
        cell.descLabel.text = [newsArray objectAtIndex:favoriyenews_content];
        
        //图片
        NSString *picUrl = [newsArray objectAtIndex:favoritenews_thumb_pic];
        NSString *picName = [Common encodeBase64:(NSMutableData *)[picUrl dataUsingEncoding: NSUTF8StringEncoding]];
        
        if (picUrl.length > 1) 
        {
            UIImage *pic = [[FileManager getPhoto:picName] fillSize:CGSizeMake(picWidth, picHeight)];
            if (pic.size.width > 2)
            {
                cell.picView.image = pic;
            }
            else
            {
                UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"活动资讯列表默认" ofType:@"png"]];
                cell.picView.image = [defaultPic fillSize:CGSizeMake(picWidth, picHeight)];
                
				if (tableView.dragging == NO && tableView.decelerating == NO)
				{
                    [self startIconDownload:picUrl forIndex:indexPath];
				}
            }
        }
        else
        {
            UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"活动资讯列表默认" ofType:@"png"]];
            cell.picView.image = [defaultPic fillSize:CGSizeMake(picWidth, picHeight)];
        }
    }
    
	return cell;	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *newArray = [self.listArray objectAtIndex:indexPath.row];
    
    if ([[newArray objectAtIndex:favoritenews_stauts] intValue] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"该资讯已删除" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }else {
        newsDetailViewController *newsDetail = [[newsDetailViewController alloc] init];
        newsDetail.detailArray = newArray;
        newsDetail.commentTotal = [NSString stringWithFormat:@"%d",[[newArray objectAtIndex:favoritenews_comments] intValue]];
        newsDetail.isFrom = YES;
        [self.collectView.navigationController pushViewController:newsDetail animated:YES];
        [newsDetail release];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    rowValue = indexPath.row;
    int _userId = [[[[DBOperate queryData:T_MEMBER_INFO theColumn:nil theColumnValue:nil withAll:YES] objectAtIndex:0] objectAtIndex:member_info_memberId] intValue];

	_infoId = [[self.listArray objectAtIndex:indexPath.row] objectAtIndex:favoritenews_id];
	//NSLog(@"_infoId=======%d",[_infoId intValue]);
    
    NSMutableDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [Common getSecureString],@"keyvalue",
                                        [NSNumber numberWithInt: SITE_ID],@"site_id",
                                        [NSNumber numberWithInt:_userId],@"user_id",
                                        [NSNumber numberWithInt:1],@"type",
                                        _infoId,@"info_id",nil];
	
	[[DataManager sharedManager] accessService:jsontestDic command:MEMBER_NEWSDELETE_COMMAND_ID accessAdress:@"member/delfavorite.do?param=%@" delegate:self withParam:jsontestDic];
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{ 
    return UITableViewCellEditingStyleDelete; 
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
            label.text = @"松开加载更多";
        }
        else
        {
            label.text = @"上拉加载更多";
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
            
            label.text = @" 加载中 ...";
            [indicatorView startAnimating];
            
            //数据
            [self accessMoreService];
        }
        else
        {
            label.text = @"上拉加载更多";
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
	newsCellViewController *cell = (newsCellViewController *)[self.myTableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
	
    if (iconDownloader != nil)
    {
		if(iconDownloader.cardIcon.size.width > 2.0){ 			
			UIImage *photo = iconDownloader.cardIcon;
			
            NSString *imageurl = [[self.listArray objectAtIndex:iconDownloader.indexPathInTableView.row] objectAtIndex:favoritenews_thumb_pic];
            NSString *photoname = [Common encodeBase64:(NSMutableData *)[imageurl dataUsingEncoding: NSUTF8StringEncoding]];
            
			if ([FileManager savePhoto:photoname withImage:photo]) {
				cell.picView.image = photo;
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

#pragma mark -------private methods
- (void)accessMoreService
{
    int _userId = [[[[DBOperate queryData:T_MEMBER_INFO theColumn:nil theColumnValue:nil withAll:YES] objectAtIndex:0] objectAtIndex:member_info_memberId] intValue];
    
    int created = [[[self.listArray objectAtIndex:[self.listArray count] - 1] objectAtIndex:favorite_products_created] intValue];
    NSMutableDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [Common getSecureString],@"keyvalue",
                                        [NSNumber numberWithInt: SITE_ID],@"site_id",
                                        [NSNumber numberWithInt:_userId],@"user_id",
                                        [NSNumber numberWithInt:1],@"type",
                                        [NSNumber numberWithInt:created],@"created",nil];
    
    [[DataManager sharedManager] accessService:jsontestDic command:MEMBER_NEWSMORELIST_COMMAND_ID accessAdress:@"member/favoritelist.do?param=%@" delegate:self withParam:jsontestDic];
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
    
    int _userId = [[[[DBOperate queryData:T_MEMBER_INFO theColumn:nil theColumnValue:nil withAll:YES] objectAtIndex:0] objectAtIndex:member_info_memberId] intValue];
    
    NSMutableDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [Common getSecureString],@"keyvalue",
                                        [NSNumber numberWithInt: SITE_ID],@"site_id",
                                        [NSNumber numberWithInt:_userId],@"user_id",
                                        [NSNumber numberWithInt:1],@"type",nil];
    
    [[DataManager sharedManager] accessService:jsontestDic command:MEMBER_NEWSLIST_COMMAND_ID accessAdress:@"member/favoritelist.do?param=%@" delegate:self withParam:jsontestDic];
}

- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
	NSLog(@"information finish");
	NSLog(@"=====%@",resultArray);
    switch (commandid) {
        case MEMBER_NEWSLIST_COMMAND_ID:
        {
            [self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
        }
            break;
        case MEMBER_NEWSDELETE_COMMAND_ID:
        {
            [self performSelectorOnMainThread:@selector(deleteResult:) withObject:resultArray waitUntilDone:NO];
        }
            break;
        case MEMBER_NEWSMORELIST_COMMAND_ID:
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
    
    self.listArray = (NSMutableArray *)[DBOperate queryData:T_FAVORITE_NEWS theColumn:nil theColumnValue:nil withAll:YES];
    //NSLog(@"self.listArray========%@",self.listArray);
    //NSLog(@"[self.listArray count]=====%d",[self.listArray count]);
    
    if ([self.listArray count] == 0) {
        noLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        noLabel.text = @"您还没有收藏任何活动资讯哦";
        noLabel.backgroundColor = [UIColor clearColor];
        noLabel.textColor = [UIColor grayColor];
        noLabel.textAlignment = UITextAlignmentCenter;
        noLabel.font = [UIFont systemFontOfSize:16.0f];
        [self.view addSubview:noLabel];
    }else {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 5, 320, self.view.frame.size.height- 10) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_myTableView];
        self.myTableView.backgroundColor = [UIColor clearColor];
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

- (void)deleteResult:(NSMutableArray *)resultArray
{
	int retInt = [[resultArray objectAtIndex:0] intValue];
	if (retInt == 1) {
		[DBOperate deleteData:T_FAVORITE_NEWS tableColumn:@"id" columnValue:_infoId];
        [DBOperate deleteData:T_FAVORITED_NEWS tableColumn:@"news_id" columnValue:_infoId];
        [self.listArray removeObjectAtIndex:rowValue];
		
        NSMutableArray *deleteIndexPaths = [[NSMutableArray alloc] init];
        NSIndexPath *newPath = [NSIndexPath indexPathForRow:rowValue inSection:0];
        [deleteIndexPaths addObject:newPath];
        [self.myTableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationFade];
        [deleteIndexPaths release];
        
		//[self.myTableView reloadData];
		
		if ([self.listArray count] == 0) {
			self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
			label.text = @"您还没有收藏任何活动资讯哦";
			label.backgroundColor = [UIColor clearColor];
			label.textColor = [UIColor grayColor];
			label.textAlignment = UITextAlignmentCenter;
			label.font = [UIFont systemFontOfSize:16.0f];
			[self.view addSubview:label];
			[label release];
		}
		
	}else {
		MBProgressHUD *mbprogressHUD = [[MBProgressHUD alloc] initWithView:self.view];
		mbprogressHUD.delegate = self;
		mbprogressHUD.customView= [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-信息.png"]] autorelease];
		mbprogressHUD.mode = MBProgressHUDModeCustomView; 
		mbprogressHUD.labelText = @"删除失败";
		[self.view addSubview:mbprogressHUD];
		[self.view bringSubviewToFront:mbprogressHUD];
		[mbprogressHUD show:YES];
		[mbprogressHUD hide:YES afterDelay:1];
		[mbprogressHUD release];
	}
	
}
@end
