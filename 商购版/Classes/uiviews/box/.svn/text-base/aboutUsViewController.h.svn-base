//
//  aboutUsViewController.h
//  Profession
//
//  Created by siphp on 12-8-24.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconDownLoader.h"
#import "DataManager.h"

@interface aboutUsViewController : UIViewController<IconDownloaderDelegate,CommandOperationDelegate> {
	UIScrollView *scrollView;
	UIActivityIndicatorView *spinner;
	NSMutableArray *aboutUsItems;
	int logoWith;
	int logoHigh;
	NSMutableDictionary *imageDownloadsInProgress;
	NSMutableArray *imageDownloadsInWaiting;
    NSArray *telArr;
}

@property(nonatomic,retain) UIScrollView *scrollView;
@property(nonatomic,retain) UIActivityIndicatorView *spinner;
@property(nonatomic,retain) NSMutableArray *aboutUsItems;
@property(nonatomic,retain) NSMutableArray *imageDownloadsInWaiting;
@property(nonatomic,retain) NSMutableDictionary *imageDownloadsInProgress;

//拨打电话
-(void)callPhone;

//发送邮件
-(void)sendEmail;

//打开地图
-(void)showMapByCoord;

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

//更新数据的操作
-(void)updateAboutUs;

//网络请求回调函数
- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver;

@end
