//
//  recommendViewController.h
//  shopping
//
//  Created by lai yun on 12-12-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "IconDownLoader.h"
#import "DataManager.h"
#import "EGORefreshTableHeaderView.h"
#import "myImageView.h"

@interface recommendViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,CommandOperationDelegate,IconDownloaderDelegate,EGORefreshTableHeaderDelegate,myImageViewDelegate>
{
    UITableView *myTableView;
	NSMutableArray *productItems;
	UIActivityIndicatorView *spinner;
    UILabel *moreLabel;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    BOOL _loadingMore;
    BOOL _isAllowLoadingMore;
    NSMutableDictionary *imageDownloadsInProgress;
	NSMutableArray *imageDownloadsInWaiting;
    CGFloat picWidth;
    CGFloat picHeight;
}

@property(nonatomic,retain) UITableView *myTableView;
@property(nonatomic,retain) NSMutableArray *productItems;
@property(nonatomic,retain) UIActivityIndicatorView *spinner;
@property(nonatomic,retain) UILabel *moreLabel;
@property (nonatomic, assign) BOOL _reloading;
@property (nonatomic, assign) BOOL _loadingMore;
@property(nonatomic,retain) NSMutableArray *imageDownloadsInWaiting;
@property(nonatomic,retain) NSMutableDictionary *imageDownloadsInProgress;

//添加数据表视图
-(void)addTableView;

//滚动loading图片
- (void)loadImagesForOnscreenRows;

//保存缓存图片
-(bool)savePhoto:(UIImage*)photo atIndexPath:(NSIndexPath*)indexPath;

//获取网络图片
- (void)startIconDownload:(NSString*)photoURL forIndexPath:(NSIndexPath*)indexPath;

//回调 获到网络图片后的回调函数
- (void)appImageDidLoad:(NSIndexPath *)indexPath withImageType:(int)Type;

//更新记录
-(void)update;

//更多的操作
-(void)appendTableWith:(NSMutableArray *)data;

//网络获取数据
-(void)accessItemService;

//网络获取更多数据
-(void)accessMoreService;

//回归常态
-(void)backNormal;

//更多回归常态
-(void)moreBackNormal;

//网络请求回调函数
- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver;


@end
