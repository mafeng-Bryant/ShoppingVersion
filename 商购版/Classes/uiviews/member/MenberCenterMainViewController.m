//
//  MenberCenterMainViewController.m
//  shopping
//
//  Created by 来 云 on 12-12-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MenberCenterMainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LoginViewController.h"
#import "DataManager.h"
#import "Encry.h"
#import "Common.h"
#import "FileManager.h"
#import "downloadParam.h"
#import "callSystemApp.h"
#import "imageDownLoadInWaitingObject.h"
#import "UIImageScale.h"
#import "shoppingAppDelegate.h"
#import "MyFavoriteViewController.h"
#import "MyCollectionViewController.h"
#import "MyCommentViewController.h"
#import "MyPrizeViewController.h"
#import "MyDiscountViewController.h"
#import "MyOrdersViewController.h"
#import "MyAddressViewController.h"
#import "EasyReservationViewController.h"

#define kRowHeight 40.0f

@interface MenberCenterMainViewController ()

@end

@implementation MenberCenterMainViewController
@synthesize memberHeaderView;
@synthesize memberName;
@synthesize memberLevel;
@synthesize myTableView = _myTableView;
@synthesize iconDownLoad;
@synthesize imageDownloadsInProgress;
@synthesize imageDownloadsInWaiting;
@synthesize delegate;
@synthesize loginViewController = _loginViewController;

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"抽奖大背景.png"]];
    
	NSMutableDictionary *idip = [[NSMutableDictionary alloc]init];
	self.imageDownloadsInProgress = idip;
	[idip release];
	
	NSMutableArray *wait = [[NSMutableArray alloc]init];
	self.imageDownloadsInWaiting = wait;
	[wait release];
    
    [self addTopView];
    
    [self addBottomView];
}

- (void)addTopView
{
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 120)];
    topView.backgroundColor = [UIColor clearColor];
    topView.userInteractionEnabled = YES;
    [self.view addSubview:topView];
    
    UIImage *newsimage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"会员中心默认头像" ofType:@"png"]];
    UIImageView *coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, topView.frame.size.height - 30 - 47, 60, 60)];
    coverImageView.image = newsimage;
    coverImageView.userInteractionEnabled = YES;
    coverImageView.layer.masksToBounds = YES;
    coverImageView.layer.cornerRadius = 30;
    [newsimage release];
    self.memberHeaderView = coverImageView;
    [self.view addSubview:memberHeaderView];
	[coverImageView release];
    
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeImage)];
	[memberHeaderView addGestureRecognizer:tapGesture];
	tapGesture.delegate = self;
	[tapGesture release];
//    UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    headerBtn.frame = CGRectMake(10, 50, 60, 60);
//    [headerBtn setImage:newsimage forState:UIControlStateNormal];
//    [headerBtn addTarget:self action:@selector(changeImage) forControlEvents:UIControlStateNormal];
//    headerBtn.layer.masksToBounds = YES;
//    headerBtn.layer.cornerRadius = 30;
//    [topView addSubview:headerBtn];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(80, topView.frame.size.height - 30 - 47, 200, 30)];
    name.text = @"";
    name.tag = 100;
    name.textColor = [UIColor whiteColor];
    name.font = [UIFont systemFontOfSize:18.0f];
    name.textAlignment = UITextAlignmentLeft;
    name.backgroundColor = [UIColor clearColor];
    [topView addSubview:name];
    [name release];
    
    UIImage *btnBgImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"个人中心头部背景" ofType:@"png"]];
    UIImageView *btnBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, topView.frame.size.height - btnBgImage.size.height, btnBgImage.size.width, btnBgImage.size.height)];
    btnBgView.image = btnBgImage;
    btnBgView.userInteractionEnabled = YES;
    [topView addSubview:btnBgView];
    [btnBgImage release];
    
    NSArray *imageNameArr = [[NSArray alloc] initWithObjects:@"icon_喜欢_白色",@"icon_收藏_白色",@"icon_评论_白色", nil];
    NSArray *strArr = [[NSArray alloc] initWithObjects:@"我的喜欢",@"我的收藏",@"我的评论", nil];
    for (int i = 0; i < [imageNameArr count]; i ++) {
        UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[imageNameArr objectAtIndex:i] ofType:@"png"]];
        
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(112 + i * img.size.width + i * 64 , 6, img.size.width, img.size.height)];
        view.image = img;
        [btnBgView addSubview:view];
        [img release];
        [view release];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80 + i * 80, CGRectGetMaxY(view.frame), 80, 25)];
		label.text = [strArr objectAtIndex:i];
        label.textColor = [UIColor whiteColor];
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textAlignment = UITextAlignmentCenter;
		label.backgroundColor = [UIColor clearColor];
		[btnBgView addSubview:label];
        [label release];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i + 1;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(80 + i * 80, 0, 80, 47);
        [btnBgView addSubview:btn];
    }
    [btnBgView release];
}

