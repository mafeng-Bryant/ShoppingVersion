//
//  MoreButtonViewController.m
//  xieHui
//
//  Created by 来 云 on 12-11-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MoreButtonViewController.h"
#import "Common.h"
#import "DataManager.h"
#import "DBOperate.h"
#import "FileManager.h"
#import "imageDownLoadInWaitingObject.h"
#import "Encry.h"
#import "downloadParam.h"
#import "callSystemApp.h"
#import "UIImageScale.h"
#import "imageDetailViewController.h"
@interface MoreButtonViewController ()

@end

@implementation MoreButtonViewController
@synthesize catStr;
@synthesize titleStr;
@synthesize listArray = __listArray;
@synthesize imageDownloadsInProgressDic;
@synthesize imageDownloadsInWaitingArray;
@synthesize iconDownLoad;
@synthesize spinner;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    __listArray = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *idip = [[NSMutableDictionary alloc]init];
	self.imageDownloadsInProgressDic = idip;
	[idip release];
	NSMutableArray *wait = [[NSMutableArray alloc]init];
	self.imageDownloadsInWaitingArray = wait;
	[wait release];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    //添加loading图标
	UIActivityIndicatorView *tempSpinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
	[tempSpinner setCenter:CGPointMake(self.view.frame.size.width / 3, (self.view.frame.size.height - 44.0f) / 2.0)];
	self.spinner = tempSpinner;
	
	UILabel *loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 100, 20)];
	loadingLabel.font = [UIFont systemFontOfSize:14];
	loadingLabel.textColor = [UIColor whiteColor];
	loadingLabel.text = LOADING_TIPS;		
	loadingLabel.textAlignment = UITextAlignmentCenter;
	loadingLabel.backgroundColor = [UIColor clearColor];
	[self.spinner addSubview:loadingLabel];
	[self.view addSubview:self.spinner];
	[self.spinner startAnimating];
	[tempSpinner release];
    
    [self accessService];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    catStr = nil;
    titleStr = nil;
    __listArray = nil;
    for (IconDownLoader *one in [imageDownloadsInProgressDic allValues]){
		one.delegate = nil;
	}
    imageDownloadsInProgressDic = nil;
    imageDownloadsInWaitingArray = nil;
    iconDownLoad = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [catStr release];
    [titleStr release];
    [__listArray release];
    for (IconDownLoader *one in [imageDownloadsInProgressDic allValues]){
		one.delegate = nil;
	}
    [imageDownloadsInProgressDic release];
    [imageDownloadsInWaitingArray release];
    [iconDownLoad release];
    [spinner release];
    [super dealloc];
}

#pragma mark PagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView{
    return CGSizeMake(260, 260);
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(PagedFlowView *)flowView
{
    //NSLog(@"Scrolled to page # %d", pageNumber);
    if (self.listArray != nil && pageNumber >= 0 && pageNumber < [self.listArray count]) {
        NSString *str = [[self.listArray objectAtIndex:pageNumber] objectAtIndex:morecatinfo_desc];
        UILabel *label = (UILabel *)[self.view viewWithTag:300];
        label.text = str;
        
        self.title = [NSString stringWithFormat:@"%@(%d/%d)",titleStr,pageNumber + 1,[self.listArray count]];
    }
}

//返回显示View的个数
- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView{
    return [self.listArray count];
}

//返回给某列使用的View
- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    // NSLog(@"index====%d",index);
    UIImageView *imageView = (UIImageView *)[flowView dequeueReusableCell];
    if (!imageView) {
        imageView = [[UIImageView alloc] init];
    }
    
    if (self.listArray != nil && self.listArray > 0) {
        NSArray *ayArray = [self.listArray objectAtIndex:index];
        
        if (ayArray != nil ) {
            NSString *imageUrl = [ayArray objectAtIndex:morecatinfo_catImageurl];
            //NSString *imageUrl = @"http://demo1.3g.yunlai.cn/userfiles/000/000/101/recent_img/112610324.jpg";
            NSString *imageName = [ayArray objectAtIndex:morecatinfo_catImagename];
    
            UIImage *img = [FileManager getPhoto:imageName];
            if (img != nil) {
                imageView.image = img;
            }else {
                UIImage *bgImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"精品推荐商品默认" ofType:@"png"]];
                imageView.image = bgImage;
                if (imageUrl.length > 0) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:10000 + index inSection:0];
                    [self startIconDownload:imageUrl forIndex:indexPath];
                    imageView.tag = 10000 + index;
                }
            }
        }
    }
    return imageView;
}

//点击事件
- (void)touchViewCellForPageAtIndex:(NSInteger)index
{
    //设置返回本类按钮
    UIBarButtonItem * tempButtonItem = [[ UIBarButtonItem alloc] init]; 
    tempButtonItem.title = titleStr;
    self.navigationItem.backBarButtonItem = tempButtonItem ; 
    [tempButtonItem release];
    
    imageDetailViewController *imageDetail = [[imageDetailViewController alloc] init];			
	imageDetail.picArray = self.listArray;
	imageDetail.chooseIndex = index;
	[self.navigationController pushViewController:imageDetail animated:YES];
	[imageDetail release];
}

