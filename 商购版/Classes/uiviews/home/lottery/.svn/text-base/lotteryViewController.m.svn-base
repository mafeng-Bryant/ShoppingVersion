//
//  lotteryViewController.m
//  shopping
//
//  Created by lai yun on 13-1-25.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "lotteryViewController.h"
#import "Common.h"
#import "DBOperate.h"
#import "UIImageScale.h"
#import "FileManager.h"
#import "downloadParam.h"
#import "imageDownLoadInWaitingObject.h"
#import "MyPrizeViewController.h"
#import "lotteryDetailViewController.h"

@interface lotteryViewController ()

@end

@implementation lotteryViewController

@synthesize lotteryID;
@synthesize lotteryArray;
@synthesize lotteryPicArray;
@synthesize imageDownloadsInProgress;
@synthesize imageDownloadsInWaiting;
@synthesize picView;
@synthesize timeLabel;
@synthesize statusImageView;
@synthesize lotteryResultView;
@synthesize tipsLabel;
@synthesize shakeImageView;
@synthesize resultImageView;
@synthesize resultLabel;
@synthesize scrollImage1;
@synthesize scrollImage2;
@synthesize scrollImage3;
@synthesize scrollingPlayer;
@synthesize scrolledPlayer;
@synthesize userId;
@synthesize userName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"幸运抽奖";
    
    picWidth = 300.0f;
    picHeight = 122.0f;
    
    isScrolling = NO;
    
    NSMutableDictionary *idip = [[NSMutableDictionary alloc]init];
	self.imageDownloadsInProgress = idip;
	[idip release];
	
	NSMutableArray *wait = [[NSMutableArray alloc]init];
	self.imageDownloadsInWaiting = wait;
    
    //声音初始化
    NSURL* rollFileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"roll.wav" ofType:nil]];
    AVAudioPlayer *tempScrollingPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:rollFileURL error:NULL];
    tempScrollingPlayer.numberOfLoops = -1;  // Endless
    self.scrollingPlayer = tempScrollingPlayer;
    [tempScrollingPlayer release];
    
    NSURL* dingFileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"ding.wav" ofType:nil]];
    AVAudioPlayer *tempScrolledPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:dingFileURL error:NULL];
    tempScrolledPlayer.numberOfLoops = 0;  // Endless
    self.scrolledPlayer = tempScrolledPlayer;
    [tempScrolledPlayer release];
    
    //我的奖品按钮
    UIImage *prizeImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"抽奖我的奖品按钮" ofType:@"png"]];
	UIButton *prizeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	prizeButton.frame = CGRectMake( 0.0f , 0.0f , 88.0f , 40.0f);
	[prizeButton addTarget:self action:@selector(myPrize) forControlEvents:UIControlEventTouchUpInside];
    [prizeButton setBackgroundImage:prizeImage forState:UIControlStateNormal];
    [prizeImage release];
    [prizeButton setTitle:@"我的奖品" forState:UIControlStateNormal];
    prizeButton.titleLabel.textAlignment = UITextAlignmentCenter;
    prizeButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0f];
    UIBarButtonItem *prizeItem = [[UIBarButtonItem alloc] initWithCustomView:prizeButton]; 
    self.navigationItem.rightBarButtonItem = prizeItem;
    
    //背景
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake( 0.0f , 0.0f , self.view.frame.size.width , self.view.frame.size.height)];
    backgroundView.layer.masksToBounds = YES;
    [self.view addSubview:backgroundView];
    [backgroundView release];
    
    UIImage *backgroundImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"抽奖背景" ofType:@"png"]];
    UIImageView *backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f , 0.0f , backgroundImage.size.width , backgroundImage.size.height)];
    backgroundImageView.image = backgroundImage;
    [backgroundImage release];
    [backgroundView addSubview:backgroundImageView];
	[backgroundImageView release];
    
    //内容背景
    UIView *contentBackgroundView = [[UIView alloc] initWithFrame:CGRectMake( 10.0f , 10.0f , 300.0f , 202.0f)];
    contentBackgroundView.backgroundColor = [UIColor clearColor];
    contentBackgroundView.layer.cornerRadius = 10;
    
    contentBackgroundView.userInteractionEnabled = YES;
	UITapGestureRecognizer *backgroundSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lotteryDetail)];
	[contentBackgroundView addGestureRecognizer:backgroundSingleTap];
	[backgroundSingleTap release];
    
    //添加四个边阴影
    contentBackgroundView.layer.shadowColor = [UIColor blackColor].CGColor;
    contentBackgroundView.layer.shadowOffset = CGSizeMake(0, 0);
    contentBackgroundView.layer.shadowOpacity = 0.5;
    contentBackgroundView.layer.shadowRadius = 2.0;
    [self.view addSubview:contentBackgroundView];
    [contentBackgroundView release];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake( 0.0f , 0.0f , 300.0f , 202.0f)];
    contentView.backgroundColor = [UIColor clearColor];
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = 10;
    [contentBackgroundView addSubview:contentView];
    [contentView release];
    
    //content 背景
    UIImage *contentBackgroundImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"抽奖列表背景" ofType:@"png"]];
    contentView.backgroundColor = [UIColor colorWithPatternImage:contentBackgroundImage];
    [contentBackgroundImage release];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake( 10.0f , 0.0f , 280.0f, 40.0f)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0f];
    titleLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
    titleLabel.text = [lotteryArray objectAtIndex:lottery_name];
    [contentView addSubview:titleLabel];
    [titleLabel release];
    
    //图片
    myImageView *tempPicView = [[myImageView alloc]initWithFrame:CGRectMake( 0.0f , CGRectGetMaxY(titleLabel.frame) , 300.0f, 122.0f) withImageId:[NSString stringWithFormat:@"%d",0]];
    self.picView = tempPicView;
    [contentView addSubview:self.picView];
    [tempPicView release];
    
    NSString *picUrl = [self.lotteryArray objectAtIndex:lottery_pic];
    NSString *picName = [Common encodeBase64:(NSMutableData *)[picUrl dataUsingEncoding: NSUTF8StringEncoding]];
    if (picUrl.length > 1) 
    {
        UIImage *pic = [[FileManager getPhoto:picName] fillSize:CGSizeMake(picWidth, picHeight)];
        if (pic.size.width > 2)
        {
            self.picView.image = pic;
        }
        else
        {
            UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"抽奖奖品默认" ofType:@"png"]];
            self.picView.image = [defaultPic fillSize:CGSizeMake(picWidth, picHeight)];
            [self.picView stopSpinner];
            [self.picView startSpinner];
            [self startIconDownload:picUrl forIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

        }
    }
    else
    {
        UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"抽奖奖品默认" ofType:@"png"]];
        self.picView.image = [defaultPic fillSize:CGSizeMake(picWidth, picHeight)];
    }
    
    //价格
    UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake( 10.0f , CGRectGetMaxY(self.picView.frame) , 80.0f, 40.0f)];
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
    priceLabel.font = [UIFont systemFontOfSize:14.0f];
    priceLabel.textColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1];
    priceLabel.text = [NSString stringWithFormat:@" ￥%@",[lotteryArray objectAtIndex:lottery_product_price]];
    [contentView addSubview:priceLabel];
    [priceLabel release];
    
    //中奖人数
    UILabel *winNumTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake( CGRectGetMaxX(priceLabel.frame) , CGRectGetMaxY(self.picView.frame) , 80.0f, 40.0f)];
    winNumTitleLabel.backgroundColor = [UIColor clearColor];
    winNumTitleLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
    winNumTitleLabel.font = [UIFont systemFontOfSize:14.0f];
    winNumTitleLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
    winNumTitleLabel.text = @"已中奖人数:";
    [contentView addSubview:winNumTitleLabel];
    [winNumTitleLabel release];
    
    UILabel *winNumLabel = [[UILabel alloc]initWithFrame:CGRectMake( CGRectGetMaxX(winNumTitleLabel.frame) , CGRectGetMaxY(self.picView.frame) , 60.0f, 40.0f)];
    winNumLabel.backgroundColor = [UIColor clearColor];
    winNumLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
    winNumLabel.font = [UIFont systemFontOfSize:14.0f];
    winNumLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
    winNumLabel.text = [lotteryArray objectAtIndex:lottery_win_num];
    [contentView addSubview:winNumLabel];
    [winNumLabel release];
    
    //老虎机
    UIImage *slotImageTop = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"抽奖老虎机背景上" ofType:@"png"]];
    UIImageView *slotImageTopView = [[UIImageView alloc]initWithFrame: CGRectMake( 0.0f , CGRectGetMaxY(contentBackgroundView.frame) + 5.0f , slotImageTop.size.width, slotImageTop.size.height)];
    slotImageTopView.backgroundColor = [UIColor clearColor];
    slotImageTopView.image = slotImageTop;
    [slotImageTop release];
    [self.view insertSubview:slotImageTopView atIndex:3];
    [slotImageTopView release];
    
    //滚动层
    UIView *scrollView = [[UIView alloc] initWithFrame:CGRectMake( 25.0f , CGRectGetMaxY(contentBackgroundView.frame) + 15.0f , 270, 60.0f)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.layer.masksToBounds = YES;
    [self.view insertSubview:scrollView atIndex:4];
    [scrollView release];
    
    //滚动图片1
    scrollImageView *tempScrollImageView1 = [[scrollImageView alloc]initWithFrame:CGRectMake(0.0f , 0.0f , 90.0f , 60.0f)];
    tempScrollImageView1.backgroundColor = [UIColor clearColor];
    tempScrollImageView1.delegate = self;
    self.scrollImage1 = tempScrollImageView1;
    [scrollView addSubview:self.scrollImage1];
    [tempScrollImageView1 release];
    
    //滚动图片2
    scrollImageView *tempScrollImageView2 = [[scrollImageView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(self.scrollImage1.frame) , 0.0f , 90.0f , 60.0f)];
    tempScrollImageView2.backgroundColor = [UIColor clearColor];
    tempScrollImageView2.delegate = self;
    self.scrollImage2 = tempScrollImageView2;
    [scrollView addSubview:self.scrollImage2];
    [tempScrollImageView2 release];
    
    //滚动图片3
    scrollImageView *tempScrollImageView3 = [[scrollImageView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(self.scrollImage2.frame) , 0.0f , 90.0f , 60.0f)];
    tempScrollImageView3.backgroundColor = [UIColor clearColor];
    tempScrollImageView3.delegate = self;
    self.scrollImage3 = tempScrollImageView3;
    [scrollView addSubview:self.scrollImage3];
    [tempScrollImageView3 release];
    
    
    //提示
    UILabel *tempTipsLabel = [[UILabel alloc]initWithFrame:CGRectMake( 25.0f , CGRectGetMaxY(slotImageTopView.frame) - 40.0f , 240.0f , 30.0f )];
    tempTipsLabel.backgroundColor = [UIColor clearColor];
    tempTipsLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
    tempTipsLabel.textColor = [UIColor colorWithRed:0.34 green:0.02 blue:0.02 alpha:1];
    tempTipsLabel.text = @"想知道您今天运气如何? 赶快摇一摇!";
    tempTipsLabel.font = [UIFont systemFontOfSize:13.0f];
    tempTipsLabel.textAlignment = UITextAlignmentLeft;
    tempTipsLabel.shadowColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0f alpha:0.2];
    tempTipsLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    self.tipsLabel = tempTipsLabel;
    [self.view addSubview:self.tipsLabel];
    [tempTipsLabel release];
    
    UIImage *shakeImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"抽奖震动手机图标" ofType:@"png"]];
    UIImageView *tempShakeImageView = [[UIImageView alloc]initWithFrame: CGRectMake( CGRectGetMaxX(self.tipsLabel.frame) , CGRectGetMaxY(slotImageTopView.frame) - 35.0f , shakeImage.size.width, shakeImage.size.height)];
    tempShakeImageView.backgroundColor = [UIColor clearColor];
    tempShakeImageView.image = shakeImage;
    [shakeImage release];
    self.shakeImageView = tempShakeImageView;
    self.shakeImageView.hidden = YES;
    [self.view insertSubview:self.shakeImageView atIndex:4];
    [tempShakeImageView release];
    
    UIImage *slotImageBottom = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"抽奖老虎机背景下" ofType:@"png"]];
    UIImageView *slotImageBottomView = [[UIImageView alloc]initWithFrame: CGRectMake( 0.0f , CGRectGetMaxY(slotImageTopView.frame) , slotImageBottom.size.width, slotImageBottom.size.height)];
    slotImageBottomView.backgroundColor = [UIColor clearColor];
    slotImageBottomView.image = slotImageBottom;
    [slotImageBottom release];
    [self.view insertSubview:slotImageBottomView atIndex:1];
    [slotImageBottomView release];
    
    //结果纸张
    UIImage *resultPaperImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"抽奖老虎机单子" ofType:@"png"]];
    
    UIView *tempLotteryResultView = [[UIView alloc] initWithFrame:CGRectMake( 25.0f , CGRectGetMaxY(slotImageTopView.frame) -80.0f , resultPaperImage.size.width, resultPaperImage.size.height)];
    self.lotteryResultView = tempLotteryResultView;
    [self.view insertSubview:self.lotteryResultView atIndex:2];
    [tempLotteryResultView release];
    
    UIImageView *resultPaperImageView = [[UIImageView alloc]initWithFrame: CGRectMake( 0.0f , 0.0f , resultPaperImage.size.width, resultPaperImage.size.height)];
    resultPaperImageView.backgroundColor = [UIColor clearColor];
    resultPaperImageView.image = resultPaperImage;
    [resultPaperImage release];
    [self.lotteryResultView addSubview:resultPaperImageView];
    [resultPaperImageView release];
    
    //结果
    UIImage *resultImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"抽奖中奖表情" ofType:@"png"]];
    UIImageView *tempResultImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    tempResultImageView.frame = CGRectMake( 30.0f , 30.0f , 27.0f, 27.0f);
    tempResultImageView.image = resultImage;
    [resultImage release];
    self.resultImageView = tempResultImageView;
    self.resultImageView.backgroundColor = [UIColor clearColor];
    [self.lotteryResultView addSubview:self.resultImageView];
    [tempResultImageView release];
    
    UILabel *tempResultLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    tempResultLabel.frame = CGRectMake( CGRectGetMaxX(self.resultImageView.frame) + 10.0f , 30.0f , 160.0f, 30.0f);
    tempResultLabel.backgroundColor = [UIColor clearColor];
    tempResultLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
    tempResultLabel.textColor = [UIColor colorWithRed:0.34 green:0.02 blue:0.02 alpha:1];
    tempResultLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
    tempResultLabel.textAlignment = UITextAlignmentCenter;
    tempResultLabel.text = @"您运气真好,中奖了!";
    self.resultLabel = tempResultLabel;
    [self.lotteryResultView addSubview:self.resultLabel];
    [tempResultLabel release];
    
    //状态
    UIImageView *tempStatusImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.statusImageView = tempStatusImageView;
    self.statusImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.statusImageView];
    [tempStatusImageView release];
    
    UILabel *tempTimeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    tempTimeLabel.backgroundColor = [UIColor clearColor];
    tempTimeLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
    tempTimeLabel.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
    tempTimeLabel.text = @"";
    tempTimeLabel.textAlignment = UITextAlignmentCenter;
    self.timeLabel = tempTimeLabel;
    [self.view addSubview:self.timeLabel];
    [tempTimeLabel release];
    
    //判断当前状态
    int stauts = [[lotteryArray objectAtIndex:lottery_status] intValue];
    startTime = [[lotteryArray objectAtIndex:lottery_starttime] intValue];
    endTime = [[lotteryArray objectAtIndex:lottery_endtime] intValue];
    
    if (stauts == 1)
    {
        [self performSelector:@selector(countdown) withObject:nil afterDelay:0.0];
    }
    else
    {
        //已下架
        UIImage *statusImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"抽奖已经结束小标签" ofType:@"png"]];
        self.statusImageView.frame = CGRectMake( CGRectGetMaxX(self.picView.frame) - statusImage.size.width + 15.0f , CGRectGetMaxY(self.picView.frame) - statusImage.size.height + 5.0f , statusImage.size.width , statusImage.size.height);
        self.statusImageView.image = statusImage;
        [statusImage release];
        self.timeLabel.frame = self.statusImageView.frame;
        self.timeLabel.text = @"已结束";
        self.timeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0f];
        self.timeLabel.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
        
        //提示
        self.shakeImageView.hidden = YES;
        self.tipsLabel.text = @"活动已结束,下次记得要快哦!";
        
        //设置滚动老虎机状态
        if (!self.scrollImage1.isLock)
        {
            [self.scrollImage1 setLock:YES];
        }
        
        if (!self.scrollImage2.isLock)
        {
            [self.scrollImage2 setLock:YES];
        }
        
        if (!self.scrollImage3.isLock)
        {
            [self.scrollImage3 setLock:YES];
        }
    }
    
}

