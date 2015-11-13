//
//  imageDetailViewController.h
//  Profession
//
//  Created by siphp on 12-8-14.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myImageView.h"
#import "IconDownLoader.h"
#import "manageActionSheet.h"
#import "weiboSetViewController.h"
#import "TencentViewController.h"

@interface imageDetailViewController : UIViewController <UIScrollViewDelegate,myImageViewDelegate,IconDownloaderDelegate,manageActionSheetDelegate,OauthSinaWeiSuccessDelegate,OauthTencentWeiSuccessDelegate>{
	NSMutableArray *picArray;
	UIScrollView *showPicScrollView;
	int photoWith;
	int photoHigh;
	NSMutableDictionary *imageDownloadsInProgress;
	NSMutableArray *imageDownloadsInWaiting;
    manageActionSheet *actionSheet;
	int chooseIndex;
}

@property(nonatomic,retain) NSMutableArray *picArray;
@property(nonatomic,retain) UIScrollView *showPicScrollView;
@property(nonatomic,retain) NSMutableArray *imageDownloadsInWaiting;
@property(nonatomic,retain) NSMutableDictionary *imageDownloadsInProgress;
@property(nonatomic,retain) manageActionSheet *actionSheet;
@property(nonatomic,assign) int chooseIndex;


//图片展示
-(void)showPic;

//保存缓存图片
-(bool)savePhoto:(UIImage*)photo atIndexPath:(NSIndexPath*)indexPath;

//获取网络图片
- (void)startIconDownload:(NSString*)photoURL forIndexPath:(NSIndexPath*)indexPath;

//回调 获到网络图片后的回调函数
- (void)appImageDidLoad:(NSIndexPath *)indexPath withImageType:(int)Type;

//分享
-(void)share;

@end
