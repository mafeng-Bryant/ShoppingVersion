//
//  lotteryViewController.h
//  shopping
//
//  Created by lai yun on 13-1-25.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h> 
#import <CoreFoundation/CoreFoundation.h>  
#import <QuartzCore/QuartzCore.h>
#import "IconDownLoader.h"
#import "DataManager.h"
#import "myImageView.h"
#import "scrollImageView.h"
#import "LoginViewController.h"

@interface lotteryViewController : UIViewController<CommandOperationDelegate,IconDownloaderDelegate,myImageViewDelegate,scrollImageDelegate,LoginViewDelegate>
{
    NSString *lotteryID;
	NSMutableArray *lotteryArray;
	NSMutableArray *lotteryPicArray;
    NSMutableDictionary *imageDownloadsInProgress;
	NSMutableArray *imageDownloadsInWaiting;
    myImageView *picView;
    UILabel *timeLabel;
    UIImageView *statusImageView;
    UIView *lotteryResultView;
    UILabel *tipsLabel;
    UIImageView *shakeImageView;
    UIImageView *resultImageView;
    UILabel *resultLabel;
    CGFloat picWidth;
    CGFloat picHeight;
    int startTime;
    int endTime;
    scrollImageView *scrollImage1;
    scrollImageView *scrollImage2;
    scrollImageView *scrollImage3;
    AVAudioPlayer *scrollingPlayer;
    AVAudioPlayer *scrolledPlayer;
    BOOL isScrolling;
    NSString *userId;
    NSString *userName;
    int LotterySurplusCount;
    int assignUserRandIndex;
    int assignUserShakeTime;
    BOOL isWinUser;
    BOOL isAssignUser;
    BOOL isMyPrizeLogin;
}

@property(nonatomic,retain) NSString *lotteryID;
@property(nonatomic,retain) NSMutableArray *lotteryArray;
@property(nonatomic,retain) NSMutableArray *lotteryPicArray;
@property(nonatomic,retain) NSMutableArray *imageDownloadsInWaiting;
@property(nonatomic,retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, retain) myImageView *picView;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UIImageView *statusImageView;
@property (nonatomic, retain) UIView *lotteryResultView;
@property (nonatomic, retain) UILabel *tipsLabel;
@property (nonatomic, retain) UIImageView *shakeImageView;
@property (nonatomic, retain) UIImageView *resultImageView;
@property (nonatomic, retain) UILabel *resultLabel;
@property (nonatomic, retain) scrollImageView *scrollImage1;
@property (nonatomic, retain) scrollImageView *scrollImage2;
@property (nonatomic, retain) scrollImageView *scrollImage3;
@property (nonatomic, retain) AVAudioPlayer *scrollingPlayer;
@property (nonatomic, retain) AVAudioPlayer *scrolledPlayer;
@property(nonatomic,retain) NSString *userId;
@property(nonatomic,retain) NSString *userName;

//开始倒计时 改变状态
-(void)countdown;

//设置倒计时时间
-(NSString *)mackCountdownDateString:(int)currentTime;

//抽奖
-(void)doLottery;

//滚动
-(void)doScroll:(int)index1 scrollIndex2:(int)index2 scrollIndex3:(int)index3;

//中奖动画
-(void)winAnimation;

//我的奖品
-(void)myPrize;

//抽奖详情
-(void)lotteryDetail;

//保存缓存图片
-(bool)savePhoto:(UIImage*)photo atIndexPath:(NSIndexPath*)indexPath;

//获取网络图片
- (void)startIconDownload:(NSString*)photoURL forIndexPath:(NSIndexPath*)indexPath;

//回调 获到网络图片后的回调函数
- (void)appImageDidLoad:(NSIndexPath *)indexPath withImageType:(int)Type;

//网络获取数据
-(void)accessItemService;

//网络请求回调函数
- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver;

@end