-(void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
    
    //获取当前登陆用户信息
    NSMutableArray *memberArray = (NSMutableArray *)[DBOperate queryData:T_MEMBER_INFO theColumn:@"" theColumnValue:@"" withAll:YES];
	if ([memberArray count] > 0) 
	{
		self.userId = [[memberArray objectAtIndex:0] objectAtIndex:member_info_memberId];
        self.userName = [[memberArray objectAtIndex:0] objectAtIndex:member_info_name];
        
        //判断已经中奖的会员
        NSString *winUsers = [lotteryArray objectAtIndex:lottery_win_users];
        if (winUsers.length > 0)
        {
            if ([winUsers rangeOfString:@"," options:NSCaseInsensitiveSearch].location == NSNotFound)
            {
                isWinUser = isWinUser ? YES : ([winUsers isEqualToString:self.userId] ? YES : NO);
            }
            else
            {
                NSArray *winUserArray = [winUsers componentsSeparatedByString:@","];
                isWinUser = isWinUser ? YES : ([winUserArray indexOfObject:self.userId] == NSNotFound ? NO : YES);
            }
        }
        
        //判断是否为指定会员抽奖
        NSString *users = [lotteryArray objectAtIndex:lottery_users];
        if (users.length > 0)
        {
            if ([users rangeOfString:@"," options:NSCaseInsensitiveSearch].location == NSNotFound)
            {
                isAssignUser = [users isEqualToString:self.userName] ? YES : NO;
            }
            else
            {
                NSArray *userArray = [users componentsSeparatedByString:@","];
                isAssignUser = [userArray indexOfObject:self.userName] == NSNotFound ? NO : YES;
            }
        }
        
	}
	else 
	{
		self.userId = @"0";
        self.userName = @"";
        isAssignUser = NO;
	}
    
    //获取当前用户摇一摇剩余的次数
    NSDate* cDate = [NSDate date];
    NSDateFormatter *outputFormat = [[NSDateFormatter alloc] init];
    [outputFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [outputFormat stringFromDate:cDate];
    LotterySurplusCount = [[Common getLotteryLogs:dateString] intValue];
    
    //设置指定会员第几次中奖
    assignUserRandIndex = arc4random()%LotterySurplusCount;
    assignUserShakeTime = 0;


}

//设置支持第一相应 以支持摇一摇
-(BOOL)canBecomeFirstResponder{
    return YES;
}

-(void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
    
    //成为第一响应者 以支持摇一摇
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    //取消成为第一响应者
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

//开始倒计时 改变状态
-(void)countdown
{
    NSTimeInterval cTime = [[NSDate date] timeIntervalSince1970];
    long long int currentTime = (long long int)cTime;
    if (startTime > currentTime)
    {
        //即将开始
        UIImage *statusImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"抽奖即将开始小标签" ofType:@"png"]];
        self.statusImageView.frame = CGRectMake( CGRectGetMaxX(self.picView.frame) - statusImage.size.width + 15.0f , CGRectGetMaxY(self.picView.frame) - statusImage.size.height + 5.0f , statusImage.size.width , statusImage.size.height);
        self.statusImageView.image = statusImage;
        [statusImage release];
        self.timeLabel.frame = self.statusImageView.frame;
        self.timeLabel.text = @"即将开始";
        self.timeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0f];
        self.timeLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1];
        
        //提示
        self.shakeImageView.hidden = YES;
        self.tipsLabel.text = @"活动还未开始,请耐心等待哦!";
        
        //设置滚动老虎机状态
        if (!self.scrollImage1.isLock)
        {
            [self.scrollImage1 setLock:YES];
        }
        
        if (!self.scrollImage2.isLock)
        {
            [self.scrollImage2 setLock:YES];
        }
        
        if (!self.scrollImage3.isLock)
        {
            [self.scrollImage3 setLock:YES];
        }

        [self performSelector:@selector(countdown) withObject:nil afterDelay:1.0];
        
    }
    else if(startTime <= currentTime && endTime > currentTime)
    {
        //正在进行
        UIImage *statusImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"抽奖正在进行小标签" ofType:@"png"]];
        self.statusImageView.frame = CGRectMake( CGRectGetMaxX(self.picView.frame) - statusImage.size.width + 15.0f , CGRectGetMaxY(self.picView.frame) - statusImage.size.height + 5.0f , statusImage.size.width , statusImage.size.height);
        self.statusImageView.image = statusImage;
        [statusImage release];
        self.timeLabel.frame = self.statusImageView.frame;
        self.timeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:10.0f];
        self.timeLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1];
        
        //时间
        self.timeLabel.text = [self mackCountdownDateString:currentTime];
        
        //提示
        self.shakeImageView.hidden = NO;
        self.tipsLabel.text = [NSString stringWithFormat:@"您今天还有 %d 次抽奖机会,赶快摇一摇!",LotterySurplusCount];
        
        //设置滚动老虎机状态
        if (self.scrollImage1.isLock)
        {
            [self.scrollImage1 setLock:NO];
        }
        
        if (self.scrollImage2.isLock)
        {
            [self.scrollImage2 setLock:NO];
        }
        
        if (self.scrollImage3.isLock)
        {
            [self.scrollImage3 setLock:NO];
        }
        
        [self performSelector:@selector(countdown) withObject:nil afterDelay:1.0];
    }
    else
    {
        //已下架
        UIImage *statusImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"抽奖已经结束小标签" ofType:@"png"]];
        self.statusImageView.frame = CGRectMake( CGRectGetMaxX(self.picView.frame) - statusImage.size.width + 15.0f , CGRectGetMaxY(self.picView.frame) - statusImage.size.height + 5.0f , statusImage.size.width , statusImage.size.height);
        self.statusImageView.image = statusImage;
        [statusImage release];
        self.timeLabel.frame = self.statusImageView.frame;
        self.timeLabel.text = @"已结束";
        self.timeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0f];
        self.timeLabel.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
        
        //提示
        self.shakeImageView.hidden = YES;
        self.tipsLabel.text = @"活动已结束,下次记得要快哦!";
        
        //设置滚动老虎机状态
        if (!self.scrollImage1.isLock)
        {
            [self.scrollImage1 setLock:YES];
        }
        
        if (!self.scrollImage2.isLock)
        {
            [self.scrollImage2 setLock:YES];
        }
        
        if (!self.scrollImage3.isLock)
        {
            [self.scrollImage3 setLock:YES];
        }
    }
}

