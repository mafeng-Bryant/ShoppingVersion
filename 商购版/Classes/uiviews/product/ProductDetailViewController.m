//
//  ProductDetailViewController.m
//  shopping
//
//  Created by yunlai on 13-1-21.
//
//

#import "ProductDetailViewController.h"
#import "HPGrowingTextView.h"
#import "UIColumnViewCell.h"
#import "DBOperate.h"
#import "manageActionSheet.h"
#import "callSystemApp.h"
#import "ShareToBlogViewController.h"
#import "SinaViewController.h"
#import "TencentViewController.h"
#import "Common.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "SendMsgToWeChat.h"
#import "UpdateAppAlert.h"
#import "MBProgressHUD.h"
#import "DataManager.h"
#import "alertView.h"
#import "carViewController.h"
#import "FileManager.h"
#import "UIImageScale.h"

#define SHARE_ACTIONSHEET_ID 4001
#define WECHAT_ACTIONSHEET_ID 4002

@interface ProductDetailViewController ()

@end

@implementation ProductDetailViewController

@synthesize catID;
@synthesize productID;
@synthesize productList;
@synthesize isFavorite;
@synthesize userId;
@synthesize operateType;
@synthesize isLike;
@synthesize selectIndex;
@synthesize pType;
@synthesize currentCatId;
@synthesize pvType;
@synthesize pvType3_Id;

-(id)init
{
	self = [super init];
	if(self)
	{
		//注册键盘通知
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillShow:)
													 name:UIKeyboardWillShowNotification
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillHide:)
													 name:UIKeyboardWillHideNotification
												   object:nil];
	}
	
	return self;
}

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
    self.view.backgroundColor = [UIColor clearColor];
    self.title = @"商品展示";

    if (productList != nil && [productList count] > 0) {
        [self updateView:self.productList];
    }else{
        [self accessService];
    }
    
    if (pvType == nil) {
        pvType = @"0";
    }
    isLoadingMore = NO;
}

- (void) dealloc{
    progressHUDTmp.delegate = nil;
    [progressHUDTmp release];
    [productList release];
    [containerView release];
	[textView release];
    [columnView release];
    [shareActionSheet release];
    [weChatAlert release];
    [wechatActionSheet release];
    [userId release];
    [currentCatId release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    NSArray *appTime = [DBOperate queryData:T_PRODUCTS_ACCESS theColumn:nil theColumnValue:nil withAll:YES];
    if ([appTime count] > 0) {
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
        
        int timeValue = [[[appTime objectAtIndex:[appTime count] - 1] objectAtIndex:products_access_currentTime] intValue];
        int stay = [[[appTime objectAtIndex:[appTime count] - 1] objectAtIndex:products_access_stayTime] intValue];
        
        int _id = [[[appTime objectAtIndex:[appTime count] - 1] objectAtIndex:products_access_productId] intValue];
        
        [DBOperate updateWithTwoConditions:T_PRODUCTS_ACCESS theColumn:@"stayTime" theColumnValue:[NSString stringWithFormat:@"%d",currentInt - timeValue + stay] ColumnOne:@"currentTime" valueOne:[NSString stringWithFormat:@"%d",timeValue] columnTwo:@"productId" valueTwo:[NSString stringWithFormat:@"%d",_id]];
    }
}

//数据统计
- (void)pvAction:(int)_index
{
    //NSLog(@"pvType====%@",pvType);
    NSArray *itemArr = [productList objectAtIndex:_index];
    int _id = [[itemArr objectAtIndex:product_id] intValue];
    NSLog(@"_id===%d",_id);
    
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
    
    NSArray *arr = [DBOperate queryData:T_PRODUCTS_ACCESS oneColumn:@"currentTime" equalValue:[NSString stringWithFormat:@"%d",leftInt] twoColumn:@"currentTime" equalValue:[NSString stringWithFormat:@"%d",rightInt] threeColumn:@"productId" equalValue:[NSString stringWithFormat:@"%d",_id]];
    if ([arr count] == 0) {
        NSArray *item = nil;
        if ([self.pvType intValue] == 3) {
            item = [NSArray arrayWithObjects:[NSNumber numberWithInt:_id],[NSNumber numberWithInt:currentInt],@"",[NSNumber numberWithInt:1],[NSNumber numberWithInt:3],[NSNumber numberWithInt:[self.pvType3_Id intValue]], nil];
        }else {
            item = [NSArray arrayWithObjects:[NSNumber numberWithInt:_id],[NSNumber numberWithInt:currentInt],@"",[NSNumber numberWithInt:1],[NSNumber numberWithInt:[self.pvType intValue]],@"", nil];
        }
        
        [DBOperate insertDataWithnotAutoID:item tableName:T_PRODUCTS_ACCESS];
    }else {
        [DBOperate deleteDataWithTwoConditions:T_PRODUCTS_ACCESS oneColumn:@"currentTime" oneValue:[NSString stringWithFormat:@"%d",leftInt] twoColumn:@"currentTime" twoValue:[NSString stringWithFormat:@"%d",rightInt] threeColumn:@"productId" threeValue:[NSString stringWithFormat:@"%d",_id]];
        
        NSMutableArray *listArr = [arr objectAtIndex:0];
        
        int count = [[listArr objectAtIndex:products_access_visitCount] intValue];
        
        NSArray *item = nil;
        if ([self.pvType intValue] == 3) {
            item = [NSArray arrayWithObjects:[NSNumber numberWithInt:_id],[NSNumber numberWithInt:currentInt],[NSNumber numberWithInt:[[listArr objectAtIndex:products_access_stayTime] intValue]],[NSNumber numberWithInt:count + 1],[NSNumber numberWithInt:3],[NSNumber numberWithInt:[self.pvType3_Id intValue]], nil];
        }else {
            item = [NSArray arrayWithObjects:[NSNumber numberWithInt:_id],[NSNumber numberWithInt:currentInt],[NSNumber numberWithInt:[[listArr objectAtIndex:products_access_stayTime] intValue]],[NSNumber numberWithInt:count + 1],[NSNumber numberWithInt:[self.pvType intValue]],@"", nil];
        }
        [DBOperate insertDataWithnotAutoID:item tableName:T_PRODUCTS_ACCESS];
    }
}

//请求产品详情数据
- (void) accessService{
    if (progressHUDTmp == nil) {
        progressHUDTmp = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
        progressHUDTmp.delegate = self;
        progressHUDTmp.labelText = @"加载中...";
        [self.view addSubview:progressHUDTmp];
        [self.view bringSubviewToFront:progressHUDTmp];
        [progressHUDTmp show:YES];
    }
    NSString *reqUrl = @"product/detail.do?param=%@";
    NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [Common getSecureString],@"keyvalue",
                                 [NSNumber numberWithInt: SITE_ID],@"site_id",
                                 [NSNumber numberWithInt:productID],@"product_id",
                                 nil];
    
    [[DataManager sharedManager] accessService:jsontestDic
                                       command:OPERAT_PRODUCT_DETAIL_COMMAND_ID
                                  accessAdress:reqUrl
                                      delegate:self
                                     withParam:nil];
}

