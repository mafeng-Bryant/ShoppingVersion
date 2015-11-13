//
//  historyViewController.m
//  history
//
//  Created by siphp on 13-01-05.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "historyViewController.h"
#import "Common.h"
#import "DBOperate.h"
#import "UIImageScale.h"
#import "FileManager.h"
#import "downloadParam.h"
#import "imageDownLoadInWaitingObject.h"
#import "productTableCellViewController.h"
#import "ProductDetailViewController.h"
#import "newsCellViewController.h"
#import "newsDetailViewController.h"

@implementation historyViewController

@synthesize myTableView;
@synthesize productItems;
@synthesize imageDownloadsInProgress;
@synthesize imageDownloadsInWaiting;

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BG_IMAGE]];
    
    self.title = @"历史记录";
    
    NSMutableArray *tempProductItems = [[NSMutableArray alloc] init];
	self.productItems = tempProductItems;
	[tempProductItems release];
    
    NSMutableDictionary *idip = [[NSMutableDictionary alloc]init];
	self.imageDownloadsInProgress = idip;
	[idip release];
	
	NSMutableArray *wait = [[NSMutableArray alloc]init];
	self.imageDownloadsInWaiting = wait;
	[wait release];

    picWidth = 70.0f;
    picHeight = 70.0f;
    
    imgWidth = 76.0f;
    imgHeight = 56.0f;
    
    //清空按钮
//    UIImage *cancelImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"云拍取消按钮" ofType:@"png"]];
//	UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//	cancelButton.frame = CGRectMake( 0.0f , 0.0f , 55.0f , 40.0f);
//	[cancelButton addTarget:self action:@selector(delHistory) forControlEvents:UIControlEventTouchUpInside];
//    [cancelButton setBackgroundImage:cancelImage forState:UIControlStateNormal];
//    [cancelImage release];
//    [cancelButton setTitle:@"清空" forState:UIControlStateNormal];
//    cancelButton.titleLabel.textAlignment = UITextAlignmentCenter;
//    cancelButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0f];
//    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton]; 
//    self.navigationItem.rightBarButtonItem = cancelItem;
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStyleBordered target:self action:@selector(delHistory)];
    self.navigationItem.rightBarButtonItem = cancelItem;
    [cancelItem release];
    
    NSArray *imageArr = [[NSArray alloc] initWithObjects:@"切换标签1.png",@"切换标签2.png",nil];
    segmentView = [[CustomSegment alloc] initWithSelectedImgArray:imageArr point:CGPointMake(0, 0)titleArray:[NSArray arrayWithObjects:@"商品",@"资讯", nil]];
    segmentView.delegate = self;
    [self.view addSubview:segmentView];
    [segmentView setSelectedIndex:0];
    
    
//    //增加的遮盖图层
//    UIImage *coverImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"上bar底部遮盖" ofType:@"png"]];
//    UIImageView *coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f , 0.0f , coverImage.size.width , coverImage.size.height)];
//    coverImageView.image = coverImage;
//    [coverImage release];
//    [self.view addSubview:coverImageView];
//	[coverImageView release];
    
    //添加表
    [self addTableView];

}

-(void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
}

//添加数据表视图
-(void)addTableView;
{
	UITableView *tempTableView = [[UITableView alloc] initWithFrame:CGRectMake( 0.0f , CGRectGetMaxY(segmentView.frame) , self.view.frame.size.width , VIEW_HEIGHT - 20.0f - CGRectGetMaxY(segmentView.frame) - 44)];
    [tempTableView setDelegate:self];
    [tempTableView setDataSource:self];
    tempTableView.scrollsToTop = YES;
    self.myTableView = tempTableView;
    [tempTableView release];
    self.myTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:myTableView];
    //分割线
    self.myTableView.separatorColor = [UIColor clearColor];
    
}