//设置倒计时时间
-(NSString *)mackCountdownDateString:(int)currentTime
{
    int surplusTimes = endTime - currentTime;
    
    //天数
    int dayCount = surplusTimes / (24 * 60 * 60);
    surplusTimes = surplusTimes % (24 * 60 * 60);
    
    //小时
    int hoursCount = surplusTimes / (60 * 60);
    surplusTimes = surplusTimes % (60 * 60);
    
    //分钟
    int minuteCount = surplusTimes / 60;
    
    //秒数
    int timesCount = surplusTimes % 60;
    
    return [NSString stringWithFormat:@"剩余: %d天%d小时%d分%d秒",dayCount,hoursCount,minuteCount,timesCount];
}

//抽奖
-(void)doLottery
{
    int index1 = 0;
    int index2 = 0;
    int index3 = 0;
    
    //已中奖的 不会再中
    if (!isWinUser)
    {
        //设置中奖的概率
        if (isAssignUser) 
        {
            //第几次中奖
            if (assignUserShakeTime == assignUserRandIndex)
            {
                //必中
                index1 = index2 = index3 = arc4random()%10;
            }
            else
            {
                index1 = arc4random()%10;
                index2 = arc4random()%10;
                index3 = arc4random()%10;
                assignUserShakeTime++;
            }
        }
        else
        {
            
            NSString *probability = [lotteryArray objectAtIndex:lottery_probability];
            
            if ([probability rangeOfString:@"/" options:NSCaseInsensitiveSearch].location == NSNotFound)
            {
                //如果程序到这里面来 说明程序已经错误 按默认的概率
                index1 = arc4random()%10;
                index2 = arc4random()%10;
                index3 = arc4random()%10;
            }
            else
            {
                NSArray *probabilityArray = [probability componentsSeparatedByString:@"/"];
                int num = [[probabilityArray objectAtIndex:0] intValue];
                int count = [[probabilityArray objectAtIndex:1] intValue];
                
                int randNum = arc4random()%count;
                
                if (randNum <= num) 
                {
                    //中奖了
                    index1 = index2 = index3 = arc4random()%10;
                }
                else
                {
                    //设置不中奖
                    while((index1 == index2) && (index1 == index3))
                    {
                        index1 = arc4random()%10;
                        index2 = arc4random()%10;
                        index3 = arc4random()%10;
                    }
                }
            }
            
        }
    }
    else
    {
        //设置不中奖
        while((index1 == index2) && (index1 == index3))
        {
            index1 = arc4random()%10;
            index2 = arc4random()%10;
            index3 = arc4random()%10;
        }
    }
    
    //开始滚动
    [self doScroll:index1 scrollIndex2:index2 scrollIndex3:index3];
    
}

