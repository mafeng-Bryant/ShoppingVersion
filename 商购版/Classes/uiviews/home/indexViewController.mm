//
//  indexViewController.m
//  shopping
//
//  Created by lai yun on 12-12-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "indexViewController.h"
#import "Common.h"
#import "FileManager.h"
#import "UIImageScale.h"
#import "downloadParam.h"
#import "imageDownLoadInWaitingObject.h"
#import "searchViewController.h"
#import "shoppingAppDelegate.h"
#import "specialListViewController.h"
#import "newsViewController.h"
#import "scanViewController.h"
#import "lotteryListViewController.h"
#import "MyCollectionViewController.h"
#import "historyViewController.h"
#import "browserViewController.h"
#import "subCatProductViewController.h"
#import "ProductDetailViewController.h"
#import "BaiduMapViewController.h"

@interface indexViewController ()

@end

@implementation indexViewController

@synthesize delegate;
@synthesize spinner;
@synthesize mainScrollView;
@synthesize bannerScrollView;
@synthesize pageControll;
@synthesize contentView;
@synthesize adItems;
@synthesize tagsItems;
@synthesize imageDownloadsInProgress;
@synthesize imageDownloadsInWaiting;

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
    self.view.backgroundColor = [UIColor clearColor];
    
    bannerWidth = self.view.frame.size.width;
    bannerHeight = 220.0f;
    
    iconWidth = 70.0f;
    iconHeight = 70.0f;
    
    NSMutableDictionary *idip = [[NSMutableDictionary alloc]init];
	self.imageDownloadsInProgress = idip;
	[idip release];
	
	NSMutableArray *wait = [[NSMutableArray alloc]init];
	self.imageDownloadsInWaiting = wait;
	[wait release];
    
    //上bar
//    UIImage *topBarImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NAV_BG_PIC ofType:nil]];
    UIImage *topBarImage = nil;
    if (IOS_VERSION >= 7.0) {
        topBarImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:IOS7_NAV_BG_PIC ofType:nil]];
    }else{
        topBarImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NAV_BG_PIC ofType:nil]];
    }
    
    UIImageView *topBarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f , 0.0f , self.view.frame.size.width , topBarImage.size.height)];
	
	topBarImageView.image = topBarImage;
	[topBarImage release];
    
    //添加logo
    UIImage *logoImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"]];
    
    int yValue = 0;
    if (IOS_VERSION >= 7.0) {
        yValue = (topBarImageView.frame.size.height - logoImage.size.height)/2 + 10;
    }else{
        yValue = (topBarImageView.frame.size.height - logoImage.size.height)/2;
    }
    UIImageView *logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(((topBarImageView.frame.size.width - logoImage.size.width)/2) ,yValue , logoImage.size.width , logoImage.size.height)];
    logoImageView.image = logoImage;
    [logoImage release];
    [topBarImageView addSubview:logoImageView];
	[logoImageView release];
    
    [self.view addSubview:topBarImageView];
	[topBarImageView release];
    
    //获取最搞搜索关键词
    NSArray *keyWordArray = [DBOperate queryData:T_SYSTEM_CONFIG theColumn:@"tag" 
                                             theColumnValue:@"keyWord" withAll:NO];
    NSString *keyWord = @"搜索";
	if ([keyWordArray count]>0) 
    {
		keyWord = [[keyWordArray objectAtIndex:0] objectAtIndex:1];
	}
    
    //搜索
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f , CGRectGetMaxY(topBarImageView.frame) , self.view.frame.size.width, 40.0f)];
    searchBar.backgroundImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"共用二级bar背景" ofType:@"png"]];
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchBar.keyboardType = UIKeyboardTypeDefault;
    searchBar.delegate = self;
    searchBar.placeholder = keyWord;
    [self.view addSubview:searchBar];
    [searchBar release];
    
    //主体
    UIScrollView *tmpScroll = [[UIScrollView alloc] initWithFrame:CGRectMake( 0.0f , CGRectGetMaxY(searchBar.frame) , self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(searchBar.frame) - 49.0f)];
    tmpScroll.contentSize = CGSizeMake(self.view.frame.size.width, tmpScroll.frame.size.height);
    tmpScroll.pagingEnabled = NO;
    tmpScroll.showsHorizontalScrollIndicator = NO;
    tmpScroll.showsVerticalScrollIndicator = NO;
    tmpScroll.delegate = self;
    self.mainScrollView = tmpScroll;
    [tmpScroll release];
    [self.view addSubview:self.mainScrollView];
    
    //下拉更新
	_refreshHeaderView = nil;
	_reloading = NO;
	EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.mainScrollView.bounds.size.height, self.view.frame.size.width, self.mainScrollView.bounds.size.height)];
	view.delegate = self;
	[self.mainScrollView addSubview:view];
	_refreshHeaderView = view;
	[view release];
	[_refreshHeaderView refreshLastUpdatedDate];
    
    //增加的遮盖图层
    UIImage *coverImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"上bar底部遮盖" ofType:@"png"]];
    UIImageView *coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f , CGRectGetMaxY(searchBar.frame) , coverImage.size.width , coverImage.size.height)];
    coverImageView.image = coverImage;
    [coverImage release];
    [self.view addSubview:coverImageView];
	[coverImageView release];
	
    //添加loading图标
	UIActivityIndicatorView *tempSpinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
	[tempSpinner setCenter:CGPointMake(self.view.frame.size.width / 3, self.mainScrollView.frame.size.height / 2.0)];
	self.spinner = tempSpinner;
	UILabel *loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 100, 20)];
	loadingLabel.font = [UIFont systemFontOfSize:14];
	loadingLabel.textColor = [UIColor colorWithRed:0.5 green: 0.5 blue: 0.5 alpha:1.0];
	loadingLabel.text = LOADING_TIPS;		
	loadingLabel.textAlignment = NSTextAlignmentCenter;
	loadingLabel.backgroundColor = [UIColor clearColor];
	[self.spinner addSubview:loadingLabel];
    [loadingLabel release];
	[self.mainScrollView addSubview:self.spinner];
	[self.spinner startAnimating];
	[tempSpinner release];
    
    //网络请求
    [self accessItemService];
}