#pragma mark ------ CustomSegmentDelegate method
- (void)segmentWithIndex:(int)index
{
    //NSLog(@"index====%d",index);
    [self.productItems removeAllObjects];
    if (index == 0) {
        __viewType = ViewTypeProduct;
        //获取数据
        NSMutableArray *item = (NSMutableArray *)[DBOperate queryData:T_HISTORY_PRODUCT theColumn:nil theColumnValue:nil withAll:YES];
        for (int i = [item count] - 1; i < [item count]; i --) {
            [self.productItems addObject:[item objectAtIndex:i]];
        }
        NSLog(@"self.productItems ===== %@",self.productItems);
         [self.myTableView reloadData];
    }else {
        __viewType = ViewTypeNew;
        //获取数据
        NSMutableArray *item = (NSMutableArray *)[DBOperate queryData:T_HISTORY_NEW theColumn:nil theColumnValue:nil withAll:YES];
        for (int i = [item count] - 1; i < [item count]; i --) {
            [self.productItems addObject:[item objectAtIndex:i]];
        }
        [self.myTableView reloadData];
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
            if (__viewType == ViewTypeProduct) {
                productTableCellViewController *productTableCell = (productTableCellViewController *)[self.myTableView cellForRowAtIndexPath:indexPath];
                
                NSArray *productArray = [self.productItems objectAtIndex:[indexPath row]];
                NSString *picUrl = [productArray objectAtIndex:history_product_pic];
                NSString *picName = [Common encodeBase64:(NSMutableData *)[picUrl dataUsingEncoding: NSUTF8StringEncoding]];
                
                if (picUrl.length > 1)
                {
                    UIImage *pic = [[FileManager getPhoto:picName] fillSize:CGSizeMake(picWidth, picHeight)];
                    if (pic.size.width > 2)
                    {
                        productTableCell.picView.image = pic;
                    }
                    else
                    {
                        UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品列表默认图片" ofType:@"png"]];
                        productTableCell.picView.image = [defaultPic fillSize:CGSizeMake(picWidth, picHeight)];
                        
                        if (self.myTableView.dragging == NO && self.myTableView.decelerating == NO)
                        {
                            [self startIconDownload:picUrl forIndexPath:indexPath];
                        }
                    }
                }
                else
                {
                    UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品列表默认图片" ofType:@"png"]];
                    productTableCell.picView.image = [defaultPic fillSize:CGSizeMake(picWidth, picHeight)];
                }
            }else {
                newsCellViewController *newsCell = (newsCellViewController *)[self.myTableView cellForRowAtIndexPath:indexPath];
                
                NSArray *newsArray = [self.productItems objectAtIndex:[indexPath row]];
                NSString *picUrl = [newsArray objectAtIndex:history_new_thumb_pic];
                NSString *picName = [Common encodeBase64:(NSMutableData *)[picUrl dataUsingEncoding: NSUTF8StringEncoding]];
                
                if (picUrl.length > 1)
                {
                    UIImage *pic = [[FileManager getPhoto:picName] fillSize:CGSizeMake(imgWidth, imgHeight)];
                    if (pic.size.width > 2)
                    {
                        newsCell.picView.image = pic;
                    }
                    else
                    {
                        UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"活动资讯列表默认" ofType:@"png"]];
                        newsCell.picView.image = [defaultPic fillSize:CGSizeMake(imgWidth, imgHeight)];
                        
                        if (self.myTableView.dragging == NO && self.myTableView.decelerating == NO)
                        {
                            [self startIconDownload:picUrl forIndexPath:indexPath];
                        }
                    }
                }
                else
                {
                    UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"活动资讯列表默认" ofType:@"png"]];
                    newsCell.picView.image = [defaultPic fillSize:CGSizeMake(imgWidth, imgHeight)];
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
        NSString *picUrl = nil;
        if (__viewType == ViewTypeProduct) {
            picUrl = [productArray objectAtIndex:history_product_pic];
        }else {
            picUrl = [productArray objectAtIndex:history_product_pic];
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
        if (__viewType == ViewTypeProduct) {
            productTableCellViewController *productTableCell = (productTableCellViewController *)[self.myTableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
            
            // Display the newly loaded image
            if(iconDownloader.cardIcon.size.width>2.0)
            {
                //保存图片
                [self savePhoto:iconDownloader.cardIcon atIndexPath:indexPath];
                
                UIImage *pic = [iconDownloader.cardIcon fillSize:CGSizeMake(picWidth, picHeight)];
                productTableCell.picView.image = pic;
            }
        }else {
            newsCellViewController *newsCell = (newsCellViewController *)[self.myTableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
            
            // Display the newly loaded image
            if(iconDownloader.cardIcon.size.width>2.0)
            {
                //保存图片
                [self savePhoto:iconDownloader.cardIcon atIndexPath:indexPath];
                
                UIImage *pic = [iconDownloader.cardIcon fillSize:CGSizeMake(imgWidth, imgHeight)];
                newsCell.picView.image = pic;
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

#pragma mark -
#pragma mark UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0)
    {
        if (__viewType == ViewTypeProduct) {
            [DBOperate deleteData:T_HISTORY_PRODUCT];
            [DBOperate deleteData:T_HISTORY_PRODUCT_PIC];
            [self.productItems removeAllObjects];
            [self.myTableView reloadData];
        }else {
            [DBOperate deleteData:T_HISTORY_NEW];
            [self.productItems removeAllObjects];
            [self.myTableView reloadData];
        }
    }
}

//清空记录
- (void)delHistory
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定要清空记录?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    [alertView show];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.productItems count] == 0)
    {
        return 1;
    }
    else
    {
        return [self.productItems count];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.productItems != nil && [self.productItems count] > 0)
    {
        //记录
        if (__viewType == ViewTypeProduct) {
            return 86.0f;
        }else {
            return 75.0f;
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
        //记录
        CellIdentifier = @"listCell";
        cellType = 1;
    }
    else
    {
        //没有记录
        CellIdentifier = @"noneCell";
        cellType = 0;
    }
	
	cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
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
            if (__viewType == ViewTypeProduct) {
                noneLabel.text = @"您还没有浏览任何商品哦";
            }else {
                noneLabel.text = @"您还没有浏览任何活动资讯哦";
            }
            noneLabel.textAlignment = UITextAlignmentCenter;
            noneLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:noneLabel];
            [noneLabel release];
            
            break;
        }
            //记录
        case 1:
        {
            if (__viewType == ViewTypeProduct) {
                cell = [[[productTableCellViewController alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            }else {
                cell = [[[newsCellViewController alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            }
            
            break;
        }
            
        default:
            break;
    }
    
    cell.backgroundColor = [UIColor clearColor];
	if (cellType == 1)
    {
        if (__viewType == ViewTypeProduct) {
            //数据填充
            NSArray *productArray = [self.productItems objectAtIndex:[indexPath row]];
            
            productTableCellViewController *productTableCell = (productTableCellViewController *)cell;
            
            //标题
            productTableCell.titleLabel.text = [productArray objectAtIndex:product_title];
            
            //价格判断
            if ([[productArray objectAtIndex:history_product_promotion_price] intValue] != 0 && [[productArray objectAtIndex:history_product_promotion_price] length] > 0)
            {
                //有优惠价格
                productTableCell.originalLabel.hidden = NO;
                productTableCell.lineView.hidden = NO;
                
                NSString *priceString = [NSString stringWithFormat:@"￥%@",[productArray objectAtIndex:history_product_promotion_price]];
                CGSize constraint = CGSizeMake(20000.0f, 20.0f);
                CGSize size = [priceString sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
                CGFloat fixWidth = (size.width + 5.0f) > 60.0f ? 60.0f : (size.width + 5.0f);
                
                productTableCell.priceLabel.frame = CGRectMake( productTableCell.priceLabel.frame.origin.x, productTableCell.priceLabel.frame.origin.y , fixWidth , productTableCell.priceLabel.frame.size.height) ;
                
                
                NSString *originalString = [NSString stringWithFormat:@"/ ￥%@",[productArray objectAtIndex:history_product_price]];
                
                CGSize constraint1 = CGSizeMake(20000.0f, 20.0f);
                CGSize size1 = [originalString sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:constraint1 lineBreakMode:UILineBreakModeWordWrap];
                CGFloat fixWidth1 = (size1.width + 5.0f) > 60.0f ? 60.0f : (size1.width + 5.0f);
                
                productTableCell.originalLabel.frame = CGRectMake( CGRectGetMaxX(productTableCell.priceLabel.frame), productTableCell.originalLabel.frame.origin.y , fixWidth1 , productTableCell.originalLabel.frame.size.height) ;
                
                productTableCell.lineView.frame = CGRectMake( CGRectGetMaxX(productTableCell.priceLabel.frame) + 5.0f, productTableCell.lineView.frame.origin.y , fixWidth1 - 12.0f , productTableCell.lineView.frame.size.height) ;
                
                productTableCell.priceLabel.text = priceString;
                productTableCell.originalLabel.text = originalString;
            }
            else
            {
                //没有优惠价格
                productTableCell.originalLabel.hidden = YES;
                productTableCell.lineView.hidden = YES;
                
                NSString *priceString = [NSString stringWithFormat:@"￥%@",[productArray objectAtIndex:history_product_price]];
                
                CGSize constraint = CGSizeMake(20000.0f, 20.0f);
                CGSize size = [priceString sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
                CGFloat fixWidth = (size.width + 5.0f) > 120.0f ? 120.0f : (size.width + 5.0f);
                
                productTableCell.priceLabel.frame = CGRectMake( productTableCell.priceLabel.frame.origin.x, productTableCell.priceLabel.frame.origin.y , fixWidth , productTableCell.priceLabel.frame.size.height) ;
                
                productTableCell.priceLabel.text = priceString;
                productTableCell.originalLabel.text = @"";
            }
            
            //喜欢
            productTableCell.likeLabel.text = [productArray objectAtIndex:history_product_likes];
            
            //评论
            productTableCell.commentLabel.text = [productArray objectAtIndex:history_product_comment_num];
            
            //图片
            NSString *picUrl = [productArray objectAtIndex:history_product_pic];
            NSString *picName = [Common encodeBase64:(NSMutableData *)[picUrl dataUsingEncoding: NSUTF8StringEncoding]];
            
            if (picUrl.length > 1)
            {
                UIImage *pic = [[FileManager getPhoto:picName] fillSize:CGSizeMake(picWidth, picHeight)];
                if (pic.size.width > 2)
                {
                    productTableCell.picView.image = pic;
                }
                else
                {
                    UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品列表默认图片" ofType:@"png"]];
                    productTableCell.picView.image = [defaultPic fillSize:CGSizeMake(picWidth, picHeight)];
                    
                    if (tableView.dragging == NO && tableView.decelerating == NO)
                    {
                        [self startIconDownload:picUrl forIndexPath:indexPath];
                    }
                }
            }
            else
            {
                UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品列表默认图片" ofType:@"png"]];
                productTableCell.picView.image = [defaultPic fillSize:CGSizeMake(picWidth, picHeight)];
            }
            
            return productTableCell;
        }else {
            //数据填充
            NSArray *newsArray = [self.productItems objectAtIndex:[indexPath row]];
            
            newsCellViewController *newsCell = (newsCellViewController *)cell;
            
            //标题
            newsCell.titleLabel.text = [NSString stringWithFormat:@"%@",[newsArray objectAtIndex:history_new_title]];
            
            //描述
            newsCell.descLabel.text = [NSString stringWithFormat:@"%@",[newsArray objectAtIndex:history_new_content]];
            
            if ([[newsArray objectAtIndex:history_new_recommend] intValue] == 1)
            {
                newsCell.recommendImageView.hidden = NO;
            }
            else
            {
                newsCell.recommendImageView.hidden = YES;
            }
            
            //图片
            NSString *picUrl = [newsArray objectAtIndex:history_new_thumb_pic];
            NSString *picName = [Common encodeBase64:(NSMutableData *)[picUrl dataUsingEncoding: NSUTF8StringEncoding]];
            
            if (picUrl.length > 1)
            {
                UIImage *pic = [[FileManager getPhoto:picName] fillSize:CGSizeMake(imgWidth, imgHeight)];
                if (pic.size.width > 2)
                {
                    newsCell.picView.image = pic;
                }
                else
                {
                    UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"活动资讯列表默认" ofType:@"png"]];
                    newsCell.picView.image = [defaultPic fillSize:CGSizeMake(imgWidth, imgHeight)];
                    
                    if (tableView.dragging == NO && tableView.decelerating == NO)
                    {
                        [self startIconDownload:picUrl forIndexPath:indexPath];
                    }
                }
            }
            else
            {
                UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"活动资讯列表默认" ofType:@"png"]];
                newsCell.picView.image = [defaultPic fillSize:CGSizeMake(imgWidth, imgHeight)];
            }
            
            return newsCell;
        }
        
	}
    
    return cell; 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
    int countItems = [self.productItems count];
	
	if (countItems > [indexPath row]) 
    {
        //NSLog(@"---------------%@",[self.productItems objectAtIndex:[indexPath row]]);
        
        if (__viewType == ViewTypeProduct) {
            NSArray *productArray = [self.productItems objectAtIndex:[indexPath row]];
            ProductDetailViewController *ProductDetailView = [[ProductDetailViewController alloc] init];
            ProductDetailView.productID = [[productArray objectAtIndex:history_product_id] intValue];
            [self.navigationController pushViewController:ProductDetailView animated:YES];
            [ProductDetailView release];
        }else {
            NSMutableArray *newArray = [self.productItems objectAtIndex:[indexPath row]];
            newsDetailViewController *newsDetail = [[newsDetailViewController alloc] init];
            newsDetail.detailArray = newArray;
            newsDetail.commentTotal = [NSString stringWithFormat:@"%d",[[newArray objectAtIndex:news_comments] intValue]];
            [self.navigationController pushViewController:newsDetail animated:YES];
            [newsDetail release];
        }
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	//[super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    if (!decelerate)
	{
		[self loadImagesForOnscreenRows];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
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
    for (IconDownLoader *one in [imageDownloadsInProgress allValues]){
		one.delegate = nil;
	}
	self.imageDownloadsInProgress = nil;
	self.imageDownloadsInWaiting = nil;
}


- (void)dealloc {
	self.myTableView.delegate = nil;
	self.myTableView = nil;
    self.productItems = nil;
    for (IconDownLoader *one in [imageDownloadsInProgress allValues]){
		one.delegate = nil;
	}
	self.imageDownloadsInProgress = nil;
	self.imageDownloadsInWaiting = nil;
    [super dealloc];
}

@end