//滚动
-(void)doScroll:(int)index1 scrollIndex2:(int)index2 scrollIndex3:(int)index3
{
    //震动接口
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    isScrolling = YES;
    
    //记录次数
    LotterySurplusCount = LotterySurplusCount - 1;
    
    //更新到数据库
    NSDate* cDate = [NSDate date];
    NSDateFormatter *outputFormat = [[NSDateFormatter alloc] init];
    [outputFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [outputFormat stringFromDate:cDate];
    NSArray *array = [NSArray arrayWithObjects:dateString,[NSNumber numberWithInt:LotterySurplusCount],nil];
	[DBOperate deleteData:T_LOTTERY_LOGS tableColumn:@"date" columnValue:dateString];
	[DBOperate insertData:array tableName:T_LOTTERY_LOGS];
    
    //设置滚动参数
    [self.scrollImage1 setScrollIndexAndCount:index1];
    [self.scrollImage2 setScrollIndexAndCount:index2];
    [self.scrollImage3 setScrollIndexAndCount:index3];
    
    //开始滚动
    [self.scrollImage1 scrollAnimation];
    [self.scrollImage2 scrollAnimation];
    [self.scrollImage3 scrollAnimation];
    
    //播放声音
    [self.scrollingPlayer play];
}

//中奖动画
-(void)winAnimation
{
    CGRect lotteryResultViewFrame = self.lotteryResultView.frame;
    lotteryResultViewFrame.origin.y = lotteryResultViewFrame.origin.y + 70.0f;
    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationCurve:1];
    [UIView setAnimationDidStopSelector:@selector(winAnimationDone)];
    [UIView setAnimationDelegate:self];
	self.lotteryResultView.frame = lotteryResultViewFrame;

	[UIView commitAnimations];
    
    
}