- (void)addBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), 320, self.view.frame.size.height - CGRectGetMaxY(topView.frame) - 44)];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.userInteractionEnabled = YES;
    [self.view addSubview:bottomView];
    
    UIImage *btnPrizeImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"我的奖品" ofType:@"png"]];
	UIButton *prizeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	prizeButton.frame = CGRectMake(10, 10, btnPrizeImage.size.width, btnPrizeImage.size.height);
    prizeButton.tag = 4;
	[prizeButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
	[prizeButton setImage:btnPrizeImage forState:UIControlStateNormal];
	[bottomView addSubview:prizeButton];
	[btnPrizeImage release];
    
    UIImage *btnDiscountImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"我的优惠券" ofType:@"png"]];
	UIButton *discountButton = [UIButton buttonWithType:UIButtonTypeCustom];
	discountButton.frame = CGRectMake(CGRectGetMaxX(prizeButton.frame) + 6, 10, btnDiscountImage.size.width, btnDiscountImage.size.height);
    discountButton.tag = 5;
	[discountButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
	[discountButton setImage:btnDiscountImage forState:UIControlStateNormal];
	[bottomView addSubview:discountButton];
	[btnDiscountImage release];
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(prizeButton.frame), 320, 160) style:UITableViewStyleGrouped];
	_myTableView.delegate = self;
	_myTableView.dataSource = self;
	_myTableView.rowHeight = kRowHeight;
	_myTableView.scrollEnabled = NO;
	_myTableView.backgroundColor = [UIColor clearColor];
    _myTableView.backgroundView = nil;
    [bottomView addSubview:_myTableView];
    
    [bottomView release];
}

- (void)viewAppearAction{
	NSArray *dbArray = [DBOperate queryData:T_MEMBER_INFO theColumn:nil theColumnValue:nil withAll:YES];
	if ([dbArray count] != 0) {
		NSArray *ay = [dbArray objectAtIndex:0];
		
		UILabel *name = (UILabel *)[self.view viewWithTag:100];
		NSString *nameStr = [ay objectAtIndex:member_info_name];
		name.text = nameStr;
        
        NSString *piclink = [ay objectAtIndex:member_info_image];
        NSString *photoname = [Common encodeBase64:(NSMutableData *)[piclink dataUsingEncoding: NSUTF8StringEncoding]];
        UIImage *img = [FileManager getPhoto:photoname];
        if (img != nil) {
            memberHeaderView.image = img;
            
            shoppingAppDelegate *deleagte = (shoppingAppDelegate *)[UIApplication sharedApplication].delegate;
            deleagte.headerImage = img;
        }else {
            UIImage *newsimage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"会员中心默认头像" ofType:@"png"]];
            memberHeaderView.image = newsimage;
            if (piclink.length > 0) {
                [self startIconDownload:piclink forIndex:[NSIndexPath indexPathForRow:0 inSection:0]];
            }
        }
	}
}