//添加广告banner
-(void)addBannerScrollView
{
    //取广告数据
    self.adItems = [DBOperate queryData:T_AD_LIST 
								 theColumn:@"" theColumnValue:@"" orderBy:@"sort_order" orderType:@"desc" withAll:YES];
    
    if (![self.bannerScrollView isDescendantOfView:self.mainScrollView]) 
    {
        UIScrollView *tmpScroll = [[UIScrollView alloc] initWithFrame:CGRectMake( 0.0f , 0.0f , bannerWidth, bannerHeight)];
        tmpScroll.contentSize = CGSizeMake(tmpScroll.frame.size.width, tmpScroll.frame.size.height);
        tmpScroll.pagingEnabled = YES;
        tmpScroll.delegate = self;
        tmpScroll.showsHorizontalScrollIndicator = NO;
        tmpScroll.showsVerticalScrollIndicator = NO;
        self.bannerScrollView = tmpScroll;
        [tmpScroll release];
        
        [self.mainScrollView addSubview:self.bannerScrollView];
    }
    
    //内容
    NSArray *viewsToRemove = [self.bannerScrollView subviews]; 
    for (UIView *v in viewsToRemove) 
    {
        [v removeFromSuperview];
    }
    
    NSUInteger pageCount = [self.adItems count];
    if (pageCount > 0)
    {
        for(NSUInteger i = 0;i < pageCount;i++)
		{
            myImageView *myiv = [[myImageView alloc]initWithFrame:
								 CGRectMake( bannerWidth*i , 0.0f, bannerWidth, bannerHeight) withImageId:[NSString stringWithFormat:@"%lu",(unsigned long)i]];
			UIImage *img = [[UIImage alloc]initWithContentsOfFile:
							[[NSBundle mainBundle] pathForResource:@"默认图banner" ofType:@"png"]];
			myiv.image = img;
			[img release];
			myiv.mydelegate = self;
			myiv.tag = 1000 + i;
			
			[self.bannerScrollView addSubview:myiv];
            [myiv release];
			
            NSArray *pic = [self.adItems objectAtIndex:i];
            NSString *photoUrl = [pic objectAtIndex:ad_list_img];
            NSString *picName = [Common encodeBase64:(NSMutableData *)[photoUrl dataUsingEncoding: NSUTF8StringEncoding]];
            
            if (photoUrl.length > 1) 
            {
                UIImage *photo = [FileManager getPhoto:picName];
                if (photo.size.width > 2)
                {
                    myiv.image = [photo fillSize:CGSizeMake(bannerWidth,bannerHeight)];
                }
                else
                {
                    [myiv startSpinner];
                    [self startIconDownload:photoUrl forIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                }
            }
		}
        
        self.bannerScrollView.contentSize = CGSizeMake(pageCount * bannerWidth, bannerHeight);
        
        if (pageCount > 1)
        {
            int pageUnitWidth = 20.0f;
            CGFloat pageControllWidth = pageUnitWidth * pageCount;
            CGFloat pageControllHeight = 15.0f;
            if(self.pageControll == nil)
            {
                UIPageControl *tempPageControll = [[UIPageControl alloc] initWithFrame:CGRectMake(self.view.center.x - (pageControllWidth/2.0), CGRectGetMaxY(self.bannerScrollView.frame) - pageControllHeight, pageControllWidth, pageControllHeight)];
                self.pageControll = tempPageControll;
                [tempPageControll release];
                [pageControll addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
                [self.mainScrollView addSubview:self.pageControll];
                
            }
            self.pageControll.numberOfPages = pageCount;
            self.pageControll.currentPage = 0;
        }
    }
}

//添加主内容 icon按钮
-(void)addContentView
{
    //先移出
    [self.contentView removeFromSuperview];
    
    UIView *tempContentView = [[UIView alloc] initWithFrame:CGRectMake( 0.0f , CGRectGetMaxY(self.bannerScrollView.frame), self.view.frame.size.width, 285.0f)];
    tempContentView.backgroundColor = [UIColor clearColor];
    self.contentView = tempContentView;
    [self.mainScrollView addSubview:self.contentView];
    [tempContentView release];
    
    //icon按钮背景
    UIImage *iconBackgroundImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"首页icon背景" ofType:@"png"]];
    UIImageView *iconBackgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake( 0.0f , 0.0f , iconBackgroundImage.size.width , iconBackgroundImage.size.height)];
    iconBackgroundImageView.image = iconBackgroundImage;
    [iconBackgroundImage release];
    [self.contentView addSubview:iconBackgroundImageView];
	[iconBackgroundImageView release];
    
    //获取标签按钮
    self.tagsItems = [DBOperate queryData:T_SPECIAL_TAGS 
                              theColumn:@"" theColumnValue:@"" orderBy:@"sort_order" orderType:@"desc" withAll:YES];
    
    //中间icon间隔
    CGFloat midIconWidth = ((self.view.frame.size.width - (4*iconWidth)) / 5);
    
    // =======================  添加第一排按钮  ========================
    
    //二维码扫描
    UIImage *codeImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"二维码按钮icon" ofType:@"png"]];
    
	UIButton *codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	codeButton.frame = CGRectMake( midIconWidth , midIconWidth , iconWidth, iconHeight);
	[codeButton addTarget:self action:@selector(goCode) forControlEvents:UIControlEventTouchUpInside];
    [codeButton setBackgroundImage:codeImage forState:UIControlStateNormal];
	[self.contentView addSubview:codeButton];
	[codeImage release];
    
    UILabel *codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(codeButton.frame.origin.x, CGRectGetMaxY(codeButton.frame) + 4.5f , codeImage.size.width, 12.0f)];
	codeLabel.text = @"云拍";	
	codeLabel.textColor = [UIColor grayColor];
	codeLabel.font = [UIFont systemFontOfSize:12.0f];
	codeLabel.textAlignment = NSTextAlignmentCenter;
	codeLabel.backgroundColor = [UIColor clearColor];
	[self.contentView addSubview:codeLabel];
	[codeLabel release];
    
    //浏览记录
    UIImage *historyImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"浏览记录按钮icon" ofType:@"png"]];
    
	UIButton *historyButton = [UIButton buttonWithType:UIButtonTypeCustom];
	historyButton.frame = CGRectMake( CGRectGetMaxX(codeButton.frame) + midIconWidth , midIconWidth , iconWidth, iconHeight);
	[historyButton addTarget:self action:@selector(history) forControlEvents:UIControlEventTouchUpInside];
    [historyButton setBackgroundImage:historyImage forState:UIControlStateNormal];
	[self.contentView addSubview:historyButton];
	[historyImage release];
    
    UILabel *historyLabel = [[UILabel alloc] initWithFrame:CGRectMake(historyButton.frame.origin.x, CGRectGetMaxY(historyButton.frame) + 4.5f , historyImage.size.width, 12.0f)];
	historyLabel.text = @"浏览记录";	
	historyLabel.textColor = [UIColor grayColor];
	historyLabel.font = [UIFont systemFontOfSize:12.0f];
	historyLabel.textAlignment = NSTextAlignmentCenter;
	historyLabel.backgroundColor = [UIColor clearColor];
	[self.contentView addSubview:historyLabel];
	[historyLabel release];
    
    UIButton *thirdButton;
    if (HOME_IS_SHOW_MAP == 1)
    {
        //我的收藏
        UIImage *mapImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"分店地图按钮icon" ofType:@"png"]];
        
        UIButton *mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        mapButton.frame = CGRectMake( CGRectGetMaxX(historyButton.frame) + midIconWidth , midIconWidth , iconWidth, iconHeight);
        [mapButton addTarget:self action:@selector(map) forControlEvents:UIControlEventTouchUpInside];
        [mapButton setBackgroundImage:mapImage forState:UIControlStateNormal];
        [self.contentView addSubview:mapButton];
        [mapImage release];
        
        UILabel *mapLabel = [[UILabel alloc] initWithFrame:CGRectMake(mapButton.frame.origin.x, CGRectGetMaxY(mapButton.frame) + 4.5f , mapImage.size.width, 12.0f)];
        mapLabel.text = @"分店地图";
        mapLabel.textColor = [UIColor grayColor];
        mapLabel.font = [UIFont systemFontOfSize:12.0f];
        mapLabel.textAlignment = NSTextAlignmentCenter;
        mapLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:mapLabel];
        [mapLabel release];
        
        thirdButton = mapButton;
    }
    else
    {
        //我的收藏
        UIImage *favoriteImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"我的收藏按钮icon" ofType:@"png"]];
        
        UIButton *favoriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        favoriteButton.frame = CGRectMake( CGRectGetMaxX(historyButton.frame) + midIconWidth , midIconWidth , iconWidth, iconHeight);
        [favoriteButton addTarget:self action:@selector(favorite) forControlEvents:UIControlEventTouchUpInside];
        [favoriteButton setBackgroundImage:favoriteImage forState:UIControlStateNormal];
        [self.contentView addSubview:favoriteButton];
        [favoriteImage release];
        
        UILabel *favoriteLabel = [[UILabel alloc] initWithFrame:CGRectMake(favoriteButton.frame.origin.x, CGRectGetMaxY(favoriteButton.frame) + 4.5f , favoriteImage.size.width, 12.0f)];
        favoriteLabel.text = @"我的收藏";	
        favoriteLabel.textColor = [UIColor grayColor];
        favoriteLabel.font = [UIFont systemFontOfSize:12.0f];
        favoriteLabel.textAlignment = NSTextAlignmentCenter;
        favoriteLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:favoriteLabel];
        [favoriteLabel release];
        
        thirdButton = favoriteButton;
    }
    
    //活动资讯
    UIImage *newsImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"活动资讯按钮icon" ofType:@"png"]];
    
	UIButton *newsButton = [UIButton buttonWithType:UIButtonTypeCustom];
	newsButton.frame = CGRectMake( CGRectGetMaxX(thirdButton.frame) + midIconWidth , midIconWidth , iconWidth, iconHeight);
	[newsButton addTarget:self action:@selector(news) forControlEvents:UIControlEventTouchUpInside];
    [newsButton setBackgroundImage:newsImage forState:UIControlStateNormal];
	[self.contentView addSubview:newsButton];
	[newsImage release];
    
    UILabel *newsLabel = [[UILabel alloc] initWithFrame:CGRectMake(newsButton.frame.origin.x, CGRectGetMaxY(newsButton.frame) + 4.5f , newsImage.size.width, 12.0f)];
	newsLabel.text = @"活动资讯";	
	newsLabel.textColor = [UIColor grayColor];
	newsLabel.font = [UIFont systemFontOfSize:12.0f];
	newsLabel.textAlignment = NSTextAlignmentCenter;
	newsLabel.backgroundColor = [UIColor clearColor];
	[self.contentView addSubview:newsLabel];
	[newsLabel release];
    
    // =======================  添加第二排按钮 , 支持多排  ========================
    
    //第一个 抽奖 还是固定的
    UIImage *lotteryImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"抽奖按钮icon" ofType:@"png"]];
    
	UIButton *lotteryButton = [UIButton buttonWithType:UIButtonTypeCustom];
	lotteryButton.frame = CGRectMake( midIconWidth , CGRectGetMaxY(codeLabel.frame) + midIconWidth , iconWidth, iconHeight);
	[lotteryButton addTarget:self action:@selector(lottery) forControlEvents:UIControlEventTouchUpInside];
    [lotteryButton setBackgroundImage:lotteryImage forState:UIControlStateNormal];
	[self.contentView addSubview:lotteryButton];
	[lotteryImage release];
    
    UILabel *lotteryLabel = [[UILabel alloc] initWithFrame:CGRectMake(lotteryButton.frame.origin.x, CGRectGetMaxY(lotteryButton.frame) + 4.5f , lotteryImage.size.width, 12.0f)];
	lotteryLabel.text = @"幸运抽奖";	
	lotteryLabel.textColor = [UIColor grayColor];
	lotteryLabel.font = [UIFont systemFontOfSize:12.0f];
	lotteryLabel.textAlignment = UITextAlignmentCenter;
	lotteryLabel.backgroundColor = [UIColor clearColor];
	[self.contentView addSubview:lotteryLabel];
	[lotteryLabel release];
    
    int tagsCount = [self.tagsItems count];
    int residueNum = 0;   //余数
    int divisibleNum = 0;     //整除数
    if (tagsCount > 0)
    {
        for (int i = 0; i < tagsCount; i ++) 
        {
            NSArray *tagsArray = [self.tagsItems objectAtIndex:i];
            residueNum = (i + 1) % 4;
            divisibleNum = (i + 1) / 4;
            
            //自适应宽度
            CGFloat fixMarginWidth = ((residueNum + 1) * midIconWidth) + (residueNum * iconWidth);
            
            //自适应高度
            CGFloat fixMarginHeight = CGRectGetMaxY(codeLabel.frame) + midIconWidth + (divisibleNum * (midIconWidth + lotteryButton.frame.size.height + lotteryLabel.frame.size.height + 4.5f));
            
            UIButton *tempButton = [UIButton buttonWithType:UIButtonTypeCustom];
            tempButton.frame = CGRectMake(fixMarginWidth , fixMarginHeight , iconWidth , iconHeight);
            [tempButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            tempButton.tag = 2000 + i;
            [self.contentView addSubview:tempButton];
            
            NSString *photoUrl = [tagsArray objectAtIndex:special_tags_icon];
			NSString *picName = [Common encodeBase64:(NSMutableData *)[photoUrl dataUsingEncoding: NSUTF8StringEncoding]];
            UIButton *currentButton = (UIButton *)[self.contentView viewWithTag:2000 + i];
            
            if (photoUrl.length > 1) 
            {
                UIImage *photo = [[FileManager getPhoto:picName] fillSize:CGSizeMake(iconWidth, iconHeight)];
                if (photo.size.width > 2)
                {
                    [currentButton setBackgroundImage:photo forState:UIControlStateNormal];
                }
                else
                {
                    UIImage *imageIcon = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"首页默认icon" ofType:@"png"]];
                    [currentButton setBackgroundImage:imageIcon forState:UIControlStateNormal];
                    
                    [self startIconDownload:photoUrl forIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
                }
            }
            else
            {
                UIImage *imageIcon = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"首页默认icon" ofType:@"png"]];
                [currentButton setBackgroundImage:imageIcon forState:UIControlStateNormal];
            }
            
            UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(fixMarginWidth, CGRectGetMaxY(tempButton.frame) + 4.5f , tempButton.frame.size.width , 12.0f)];
            tempLabel.text = [NSString stringWithFormat:@"%@",[tagsArray objectAtIndex:special_tags_name]];	
            tempLabel.textColor = [UIColor grayColor];
            tempLabel.font = [UIFont systemFontOfSize:12.0f];
            tempLabel.textAlignment = UITextAlignmentCenter;
            tempLabel.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:tempLabel];
            [tempLabel release];
        }
    }
    
    CGFloat floatTagsCount = [self.tagsItems count];
    CGFloat floatNum = ceil((floatTagsCount + 1.0) / 4.0);
    CGFloat contentViewHeigh = CGRectGetMaxY(codeLabel.frame) + midIconWidth + (floatNum * (midIconWidth + lotteryButton.frame.size.height + lotteryLabel.frame.size.height + 4.5f));
    
    //提示层
    UIView *tipsView = [[UIView alloc] initWithFrame:CGRectMake( 90.0f , contentViewHeigh , self.view.frame.size.width - 180.0f , 88.0f)];
    tipsView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:tipsView];
    [tipsView release];
    
    UIImage *tipsImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"首页提示左箭头" ofType:@"png"]];
    UIImageView *tipsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f , 20.0f , tipsImage.size.width , tipsImage.size.height)];
    tipsImageView.image = tipsImage;
    [tipsImage release];
    [tipsView addSubview:tipsImageView];
	[tipsImageView release];
    
    UILabel *tipsTitleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake( CGRectGetMaxX(tipsImageView.frame) , 10.0f , 110.0f , 20.0f)];
    tipsTitleLabel1.backgroundColor = [UIColor clearColor];
    tipsTitleLabel1.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
    tipsTitleLabel1.font = [UIFont systemFontOfSize:12.0f];
    tipsTitleLabel1.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
    tipsTitleLabel1.textAlignment = UITextAlignmentCenter;
    tipsTitleLabel1.text = @"向右滑";
    [tipsView addSubview:tipsTitleLabel1];
    [tipsTitleLabel1 release];
    
    UILabel *tipsTitleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake( CGRectGetMaxX(tipsImageView.frame) , 30.0f , 110.0f , 20.0f)];
    tipsTitleLabel2.backgroundColor = [UIColor clearColor];
    tipsTitleLabel2.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
    tipsTitleLabel2.font = [UIFont systemFontOfSize:12.0f];
    tipsTitleLabel2.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
    tipsTitleLabel2.textAlignment = UITextAlignmentCenter;
    tipsTitleLabel2.text = @"精彩内容不断";
    [tipsView addSubview:tipsTitleLabel2];
    [tipsTitleLabel2 release];
    
    //contentViewHeigh += self.view.frame.size.height <= 460.0f ? 0.0f : 88.0f;
    
    [self.contentView setFrame:CGRectMake( 0.0f , CGRectGetMaxY(self.bannerScrollView.frame), self.view.frame.size.width, contentViewHeigh)];
    
    //设置主体高度
    self.mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.bannerScrollView.frame.size.height + self.contentView.frame.size.height + 1);
    
    //iphone4默认不完全显示
    if (self.view.frame.size.height <= 460.0f)
    {
        self.mainScrollView.contentOffset = CGPointMake(0.0f, 90.0f);
    }
    
    //----- 精品推荐、特价专区都不显示时，隐藏提示层 ---------
    NSArray *isShowRecommendArray = [DBOperate queryData:T_SYSTEM_CONFIG theColumn:@"tag"
                                          theColumnValue:@"isShowRecommend" withAll:NO];
	int isShowRecommend = 0;
	if ([isShowRecommendArray count]>0)
    {
		isShowRecommend = [[[isShowRecommendArray objectAtIndex:0] objectAtIndex:1] intValue];
	}
    
    NSArray *isShowSpecialOfferArray = [DBOperate queryData:T_SYSTEM_CONFIG theColumn:@"tag"
                                             theColumnValue:@"isShowSpecialOffer" withAll:NO];
	int isShowSpecialOffer = 0;
	if ([isShowSpecialOfferArray count]>0)
    {
		isShowSpecialOffer = [[[isShowSpecialOfferArray objectAtIndex:0] objectAtIndex:1] intValue];
	}
    
    if (isShowRecommend == 0 && isShowSpecialOffer == 0) {
        tipsView.hidden = YES;
    }
}

