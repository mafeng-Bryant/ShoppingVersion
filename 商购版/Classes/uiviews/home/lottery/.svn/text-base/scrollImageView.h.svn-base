//
//  scrollImageView.h
//  myLottery
//
//  Created by lai yun on 13-1-24.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol scrollImageDelegate;

@interface scrollImageView : UIImageView
{
    NSObject<scrollImageDelegate> *_delegate;
    BOOL _isAnimation;
    BOOL _isLock;
    BOOL _isComplete;
    int _nextIndex;          //下一个滚动位置
    int _scrollIndex;        //滚动位置
    CGFloat _animationTime;  //动画时间
    int _counter;            //计数器
    int _allScrollCount;     //总滚动次数  
}

@property (nonatomic, assign) NSObject<scrollImageDelegate> *delegate;
@property (nonatomic, assign) BOOL isAnimation;
@property (nonatomic, assign) BOOL isLock;
@property (nonatomic, assign) BOOL isComplete;
@property (nonatomic, assign) int nextIndex;
@property (nonatomic, assign) int scrollIndex;
@property (nonatomic, assign) CGFloat animationTime;
@property (nonatomic, assign) int counter;
@property (nonatomic, assign) int allScrollCount;

//初始化
-(void)setScrollIndexAndCount:(int)scrollIndex;

//设置加锁
-(void)setLock:(BOOL)isLock;

//滚动动画
-(void)scrollAnimation;

@end

@protocol scrollImageDelegate
@optional
- (void)scrollImageViewDidEndscrolling:(scrollImageView *)scrollImage;
@end