//延时动画
-(void)winAnimationDone
{
    [self performSelector:@selector(_winAnimationDone) withObject:nil afterDelay:2.0];
}

//结束动画
-(void)_winAnimationDone
{
    [UIView beginAnimations:@"animationID" context:nil];
	[UIView setAnimationDuration:0.6f];
	[UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationDidStopSelector:@selector(initializeLotteryResultView)];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.lotteryResultView cache:YES];
    
    [UIView commitAnimations];
    
    self.lotteryResultView.hidden = YES;
}

//结果重新设置
-(void)initializeLotteryResultView
{
    self.lotteryResultView.hidden = NO;
    CGRect lotteryResultViewFrame = self.lotteryResultView.frame;
    lotteryResultViewFrame.origin.y = lotteryResultViewFrame.origin.y - 70.0f;
    self.lotteryResultView.frame = lotteryResultViewFrame;
    
    //中奖的话 跳转到到我的奖品
    if (self.scrollImage1.scrollIndex == self.scrollImage2.scrollIndex && self.scrollImage1.scrollIndex == self.scrollImage3.scrollIndex)
    {
        [self myPrize];
    }
}

//我的奖品
-(void)myPrize
{
    //判断用户是否登陆
    if (_isLogin == YES)
    {
        if ([self.userId intValue] != 0)
        {
            MyPrizeViewController *prize = [[MyPrizeViewController alloc] init];
            prize.userId = self.userId;
            [self.navigationController pushViewController:prize animated:YES];
            [prize release];
        }
        else
        {
            isMyPrizeLogin = YES;
            LoginViewController *login = [[LoginViewController alloc] init];
            login.delegate = self;
            [self.navigationController pushViewController:login animated:YES];
            [login release];
        }
        
    }
    else 
    {
        isMyPrizeLogin = YES;
        LoginViewController *login = [[LoginViewController alloc] init];
        login.delegate = self;
        [self.navigationController pushViewController:login animated:YES];
        [login release];
    }
}