- (void)dealloc {
	[memberHeaderView release];
	[memberName release];
	[memberLevel release];
    [topView release];
    [_myTableView release];
	[_loginViewController release];
	[imageDownloadsInWaiting release];
	[imageDownloadsInProgress release];
	
	memberHeaderView = nil;
	memberName = nil;
	memberLevel = nil;
	_loginViewController = nil;
	delegate = nil;
	imageDownloadsInWaiting = nil;
	imageDownloadsInProgress = nil;
    [super dealloc];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
    
    //ios7新特性,解决分割线短一点
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];	
        
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		switch (indexPath.row) {
            case 0:
            {
                //图标
                UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_我的订单" ofType:@"png"]];
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, img.size.width, img.size.height)];
                imageView.image = img;
                [cell.contentView addSubview:imageView];
                [img release];
                
                //标题
                UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 10, 10, 100, 20)];
                title.backgroundColor = [UIColor clearColor];
                title.font = [UIFont systemFontOfSize:16];
                title.textColor = [UIColor darkGrayColor];
                title.text = @"我的订单";
                [cell.contentView addSubview:title];
                [title release];
				                
            }break;
            case 1:
            {
                //图标
                UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_我的常用地址" ofType:@"png"]];
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, img.size.width, img.size.height)];
                imageView.image = img;
                [cell.contentView addSubview:imageView];
                [img release];
                
                //标题
                UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 10, 10, 100, 20)];
                title.backgroundColor = [UIColor clearColor];
                title.font = [UIFont systemFontOfSize:16];
                title.textColor = [UIColor darkGrayColor];
                title.text = @"我的常用地址";
                [cell.contentView addSubview:title];
                [title release];                                
            }break;
            case 2:
            {
                //图标
                UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_轻松购" ofType:@"png"]];
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, img.size.width, img.size.height)];
                imageView.image = img;
                [cell.contentView addSubview:imageView];
                [img release];
                
                //标题
                UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) +10, 10, 100, 20)];
                title.backgroundColor = [UIColor clearColor];
                title.font = [UIFont systemFontOfSize:16];
                title.textColor = [UIColor darkGrayColor];
                title.text = @"轻松购";
                [cell.contentView addSubview:title];
                [title release];
            }break;
                
            default:
                break;
        }
        
        CGFloat xValue = IOS_VERSION < 7.0 ? 280.0f : 290.0f;
        UIImage *rimg = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"右箭头" ofType:@"png"]];
        UIImageView *rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(xValue, (40 - rimg.size.height) * 0.5, 16, 11)];
        rightImage.image = rimg;
        [rimg release];
        [cell.contentView addSubview:rightImage];
        [rightImage release];
		
    }
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int _userId = [[[[DBOperate queryData:T_MEMBER_INFO theColumn:nil theColumnValue:nil withAll:YES] objectAtIndex:0] objectAtIndex:member_info_memberId] intValue];
    
    switch (indexPath.row) {
        case 0:
        {
            MyOrdersViewController *orders = [[MyOrdersViewController alloc] init];
            orders.userId = [NSString stringWithFormat:@"%d",_userId];
			[_loginViewController.navigationController pushViewController:orders animated:YES];
			[orders release];
        }
            break;
        case 1:
        {
            MyAddressViewController *address = [[MyAddressViewController alloc] init];
            address._isHidden = YES;
            address.fromType = FromTypeMy;
            address.userId = [NSString stringWithFormat:@"%d",_userId];
			[_loginViewController.navigationController pushViewController:address animated:YES];
			[address release];
        }
            break;
        case 2:
        {
            EasyReservationViewController *reservation = [[EasyReservationViewController alloc] init];
            reservation.userId = [NSString stringWithFormat:@"%d",_userId];
			[_loginViewController.navigationController pushViewController:reservation animated:YES];
			[reservation release];
        }
            break;
        default:
            break;
    }
}

#pragma mark ----UIActionSheetDelegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [delegate actionButtonIndex:buttonIndex imageView:self.memberHeaderView];
}

#pragma mark ---- loadImage Method
- (void)startIconDownload:(NSString*)imageURL forIndex:(NSIndexPath*)index
{
	IconDownLoader *iconDownloader = [imageDownloadsInProgress objectForKey:index];
    if (iconDownloader == nil && imageURL != nil && imageURL.length > 1) 
    {
		if ([imageDownloadsInProgress count] >= DOWNLOAD_IMAGE_MAX_COUNT) {
            imageDownLoadInWaitingObject *one = [[imageDownLoadInWaitingObject alloc]init:imageURL withIndexPath:index withImageType:CUSTOMER_PHOTO];
            [imageDownloadsInWaiting addObject:one];
            [one release];
            return;
        }
        
        IconDownLoader *iconDownloader = [[IconDownLoader alloc] init];
        iconDownloader.downloadURL = imageURL;
        iconDownloader.indexPathInTableView = index;
        iconDownloader.imageType = CUSTOMER_PHOTO;
        iconDownloader.delegate = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:index];
        [iconDownloader startDownload];
        [iconDownloader release];   
	}    	
}