#pragma mark ---- loadImage Method
- (void)startIconDownload:(NSString*)imageURL forIndex:(NSIndexPath*)index
{
    //NSLog(@"%@",index);
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
    
    if (iconDownloader != nil)
    {
		if(iconDownloader.cardIcon.size.width > 2.0){ 			
			UIImage *photo = iconDownloader.cardIcon;
            NSArray *one = [self.listArray objectAtIndex:iconDownloader.indexPathInTableView.row - 10000];
            
			NSString *photoname = [callSystemApp getCurrentTime];
			if ([FileManager savePhoto:photoname withImage:photo]) {
				
				NSNumber *value = [one objectAtIndex:morecatinfo_cat_Id];
			    [DBOperate updateData:T_MORE_CATINFO tableColumn:@"imagename" 
						  columnValue:photoname conditionColumn:@"cat_Id" conditionColumnValue:value];
                self.listArray = (NSMutableArray *)[DBOperate queryData:T_MORE_CATINFO theColumn:@"catId" theColumnValue:catStr withAll:NO];
                
			}
            UIImageView *picView = (UIImageView *)[self.view viewWithTag:[indexPath row]];
            picView.image = [photo fillSize:CGSizeMake(260, 260)];
            
		}
		[imageDownloadsInProgressDic removeObjectForKey:indexPath];
		if ([imageDownloadsInWaitingArray count] > 0) {
			imageDownLoadInWaitingObject *one = [imageDownloadsInWaitingArray objectAtIndex:0];
			[self startIconDownload:one.imageURL forIndex:one.indexPath];
			[imageDownloadsInWaitingArray removeObjectAtIndex:0];
		}		
    }
}

#pragma mark ----private methods
- (void)accessService
{
    NSArray *arr = [DBOperate queryData:T_MORE_CAT theColumn:@"version" theColumnValue:self.catStr withAll:NO];
    
    int version = 0;
    if ([arr count] > 0) {
        version = [[[arr objectAtIndex:0] objectAtIndex:morecat_version] intValue];
    }
    
    NSMutableDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
								 [Common getSecureString],@"keyvalue",
                                 [NSNumber numberWithInt: version],@"ver",
								 [NSNumber numberWithInt: SITE_ID],@"site_id",
                                 [NSNumber numberWithInt:[catStr intValue]],@"cat_id",nil];
	
	[[DataManager sharedManager] accessService:jsontestDic command:MORE_CAT_INFO_COMMAND_ID 
								  accessAdress:@"introduceList.do?param=%@" delegate:self withParam:jsontestDic];
}

- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
	NSLog(@"information finish");
    //NSLog(@"resultArray====%@",resultArray);
	switch (commandid) {
		case MORE_CAT_INFO_COMMAND_ID:
		{
            [self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
		}break;
        default:
			break;
	}
}

- (void)update
{
    self.listArray = (NSMutableArray *)[DBOperate queryData:T_MORE_CATINFO theColumn:@"catId" theColumnValue:catStr orderBy:@"sort" orderType:@"DESC" withAll:NO];    
    
    if (self.listArray != nil && [self.listArray count] > 0) {
        PagedFlowView *flowView  = [[PagedFlowView alloc] initWithFrame:CGRectMake(0, 30, 320, 260)];
        flowView.delegate = self;
        flowView.dataSource = self;
        flowView.minimumPageAlpha = 0.3;
        flowView.minimumPageScale = 0.9;
        [self.view addSubview:flowView];
        [flowView release];
        
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(flowView.frame), 240, self.view.frame.size.height - CGRectGetMaxY(flowView.frame) - 15)];
        descLabel.text = @"";
        descLabel.numberOfLines = 0;
        descLabel.font = [UIFont systemFontOfSize:14.0f];
        descLabel.tag = 300;
        descLabel.textAlignment = UITextAlignmentLeft;
        descLabel.textColor = [UIColor whiteColor];
        descLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:descLabel];
        [descLabel release];
        
        descLabel.text = [[self.listArray objectAtIndex:0] objectAtIndex:morecatinfo_desc];
        
        self.title = [NSString stringWithFormat:@"%@(%d/%d)",titleStr,1,[self.listArray count]];;
    }else {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
		label.text = @"没有图片";
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor whiteColor];
		label.textAlignment = UITextAlignmentCenter;
		label.font = [UIFont systemFontOfSize:16.0f];
		[self.view addSubview:label];
		[label release];
        
        self.title = [NSString stringWithFormat:@"%@",titleStr];;
    }
    
    [self.spinner removeFromSuperview];
}
@end