//抽奖详情
-(void)lotteryDetail
{
    lotteryDetailViewController *lotteryDetailView = [[lotteryDetailViewController alloc] init];
    lotteryDetailView.lotteryID = self.lotteryID;
    lotteryDetailView.lotteryArray = self.lotteryArray;
    
    if ([[self.lotteryArray objectAtIndex:lottery_pics] isKindOfClass:[NSMutableArray class]])
    {
        lotteryDetailView.lotteryPicArray = [self.lotteryArray objectAtIndex:lottery_pics];
    }
    else
    {
        NSMutableArray *picArray = (NSMutableArray *)[DBOperate queryData:T_LOTTERY_PIC theColumn:@"lottery_id" theColumnValue:self.lotteryID orderBy:@"id" orderType:@"asc" withAll:NO];
        lotteryDetailView.lotteryPicArray = picArray;
    }
    
    [self.navigationController pushViewController:lotteryDetailView animated:YES];
    [lotteryDetailView release];
}


//保存缓存图片
-(bool)savePhoto:(UIImage*)photo atIndexPath:(NSIndexPath*)indexPath
{
    NSString *picUrl = [self.lotteryArray objectAtIndex:lottery_pic];
    NSString *picName = [Common encodeBase64:(NSMutableData *)[picUrl dataUsingEncoding: NSUTF8StringEncoding]];
    
    //保存缓存图片
    if([FileManager savePhoto:picName withImage:photo])
    {
        return YES;
    }
    else 
    {
        return NO;
    }

}