//搜索
-(void)search
{

}

//二维码扫描
-(void)goCode
{
    shoppingAppDelegate *shoppingDelegate = (shoppingAppDelegate *)[UIApplication sharedApplication].delegate;
    scanViewController *scanView = [[scanViewController alloc] init];
    [shoppingDelegate.navController pushViewController:scanView animated:YES];
    [scanView release];
}

//历史记录
-(void)history
{
    shoppingAppDelegate *shoppingDelegate = (shoppingAppDelegate *)[UIApplication sharedApplication].delegate;
    historyViewController *historyView = [[historyViewController alloc] init];
    [shoppingDelegate.navController pushViewController:historyView animated:YES];
    [historyView release];
}

//分店地图
-(void)map
{
    shoppingAppDelegate *shoppingDelegate = (shoppingAppDelegate *)[UIApplication sharedApplication].delegate;
    BaiduMapViewController *map = [[BaiduMapViewController alloc] init];
    [shoppingDelegate.navController pushViewController:map animated:YES];
    //[map release];
}

//我的收藏
-(void)favorite
{
    shoppingAppDelegate *shoppingDelegate = (shoppingAppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSArray *ay = [DBOperate queryData:T_MEMBER_INFO theColumn:nil theColumnValue:nil withAll:YES];
    
    if ([ay count] == 0) {
        LoginViewController *login = [[LoginViewController alloc] init];
        login.delegate = self;
        [shoppingDelegate.navController pushViewController:login animated:YES];
        [login release];
    }else {
        MyCollectionViewController *collect = [[MyCollectionViewController alloc] init];
        [shoppingDelegate.navController pushViewController:collect animated:YES];
        [collect release];
    }
}

//活动资讯
-(void)news
{
    shoppingAppDelegate *shoppingDelegate = (shoppingAppDelegate *)[UIApplication sharedApplication].delegate;
    newsViewController *newView = [[newsViewController alloc] init];
    [shoppingDelegate.navController pushViewController:newView animated:YES];
    [newView release];
}

//抽奖
-(void)lottery
{
    shoppingAppDelegate *shoppingDelegate = (shoppingAppDelegate *)[UIApplication sharedApplication].delegate;
    lotteryListViewController *lotteryListView = [[lotteryListViewController alloc] init];
    [shoppingDelegate.navController pushViewController:lotteryListView animated:YES];
    [lotteryListView release];
}

//广告下滑动画
-(void)adDownAnimations
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationCurve:1];
    self.mainScrollView.contentOffset = CGPointMake(0.0f, 0.0f);
    [UIView commitAnimations];
}

