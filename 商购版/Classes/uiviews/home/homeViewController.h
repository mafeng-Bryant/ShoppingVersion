//
//  homeViewController.h
//  shopping
//
//  Created by lai yun on 12-12-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "indexViewController.h"

@class recommendViewController;
@class specialOfferViewController;

@interface homeViewController : UIViewController<indexViewDelegate,UIScrollViewDelegate>
{
    UIActivityIndicatorView *spinner;
    UIScrollView *mainScrollView;
    UIPageControl *pageControll;
    indexViewController *indexView;
    recommendViewController *recommendView;
    specialOfferViewController *specialOfferView;
}

@property(nonatomic,retain) UIActivityIndicatorView *spinner;
@property(nonatomic,retain) UIScrollView *mainScrollView;
@property(nonatomic,retain) UIPageControl *pageControll;
@property(nonatomic,retain) indexViewController *indexView;
@property(nonatomic,retain) recommendViewController *recommendView;
@property(nonatomic,retain) specialOfferViewController *specialOfferView;


//添加主视图
- (void)addMainScrollView;

//设置首页内容
- (void)addIndexView;

//设置精品推荐视图跟特价专区视图
- (void)reSetMainScrollView;

//显示推荐
- (void)showRecommendView;

@end