- (void)appImageDidLoad:(NSIndexPath *)indexPath withImageType:(int)Type
{
	IconDownLoader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        NSLog(@"===%f",iconDownloader.cardIcon.size.width);
		if(iconDownloader.cardIcon.size.width>2.0)
		{ 
			//保存图片
			//UIImage *photo = iconDownloader.cardIcon;
			UIImage *photo = [iconDownloader.cardIcon fillSize:CGSizeMake(60, 60)];
			NSString *imageUrl = [[[DBOperate queryData:T_MEMBER_INFO theColumn:nil theColumnValue:nil withAll:YES] objectAtIndex:0] objectAtIndex:member_info_image];
            NSString *photoname = [Common encodeBase64:(NSMutableData *)[imageUrl dataUsingEncoding: NSUTF8StringEncoding]];
			
            [FileManager savePhoto:photoname withImage:photo];
//			if ([FileManager savePhoto:photoname withImage:photo]) {
//				[DBOperate updateWithTwoConditions:T_MEMBER_INFO theColumn:@"imageName" theColumnValue:photoname ColumnOne:@"memberId" valueOne:userId columnTwo:@"memberName" valueTwo:name];
//			}
			
			memberHeaderView.image = photo;
            
            shoppingAppDelegate *deleagte = (shoppingAppDelegate *)[UIApplication sharedApplication].delegate;
			deleagte.headerImage = photo;
		}
		
		[imageDownloadsInProgress removeObjectForKey:indexPath];
		if ([imageDownloadsInWaiting count] > 0) {
			imageDownLoadInWaitingObject *one = [imageDownloadsInWaiting objectAtIndex:0];
			[self startIconDownload:one.imageURL forIndex:one.indexPath];
			[imageDownloadsInWaiting removeObjectAtIndex:0];
		}	
    }	
}

#pragma mark-----private methods
- (void)btnAction:(id)sender
{
    int _userId = [[[[DBOperate queryData:T_MEMBER_INFO theColumn:nil theColumnValue:nil withAll:YES] objectAtIndex:0] objectAtIndex:member_info_memberId] intValue];
    
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 1:
        {
            MyFavoriteViewController *favorite = [[MyFavoriteViewController alloc] init];
            favorite.userId = [NSString stringWithFormat:@"%d",_userId];;
            [_loginViewController.navigationController pushViewController:favorite animated:YES];
			[favorite release];
        }
            break;
        case 2:
        {
            MyCollectionViewController *collect = [[MyCollectionViewController alloc] init];
            [_loginViewController.navigationController pushViewController:collect animated:YES];
			[collect release];
        }
            break;
        case 3:
        {
            MyCommentViewController *comment = [[MyCommentViewController alloc] init];
            comment.userId = [NSString stringWithFormat:@"%d",_userId];
            [_loginViewController.navigationController pushViewController:comment animated:YES];
			[comment release];
        }
            break;
        case 4:
        {
            MyPrizeViewController *prize = [[MyPrizeViewController alloc] init];
            prize.userId = [NSString stringWithFormat:@"%d",_userId];
            [_loginViewController.navigationController pushViewController:prize animated:YES];
			[prize release];
        }
            break;
        case 5:
        {
            MyDiscountViewController *discount = [[MyDiscountViewController alloc] init];
            discount.userId = [NSString stringWithFormat:@"%d",_userId];
            [_loginViewController.navigationController pushViewController:discount animated:YES];
			[discount release];
        }
            break;
            
        default:
            break;
    }
}

- (void)changeImage
{
	UIActionSheet *action=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中上传", nil];
    [action showInView:((shoppingAppDelegate *)[UIApplication sharedApplication].delegate).window];
	[action release];
}
@end
