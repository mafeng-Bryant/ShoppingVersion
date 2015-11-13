//
//  indexViewController.h
//  shopping
//
//  Created by lai yun on 12-12-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "myImageView.h"
#import "IconDownLoader.h"
#import "EGORefreshTableHeaderView.h"
#import "LoginViewController.h"

@protocol indexViewDelegate
@optional
- (void)reSetMainScrollView;
- (void)showRecommendView;
@end

@interface indexViewController : UIViewController<UIScrollViewDelegate,CommandOperationDelegate,myImageViewDelegate,IconDownloaderDelegate,EGORefreshTableHeaderDelegate,UISearchBarDelegate,LoginViewDelegate>
{
    NSObject<indexViewDelegate> *delegate;
    UIActivityIndicatorView *spinner;
    UIScrollView *mainScrollView;
    UIScrollView *bannerScrollView;
    UIPageControl *pageControll;
    UIView *contentView;
    NSArray *adItems;
    NSArray *tagsItems;
    CGFloat bannerWidth;
    CGFloat bannerHeight;
    CGFloat iconWidth;
    CGFloat iconHeight;
    NSMutableDictionary *imageDownloadsInProgress;
	NSMutableArray *imageDownloadsInWaiting;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}

@property (nonatomic, assign) NSObject<indexViewDelegate> *delegate;
@property(nonatomic,retain) UIActivityIndicatorView *spinner;
@property(nonatomic,retain) UIScrollView *mainScrollView;
@property(nonatomic,retain) UIScrollView *bannerScrollView;
@property(nonatomic,retain) UIPageControl *pageControll;
@property(nonatomic,retain) UIView *contentView;
@property(nonatomic,retain) NSArray *adItems;
@property(nonatomic,retain) NSArray *tagsItems;
@property(nonatomic,retain) NSMutableArray *imageDownloadsInWaiting;
@property(nonatomic,retain) NSMutableDictionary *imageDownloadsInProgress;

//添加banner
-(void)addBannerScrollView;

//添加主内容 icon按钮
-(void)addContentView;

//搜索
-(void)search;

//二维码扫描
-(void)goCode;

//历史记录
-(void)history;

//分店地图
-(void)map;

//我的收藏
-(void)favorite;

//活动资讯
-(void)news;

//抽奖
-(void)lottery;

//广告下滑动画
-(void)adDownAnimations;

//自定义按钮
-(void)buttonAction:(id)sender;

//保存缓存图片
-(bool)savePhoto:(UIImage*)photo atIndexPath:(NSIndexPath*)indexPath;

//获取网络图片
- (void)startIconDownload:(NSString*)photoURL forIndexPath:(NSIndexPath*)indexPath;

//回调 获到网络图片后的回调函数
- (void)appImageDidLoad:(NSIndexPath *)indexPath withImageType:(int)Type;

//网络获取数据
-(void)accessItemService;

//更新数据
-(void)update;

//回归常态
-(void)backNormal;

//网络请求回调函数
- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver;

@end
