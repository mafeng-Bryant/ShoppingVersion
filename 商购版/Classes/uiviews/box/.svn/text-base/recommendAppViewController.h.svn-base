//
//  recommendAppViewController.h
//  Profession
//
//  Created by MC374 on 12-11-10.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "IconDownLoader.h"
#import "DataManager.h"
#import "myImageView.h"

@interface recommendAppViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,IconDownloaderDelegate,CommandOperationDelegate,myImageViewDelegate> {
	UITableView *myTableView;
	NSMutableArray *recommendAppItems;
    NSMutableArray *recommendAppAdItems;
	int photoWith;
	int photoHigh;
    CGFloat bannerWidth;
    CGFloat bannerHeight;
	NSMutableDictionary *imageDownloadsInProgress;
	NSMutableArray *imageDownloadsInWaiting;
	UIActivityIndicatorView *spinner;
    UILabel *moreLabel;
    BOOL _loadingMore;
    BOOL _isAllowLoadingMore;
}

@property(nonatomic,retain) UITableView *myTableView;
@property(nonatomic,retain) NSMutableArray *recommendAppItems;
@property(nonatomic,retain) NSMutableArray *recommendAppAdItems;
@property(nonatomic,retain) NSMutableArray *imageDownloadsInWaiting;
@property(nonatomic,retain) NSMutableDictionary *imageDownloadsInProgress;
@property(nonatomic,retain) UIActivityIndicatorView *spinner;
@property(nonatomic,retain) UILabel *moreLabel;

//添加数据表视图
-(void)addTableView;

//滚动loading图片
- (void)loadImagesForOnscreenRows;

//获取图片链接
-(NSString*)getPhotoURL:(NSIndexPath *)indexPath;

//获取本地缓存的图片
-(UIImage*)getPhoto:(NSIndexPath *)indexPath;

//保存缓存图片
-(bool)savePhoto:(UIImage*)photo atIndexPath:(NSIndexPath*)indexPath;

//获取网络图片
- (void)startIconDownload:(NSString*)photoURL forIndexPath:(NSIndexPath*)indexPath;

//回调 获到网络图片后的回调函数
- (void)appImageDidLoad:(NSIndexPath *)indexPath withImageType:(int)Type;

//网络获取数据
-(void)accessItemService;

//网络获取更多数据
-(void)accessMoreService;

//更新推荐应用的操作
-(void)updateRecommendApp;

//更多的操作
-(void)appendTableWith:(NSMutableArray *)data;

//更多回归常态
-(void)moreBackNormal;

//网络请求回调函数
- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver;

@end
