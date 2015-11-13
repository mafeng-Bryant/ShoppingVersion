//
//  scrollImageView.m
//  myLottery
//
//  Created by lai yun on 13-1-24.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "scrollImageView.h"

//滚动周期 1-10
#define CYCLE 10

//控制滚动时间
#define CYCLE_NUM 3

//滚动先后停止的时间差异系数
#define COEFFICIENT 5


@implementation scrollImageView

@synthesize delegate = _delegate;
@synthesize isAnimation = _isAnimation;
@synthesize isLock = _isLock;
@synthesize isComplete = _isComplete;
@synthesize nextIndex = _nextIndex;
@synthesize scrollIndex = _scrollIndex;
@synthesize animationTime = _animationTime;
@synthesize counter = _counter;
@synthesize allScrollCount = _allScrollCount;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _isAnimation = NO;
        _isLock = NO;
        _isComplete = NO;
        self.animationTime = 0.5f;
        self.nextIndex = 1;
        self.counter = 0;
        NSString *picName = [NSString stringWithFormat:@"抽奖滚动图标%d",0];
        self.image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:picName ofType:@"png"]];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

//初始化
-(void)setScrollIndexAndCount:(int)scrollIndex
{
    self.scrollIndex = scrollIndex;
    self.allScrollCount = (CYCLE - self.nextIndex) + (CYCLE_NUM * CYCLE) + (arc4random()%COEFFICIENT * CYCLE) + self.scrollIndex;
}

//设置加锁
-(void)setLock:(BOOL)isLock
{
    _isLock = isLock;
    if (isLock)
    {
        NSString *picName = @"抽奖滚动lock";
        self.image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:picName ofType:@"png"]];
    }
    else
    {
        NSString *picName = [NSString stringWithFormat:@"抽奖滚动图标%d",0];
        self.image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:picName ofType:@"png"]];
    }
}

-(void)scrollAnimation
{
    if (!_isAnimation && !_isLock)
    {
        _isAnimation = YES;
        
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = self.animationTime;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.fillMode = kCAFillModeForwards;
        animation.delegate = self;
        //animation.removedOnCompletion = NO;
        
        /*
         kCATransitionFade;
         kCATransitionMoveIn;
         kCATransitionPush;
         kCATransitionReveal;
         */
        /*
         kCATransitionFromRight;
         kCATransitionFromLeft;
         kCATransitionFromTop;
         kCATransitionFromBottom;
         */
        
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromBottom;
        [self.layer addAnimation:animation forKey:@"animation"];
        
        
        NSString *picName = [NSString stringWithFormat:@"抽奖滚动图标%d",self.nextIndex];
        self.image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:picName ofType:@"png"]];
    }
}

#pragma mark -
#pragma mark 动画结束委托
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    _isAnimation = NO;
    
    //计数器
    self.counter = self.counter + 1;
    
    //滚动index
    if (self.nextIndex == (CYCLE - 1))
    {
        self.nextIndex = 0;
    }
    else
    {
        self.nextIndex = self.nextIndex + 1;
    }
    
    //判断 获取当前滚动速度
    if (self.counter < 5) 
    {
        //开始滚动(加速)
        self.animationTime = 0.5f - (self.counter * 0.1);
    }
    else if(self.counter >= 5 && self.counter <= (self.allScrollCount - 8))
    {
        //最大速度滚动(匀速)
        self.animationTime = 0.05f;
    }
    else
    {
        //结束滚动(减速)
        self.animationTime = 0.1 + (self.counter - (self.allScrollCount - 8)) * 0.1;
    }

    if (_isComplete)
    {
        //滚动完成后事件处理
        _isComplete = NO;
        self.animationTime = 0.5f;
        self.counter = 0;
        
        if ([self.delegate respondsToSelector:@selector(scrollImageViewDidEndscrolling:)]) 
        {
            [self.delegate performSelector:@selector(scrollImageViewDidEndscrolling:) withObject:self afterDelay:0.0];
        }
        
    }
    else
    {
        _isComplete = (self.nextIndex == self.scrollIndex && self.counter == self.allScrollCount) ? YES : NO;
        [self scrollAnimation];
    }
    
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    self.delegate = nil;
}

@end
