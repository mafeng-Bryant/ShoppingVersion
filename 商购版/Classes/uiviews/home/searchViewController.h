//
//  searchViewController.h
//  shopping
//
//  Created by lai yun on 13-1-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import <AudioToolbox/AudioToolbox.h>  
#import <CoreFoundation/CoreFoundation.h>  

@class searchButton;

@interface searchViewController : UIViewController<UISearchBarDelegate,CommandOperationDelegate>
{
    UIActivityIndicatorView *spinner;
    UISearchBar *searchBar;
    NSMutableArray *keywordItems;
    UIView *buttonsView;
    NSMutableArray *randomKeywordItems;
    searchButton *clickedSearchButton;
    CGFloat currentWidth;
    CGFloat currentHeight;
    BOOL isAnimate;
}

@property(nonatomic,retain) UIActivityIndicatorView *spinner;
@property(nonatomic,retain) UISearchBar *searchBar;
@property(nonatomic,retain) NSMutableArray *keywordItems;
@property(nonatomic,retain) UIView *buttonsView;
@property(nonatomic,retain) NSMutableArray *randomKeywordItems;
@property(nonatomic,retain) searchButton *clickedSearchButton;

//返回
-(void)backHome;

//添加按钮
-(void)addSearchButton;

//按钮动画弹出效果
- (void)searchButtonClick:(id)sender;

//随机获取关键词
- (NSString *)randomKeyWords;

//更新记录
-(void)update;

//网络获取
-(void)accessItemService;

//网络请求回调函数
- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver;

@end
