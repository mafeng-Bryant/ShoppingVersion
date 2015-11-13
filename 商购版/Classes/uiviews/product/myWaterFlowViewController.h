//
//  myWaterFlowViewController.h
//  myWaterFlow
//
//  Created by siphp on 12-12-14.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "myImageView.h"
#import "IconDownLoader.h"
#import "DataManager.h"

enum big_array {
    big_product_is_big_pic,
    big_product_row,
    big_product_info
};

enum small_array {
    small_product_is_big_pic,
    small_product_row1,
    small_product_info1,
    small_product_row2,
    small_product_info2,
};

@interface myWaterFlowViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate,myImageViewDelegate,CommandOperationDelegate,IconDownloaderDelegate>
{
    UITableView *myTableView;
	NSMutableArray *productItems;
    NSMutableArray *tableItems;
	UIActivityIndicatorView *spinner;
    UILabel *moreLabel;
    EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
    BOOL _loadingMore;
    BOOL _isAllowLoadingMore;
    NSMutableDictionary *imageDownloadsInProgress;
	NSMutableArray *imageDownloadsInWaiting;
    NSString *currentCatId;
    CGFloat myTableViewHeight;
}

@property(nonatomic,retain) UITableView *myTableView;
@property(nonatomic,retain) NSMutableArray *productItems;
@property(nonatomic,retain) NSMutableArray *tableItems;
@property(nonatomic,retain) UIActivityIndicatorView *spinner;
@property(nonatomic,retain) UILabel *moreLabel;
@property (nonatomic, assign) BOOL _reloading;
@property (nonatomic, assign) BOOL _loadingMore;
@property(nonatomic,retain) NSMutableArray *imageDownloadsInWaiting;
@property(nonatomic,retain) NSMutableDictionary *imageDownloadsInProgress;
@property(nonatomic,retain) NSString *currentCatId;
@property (nonatomic, assign) CGFloat myTableViewHeight;

//显示瀑布流
-(void)showWaterFlowView;

//添加数据表视图
-(void)addTableView;

//转化tableView 数据
-(void)makeTableItems;

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