- (void)addToHistory:(int)currentIndex
{
    [self pvAction:currentIndex];
    //NSLog(@"current===%d",currentIndex);
    //NSLog(@"itemsArray ===== %@",[productList objectAtIndex:currentIndex]);
    NSMutableArray *historyProduct = [[NSMutableArray alloc] init];
    NSMutableArray *historyProductPics = nil;
    for (int i = 0; i < [[productList objectAtIndex:currentIndex] count]; i++) {
        if (i != [[productList objectAtIndex:currentIndex] count] - 1) {
            [historyProduct addObject:[[productList objectAtIndex:currentIndex] objectAtIndex:i]];
        }else {
            historyProductPics = [[productList objectAtIndex:currentIndex] objectAtIndex:i];
        }
    }
    
    [historyProduct insertObject:@"" atIndex:[historyProduct count]];
    NSString *productId = [NSString stringWithFormat:@"%d",[[historyProduct objectAtIndex:0] intValue]];
    [DBOperate deleteData:T_HISTORY_PRODUCT tableColumn:@"id" columnValue:productId];
    [DBOperate insertDataWithnotAutoID:historyProduct tableName:T_HISTORY_PRODUCT];
    
    //NSLog(@"historyProductPics ==== %@",historyProductPics);
    [DBOperate deleteData:T_HISTORY_PRODUCT_PIC tableColumn:@"product_id" columnValue:productId];
    
    if (historyProductPics != nil)
    {
        for (int j = 0; j < [historyProductPics count]; j ++) {
            NSMutableArray *arr = [historyProductPics objectAtIndex:j];
            [DBOperate insertDataWithnotAutoID:arr tableName:T_HISTORY_PRODUCT_PIC];
        }
    }
    
    [historyProduct release];
}

- (void) updateView:(NSMutableArray*)array{
    
    if (progressHUDTmp != nil) {
        [progressHUDTmp hide:YES];
        [progressHUDTmp removeFromSuperview];
    }
    if (array != nil && [array count] > 0) {
        [self addProductTableview];
        //增加的遮盖图层
        UIImage *coverImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"上bar底部遮盖" ofType:@"png"]];
        UIImageView *coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f , 0 , coverImage.size.width , coverImage.size.height)];
        coverImageView.image = coverImage;
        [coverImage release];
        [self.view addSubview:coverImageView];
        [coverImageView release];
        
        //获取当前用户的user_id
        NSMutableArray *memberArray = (NSMutableArray *)[DBOperate queryData:T_MEMBER_INFO theColumn:@"" theColumnValue:@"" withAll:YES];
        if ([memberArray count] > 0)
        {
            self.userId = [[memberArray objectAtIndex:0] objectAtIndex:member_info_memberId];
        }
        else
        {
            self.userId = @"0";
        }
        NSLog(@"userId:%@",userId);
        NSLog(@"productID:%d",productID);
        //判断该信息是否为当前用户收藏
        NSMutableArray *favorite = (NSMutableArray *)[DBOperate
                                                      queryData:T_FAVORITED_PRODUCTS theColumn:@"product_id"
                                                      equalValue:[NSString stringWithFormat:@"%d",productID]
                                                      theColumn:@"user_id" equalValue:userId];
        
        if (favorite == nil || ![favorite count] > 0)
        {
            //没有收藏
            isFavorite = NO;
        }
        else
        {
            //已收藏
            isFavorite = YES;
        }
        //判断该信息是否为当前用户喜欢产品
        NSMutableArray *likeList = (NSMutableArray *)[DBOperate
                                                      queryData:T_FAVORITED_LIKES theColumn:@"likes_id"
                                                      equalValue:[NSString stringWithFormat:@"%d",productID] theColumn:@"user_id" equalValue:userId];
        
        
        if (likeList == nil || ![likeList count] > 0)
        {
            isLike = NO;
        }
        else
        {
            //已喜欢
            isLike = YES;
        }
        
        //评论输入框
        [self addButtomBar];
        
        //定制下bar
        [self showCustomToolbar];
    }else{
        //添加市场价
        UILabel *noneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,12,self.view.frame.size.width,30)];
        noneLabel.backgroundColor = [UIColor clearColor];
        noneLabel.font = [UIFont systemFontOfSize:16];
        noneLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
        noneLabel.text = @"此商品已下架";
        noneLabel.textAlignment = UITextAlignmentCenter;
        [self.view addSubview:noneLabel];
        [noneLabel release];
    }
    
}

- (void) addProductTableview{
    //添加产品滑动view
    CGRect frame = CGRectMake(0, 0.0f, self.view.bounds.size.width, [[UIScreen mainScreen] bounds].size.height-44-44-40-20);
    columnView = [[UIColumnView alloc] initWithFrame:frame];
    columnView.pagingEnabled = YES;
    columnView.backgroundColor = [UIColor clearColor];
    columnView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    columnView.viewDelegate = self;
    columnView.delegate = self;
    columnView.viewDataSource = self;
    [self.view addSubview:columnView];
    
    NSLog(@"selectIndex:%d",selectIndex);
    columnView.contentOffset = CGPointMake(320 * selectIndex, 0);
}