//自定义按钮
-(void)buttonAction:(id)sender
{
    UIButton *selectedButton = sender;
    int index = selectedButton.tag - 2000;
    NSArray *tagsArray = [self.tagsItems objectAtIndex:index];
    shoppingAppDelegate *shoppingDelegate = (shoppingAppDelegate *)[UIApplication sharedApplication].delegate;
    specialListViewController *specialListView = [[specialListViewController alloc] init];
    specialListView.contentType = 1;
    specialListView.specialId = [NSString stringWithFormat:@"%@",[tagsArray objectAtIndex:special_tags_id]];
    specialListView.titleString = [NSString stringWithFormat:@"%@",[tagsArray objectAtIndex:special_tags_name]];
    [shoppingDelegate.navController pushViewController:specialListView animated:YES];
    [specialListView release];

}

- (void) pageTurn: (UIPageControl *) aPageControl
{
	int whichPage = aPageControl.currentPage;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	self.bannerScrollView.contentOffset = CGPointMake(bannerWidth * whichPage, 0.0f);
	[UIView commitAnimations];
    
    //广告下滑
    [self adDownAnimations];
}

//保存缓存图片
-(bool)savePhoto:(UIImage*)photo atIndexPath:(NSIndexPath*)indexPath
{
    if ([indexPath section] == 0)
    {
        //banner图片
        int countItems = [self.adItems count];
        if (countItems > [indexPath row]) 
        {
            NSArray *pic = [self.adItems objectAtIndex:[indexPath row]];
            NSString *picName = [Common encodeBase64:(NSMutableData *)[[pic objectAtIndex:ad_list_img] dataUsingEncoding: NSUTF8StringEncoding]];
            
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
    }
    else if([indexPath section] == 1)
    {
        //标签图片
        int countItems = [self.tagsItems count];
        if (countItems > [indexPath row]) 
        {
            NSArray *pic = [self.tagsItems objectAtIndex:[indexPath row]];
            NSString *picName = [Common encodeBase64:(NSMutableData *)[[pic objectAtIndex:special_tags_icon] dataUsingEncoding: NSUTF8StringEncoding]];
            
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
    }
    
	return NO;
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
            
            if ([indexPath section] == 0)
            {
                UIImage *photo = [iconDownloader.cardIcon fillSize:CGSizeMake(bannerWidth, bannerHeight)];
                //banner图片
                myImageView *currentMyImageView = (myImageView *)[self.bannerScrollView viewWithTag:1000 + [indexPath row]];
                currentMyImageView.image = photo;
                [currentMyImageView stopSpinner];
            }
            else if([indexPath section] == 1)
            {
                UIImage *photo = [iconDownloader.cardIcon fillSize:CGSizeMake(iconWidth, iconHeight)];
                //按钮标签图片
                UIButton *currentButton = (UIButton *)[self.contentView viewWithTag:2000 + [indexPath row]];
                [currentButton setBackgroundImage:photo forState:UIControlStateNormal];
            }
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
    NSString *reqUrl = @"index/list.do?param=%@";
	
	NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
								 [Common getSecureString],@"keyvalue",
								 [NSNumber numberWithInt: SITE_ID],@"site_id",
                                 [Common getVersion:OPERAT_AD_REFRESH],@"ad_ver",
                                 [Common getVersion:OPERAT_SPECIAL_TAGS_REFRESH],@"tags_ver",
								 nil];
	
	[[DataManager sharedManager] accessService:jsontestDic
									   command:OPERAT_INDEX_REFRESH 
								  accessAdress:reqUrl 
									  delegate:self
									 withParam:nil];
}

//更新数据
-(void)update
{
    //首页布局
    if ([delegate respondsToSelector:@selector(reSetMainScrollView)]) 
    {
        [delegate performSelector:@selector(reSetMainScrollView) withObject:nil afterDelay:0.0];
    }

    //广告
    [self addBannerScrollView];
    
    //按钮标签
    [self addContentView];

    [self backNormal];
}

//回归常态
-(void)backNormal
{
	//loading图标移除
	if (self.spinner != nil) {
		[self.spinner stopAnimating];
	}
	
	//下拉缩回
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:NO];
}