//获取网络图片
- (void)startIconDownload:(NSString*)photoURL forIndexPath:(NSIndexPath*)indexPath
{
    IconDownLoader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil && photoURL != nil && photoURL.length > 1) 
    {
		if ([imageDownloadsInProgress count]>= 5) {
			imageDownLoadInWaitingObject *one = [[imageDownLoadInWaitingObject alloc]init:photoURL withIndexPath:indexPath withImageType:CUSTOMER_PHOTO];
			[imageDownloadsInWaiting addObject:one];
			[one release];
			return;
		}
        IconDownLoader *iconDownloader = [[IconDownLoader alloc] init];
        iconDownloader.downloadURL = photoURL;
        iconDownloader.indexPathInTableView = indexPath;
		iconDownloader.imageType = CUSTOMER_PHOTO;
        iconDownloader.delegate = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
        [iconDownloader release];
    }
}

//回调 获到网络图片后的回调函数
- (void)appImageDidLoad:(NSIndexPath *)indexPath withImageType:(int)Type
{
    IconDownLoader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        
        // Display the newly loaded image
		if(iconDownloader.cardIcon.size.width>2.0)
		{ 
			//保存图片
			[self savePhoto:iconDownloader.cardIcon atIndexPath:indexPath];
            
            UIImage *pic = [iconDownloader.cardIcon fillSize:CGSizeMake(picWidth, picHeight)];
            self.picView.image = pic;
            [self.picView stopSpinner];
		}
		
		[imageDownloadsInProgress removeObjectForKey:indexPath];
		if ([imageDownloadsInWaiting count]>0) 
		{
			imageDownLoadInWaitingObject *one = [imageDownloadsInWaiting objectAtIndex:0];
			[self startIconDownload:one.imageURL forIndexPath:one.indexPath];
			[imageDownloadsInWaiting removeObjectAtIndex:0];
		}
		
    }
}

//网络获取数据
-(void)accessItemService
{
    NSString *reqUrl = @"luckdraw/luckdraw.do?param=%@";
    
    NSTimeInterval cTime = [[NSDate date] timeIntervalSince1970];
    long long int currentTime = (long long int)cTime;
	
	NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
								 [Common getSecureString],@"keyvalue",
								 [NSNumber numberWithInt: SITE_ID],@"site_id",
								 [NSNumber numberWithInt: [self.userId intValue]],@"user_id",
                                 [NSNumber numberWithInt: [[self.lotteryArray objectAtIndex:lottery_id] intValue]],@"id",
                                 [NSNumber numberWithInt: currentTime],@"created",
								 nil];
	
	[[DataManager sharedManager] accessService:jsontestDic
									   command:OPERAT_SEND_LOTTERY_WIN 
								  accessAdress:reqUrl 
									  delegate:self
									 withParam:nil];
}

