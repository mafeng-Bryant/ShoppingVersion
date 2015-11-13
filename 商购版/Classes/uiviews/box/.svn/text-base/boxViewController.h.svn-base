//
//  boxViewController.h
//  shopping
//
//  Created by lai yun on 12-12-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommandOperation.h"
#import "IconDownLoader.h"
#import "MBProgressHUD.h"
@interface boxViewController : UIViewController <CommandOperationDelegate,IconDownloaderDelegate,MBProgressHUDDelegate>{
    UIScrollView *mainScrollView;
    UIView *introductionView;
    UIView *moreView;
    UIActivityIndicatorView *spinner;
    CGFloat iconWidth;
    CGFloat iconHeight;
    CGFloat iconBgWidth;
    CGFloat iconBgHeight;
    UIImageView *btnBgImageView;
    
    NSMutableArray *__listArray;
    
    NSMutableDictionary *imageDownloadsInProgressDic;
	NSMutableArray *imageDownloadsInWaitingArray;
	IconDownLoader *iconDownLoad;
    
}
@property (nonatomic, retain) UIScrollView *mainScrollView;
@property (nonatomic, retain) UIView *introductionView;
@property (nonatomic, retain) UIView *moreView;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;
@property (nonatomic, retain) NSMutableArray *listArray;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgressDic;
@property (nonatomic, retain) NSMutableArray *imageDownloadsInWaitingArray;
@property (nonatomic, retain) IconDownLoader *iconDownLoad;

//创建介绍视图
-(void)createIntroductionView;

//创建更多功能视图
-(void)createMoreView;

//关于我们
-(void)aboutUs;

//微博设置
-(void)weiboSet;

//在线反馈
-(void)feedback;

//推荐应用
-(void)recommendApp;

@end