//网络请求回调函数
- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver
{
    [self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
}

#pragma mark -
#pragma mark 图片滚动委托
- (void)imageViewTouchesEnd:(NSString *)imageId
{	
    NSArray *adArray = [self.adItems objectAtIndex:[imageId intValue]];
    int tpye = [[adArray objectAtIndex:ad_list_ad_type] intValue];
    
    //点击统计
    int adID = [[adArray objectAtIndex:ad_list_id] intValue];
    [self pvAction:adID];
    
    switch (tpye)
    {
        //活动资讯
        case 1:
        {
            [self news];
            break;
        }
        //精品推荐
        case 2:
        {
            if ([delegate respondsToSelector:@selector(showRecommendView)]) 
            {
                [delegate performSelector:@selector(showRecommendView) withObject:nil afterDelay:0.0];
            }
            break;
        }
        //抽奖
        case 3:
        {
            [self lottery];
            break;
        }
        //普通连接
        case 4:
        {
            shoppingAppDelegate *shoppingDelegate = (shoppingAppDelegate *)[UIApplication sharedApplication].delegate;
            browserViewController *browser = [[browserViewController alloc] init];
            browser.isShowTool = YES;
            browser.url = [adArray objectAtIndex:ad_list_url];
            [shoppingDelegate.navController pushViewController:browser animated:YES];
            [browser release];
            break;
        }
        //首页栏目
        case 5:
        {
            NSArray *tagsArray = [DBOperate queryData:T_SPECIAL_TAGS 
                                            theColumn:@"id" theColumnValue:[adArray objectAtIndex:ad_list_info_id] orderBy:@"sort_order" orderType:@"desc" withAll:NO];
            NSString *title = @"";
            if ([tagsArray count] > 0)
            {
                title = [[tagsArray objectAtIndex:0] objectAtIndex:special_tags_name];
            }
            
            shoppingAppDelegate *shoppingDelegate = (shoppingAppDelegate *)[UIApplication sharedApplication].delegate;
            specialListViewController *specialListView = [[specialListViewController alloc] init];
            specialListView.contentType = 1;
            specialListView.specialId = [NSString stringWithFormat:@"%@",[adArray objectAtIndex:ad_list_info_id]];
            specialListView.titleString = title;
            [shoppingDelegate.navController pushViewController:specialListView animated:YES];
            [specialListView release];
            break;
        }
        //特价专区
        case 6:
        {
            NSArray *specialOfferArray = [DBOperate queryData:T_SPECIAL_OFFER 
                                            theColumn:@"id" theColumnValue:[adArray objectAtIndex:ad_list_info_id] orderBy:@"sort_order" orderType:@"desc" withAll:NO];
            NSString *title = @"";
            if ([specialOfferArray count] > 0)
            {
                title = [[specialOfferArray objectAtIndex:0] objectAtIndex:special_offer_name];
            }
            
            shoppingAppDelegate *shoppingDelegate = (shoppingAppDelegate *)[UIApplication sharedApplication].delegate;
            specialListViewController *specialListView = [[specialListViewController alloc] init];
            specialListView.contentType = 2;
            specialListView.specialId = [NSString stringWithFormat:@"%@",[adArray objectAtIndex:ad_list_info_id]];
            specialListView.titleString = title;
            [shoppingDelegate.navController pushViewController:specialListView animated:YES];
            [specialListView release];
            break;
        }
        //商品分类
        case 7:
        {
            shoppingAppDelegate *shoppingDelegate = (shoppingAppDelegate *)[UIApplication sharedApplication].delegate;
            subCatProductViewController *subCatProductView = [[subCatProductViewController alloc] init];
            subCatProductView.catId = [NSString stringWithFormat:@"%@",[adArray objectAtIndex:ad_list_info_id]];
            [shoppingDelegate.navController pushViewController:subCatProductView animated:YES];
            [subCatProductView release];
            break;
        }
        //某个商品
        case 8:
        {
            shoppingAppDelegate *shoppingDelegate = (shoppingAppDelegate *)[UIApplication sharedApplication].delegate;
            ProductDetailViewController *ProductDetailView = [[ProductDetailViewController alloc] init];
            ProductDetailView.productID = [[adArray objectAtIndex:ad_list_info_id] intValue];
            [shoppingDelegate.navController pushViewController:ProductDetailView animated:YES];
            [ProductDetailView release];
            break;
        }
        default:
            break;
    }
}

- (void)imageViewDoubleTouchesEnd:(NSString *)imageId
{	

}

//数据统计
- (void)pvAction:(int)_id
{
    NSDate* nowDate = [NSDate date];
    NSDateFormatter *outputFormat = [[NSDateFormatter alloc] init];
    [outputFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [outputFormat stringFromDate:nowDate];
    NSDate *currentDate = [outputFormat dateFromString:dateString];
    [outputFormat release];
    NSTimeInterval t = [currentDate timeIntervalSince1970];   //转化为时间戳
    long long int time = (long long int)t;
    NSNumber *num = [NSNumber numberWithLongLong:time];
    int currentInt = [num intValue];
    NSLog(@"currentInt ==== %d",currentInt);
    
    NSDate* date1 = [NSDate dateWithTimeIntervalSince1970:currentInt];
    NSDateFormatter *outputFormat1 = [[NSDateFormatter alloc] init];
    [outputFormat1 setDateFormat:@"yyyy-MM-dd HH"];
    NSString *dateString1 = [outputFormat1 stringFromDate:date1];
    NSDate *currentDate1 = [outputFormat1 dateFromString:dateString1];
    [outputFormat1 release];
    NSTimeInterval t1 = [currentDate1 timeIntervalSince1970];   //转化为时间戳
    long long int time1 = (long long int)t1;
    NSNumber *num1 = [NSNumber numberWithLongLong:time1];
    int leftInt = [num1 intValue];
    int rightInt = leftInt + 60 * 60;
    
    NSArray *arr = [DBOperate queryData:T_ADS_ACCESS oneColumn:@"currentTime" equalValue:[NSString stringWithFormat:@"%d",leftInt] twoColumn:@"currentTime" equalValue:[NSString stringWithFormat:@"%d",rightInt] threeColumn:@"adId" equalValue:[NSString stringWithFormat:@"%d",_id]];
    if ([arr count] == 0) {
        NSArray *item = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:_id],[NSNumber numberWithInt:currentInt],[NSNumber numberWithInt:1], nil];
        [DBOperate insertDataWithnotAutoID:item tableName:T_ADS_ACCESS];
    }else {
        [DBOperate deleteDataWithTwoConditions:T_ADS_ACCESS oneColumn:@"currentTime" oneValue:[NSString stringWithFormat:@"%d",leftInt] twoColumn:@"currentTime" twoValue:[NSString stringWithFormat:@"%d",rightInt] threeColumn:@"adId" threeValue:[NSString stringWithFormat:@"%d",_id]];
        
        NSMutableArray *listArr = [arr objectAtIndex:0];
        
        int count = [[listArr objectAtIndex:ads_access_visitCount] intValue];
        
        NSArray *item = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:_id],[NSNumber numberWithInt:currentInt],[NSNumber numberWithInt:count + 1], nil];
        [DBOperate insertDataWithnotAutoID:item tableName:T_ADS_ACCESS];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
    if (scrollView == self.mainScrollView) 
    {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (scrollView == self.mainScrollView) 
    {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
	//[super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    
    if(scrollView == self.bannerScrollView)
    {
        [self adDownAnimations];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView == self.bannerScrollView)
    {
        CGPoint offset = scrollView.contentOffset;
        self.pageControll.currentPage = offset.x / bannerWidth;
    }

}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.mainScrollView];
    
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
    
    [self accessItemService];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark -
#pragma mark UISearchBar Delegate Methods
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    shoppingAppDelegate *shoppingDelegate = (shoppingAppDelegate *)[UIApplication sharedApplication].delegate;
    searchViewController *searchView = [[searchViewController alloc] init];
    [shoppingDelegate.navController pushViewController:searchView animated:YES];
    [searchView release];
    
    return NO;
}

#pragma mark -----LoginViewDelegate Method
- (void)loginWithResult:(BOOL)isLoginSuccess
{
    [self performSelector:@selector(toMyCollectView) withObject:nil afterDelay:0.5];
}

- (void)toMyCollectView
{
    shoppingAppDelegate *shoppingDelegate = (shoppingAppDelegate *)[UIApplication sharedApplication].delegate;
    MyCollectionViewController *collect = [[MyCollectionViewController alloc] init];
    [shoppingDelegate.navController pushViewController:collect animated:YES];
    [collect release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.delegate = nil;
    self.spinner = nil;
    self.mainScrollView.delegate = nil;
    self.mainScrollView = nil;
    self.bannerScrollView.delegate = nil;
    self.bannerScrollView = nil;
    self.pageControll = nil;
    self.contentView = nil;
    self.adItems = nil;
    for (IconDownLoader *one in [imageDownloadsInProgress allValues]){
		one.delegate = nil;
	}
	self.imageDownloadsInProgress = nil;
	self.imageDownloadsInWaiting = nil;
    _refreshHeaderView.delegate = nil;
	_refreshHeaderView = nil;
}

- (void)dealloc 
{
    self.delegate = nil;
    self.spinner = nil;
    self.mainScrollView.delegate = nil;
    self.mainScrollView = nil;
    self.bannerScrollView.delegate = nil;
    self.bannerScrollView = nil;
    self.pageControll = nil;
    self.contentView = nil;
    self.tagsItems = nil;
    for (IconDownLoader *one in [imageDownloadsInProgress allValues]){
		one.delegate = nil;
	}
	self.imageDownloadsInProgress = nil;
	self.imageDownloadsInWaiting = nil;
    _refreshHeaderView.delegate = nil;
	_refreshHeaderView = nil;
    [super dealloc];
}

@end