//网络请求回调函数
- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver
{
    //do nothing;
}

#pragma mark -
#pragma mark 滚动完成调用
- (void)scrollImageViewDidEndscrolling:(scrollImageView *)scrollImage
{    
    if (!self.scrollImage1.isAnimation && !self.scrollImage2.isAnimation && !self.scrollImage3.isAnimation && isScrolling)
    {
        //震动接口
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        //停止滚动声音
        [self.scrollingPlayer stop];
        [self.scrolledPlayer play];
        
        isScrolling = NO;
        
        //中奖
        if (self.scrollImage1.scrollIndex == self.scrollImage2.scrollIndex && self.scrollImage1.scrollIndex == self.scrollImage3.scrollIndex) 
        {
            isWinUser = YES;
            
            //调用中奖接口
            [self accessItemService];
            
            //提示
            self.resultImageView.image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"抽奖中奖表情" ofType:@"png"]];
            self.resultLabel.text = @"您运气真好,中奖了!";
            
        }
        else
        {
            //提示
            self.resultImageView.image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"抽奖未中奖表情" ofType:@"png"]];
            if(LotterySurplusCount <= 0)
            {
               self.resultLabel.text = @"今天机会已用完,明天再来哦!";
            }
            else
            {
                self.resultLabel.text = @"别泄气,下次一定中!";
            }
        }
        
        //动画
        [self winAnimation];

    }
}

#pragma mark -
#pragma mark 摇一摇监测
- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent*)event {
	//if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake)
    if (motion == UIEventSubtypeMotionShake)
    {
        //判断用户是否登陆
		if (_isLogin == YES) 
		{
			if ([self.userId intValue] != 0)
			{
                //判断当前状态
                int stauts = [[lotteryArray objectAtIndex:lottery_status] intValue];
                if (stauts == 1)
                {
                    //正在进行
                    NSTimeInterval cTime = [[NSDate date] timeIntervalSince1970];
                    long long int currentTime = (long long int)cTime;
                    if(startTime <= currentTime && endTime > currentTime)
                    {
                        //确保没有在滚动 并且没有超过限制次数
                        if (!isScrolling && LotterySurplusCount > 0) 
                        {
                            [self doLottery];
                        }
                    }
                }
			}
			else
			{
                isMyPrizeLogin = NO;
				LoginViewController *login = [[LoginViewController alloc] init];
                login.delegate = self;
				[self.navigationController pushViewController:login animated:YES];
				[login release];
			}
			
		}
		else 
		{
            isMyPrizeLogin = NO;
			LoginViewController *login = [[LoginViewController alloc] init];
            login.delegate = self;
			[self.navigationController pushViewController:login animated:YES];
			[login release];
		}
	}
}

#pragma mark -
#pragma mark 登录接口回调
- (void)loginWithResult:(BOOL)isLoginSuccess{
    
	if (isLoginSuccess) 
    {
        if (isMyPrizeLogin) 
        {
            [self performSelector:@selector(myPrize) withObject:nil afterDelay:0.5];
        }
	}
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.lotteryID = nil;
    self.lotteryArray = nil;
    self.lotteryPicArray = nil;
    for (IconDownLoader *one in [imageDownloadsInProgress allValues]){
		one.delegate = nil;
	}
	self.imageDownloadsInProgress = nil;
	self.imageDownloadsInWaiting = nil;
    self.picView = nil;
    self.timeLabel = nil;
    self.statusImageView = nil;
    self.lotteryResultView = nil;
    self.tipsLabel = nil;
    self.shakeImageView = nil;
    self.resultImageView = nil;
    self.resultLabel = nil;
    self.scrollImage1 = nil;
    self.scrollImage2 = nil;
    self.scrollImage3 = nil;
    self.scrollingPlayer = nil;
    self.scrolledPlayer = nil;
}

- (void)dealloc {
	
    [self.lotteryID release];
    [self.lotteryArray release];
    [self.lotteryPicArray release];
    for (IconDownLoader *one in [imageDownloadsInProgress allValues]){
		one.delegate = nil;
	}
	[self.imageDownloadsInProgress release];
	[self.imageDownloadsInWaiting release];
    [self.picView release];
    [self.timeLabel release];
    [self.statusImageView release];
    [self.lotteryResultView release];
    [self.tipsLabel release];
    [self.shakeImageView release];
    [self.resultImageView release];
    [self.resultLabel release];
    [self.scrollImage1 release];
    [self.scrollImage2 release];
    [self.scrollImage3 release];
    self.scrollingPlayer = nil;
    [self.scrolledPlayer release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