- (void) addButtomBar{
    
	containerView = [[UIView alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-20-44-44-40, 320, 40)];
    
	textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 3, 235, 40)];
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
	textView.minNumberOfLines = 1;
	textView.maxNumberOfLines = 3;
	textView.returnKeyType = UIReturnKeyDefault; //just as an example
	textView.font = [UIFont systemFontOfSize:15.0f];
    textView.textColor = [UIColor grayColor];
	textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.backgroundColor = [UIColor whiteColor];
    textView.text = @"评论";
    
    // textView.text = @"test\n\ntest";
	// textView.animateHeightChange = NO; //turns off animation
	
    [self.view addSubview:containerView];
	
    UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[[UIImageView alloc] initWithImage:entryBackground] autorelease];
    entryImageView.frame = CGRectMake(5, 0, 240, 40);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    entryImageView.tag = 2000;
	
    UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:background] autorelease];
    imageView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // view hierachy
    [containerView addSubview:imageView];
    [containerView addSubview:textView];
    [containerView addSubview:entryImageView];
	
   
	//字数统计
	UILabel *remainCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(265.0f, 5.0f, 50.0f, 20.0f)];
	[remainCountLabel setFont:[UIFont systemFontOfSize:12.0f]];
	remainCountLabel.textColor = [UIColor colorWithRed:0.5 green: 0.5 blue: 0.5 alpha:1.0];
	remainCountLabel.tag = 2004;
	remainCountLabel.text = @"140/140";
	remainCountLabel.hidden = YES;
	remainCountLabel.backgroundColor = [UIColor clearColor];
	remainCountLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
	remainCountLabel.textAlignment = UITextAlignmentCenter;
	[containerView addSubview:remainCountLabel];
	[remainCountLabel release];
    
	//添加发送按钮
	UIImage *sendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
	UIImage *selectedSendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
	
	UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	sendBtn.frame = CGRectMake(containerView.frame.size.width - 65, 8, 50, 27);
	sendBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
	[sendBtn setTitle:@"评论" forState:UIControlStateNormal];
	[sendBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
	sendBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
	sendBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
	sendBtn.tag = 2003;
	sendBtn.hidden = NO;
	[sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[sendBtn addTarget:self action:@selector(publishComment:) forControlEvents:UIControlEventTouchUpInside];
	[sendBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
	[sendBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
	[containerView addSubview:sendBtn];
	
	[self.view addSubview:containerView];
}

- (void) showCustomToolbar{
	UIImageView *toolBarView = [[UIImageView alloc] initWithFrame:
								CGRectMake(0.0f, [[UIScreen mainScreen] bounds].size.height-20-44-44, 320.0f, 44.0f)];
	UIImage *image = [[UIImage alloc]initWithContentsOfFile:
					  [[NSBundle mainBundle] pathForResource:@"产品详情下bar" ofType:@"png"]];
	toolBarView.image = image;
	toolBarView.tag = 3005;
	toolBarView.userInteractionEnabled = YES;
	[image release];
	[self.view addSubview:toolBarView];
	
	int buttonMargin = (320 - 24*4)/5;
	int offset;
	
	UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[shareBtn setFrame:CGRectMake(buttonMargin, 10, 24, 24)];
	[shareBtn setImage:[UIImage imageNamed:@"产品详情分享.png"] forState:UIControlStateNormal];
	[shareBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
	[toolBarView addSubview:shareBtn];
	
	offset = buttonMargin*2 + 24;
	
    likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[likeBtn setFrame:CGRectMake(offset, 10, 24, 24)];
    if (isLike) {
        [likeBtn setImage:[UIImage imageNamed:@"产品详情已喜欢.png"] forState:UIControlStateNormal];
    }else{
        [likeBtn setImage:[UIImage imageNamed:@"产品详情喜欢.png"] forState:UIControlStateNormal];
    }
	[likeBtn addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
	[toolBarView addSubview:likeBtn];
	
	offset = buttonMargin*3 + 24*2;
	
    shoucangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[shoucangBtn setFrame:CGRectMake(offset, 10, 24, 24)];
    if (isFavorite) {
        [shoucangBtn setImage:[UIImage imageNamed:@"产品详情已收藏.png"] forState:UIControlStateNormal];
    }else{
        [shoucangBtn setImage:[UIImage imageNamed:@"产品详情收藏.png"] forState:UIControlStateNormal];
    }
	[shoucangBtn addTarget:self action:@selector(shoucang:) forControlEvents:UIControlEventTouchUpInside];
	[toolBarView addSubview:shoucangBtn];
	
	offset = buttonMargin*4 + 24*3;
    
    UIButton *wechatbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [wechatbtn setFrame:CGRectMake(offset, 10, 24, 24)];
    [wechatbtn setImage:[UIImage imageNamed:@"微信.png"] forState:UIControlStateNormal];
    [wechatbtn addTarget:self action:@selector(handleToWeChat:) forControlEvents:UIControlEventTouchUpInside];
    [toolBarView addSubview:wechatbtn];
		
	[toolBarView release];
	
}

#pragma mark -
#pragma mark manageActionSheetDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud{
	
	if (progressHUDTmp)
    {
        [progressHUDTmp removeFromSuperview];
	}
}

#pragma mark -
#pragma mark manageActionSheetDelegate
- (void) actionSheetAppear:(int)actionID actionSheet:(UIActionSheet *)actionSheet{
	
}
- (void)getChoosedIndex:(int)actionID chooseIndex:(int)index{
    isShowPromotionAlert = YES;
    NSArray *detailAy = [productList objectAtIndex:currentCellIndex];
    NSArray *picarray = [detailAy objectAtIndex:product_pics];
    NSArray *pic_thrum_ay = [picarray objectAtIndex:currentCell.pageControl.currentPage];
    NSString *imageUrl = [pic_thrum_ay objectAtIndex:2];
    NSLog(@"pic_thrum_ay:%@",pic_thrum_ay);
    NSLog(@"imageUrl:%@",imageUrl);
    NSString *picName = [Common encodeBase64:(NSMutableData *)[imageUrl dataUsingEncoding: NSUTF8StringEncoding]];
    //获取分享图片
    UIImage *shareImage = [[FileManager getPhoto:picName] fillSize:CGSizeMake(114, 114)];
    if (shareImage == nil) {
        NSLog(@"no share image");
    }
    //NSString *shareContent = [detailAy objectAtIndex:product_content];
    NSString *shareTitle = [detailAy objectAtIndex:product_title];
    NSString *shareLink = [NSString stringWithFormat:@"%@%@%d",DETAIL_SHARE_LINK,@"product/view/",[[detailAy objectAtIndex:product_id] intValue]];

	NSString *allContent = [NSString stringWithFormat:@"%@  %@",shareTitle,shareLink];
	if (actionID == SHARE_ACTIONSHEET_ID) {
        switch (index) {
            case 0:
            {
                NSString *str = [NSString stringWithFormat:@"%@ %@\n%@",shareTitle,shareLink,SHARE_CONTENTS];
                [callSystemApp sendMessageTo:@"" inUIViewController:self withContent:str];
            }
                break;
            case 1:
            {
                //收件人，cc：抄送  subject：主题   body：内容
                NSString *content = [NSString stringWithFormat:@"%@\n%@",allContent,SHARE_CONTENTS];
                [callSystemApp sendEmail:@"" cc:@"" subject:shareTitle body:content];
            }
                break;
            case 2:
            {
                NSArray *weiboArray = [DBOperate queryData:T_WEIBO_USERINFO theColumn:@"weiboType"
                                            theColumnValue:SINA withAll:NO];
                if (weiboArray != nil && [weiboArray count] > 0) {
                    ShareToBlogViewController *share = [[ShareToBlogViewController alloc] init];
                    share.weiBoType = 0;
                    share.shareImage = shareImage;//newsImageView.image;
                    share.checkBoxSelected =YES;
                    //share.defaultContent = [NSString stringWithFormat:@"%@   %@",allContent,SHARE_CONTENTS];
                    share.defaultContent = [NSString stringWithFormat:@"%@   %@",allContent,@""];
                    [self.navigationController pushViewController:share animated:YES];
                    [share release];
                }else {
                    SinaViewController *sc = [[SinaViewController alloc] init];
                    sc.delegate = self;
                    [self.navigationController pushViewController:sc animated:YES];
                    [sc release];
                }
                
            }
                break;
            case 3:
            {
                NSArray *weiboArray = [DBOperate queryData:T_WEIBO_USERINFO theColumn:@"weiboType"
                                            theColumnValue:TENCENT withAll:NO];
                if (weiboArray != nil && [weiboArray count] > 0) {
                    ShareToBlogViewController *share = [[ShareToBlogViewController alloc] init];
                    share.weiBoType = 1;
                    share.shareImage = nil;//newsImageView.image;
                    share.checkBoxSelected =YES;
                    //share.defaultContent = [NSString stringWithFormat:@"%@   %@",allContent,SHARE_CONTENTS];
                    share.defaultContent = [NSString stringWithFormat:@"%@   %@",allContent,@""];
                    //share.defaultContent = [detailArray objectAtIndex:recommend_news_title];
                    [self.navigationController pushViewController:share animated:YES];
                    [share release];
                }else {
                    TencentViewController *tc = [[TencentViewController alloc] init];
                    tc.delegate = self;
                    [self.navigationController pushViewController:tc animated:YES];
                    [tc release];
                }
            }
                break;
            default :
                break;
        }
    }else if(actionID == WECHAT_ACTIONSHEET_ID){
        SendMsgToWeChat *sendMsg = [[SendMsgToWeChat alloc] init];
        
		if (app_wechat_share_type == app_to_wechat) {
			[sendMsg sendNewsContent:shareTitle newsDescription:shareTitle newsImage:shareImage newUrl:shareLink shareType:index];
		}else if (app_wechat_share_type == wechat_to_app) {
			[sendMsg RespNewsContent:shareTitle newsDescription:shareTitle newsImage:shareImage newUrl:shareLink];
		}
		[sendMsg release];
	}
	
}

#pragma mark OauthSinaSeccessDelagate
- (void) oauthSinaSuccess{
    isShowPromotionAlert = YES;
    NSArray *detailAy = [productList objectAtIndex:currentCellIndex];
    NSArray *picarray = [detailAy objectAtIndex:product_pics];
    NSArray *pic_thrum_ay = [picarray objectAtIndex:currentCell.pageControl.currentPage];
    NSString *imageUrl = [pic_thrum_ay objectAtIndex:2];
    NSLog(@"pic_thrum_ay:%@",pic_thrum_ay);
    NSLog(@"imageUrl:%@",imageUrl);
    NSString *picName = [Common encodeBase64:(NSMutableData *)[imageUrl dataUsingEncoding: NSUTF8StringEncoding]];
    //获取分享图片
    UIImage *shareImage = [[FileManager getPhoto:picName] fillSize:CGSizeMake(114, 114)];
    if (shareImage == nil) {
        NSLog(@"no share image");
    }
    NSString *shareContent = [detailAy objectAtIndex:product_title];
    NSString *shareLink = [NSString stringWithFormat:@"%@%@%d",DETAIL_SHARE_LINK,@"product/view/",[[detailAy objectAtIndex:product_id] intValue]];
    
	NSString *allContent = [NSString stringWithFormat:@"%@  %@",shareContent,shareLink];
    
	ShareToBlogViewController *share = [[ShareToBlogViewController alloc] init];
	share.weiBoType = 0;
	share.shareImage = shareImage;
	share.checkBoxSelected =YES;
    //share.defaultContent = [NSString stringWithFormat:@"%@   %@",allContent,SHARE_CONTENTS];
    share.defaultContent = [NSString stringWithFormat:@"%@   %@",allContent,@""];
    [self.navigationController pushViewController:share animated:YES];
	[share release];
}

#pragma mark OauthTencentSeccessDelagate
- (void) oauthTencentSuccess{
    isShowPromotionAlert = YES;
    NSArray *detailAy = [productList objectAtIndex:currentCellIndex];
    NSArray *picarray = [detailAy objectAtIndex:product_pics];
    NSArray *pic_thrum_ay = [picarray objectAtIndex:currentCell.pageControl.currentPage];
    NSString *imageUrl = [pic_thrum_ay objectAtIndex:2];
    NSLog(@"pic_thrum_ay:%@",pic_thrum_ay);
    NSLog(@"imageUrl:%@",imageUrl);
    NSString *picName = [Common encodeBase64:(NSMutableData *)[imageUrl dataUsingEncoding: NSUTF8StringEncoding]];
    //获取分享图片
    UIImage *shareImage = [[FileManager getPhoto:picName] fillSize:CGSizeMake(114, 114)];
    if (shareImage == nil) {
        NSLog(@"no share image");
    }
    NSString *shareContent = [detailAy objectAtIndex:product_title];
    NSString *shareLink = [NSString stringWithFormat:@"%@%@%d",DETAIL_SHARE_LINK,@"product/view/",[[detailAy objectAtIndex:product_id] intValue]];
    
	NSString *allContent = [NSString stringWithFormat:@"%@  %@",shareContent,shareLink];
    
	ShareToBlogViewController *share = [[ShareToBlogViewController alloc] init];
	share.weiBoType = 1;
	share.shareImage = shareImage;
	share.checkBoxSelected =YES;
    //share.defaultContent = [NSString stringWithFormat:@"%@   %@",allContent,SHARE_CONTENTS];
    share.defaultContent = [NSString stringWithFormat:@"%@   %@",allContent,@""];
	[self.navigationController pushViewController:share animated:YES];
	[share release];
}

- (void) share:(id)sender{
    NSArray *actionSheetMenu = [NSArray arrayWithObjects:@"分享给手机用户",@"分享给邮箱联系人",@"分享到新浪微博",@"分享到腾讯微博",nil];
	shareActionSheet = [[manageActionSheet alloc]initActionSheetWithStrings:actionSheetMenu];
	shareActionSheet.manageDeleage = self;
    shareActionSheet.actionID = SHARE_ACTIONSHEET_ID;
	[shareActionSheet showActionSheet:self.view];
}

#pragma mark 发表评论
-(void)publishComment:(id)sender
{
    if (_isLogin) {
        NSString *content = textView.text;
        
        //把回车 转化成 空格
        content = [content stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
        content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        
        if ([content length] > 0 && ![content isEqualToString:@"评论"])
        {
            if ([content length] > 140)
            {
                [alertView showAlert:@"回复内容不能超过140个字符"];
            }
            else
            {
                progressHUDTmp = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
                progressHUDTmp.delegate = self;
                progressHUDTmp.labelText = @"发送中... ";
                [self.view addSubview:progressHUDTmp];
                [self.view bringSubviewToFront:progressHUDTmp];
                [progressHUDTmp show:YES];
                
                NSString *reqUrl = @"member/comment.do?param=%@";
                NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                             [Common getSecureString],@"keyvalue",
                                             [NSNumber numberWithInt: SITE_ID],@"site_id",
                                             [NSNumber numberWithInt:[self.userId intValue]],@"user_id",
                                             [NSNumber numberWithInt: 0],@"type",
                                             [NSNumber numberWithInt:productID],@"info_id",
                                             [NSNumber numberWithInt: 0],@"isPurchase",
                                             content,@"content",
                                             nil];
                
                [[DataManager sharedManager] accessService:jsontestDic
                                                   command:OPERAT_SEND_PRODUCTS_COMMENT
                                              accessAdress:reqUrl
                                                  delegate:self
                                                 withParam:nil];
                
                [textView resignFirstResponder];
            }
        }
        else
        {
            //[alertView showAlert:@"请输入留言内容"];
            [textView becomeFirstResponder];
        }
    }else{
        LoginViewController *login = [[LoginViewController alloc] init];
        login.delegate = self;
        self.operateType = 1;
        [self.navigationController pushViewController:login animated:YES];
        [login release];
    }
    
}

- (void) like:(id)sender
{
	if (!isLike)
	{
		//判断用户是否登陆
		if (_isLogin)
		{
			if (progressHUDTmp == nil) {
				progressHUDTmp = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
				progressHUDTmp.delegate = self;
				progressHUDTmp.labelText = @"发送中... ";
				[self.view addSubview:progressHUDTmp];
				[self.view bringSubviewToFront:progressHUDTmp];
			}
			[progressHUDTmp show:YES];
			
			
			NSString *reqUrl = @"member/like.do?param=%@";
			
			NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
										 [Common getSecureString],@"keyvalue",
										 [NSNumber numberWithInt: SITE_ID],@"site_id",
										 [NSNumber numberWithInt:[self.userId intValue]],@"user_id",
										 [NSNumber numberWithInt:productID],@"product_id",
										 nil];
			
			[[DataManager sharedManager] accessService:jsontestDic
											   command:OPERAT_SEND_PRODUCTS_LIKE
										  accessAdress:reqUrl
											  delegate:self
											 withParam:nil];
		}
		else
		{
			LoginViewController *login = [[LoginViewController alloc] init];
			login.delegate = self;
			self.operateType = 2;
			[self.navigationController pushViewController:login animated:YES];
			[login release];
		}
		
	}
}

- (void) shoucang:(id)sender
{
	if (!isFavorite)
	{
		//判断用户是否登陆
		if (_isLogin)
		{
			if (progressHUDTmp == nil) {
				progressHUDTmp = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
				progressHUDTmp.delegate = self;
				progressHUDTmp.labelText = @"发送中... ";
				[self.view addSubview:progressHUDTmp];
				[self.view bringSubviewToFront:progressHUDTmp];
			}
			[progressHUDTmp show:YES];
			
			
			NSString *reqUrl = @"member/favorite.do?param=%@";
			
			NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
										 [Common getSecureString],@"keyvalue",
										 [NSNumber numberWithInt: SITE_ID],@"site_id",
										 [NSNumber numberWithInt:[self.userId intValue]],@"user_id",
										 [NSNumber numberWithInt:productID],@"info_id",
										 [NSNumber numberWithInt: 0],@"type",
										 nil];
			
			[[DataManager sharedManager] accessService:jsontestDic
											   command:OPERAT_SEND_PRODUCTS_FAVORITE
										  accessAdress:reqUrl
											  delegate:self
											 withParam:nil];
		}
		else
		{
			LoginViewController *login = [[LoginViewController alloc] init];
			login.delegate = self;
			self.operateType = 3;
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
        //获取当前用户的user_id
        NSMutableArray *memberArray = (NSMutableArray *)[DBOperate queryData:T_MEMBER_INFO theColumn:@"" theColumnValue:@"" withAll:YES];
        if ([memberArray count] > 0)
        {
            self.userId = [[memberArray objectAtIndex:0] objectAtIndex:member_info_memberId];
        }
        else
        {
            self.userId = @"0";
        }
        
		if (operateType == 1)
        {
            //评论操作，调用评论接口
			[textView resignFirstResponder];
            if ([textView.text length] > 0) {
                [self publishComment:nil];
            }
		}
        else if (operateType == 2)
        {
            //喜欢接口
            [self like:nil];
		}else if(operateType == 3){
            //收藏操作
			[self shoucang:nil];
        }
	}
    
    
}

- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
    
    switch(commandid)
    {
        case OPERAT_PRODUCT_DETAIL_COMMAND_ID:{
            //请求回来的数据交给productList
            self.productList = resultArray;
            [self performSelectorOnMainThread:@selector(updateView:) withObject:resultArray waitUntilDone:NO];
            
        }break;
            //评论
        case OPERAT_SEND_PRODUCTS_COMMENT:
            [self performSelectorOnMainThread:@selector(commentResult:) withObject:resultArray waitUntilDone:NO];
            break;
            
            //收藏
        case OPERAT_SEND_PRODUCTS_FAVORITE:
            [self performSelectorOnMainThread:@selector(favoriteResult:) withObject:resultArray waitUntilDone:NO];
            break;
            //喜欢
        case OPERAT_SEND_PRODUCTS_LIKE:
            [self performSelectorOnMainThread:@selector(likeResult:) withObject:resultArray waitUntilDone:NO];
            break;
            //商品更多
        case OPERAT_PRODUCT_MORE:
            [self performSelectorOnMainThread:@selector(appendMore:) withObject:resultArray waitUntilDone:NO];
            break;
            
        default: ;
    }
}

- (void) appendMore:(NSMutableArray*)array{
    NSLog(@"arrayCount:%d",[array count]);
    isLoadingMore = NO;
    if (array != nil && [array count] > 0) {
        if (progressHUDTmp != nil) {
            [progressHUDTmp hide:YES];
            [progressHUDTmp removeFromSuperview];
        }
//    for (int i = [productList count]-1; i >= 0 ; i--) {
//        [self.productList addObject:[productList objectAtIndex:i]];
//    }
        [productList addObjectsFromArray:array];
        [columnView reloadData];
    }else{
        [progressHUDTmp setLabelText:@"没有更多产品"];
        progressHUDTmp.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-信息.png"]] autorelease];
        progressHUDTmp.mode = MBProgressHUDModeCustomView;
        [progressHUDTmp hide:YES afterDelay:1.5f];
    }
    
}

- (void)commentResult:(NSMutableArray *)resultArray
{
    int isSuccess = [[resultArray objectAtIndex:0] intValue];
    if (isSuccess == 1 ) {
        if (progressHUDTmp) {
            progressHUDTmp.labelText = @"评论成功";
            progressHUDTmp.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-ok.png"]] autorelease];
            progressHUDTmp.mode = MBProgressHUDModeCustomView;
            [progressHUDTmp hide:YES afterDelay:1.0];
        }
        //实时更新用户评论
        NSMutableArray *array = [[NSMutableArray alloc]init];
        NSDate *date = [NSDate date];
        int created = [date timeIntervalSince1970];
        NSString *content = textView.text;
        //把回车 转化成 空格
        content = [content stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
        content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        
        NSArray *ay = [DBOperate queryData:T_MEMBER_INFO theColumn:nil theColumnValue:nil withAll:YES];
        NSString *userName = [[ay objectAtIndex:0] objectAtIndex:member_info_name];
        NSString *userHeadImage = [[ay objectAtIndex:0] objectAtIndex:member_info_image];

        [array addObject:[NSNumber numberWithInt:created]];
        [array addObject:content];
        [array addObject:userName];
        [array addObject:userHeadImage];
        [currentCell.commentArray insertObject:array atIndex:0];
        [array release];
        if (currentCell.commentArray != nil && [currentCell.commentArray count] > 1) {
            [currentCell.commentTableView reloadData];
        }else{
            [currentCell addCommentTableview];
        }
        
        //置空
        textView.text = @"";
        textView.textColor = [UIColor grayColor];
        
    }else if(isSuccess == 0 ){
        if (progressHUDTmp) {
            progressHUDTmp.labelText = @"评论失败";
            progressHUDTmp.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-信息.png"]] autorelease];
            progressHUDTmp.mode = MBProgressHUDModeCustomView;
            [progressHUDTmp hide:YES afterDelay:1.0];
        }
    }
    
}

- (void)favoriteResult:(NSMutableArray *)resultArray
{
    int isSuccess = [[resultArray objectAtIndex:0] intValue];
    if (isSuccess == 1 ) {
        NSMutableArray *memberArray = (NSMutableArray *)[DBOperate queryData:T_MEMBER_INFO theColumn:@"" theColumnValue:@"" withAll:YES];
        if ([memberArray count] > 0)
        {
            self.userId = [[memberArray objectAtIndex:0] objectAtIndex:member_info_memberId];
        }
        else
        {
            self.userId = @"0";
        }
        
        progressHUDTmp.labelText = @"收藏成功";
        progressHUDTmp.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-ok.png"]] autorelease];
        progressHUDTmp.mode = MBProgressHUDModeCustomView;
        [progressHUDTmp hide:YES afterDelay:1.0];
        
        //将收藏新闻写入新闻收藏表
        NSMutableArray *infoList = [[NSMutableArray alloc] init];
        [infoList addObject:userId];
        [infoList addObject:[NSNumber numberWithInt:productID]];
        [DBOperate insertDataWithnotAutoID:infoList tableName:T_FAVORITED_PRODUCTS];
        [infoList release];
        isFavorite = YES;
        
        [shoucangBtn setImage:[UIImage imageNamed:@"产品详情已收藏.png"] forState:UIControlStateNormal];
    }else {
        progressHUDTmp.labelText = @"收藏失败";
        progressHUDTmp.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-信息.png"]] autorelease];
        progressHUDTmp.mode = MBProgressHUDModeCustomView;
        [progressHUDTmp hide:YES afterDelay:1.0];
    }
    
}
- (void)likeResult:(NSMutableArray *)resultArray
{
    int isSuccess = [[resultArray objectAtIndex:0] intValue];
    if (isSuccess == 1 ) {
        NSMutableArray *memberArray = (NSMutableArray *)[DBOperate queryData:T_MEMBER_INFO theColumn:@"" theColumnValue:@"" withAll:YES];
        if ([memberArray count] > 0)
        {
            self.userId = [[memberArray objectAtIndex:0] objectAtIndex:member_info_memberId];
        }
        else
        {
            self.userId = @"0";
        }
        
        progressHUDTmp.labelText = @"已喜欢";
        progressHUDTmp.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-信息.png"]] autorelease];
        progressHUDTmp.mode = MBProgressHUDModeCustomView;
        [progressHUDTmp hide:YES afterDelay:1.0];
        [likeBtn setImage:[UIImage imageNamed:@"产品详情已喜欢.png"] forState:UIControlStateNormal];
        
        //将收藏新闻写入新闻收藏表
        NSMutableArray *infoList = [[NSMutableArray alloc] init];
        [infoList addObject:userId];
        [infoList addObject:[NSNumber numberWithInt:productID]];
        [DBOperate insertDataWithnotAutoID:infoList tableName:T_FAVORITED_LIKES];
        
        [infoList release];
        
        isLike = YES;
    }else {
        progressHUDTmp.labelText = @"喜欢失败";
        progressHUDTmp.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-信息.png"]] autorelease];
        progressHUDTmp.mode = MBProgressHUDModeCustomView;
        [progressHUDTmp hide:YES afterDelay:1.0];
    }
}

- (void) handleToWeChat:(id)sender{
//    if(![WXApi isWXAppInstalled]){
//		NSString *wechaturl = @"http://itunes.apple.com/cn/app/wei-xin/id414478124?mt=8";
//		weChatAlert = [[UpdateAppAlert alloc]
//                       initWithContent:nil content:@"使用微信可以方便、免费的与好友分享图片、新闻"
//                       leftbtn:@"取消" rightbtn:@"下载微信" url:wechaturl onViewController:self.navigationController];
//		[weChatAlert showAlert];
//	}else {
		NSArray *actionSheetMenu = [NSArray arrayWithObjects:@"分享到微信朋友圈",@"去微信分享给好友",nil];
		wechatActionSheet = [[manageActionSheet alloc]initActionSheetWithStrings:actionSheetMenu];
		wechatActionSheet.manageDeleage = self;
		wechatActionSheet.actionID = WECHAT_ACTIONSHEET_ID;
		[wechatActionSheet showActionSheet:self.navigationController.navigationBar];
//	}
}


#pragma mark -
#pragma mark UIColumnViewDelegate method implementation

- (void)columnView:(UIColumnView *)columnView didSelectColumnAtIndex:(NSUInteger)index {
    NSLog(@"%s selected:%d", __FUNCTION__, index);
}


- (CGFloat)columnView:(UIColumnView *)columnView widthForColumnAtIndex:(NSUInteger)index {
    return 320.0f;
}


#pragma mark -
#pragma mark UIColumnViewDataSource method implementation
- (NSUInteger)numberOfColumnsInColumnView:(UIColumnView *)columnView {
    NSLog(@"productList:%@",productList);
    return [productList count];
}


- (UITableViewCell *)columnView:(UIColumnView *)columnView1 viewForColumnAtIndex:(NSUInteger)index {
    static NSString *cellIdentifier = @"defaultCell";
    NSLog(@"columnViewindex:%d",index);
    currentCellIndex = index;
    UIColumnViewCell *cell = (UIColumnViewCell *)[columnView1 dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UIColumnViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.delegate = self;
    }
    
    NSLog(@"productList:%@",productList);
    cell.productDetailData = [productList objectAtIndex:index];
    
    cell.myNavigationController = self.navigationController;
    [cell addComponent];
    
    [self addToHistory:index];
    currentCell = cell;
    return cell;
}

#pragma mark ScrollIndexDelegate
- (void) getScrollIndex:(NSUInteger)index{
  
}

#pragma mark 改变键盘按钮
-(void)buttonChange:(BOOL)isKeyboardShow
{
	//判断软键盘显示
	if (isKeyboardShow)
	{
        UIButton *sendBtn = (UIButton *)[containerView viewWithTag:2003];
        
        //增长输入框
        if (sendBtn.hidden)
        {
            UIImageView *entryImageView = (UIImageView *)[containerView viewWithTag:2000];
            CGRect entryFrame = entryImageView.frame;
            entryFrame.size.width += 20.0f;
            
            CGRect textFrame = textView.frame;
            textFrame.size.width += 20.0f;
            
            entryImageView.frame = entryFrame;
            textView.frame = textFrame;
        }
        
		//隐藏分享 收藏按钮
		UIImageView *shareButton = (UIImageView *)[containerView viewWithTag:2001];
		UIImageView *favoriteButton = (UIImageView *)[containerView viewWithTag:2002];
		shareButton.hidden = YES;
		favoriteButton.hidden = YES;
		
		//显示字数统计
		UILabel *remainCountLabel = (UILabel *)[containerView viewWithTag:2004];
		remainCountLabel.hidden = YES;
		
		//显示发送按钮
		sendBtn.hidden = NO;
        
	}
	else
	{
		//显示分享 收藏按钮
		UIImageView *shareButton = (UIImageView *)[containerView viewWithTag:2001];
		UIImageView *favoriteButton = (UIImageView *)[containerView viewWithTag:2002];
		shareButton.hidden = NO;
		favoriteButton.hidden = NO;
		
		//隐藏字数统计
		UILabel *remainCountLabel = (UILabel *)[containerView viewWithTag:2004];
		remainCountLabel.hidden = YES;
		
		//隐藏发送按钮
		UIButton *sendBtn = (UIButton *)[containerView viewWithTag:2003];
		sendBtn.hidden = NO;
		
		//缩小输入框
		UIImageView *entryImageView = (UIImageView *)[containerView viewWithTag:2000];
		CGRect entryFrame = entryImageView.frame;
//		entryFrame.size.width -= 20.0f;
		
		CGRect textFrame = textView.frame;
//		textFrame.size.width -= 20.0f;
		
		entryImageView.frame = entryFrame;
		textView.frame = textFrame;
        
	}
    
}

//关闭键盘
-(void)hiddenKeyboard
{
    //输入内容 存起来
    textView.text = @"评论";
	textView.textColor = [UIColor grayColor];
	[textView resignFirstResponder];
}

#pragma mark -
#pragma mark 键盘通知调用
//Code from Brett Schumann
-(void) keyboardWillShow:(NSNotification *)note{
	
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    
	//新增一个遮罩按钮
    UIButton *bgBtn = (UIButton *)[self.view viewWithTag:2005];
    if (bgBtn != nil) {
        [bgBtn removeFromSuperview];
    }  //解决评论后不能拖动的问题
	UIButton *backGrougBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	backGrougBtn.frame = CGRectMake(0, 0, self.view.frame.size.width, [[UIScreen mainScreen] bounds].size.height - 20*2-44 - (keyboardBounds.size.height + containerFrame.size.height));
	backGrougBtn.tag = 2005;
	[backGrougBtn addTarget:self action:@selector(hiddenKeyboard) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:backGrougBtn];
	
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
	containerView.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
	
	//更改按钮状态
	[self buttonChange:YES];
	
}

-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height-44;
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
	containerView.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
    
	//移出遮罩按钮
	UIButton *backGrougBtn = (UIButton *)[self.view viewWithTag:2005];
	[backGrougBtn removeFromSuperview];
	
	//更改按钮状态
	[self buttonChange:NO];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
	
	CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	containerView.frame = r;
}

- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView
{
	return YES;
}

- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView
{
	textView.text = @"";
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	[self performSelectorOnMainThread:@selector(doEditing) withObject:nil waitUntilDone:NO];
	
	return YES;
}

//编辑中
-(void)doEditing
{
	UILabel *remainCountLabel = (UILabel *)[containerView viewWithTag:2004];
	int textCount = [textView.text length];
	if (textCount > 140)
	{
		remainCountLabel.textColor = [UIColor colorWithRed:1.0 green: 0.0 blue: 0.0 alpha:1.0];
	}
	else
	{
		remainCountLabel.textColor = [UIColor colorWithRed:0.5 green: 0.5 blue: 0.5 alpha:1.0];
	}
	remainCountLabel.text = [NSString stringWithFormat:@"%d/140",140 - [textView.text length]];
}



#pragma mark -
#pragma mark UIScrollViewDelegate method implementation
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollPosition = scrollView.contentSize.width - scrollView.frame.size.width - scrollView.contentOffset.x;
//    NSLog(@"scrollPosition:%f",scrollPosition);
    
    //往右拉，加载更多产品
    if (scrollPosition < -30){
        isLoadingMore = YES;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView{
    //-----记录在当前页停留了多久
    NSArray *appTime = [DBOperate queryData:T_PRODUCTS_ACCESS theColumn:nil theColumnValue:nil withAll:YES];
    if ([appTime count] > 0) {
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
        
        int timeValue = [[[appTime objectAtIndex:[appTime count] - 2] objectAtIndex:products_access_currentTime] intValue];
        int stay = [[[appTime objectAtIndex:[appTime count] - 2] objectAtIndex:products_access_stayTime] intValue];
        
        int _id = [[[appTime objectAtIndex:[appTime count] - 2] objectAtIndex:products_access_productId] intValue];
        
        [DBOperate updateWithTwoConditions:T_PRODUCTS_ACCESS theColumn:@"stayTime" theColumnValue:[NSString stringWithFormat:@"%d",currentInt - timeValue + stay] ColumnOne:@"currentTime" valueOne:[NSString stringWithFormat:@"%d",timeValue] columnTwo:@"productId" valueTwo:[NSString stringWithFormat:@"%d",_id]];
    }
    //--------------

    if (isLoadingMore) {
        [self accessMoreService];
//        [self appendMore:nil];
    }
}

- (void) accessMoreService{
    if (progressHUDTmp == nil) {
        progressHUDTmp = [[MBProgressHUD alloc] initWithView:self.view];
        progressHUDTmp.delegate = self;
    }
    progressHUDTmp.labelText = @"正在加载更多";
    [self.view addSubview:progressHUDTmp];
    [self.view bringSubviewToFront:progressHUDTmp];
    [progressHUDTmp show:YES];
    
    //请求更多数据
    NSString *reqUrl = @"product/list.do?param=%@";
    NSArray *productArray = [self.productList objectAtIndex:[self.productList count]-1];
//    NSArray *productArray = [self.productList objectAtIndex:0];
    int sort_order = [[productArray objectAtIndex:product_sort_order] intValue];
	
	NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
								 [Common getSecureString],@"keyvalue",
								 [NSNumber numberWithInt: -1],@"ver",
								 [NSNumber numberWithInt: SITE_ID],@"site_id",
                                 [NSNumber numberWithInt: [currentCatId intValue]],@"cate_id",
								 [NSNumber numberWithInt: sort_order],@"sort_order",
								 nil];
	NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								  self.currentCatId,@"cat_id",
								  nil];
	[[DataManager sharedManager] accessService:jsontestDic
									   command:OPERAT_PRODUCT_MORE
								  accessAdress:reqUrl
									  delegate:self
									 withParam:param];
}

@end
