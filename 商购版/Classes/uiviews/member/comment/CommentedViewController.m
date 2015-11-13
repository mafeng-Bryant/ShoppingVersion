//
//  CommentedViewController.m
//  shopping
//
//  Created by 来 云 on 13-1-28.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "CommentedViewController.h"
#import "Common.h"
#import "DataManager.h"
#import "DBOperate.h"
#import "UIImageScale.h"
#import "FileManager.h"
#import "downloadParam.h"
#import "imageDownLoadInWaitingObject.h"
#import "IconDownLoader.h"
#import "ProductDetailViewController.h"
#import "alertView.h"
#import "MyCommentViewController.h"
@interface CommentedViewController ()

@end

@implementation CommentedViewController
@synthesize myTableView = _myTableView;
@synthesize listArray = __listArray;
@synthesize commandOper;
@synthesize imageDownloadsInProgressDic;
@synthesize imageDownloadsInWaitingArray;
@synthesize spinner;
@synthesize userId;
@synthesize type;
@synthesize myCommentView;

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
    
    picWidth = 70.0f;
    picHeight = 70.0f;
    
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
        
        NSString *text = [[self.listArray objectAtIndex:indexPath.row] objectAtIndex:my_commentlist_commentContent];
        CGSize constraint = CGSizeMake(300.0f, 20000.0f);
		CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
		float fixHeight = size.height;
		fixHeight = fixHeight == 0 ? 30.f : MAX(fixHeight,30.0f);
               
		return 90.0f + 30 + fixHeight + 5;
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
        
        UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
		time.text = @"";
        time.textColor = [UIColor darkGrayColor];
        time.tag = 't';
		time.font = [UIFont systemFontOfSize:14.0f];
		time.textAlignment = UITextAlignmentLeft;
		time.backgroundColor = [UIColor clearColor];
		[cell.contentView addSubview:time];
        [time release];
        
        UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(time.frame), 300, 30)];
		content.text = @"";
        content.textColor = [UIColor darkTextColor];
        content.tag = 'c';
        content.numberOfLines = 0;
        content.lineBreakMode = UILineBreakModeWordWrap;
		content.font = [UIFont systemFontOfSize:17.0f];
		content.textAlignment = UITextAlignmentLeft;
		content.backgroundColor = [UIColor clearColor];
		[cell.contentView addSubview:content];
        [content release];
        
        
        UIImage *cellbackgroundImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品列表背景" ofType:@"png"]];
        UIImageView *cellbackgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f , CGRectGetMaxY(content.frame) , 320 , 86)];
        cellbackgroundImageView.tag = 1;
        cellbackgroundImageView.userInteractionEnabled = YES;
        cellbackgroundImageView.image = cellbackgroundImage;
        [cellbackgroundImage release];
        [cell.contentView addSubview:cellbackgroundImageView];

        //右箭头
        UIImageView *rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(300, 36, 16, 11)];
        UIImage *rimg;
        rimg = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"右箭头" ofType:@"png"]];
        rightImage.image = rimg;
        [rimg release];
        [cellbackgroundImageView addSubview:rightImage];
        [rightImage release];
        
        //图片
        UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品列表默认图片" ofType:@"png"]];
        UIImageView *tempPicView = [[UIImageView alloc]initWithFrame:CGRectMake( 10 , 8 , 70.0f, 70.0f)];
        [cellbackgroundImageView addSubview:tempPicView];
        tempPicView.tag = 10;
        tempPicView.image = defaultPic;
        [defaultPic release];
        
        //标题
        UILabel *tempTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake( CGRectGetMaxX(tempPicView.frame) + 10.0f , 8 + 5.0f , 210.0f, 40.0f)];
        tempTitleLabel.backgroundColor = [UIColor clearColor];
        tempTitleLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        tempTitleLabel.font = [UIFont systemFontOfSize:16];
        tempTitleLabel.numberOfLines = 2; 
        tempTitleLabel.textColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1];
        tempTitleLabel.text = @"";
        tempTitleLabel.tag = 11;
        [cellbackgroundImageView addSubview:tempTitleLabel];
        [tempTitleLabel release];
        
        //价格
        UILabel *tempPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake( CGRectGetMaxX(tempPicView.frame) + 10.0f , CGRectGetMaxY(tempTitleLabel.frame) + 5.0f , 60.0f, 20.0f)];
        tempPriceLabel.backgroundColor = [UIColor clearColor];
        tempPriceLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        tempPriceLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0f];
        tempPriceLabel.textColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1];
        tempPriceLabel.text = @"";
        tempPriceLabel.tag = 22;
        [cellbackgroundImageView addSubview:tempPriceLabel];
        [tempPriceLabel release];
        
        //优惠价格
        UILabel *tempOriginalLabel = [[UILabel alloc]initWithFrame:CGRectMake( CGRectGetMaxX(tempPriceLabel.frame), CGRectGetMaxY(tempTitleLabel.frame) + 5.0f , 60.0f, 20.0f)];
        tempOriginalLabel.backgroundColor = [UIColor clearColor];
        tempOriginalLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        tempOriginalLabel.font = [UIFont systemFontOfSize:12];
        tempOriginalLabel.textColor = [UIColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1];
        tempOriginalLabel.text = @"";
        tempOriginalLabel.tag = 33;
        tempOriginalLabel.hidden = YES;
        [cellbackgroundImageView addSubview:tempOriginalLabel];
        [tempOriginalLabel release];
        
        //横线
        UIView *tempLineView = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(tempPriceLabel.frame), CGRectGetMaxY(tempTitleLabel.frame) + 15.0f , 60.0f, 1.0f)];
        tempLineView.backgroundColor = [UIColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1];
        tempLineView.hidden = YES;
        tempLineView.tag = 333;
        [cellbackgroundImageView addSubview:tempLineView];
        [tempLineView release];
        
        //喜欢icon
        UIImageView *tempLikeImageView = [[UIImageView alloc]initWithFrame:CGRectMake( 210.0f , 60.0f , 16.0f, 16.0f)];
        UIImage *likeImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品列表喜欢icon" ofType:@"png"]];
        tempLikeImageView.image = likeImage;
        [likeImage release];
        [cellbackgroundImageView addSubview:tempLikeImageView];
        [tempLikeImageView release];
        
        //评论icon
        UIImageView *tempCommentImageView = [[UIImageView alloc]initWithFrame:CGRectMake( 265.0f , 60.0f , 16.0f, 16.0f)];
        UIImage *commentImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品列表评论icon" ofType:@"png"]];
        tempCommentImageView.image = commentImage;
        [commentImage release];
        [cellbackgroundImageView addSubview:tempCommentImageView];
        [tempCommentImageView release];
        
        //喜欢
        UILabel *tempLikeLabel = [[UILabel alloc]initWithFrame:CGRectMake( CGRectGetMaxX(tempLikeImageView.frame) + 2.0f, CGRectGetMaxY(tempTitleLabel.frame) + 5.0f , 35.0f, 20.0f)];
        tempLikeLabel.backgroundColor = [UIColor clearColor];
        tempLikeLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        tempLikeLabel.font = [UIFont systemFontOfSize:12];
        tempLikeLabel.textColor = [UIColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1];
        tempLikeLabel.text = @"44";
        tempLikeLabel.tag = 44;
        [cellbackgroundImageView addSubview:tempLikeLabel];
        [tempLikeLabel release];
        
        //评论
        UILabel *tempCommentLabel = [[UILabel alloc]initWithFrame:CGRectMake( CGRectGetMaxX(tempCommentImageView.frame) + 2.0f, CGRectGetMaxY(tempTitleLabel.frame) + 5.0f , 35.0f, 20.0f)];
        tempCommentLabel.backgroundColor = [UIColor clearColor];
        tempCommentLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        tempCommentLabel.font = [UIFont systemFontOfSize:12];
        tempCommentLabel.textColor = [UIColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1];
        tempCommentLabel.text = @"55";
        tempCommentLabel.tag = 55;
        [cellbackgroundImageView addSubview:tempCommentLabel];
        [tempCommentLabel release];
        
        [tempPicView release];
        
        [cellbackgroundImageView release];
        
        UIImage *separateImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"分割线_虚线" ofType:@"png"]];
        UIImageView *separateImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(cellbackgroundImageView.frame) + 3 , separateImage.size.width, separateImage.size.height)];
        separateImageView.tag = 66;
        separateImageView.image = separateImage;
        [separateImage release];
        [cell.contentView addSubview:separateImageView];
        [separateImageView release];
        
    }
    if ([self.listArray count] > 0 && indexPath.row < [self.listArray count]) {
        int createTime = [[[self.listArray objectAtIndex:indexPath.row] objectAtIndex:my_commentlist_commentCreated] intValue];
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:createTime];
        NSDateFormatter *outputFormat = [[NSDateFormatter alloc] init];
        [outputFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString = [outputFormat stringFromDate:date];
        [outputFormat release];
        
        UILabel *time = (UILabel *)[cell.contentView viewWithTag:'t'];
        time.text = [NSString stringWithFormat:@"%@",dateString]; 
        
        UILabel *content = (UILabel *)[cell.contentView viewWithTag:'c'];
        content.text = [[self.listArray objectAtIndex:indexPath.row] objectAtIndex:my_commentlist_commentContent];
        CGSize constraint = CGSizeMake(300.0f, 20000.0f);
		CGSize size = [content.text sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
		float fixHeight = size.height;
		fixHeight = fixHeight == 0 ? 30.f : MAX(fixHeight,30.0f);
        content.frame = CGRectMake(10, 30, 300, fixHeight + 5);
        
        UIImageView *vi = (UIImageView *)[cell.contentView viewWithTag:1];
        vi.frame = CGRectMake(0, CGRectGetMaxY(content.frame), 320, 86);
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0 , CGRectGetMaxY(content.frame) , 320 , 86);
        btn.tag = indexPath.row + 100000;
        [btn addTarget:self action:@selector(didCellAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
        
        UIImageView *cellSeparate = (UIImageView *)[cell.contentView viewWithTag:66];
        cellSeparate.frame = CGRectMake(0, CGRectGetMaxY(vi.frame) + 3, 320, 1);
        
        UILabel *tempTitleLabel = (UILabel *)[cell.contentView viewWithTag:11];
        tempTitleLabel.text = [[self.listArray objectAtIndex:indexPath.row] objectAtIndex:my_commentlist_title];
        
        UILabel *tempPriceLabel = (UILabel *)[cell.contentView viewWithTag:22];
        UILabel *tempOriginalLabel = (UILabel *)[cell.contentView viewWithTag:33];
        UILabel *tempLikeLabel = (UILabel *)[cell.contentView viewWithTag:44];
        UILabel *tempCommentLabel = (UILabel *)[cell.contentView viewWithTag:55];
        UIView *tempLineView = (UIView *)[cell.contentView viewWithTag:333];
        
        //价格判断
        if ([[[self.listArray objectAtIndex:indexPath.row] objectAtIndex:my_commentlist_promotion_price] intValue] != 0 && [[[self.listArray objectAtIndex:indexPath.row] objectAtIndex:my_commentlist_price] length] > 0) 
        {
            //有优惠价格
            tempPriceLabel.hidden = NO;
            tempOriginalLabel.hidden = NO;
            tempLineView.hidden = NO;
            
            NSString *priceString = [NSString stringWithFormat:@"￥%@",[[self.listArray objectAtIndex:indexPath.row] objectAtIndex:my_commentlist_promotion_price]];
            CGSize constraint = CGSizeMake(20000.0f, 20.0f);
            CGSize size = [priceString sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            CGFloat fixWidth = (size.width + 5.0f) > 60.0f ? 60.0f : (size.width + 5.0f);
            
            tempPriceLabel.frame = CGRectMake( tempPriceLabel.frame.origin.x, tempPriceLabel.frame.origin.y , fixWidth , tempPriceLabel.frame.size.height) ;
            
            
            NSString *originalString = [NSString stringWithFormat:@"/ ￥%@",[[self.listArray objectAtIndex:indexPath.row] objectAtIndex:my_commentlist_price]];
            
            CGSize constraint1 = CGSizeMake(20000.0f, 20.0f);
            CGSize size1 = [originalString sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:constraint1 lineBreakMode:UILineBreakModeWordWrap];
            CGFloat fixWidth1 = (size1.width + 5.0f) > 60.0f ? 60.0f : (size1.width + 5.0f);
            
            tempOriginalLabel.frame = CGRectMake( CGRectGetMaxX(tempPriceLabel.frame),tempOriginalLabel.frame.origin.y , fixWidth1 , tempOriginalLabel.frame.size.height) ;
            
            tempLineView.frame = CGRectMake( CGRectGetMaxX(tempPriceLabel.frame) + 5.0f, tempLineView.frame.origin.y , fixWidth1 - 12.0f , tempLineView.frame.size.height) ;
            
            tempPriceLabel.text = priceString;
            tempOriginalLabel.text = originalString;
        }
        else
        {
            //没有优惠价格
            tempOriginalLabel.hidden = YES;
            tempLineView.hidden = YES;
            
            NSString *priceString = [NSString stringWithFormat:@"￥%@",[[self.listArray objectAtIndex:indexPath.row] objectAtIndex:my_commentlist_price]];
            
            CGSize constraint = CGSizeMake(20000.0f, 20.0f);
            CGSize size = [priceString sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            CGFloat fixWidth = (size.width + 5.0f) > 120.0f ? 120.0f : (size.width + 5.0f);
            
            tempPriceLabel.frame = CGRectMake( tempPriceLabel.frame.origin.x,tempPriceLabel.frame.origin.y , fixWidth , tempPriceLabel.frame.size.height) ;
            
            tempPriceLabel.text = priceString;
            tempOriginalLabel.text = @"";
        }
        
        //喜欢
        tempLikeLabel.text = [[self.listArray objectAtIndex:indexPath.row] objectAtIndex:my_commentlist_likes];
        
        //评论
        tempCommentLabel.text = [[self.listArray objectAtIndex:indexPath.row] objectAtIndex:my_commentlist_comment_num];
        
        //图片
        NSString *picUrl = [[self.listArray objectAtIndex:indexPath.row] objectAtIndex:my_commentlist_pic];
        NSString *picName = [Common encodeBase64:(NSMutableData *)[picUrl dataUsingEncoding: NSUTF8StringEncoding]];
        UIImageView *tempPicView = (UIImageView *)[cell.contentView viewWithTag:10];
        
        if (picUrl.length > 1) 
        {
            UIImage *pic = [[FileManager getPhoto:picName] fillSize:CGSizeMake(picWidth, picHeight)];
            if (pic.size.width > 2)
            {
                tempPicView.image = pic;
            }
            else
            {
                UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品列表默认图片" ofType:@"png"]];
                tempPicView.image = [defaultPic fillSize:CGSizeMake(picWidth, picHeight)];
                
                if (tableView.dragging == NO && tableView.decelerating == NO)
                {
                    [self startIconDownload:picUrl forIndex:indexPath];
                }
            }
        }
        else
        {
            UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品列表默认图片" ofType:@"png"]];
            tempPicView.image = [defaultPic fillSize:CGSizeMake(picWidth, picHeight)];
        }
    }
    
	return cell;	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
	UITableViewCell *cell = (UITableViewCell *)[self.myTableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
	
    if (iconDownloader != nil)
    {
		if(iconDownloader.cardIcon.size.width > 2.0){ 			
			UIImage *photo = iconDownloader.cardIcon;
			
            NSString *imageurl = [[self.listArray objectAtIndex:iconDownloader.indexPathInTableView.row] objectAtIndex:my_commentlist_pic];
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

#pragma mark -------private methods
- (void)accessMoreService
{
    int _infoId = [[[self.listArray objectAtIndex:[self.listArray count] - 1] objectAtIndex:my_commentlist_info_id] intValue];
    NSMutableDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [Common getSecureString],@"keyvalue",
                                        [NSNumber numberWithInt: SITE_ID],@"site_id",
                                        [NSNumber numberWithInt:[self.userId intValue]],@"user_id",
                                        [NSNumber numberWithInt: _infoId],@"info_id",
                                        [NSNumber numberWithInt: 1],@"type",nil];
    
    [[DataManager sharedManager] accessService:jsontestDic command:MEMBER_COMMENTMORELIST_COMMAND_ID accessAdress:@"comment/mycommentList.do?param=%@" delegate:self withParam:jsontestDic];
}

- (void)accessService
{
    self.type = @"1";
    
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
                                        [NSNumber numberWithInt:[self.userId intValue]],@"user_id",
                                        [NSNumber numberWithInt:1],@"type",nil];
    
    [[DataManager sharedManager] accessService:jsontestDic command:MEMBER_COMMENTLIST_COMMAND_ID accessAdress:@"comment/mycommentList.do?param=%@" delegate:self withParam:jsontestDic];
}

- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
	NSLog(@"information finish");
    switch (commandid) {
        case MEMBER_COMMENTLIST_COMMAND_ID:
        {
            [self performSelectorOnMainThread:@selector(update:) withObject:resultArray waitUntilDone:NO];
        }
            break;
        case MEMBER_COMMENTMORELIST_COMMAND_ID:
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
    NSLog(@"resultArray=====%@",resultArray);
    self.listArray = resultArray;
    
    if ([self.listArray count] == 0) {
        noLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        noLabel.text = @"暂无商品评价信息";
        noLabel.backgroundColor = [UIColor clearColor];
        noLabel.textColor = [UIColor grayColor];
        noLabel.textAlignment = UITextAlignmentCenter;
        noLabel.font = [UIFont systemFontOfSize:16.0f];
        [self.view addSubview:noLabel];
    }else {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_myTableView];
        UIImage *backgroundImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"表的背景" ofType:@"png"]];
        _myTableView.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    }
    
    [self.myTableView reloadData];
}

- (void)getMoreResult:(NSMutableArray *)resultArray
{
    NSLog(@"resultArray=====%@",resultArray);
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

- (void)didCellAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSMutableArray *array = [self.listArray objectAtIndex:btn.tag - 100000];
    int status = [[array objectAtIndex:my_commentlist_status] intValue];
    if (status == 1)
    {
        NSMutableArray *productArray = [[NSMutableArray alloc]init];
        NSMutableArray *infoArray = [[NSMutableArray alloc]init];
        [infoArray addObject:[array objectAtIndex:my_commentlist_id]];
        [infoArray addObject:[array objectAtIndex:my_commentlist_cat_id]];
        [infoArray addObject:[array objectAtIndex:my_commentlist_title]];
        [infoArray addObject:[array objectAtIndex:my_commentlist_content]];
        [infoArray addObject:[array objectAtIndex:my_commentlist_promotion_price]];
        [infoArray addObject:[array objectAtIndex:my_commentlist_price]];
        [infoArray addObject:[array objectAtIndex:my_commentlist_likes]];
        [infoArray addObject:[array objectAtIndex:my_commentlist_favorites]];
        [infoArray addObject:[array objectAtIndex:my_commentlist_unit]];
        [infoArray addObject:[array objectAtIndex:my_commentlist_salenum]];
        [infoArray addObject:[array objectAtIndex:my_commentlist_comment_num]];
        [infoArray addObject:[array objectAtIndex:my_commentlist_sort_order]];
        [infoArray addObject:[array objectAtIndex:my_commentlist_is_big_pic]];
        [infoArray addObject:[array objectAtIndex:my_commentlist_pic]];
        [infoArray addObject:[array objectAtIndex:my_commentlist_pics]];
        
        [productArray addObject:infoArray];
        
        ProductDetailViewController *ProductDetailView = [[ProductDetailViewController alloc] init];
        ProductDetailView.productID = [[array objectAtIndex:my_commentlist_id] intValue];
        [self.myCommentView.navigationController pushViewController:ProductDetailView animated:YES];
        [ProductDetailView release];
    }
    else
    {
        [alertView showAlert:@"商品已下架"];
    }
}
@end
