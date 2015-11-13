//
//  MyFavoriteViewController.m
//  shopping
//
//  Created by 来 云 on 13-1-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MyFavoriteViewController.h"
#import "Common.h"
#import "DataManager.h"
#import "DBOperate.h"
#import "UIImageScale.h"
#import "FileManager.h"
#import "downloadParam.h"
#import "imageDownLoadInWaitingObject.h"
#import "productTableCellViewController.h"
#import "IconDownLoader.h"
#import "ProductDetailViewController.h"
#import "alertView.h"

@interface MyFavoriteViewController ()

@end

@implementation MyFavoriteViewController
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
	self.title = @"我的喜欢";
    
    NSMutableDictionary *idip = [[NSMutableDictionary alloc]init];
	self.imageDownloadsInProgressDic = idip;
	[idip release];
	
	NSMutableArray *wait = [[NSMutableArray alloc]init];
	self.imageDownloadsInWaitingArray = wait;
	[wait release];
    
    picWidth = 70.0f;
    picHeight = 70.0f;
    
	_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 5, 320, self.view.frame.size.height - 50) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTableView];
    self.myTableView.backgroundColor = [UIColor clearColor];
    
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
	
	productTableCellViewController *cell = (productTableCellViewController *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
        cell = [[[productTableCellViewController alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.titleLabel.text = @"";
        cell.priceLabel.text = @"";
		cell.likeLabel.text = @"";
		cell.commentLabel.text = @"";
    }
    if ([self.listArray count] > 0 && indexPath.row < [self.listArray count]) {
        NSArray *productArray = [self.listArray objectAtIndex:[indexPath row]];
        
        //标题
        cell.titleLabel.text = [productArray objectAtIndex:my_likes_title];
        
        //价格判断
        if ([[productArray objectAtIndex:my_likes_promotion_price] intValue] != 0 && [[productArray objectAtIndex:my_likes_price] length] > 0) 
        {
            //有优惠价格
            cell.originalLabel.hidden = NO;
            cell.lineView.hidden = NO;
            
            NSString *priceString = [NSString stringWithFormat:@"￥%@",[productArray objectAtIndex:my_likes_promotion_price]];
            CGSize constraint = CGSizeMake(20000.0f, 20.0f);
            CGSize size = [priceString sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            CGFloat fixWidth = (size.width + 5.0f) > 60.0f ? 60.0f : (size.width + 5.0f);
            
            cell.priceLabel.frame = CGRectMake( cell.priceLabel.frame.origin.x, cell.priceLabel.frame.origin.y , fixWidth , cell.priceLabel.frame.size.height) ;
            
            
            NSString *originalString = [NSString stringWithFormat:@"/ ￥%@",[productArray objectAtIndex:my_likes_price]];
            
            CGSize constraint1 = CGSizeMake(20000.0f, 20.0f);
            CGSize size1 = [originalString sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:constraint1 lineBreakMode:UILineBreakModeWordWrap];
            CGFloat fixWidth1 = (size1.width + 5.0f) > 60.0f ? 60.0f : (size1.width + 5.0f);
            
            cell.originalLabel.frame = CGRectMake( CGRectGetMaxX(cell.priceLabel.frame), cell.originalLabel.frame.origin.y , fixWidth1 , cell.originalLabel.frame.size.height) ;
            
            cell.lineView.frame = CGRectMake( CGRectGetMaxX(cell.priceLabel.frame) + 5.0f, cell.lineView.frame.origin.y , fixWidth1 - 12.0f , cell.lineView.frame.size.height) ;
            
            cell.priceLabel.text = priceString;
            cell.originalLabel.text = originalString;
        }
        else
        {
            //没有优惠价格
            cell.originalLabel.hidden = YES;
            cell.lineView.hidden = YES;
            
            NSString *priceString = [NSString stringWithFormat:@"￥%@",[productArray objectAtIndex:my_likes_price]];
            
            CGSize constraint = CGSizeMake(20000.0f, 20.0f);
            CGSize size = [priceString sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            CGFloat fixWidth = (size.width + 5.0f) > 120.0f ? 120.0f : (size.width + 5.0f);
            
            cell.priceLabel.frame = CGRectMake( cell.priceLabel.frame.origin.x, cell.priceLabel.frame.origin.y , fixWidth , cell.priceLabel.frame.size.height) ;
            
            cell.priceLabel.text = priceString;
            cell.originalLabel.text = @"";
        }
        
        //喜欢
        cell.likeLabel.text = [productArray objectAtIndex:my_likes_likes];
        
        //评论
        cell.commentLabel.text = [productArray objectAtIndex:my_likes_comment_num];
        
        //图片
        NSString *picUrl = [productArray objectAtIndex:my_likes_pic];
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
                UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品列表默认图片" ofType:@"png"]];
                cell.picView.image = [defaultPic fillSize:CGSizeMake(picWidth, picHeight)];
                
				if (tableView.dragging == NO && tableView.decelerating == NO)
				{
                    [self startIconDownload:picUrl forIndex:indexPath];
				}
            }
        }
        else
        {
            UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品列表默认图片" ofType:@"png"]];
            cell.picView.image = [defaultPic fillSize:CGSizeMake(picWidth, picHeight)];
        }
    }
    
	return cell;	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *array = [self.listArray objectAtIndex:[indexPath row]];
    int status = [[array objectAtIndex:my_likes_status] intValue];
    if (status == 1)
    {
//        NSMutableArray *productArray = [[NSMutableArray alloc]init];
//        NSMutableArray *infoArray = [[NSMutableArray alloc]init];
//        [infoArray addObject:[array objectAtIndex:my_likes_product_id]];
//        [infoArray addObject:[array objectAtIndex:my_likes_catid]];
//        [infoArray addObject:[array objectAtIndex:my_likes_title]];
//        [infoArray addObject:[array objectAtIndex:my_likes_content]];
//        [infoArray addObject:[array objectAtIndex:my_likes_promotion_price]];
//        [infoArray addObject:[array objectAtIndex:my_likes_price]];
//        [infoArray addObject:[array objectAtIndex:my_likes_likes]];
//        [infoArray addObject:[array objectAtIndex:my_likes_favorites]];
//        [infoArray addObject:[array objectAtIndex:my_likes_unit]];
//        [infoArray addObject:[array objectAtIndex:my_likes_salenum]];
//        [infoArray addObject:[array objectAtIndex:my_likes_comment_num]];
//        [infoArray addObject:[array objectAtIndex:my_likes_sort_order]];
//        [infoArray addObject:[array objectAtIndex:my_likes_is_big_pic]];
//        [infoArray addObject:[array objectAtIndex:my_likes_pic]];
//        [infoArray addObject:[array objectAtIndex:my_likes_pics]];
//        
//        [productArray addObject:infoArray];
        
        ProductDetailViewController *ProductDetailView = [[ProductDetailViewController alloc] init];
        ProductDetailView.productID = [[array objectAtIndex:my_likes_product_id] intValue];
        //ProductDetailView.productList = productArray;
        [self.navigationController pushViewController:ProductDetailView animated:YES];
        [ProductDetailView release];
    }
    else
    {
        [alertView showAlert:@"商品已下架"];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    rowValue = indexPath.row;
   
	_infoId = [[self.listArray objectAtIndex:indexPath.row] objectAtIndex:my_likes_product_id];
	NSLog(@"_infoId=======%d",[_infoId intValue]);
    
    NSMutableDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [Common getSecureString],@"keyvalue",
                                        [NSNumber numberWithInt: SITE_ID],@"site_id",
                                        [NSNumber numberWithInt:[self.userId intValue]],@"user_id",
                                        _infoId,@"product_id",nil];
	
	[[DataManager sharedManager] accessService:jsontestDic command:MEMBER_LIKESDELETE_COMMAND_ID accessAdress:@"member/dellike.do?param=%@" delegate:self withParam:jsontestDic];
    
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
	productTableCellViewController *cell = (productTableCellViewController *)[self.myTableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
	
    if (iconDownloader != nil)
    {
		if(iconDownloader.cardIcon.size.width > 2.0){ 			
			UIImage *photo = iconDownloader.cardIcon;
			//NSString *photoname = [callSystemApp getCurrentTime];
            NSString *imageurl = [[self.listArray objectAtIndex:iconDownloader.indexPathInTableView.row] objectAtIndex:my_likes_pic];
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
    int created = [[[self.listArray objectAtIndex:[self.listArray count] - 1] objectAtIndex:my_likes_created] intValue];
    NSMutableDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [Common getSecureString],@"keyvalue",
                                        [NSNumber numberWithInt: SITE_ID],@"site_id",
                                        [NSNumber numberWithInt:[self.userId intValue]],@"user_id",
                                        [NSNumber numberWithInt:created],@"created",nil];
    
    [[DataManager sharedManager] accessService:jsontestDic command:MEMBER_LIKESMORELIST_COMMAND_ID accessAdress:@"member/likelist.do?param=%@" delegate:self withParam:jsontestDic];
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
                                        [NSNumber numberWithInt: SITE_ID],@"site_id",
                                        [NSNumber numberWithInt:[self.userId intValue]],@"user_id",nil];
    
    [[DataManager sharedManager] accessService:jsontestDic command:MEMBER_LIKESLIST_COMMAND_ID accessAdress:@"member/likelist.do?param=%@" delegate:self withParam:jsontestDic];
}

- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
	NSLog(@"information finish");
	//NSLog(@"=====%@",resultArray);
    switch (commandid) {
        case MEMBER_LIKESLIST_COMMAND_ID:
        {
            [self performSelectorOnMainThread:@selector(update:) withObject:resultArray waitUntilDone:NO];
        }
            break;
        case MEMBER_LIKESDELETE_COMMAND_ID:
        {
            [self performSelectorOnMainThread:@selector(deleteResult:) withObject:resultArray waitUntilDone:NO];
        }
            break;
        case MEMBER_LIKESMORELIST_COMMAND_ID:
        {
            [self performSelectorOnMainThread:@selector(getMoreResult:) withObject:resultArray waitUntilDone:NO];
        }
            break;
        default:
            break;
    }
}

- (void)update:(NSMutableArray *)resultArray
{
    //移出loading
    [self.spinner removeFromSuperview];
    
    NSLog(@"resultArray========%@",resultArray);
    self.listArray = resultArray;
    
    if ([self.listArray count] == 0) {
        self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        label.text = @"您还未添加喜欢的商品哦";
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

- (void)deleteResult:(NSMutableArray *)resultArray
{
	int retInt = [[resultArray objectAtIndex:0] intValue];
	if (retInt == 1) {
//		[DBOperate deleteData:T_MY_LIKES tableColumn:@"product_id" columnValue:_infoId];
//        [DBOperate deleteData:T_MY_LIKES_PIC tableColumn:@"product_id" columnValue:_infoId];
        
        [DBOperate deleteData:T_FAVORITED_LIKES tableColumn:@"likes_id" columnValue:_infoId];
        
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
			label.text = @"您还未添加喜欢的商品哦";
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
