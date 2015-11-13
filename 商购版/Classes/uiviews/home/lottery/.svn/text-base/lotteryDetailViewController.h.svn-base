//
//  lotteryDetailViewController.h
//  shopping
//
//  Created by lai yun on 13-1-25.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myImageView.h"
#import "IconDownLoader.h"

@interface lotteryDetailViewController : UIViewController <UIScrollViewDelegate,myImageViewDelegate,IconDownloaderDelegate>{
	NSString *lotteryID;
	NSMutableArray *lotteryArray;
	NSMutableArray *lotteryPicArray;
	float scrollViewHeight;
	UIScrollView *scrollView;
	UIScrollView *showPicScrollView;
	UIPageControl *pageControll;
	int photoWith;
	int photoHigh;
	NSMutableDictionary *imageDownloadsInProgress;
	NSMutableArray *imageDownloadsInWaiting;
}

@property(nonatomic,retain) NSString *lotteryID;
@property(nonatomic,retain) NSMutableArray *lotteryArray;
@property(nonatomic,retain) NSMutableArray *lotteryPicArray;
@property(nonatomic,retain) UIScrollView *showPicScrollView;
@property(nonatomic,retain) UIScrollView *scrollView;
@property(nonatomic,retain) UIPageControl *pageControll;
@property(nonatomic,retain) NSMutableArray *imageDownloadsInWaiting;
@property(nonatomic,retain) NSMutableDictionary *imageDownloadsInProgress;


//图片展示
-(void)showLotteryPic;

//保存缓存图片
-(BOOL)savePhoto:(UIImage*)photo atIndexPath:(NSIndexPath*)indexPath;

//获取网络图片
- (void)startIconDownload:(NSString*)photoURL forIndexPath:(NSIndexPath*)indexPath;

//回调 获到网络图片后的回调函数
- (void)appImageDidLoad:(NSIndexPath *)indexPath withImageType:(int)Type;


@end