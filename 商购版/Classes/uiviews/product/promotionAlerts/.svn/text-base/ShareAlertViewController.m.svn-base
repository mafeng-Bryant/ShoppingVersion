//
//  ShareAlertViewController.m
//  information
//
//  Created by MC374 on 12-12-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShareAlertViewController.h"
#import "DBOperate.h"
#import "ShareToBlogViewController.h"
#import "LoginViewController.h"
#import "Common.h"
#import "FileManager.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "SendMsgToWeChat.h"
#import "UIImageScale.h"
#import "manageActionSheet.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "SendMsgToWeChat.h"
#import "UpdateAppAlert.h"

#define MARGIN 8

@interface ShareAlertViewController ()

@end

@implementation ShareAlertViewController
@synthesize shareContentArray;
@synthesize myNavigationController;
@synthesize actionsheet;

- (id)initWithFrame:(CGRect)frame contentArray:(NSArray*)ay{
	if ((self = [super initWithFrame:frame])) {
            
        self.shareContentArray = ay;
        
		self.headerLabel.text = @"";
        
        // Margin between edge of container frame and panel. Default = 20.0
        self.outerMarginX = 10.0f;
//        self.outerMarginY = 90.0f;
        
        // Margin between edge of panel and the content area. Default = 20.0
        self.innerMargin = 0.0f;
        
        // Border color of the panel. Default = [UIColor whiteColor]
        self.borderColor = [UIColor clearColor];
        
        // Border width of the panel. Default = 1.5f;
        self.borderWidth = 0.0f;
        
        // Corner radius of the panel. Default = 4.0f
        self.cornerRadius = 10.0f;
        
        // Color of the panel itself. Default = [UIColor colorWithWhite:0.0 alpha:0.8]
        self.contentColor = [UIColor whiteColor];
        
        // Shows the bounce animation. Default = YES
        self.shouldBounce = NO;
        
        // Height of the title view. Default = 40.0f
        [self setTitleBarHeight:0];
        
        // The gradient style (Linear, linear reversed, radial, radial reversed, center highlight). Default = UAGradientBackgroundStyleLinear
        [[self titleBar] setGradientStyle:(0)];
        
        // The line mode of the gradient view (top, bottom, both, none). Top is a white line, bottom is a black line.
        [[self titleBar] setLineMode: pow(2, 0)];
        
        // The noise layer opacity. Default = 0.4
        //[[self titleBar] setNoiseOpacity:(((arc4random() % 10) + 1) * 0.1)];
        
        // The header label, a UILabel with the same frame as the titleBar
        //[self headerLabel].font = [UIFont boldSystemFontOfSize:floor(self.titleBarHeight / 2.0)];
                
        int offsetY = 0;
        //添加优惠劵活动描述
        UILabel *descLabel = nil;
        descLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 25,260,30 )];
        [descLabel setLineBreakMode:UILineBreakModeWordWrap];
        [descLabel setMinimumFontSize:18.0f];
        [descLabel setNumberOfLines:0];
        [descLabel setFont:[UIFont systemFontOfSize:18.0f]];
        descLabel.backgroundColor = [UIColor clearColor];
        NSString *text = @"分享即可领取优惠劵！";
        if (shareContentArray != nil) {
            text = [shareContentArray objectAtIndex:shareclientpromotion_tip];
        }
        CGSize constraint = CGSizeMake(260, 20000.0f);
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:18.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        float fixHeight = size.height;
        fixHeight = fixHeight == 0 ? 30.f : fixHeight;
        [descLabel setText:text];
        [descLabel setFrame:CGRectMake(20, 25, 260, fixHeight)];        
        [self.contentView addSubview:descLabel]; 
        [descLabel release];
        
        offsetY += 25+fixHeight;
        
        //添加剪刀图片
        UIImageView *cutImageView = [[UIImageView alloc] initWithFrame:CGRectMake(250, offsetY+80+MARGIN, 30, 30)];
        UIImage *cutImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"剪刀" ofType:@"png"]];
        cutImageView.image = cutImage;
        [cutImage release],cutImage = nil;
        [self.contentView addSubview:cutImageView];
        [cutImageView release],cutImageView = nil;
        
        //添加优惠劵背景图片
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(-2, offsetY+MARGIN, 304, 90)];
        UIImage *image = [FileManager getPhoto:[shareContentArray objectAtIndex:shareclientpromotion_img_name]];
        imageview.image = image;
        [image release],image = nil;
        [self.contentView addSubview:imageview];
//        [imageview release],imageview = nil;
        
        //添加优惠劵的文字描述
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 14,260,20)];
        nameLabel.text = [shareContentArray objectAtIndex:shareclientpromotion_name];
        nameLabel.font = [UIFont systemFontOfSize:14.0f];
        nameLabel.textAlignment = UITextAlignmentLeft;
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.backgroundColor = [UIColor clearColor];
        [imageview addSubview:nameLabel];
        [nameLabel release];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30,260,50)];
        NSString *price = [shareContentArray objectAtIndex:shareclientpromotion_price];
        priceLabel.text = [NSString stringWithFormat:@"%@%@ %@",@"￥",price,[shareContentArray objectAtIndex:shareclientpromotion_unitName]];
        priceLabel.font = [UIFont systemFontOfSize:28.0f];
        priceLabel.textAlignment = UITextAlignmentLeft;
        priceLabel.textColor = [UIColor whiteColor];
        priceLabel.backgroundColor = [UIColor clearColor];
        [imageview addSubview:priceLabel];
        [priceLabel release];
        
        UILabel *youXiaoQiLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 18,80,20)];
        youXiaoQiLabel.text = @"有效期";
        youXiaoQiLabel.font = [UIFont systemFontOfSize:14.0f];
        youXiaoQiLabel.textAlignment = UITextAlignmentRight;
        youXiaoQiLabel.textColor = [UIColor whiteColor];
        youXiaoQiLabel.backgroundColor = [UIColor clearColor];
        [imageview addSubview:youXiaoQiLabel];
        [youXiaoQiLabel release];
        
        NSTimeInterval starttime = [[shareContentArray objectAtIndex:shareclientpromotion_startTime] doubleValue];
        NSTimeInterval endtime = [[shareContentArray objectAtIndex:shareclientpromotion_endTime] doubleValue];

        NSDate* startDate = [NSDate dateWithTimeIntervalSince1970:starttime];
        NSDate* endDate = [NSDate dateWithTimeIntervalSince1970:endtime];
        NSDateFormatter *outputFormat = [[NSDateFormatter alloc] init];
        [outputFormat setDateFormat:@"yyyy-MM-dd"];
        NSString *startString = [outputFormat stringFromDate:startDate];
         NSString *endString = [outputFormat stringFromDate:endDate];
        [outputFormat release];
        
        UILabel *startLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 40,80,20)];
        startLabel.text = startString;
        startLabel.font = [UIFont systemFontOfSize:14.0f];
        startLabel.textAlignment = UITextAlignmentRight;
        startLabel.textColor = [UIColor whiteColor];
        startLabel.backgroundColor = [UIColor clearColor];
        [imageview addSubview:startLabel];
        [startLabel release];
        
        UILabel *endLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 60,80,20)];
        endLabel.text = endString;
        endLabel.font = [UIFont systemFontOfSize:14.0f];
        endLabel.textAlignment = UITextAlignmentRight;
        endLabel.textColor = [UIColor whiteColor];
        endLabel.backgroundColor = [UIColor clearColor];
        [imageview addSubview:endLabel];
        [endLabel release];
        
        offsetY += 90+MARGIN;
        
        UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, offsetY+MARGIN,260,20)];
        shareLabel.text = @"立即分享到";
        shareLabel.font = [UIFont systemFontOfSize:16.0f];
        shareLabel.textAlignment = UITextAlignmentLeft;
        shareLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
        shareLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:shareLabel];
        [shareLabel release];
        
        offsetY += 20+MARGIN;
        
        //添加三个分享平台的按钮
        UIButton *sinaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sinaButton.frame = CGRectMake(23,offsetY + MARGIN,70,70);
        [sinaButton addTarget:self action:@selector(onSinaButtonClick)
            forControlEvents:UIControlEventTouchUpInside];
        UIImage *sinaImg = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"分享到新浪微博" ofType:@"png"]];
        UIImage *sinaSelectImg = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"分享到新浪微博选中" ofType:@"png"]];
        [sinaButton setImage:sinaImg forState:UIControlStateNormal];
        [sinaButton setImage:sinaSelectImg forState:UIControlStateHighlighted];
        [sinaImg release];
        [sinaSelectImg release];
        [sinaButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];         
        [self.contentView addSubview:sinaButton];
        
        UILabel *sinaLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, offsetY+70+MARGIN,70,25)];
        sinaLabel.text = @"新浪微博";
        sinaLabel.font = [UIFont systemFontOfSize:16.0f];
        sinaLabel.textAlignment = UITextAlignmentCenter;
        sinaLabel.textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
        sinaLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:sinaLabel];
        [sinaLabel release];
        
        UIButton *weChatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        weChatButton.frame = CGRectMake(116,offsetY + MARGIN,70,70);
        [weChatButton addTarget:self action:@selector(onWechatButtonClick)
             forControlEvents:UIControlEventTouchUpInside];
        UIImage *weChatImg = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"分享到微信" ofType:@"png"]];
        UIImage *weChatSelectImg = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"分享到微信选中" ofType:@"png"]];
        [weChatButton setImage:weChatImg forState:UIControlStateNormal];
        [weChatButton setImage:weChatSelectImg forState:UIControlStateHighlighted];
        [weChatImg release];
        [weChatSelectImg release];
        [weChatButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter]; 
        [self.contentView addSubview:weChatButton];
        
        UILabel *weChatLabel = [[UILabel alloc] initWithFrame:CGRectMake(116, offsetY+70+MARGIN,70,25)];
        weChatLabel.text = @"微信";
        weChatLabel.font = [UIFont systemFontOfSize:16.0f];
        weChatLabel.textAlignment = UITextAlignmentCenter;
        weChatLabel.textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
        weChatLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:weChatLabel];
        [weChatLabel release];
        
        UIButton *qqButton = [UIButton buttonWithType:UIButtonTypeCustom];
        qqButton.frame = CGRectMake(209,offsetY + MARGIN,70,70);
        [qqButton addTarget:self action:@selector(onQQButtonClick)
               forControlEvents:UIControlEventTouchUpInside];
        UIImage *qqImg = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"分享到腾讯微博" ofType:@"png"]];
        UIImage *qqSelectImg = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"分享到腾讯微博选中" ofType:@"png"]];
        [qqButton setImage:qqImg forState:UIControlStateNormal];
        [qqButton setImage:qqSelectImg forState:UIControlStateHighlighted];
        [qqImg release];
        [qqSelectImg release];
        [qqButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter]; 
        
        UILabel *qqLabel = [[UILabel alloc] initWithFrame:CGRectMake(209, offsetY+70+MARGIN,70,25)];
        qqLabel.text = @"腾讯微博";
        qqLabel.font = [UIFont systemFontOfSize:16.0f];
        qqLabel.textAlignment = UITextAlignmentCenter;
        qqLabel.textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
        qqLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:qqLabel];
        [qqLabel release];
        
        offsetY += 70+MARGIN+35;
        //设置outerMarginY的值来改变弹出框的高度
        self.outerMarginY = ([UIScreen mainScreen].bounds.size.height - offsetY)/2;
                
        [self.contentView addSubview:qqButton];
	}	
	return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) dealloc{
    [super dealloc];
    [shareContentArray release],shareContentArray = nil;
    [myNavigationController release],myNavigationController = nil;
    [actionsheet release],actionsheet = nil;
}

- (void) onSinaButtonClick{
    [self hide];
    NSString *link = [NSString stringWithFormat:@"www.yunlai.cn"];
    NSString *appLink = [link stringByAppendingFormat:@"/app"];
    NSString *shareUrl = [appLink stringByAppendingFormat:@"?isFromWeixin=1"];
    
    NSArray *weiboArray = [DBOperate queryData:T_WEIBO_USERINFO theColumn:@"weiboType" theColumnValue:SINA withAll:NO];
    NSArray *array = nil;
    
    if(weiboArray != nil && [weiboArray count] > 0){
        array = [weiboArray objectAtIndex:0];
        int oauthTime = [[array objectAtIndex:weibo_oauth_time] intValue];
        int expiredTime = [[array objectAtIndex:weibo_expires_time] intValue];
        NSString *type = [array objectAtIndex:weibo_type];
        NSDate *todayDate = [NSDate date]; 
        NSLog(@"Date:%@",todayDate);
        NSTimeInterval inter = [todayDate timeIntervalSince1970]; 
        int time = inter;
        NSLog(@"current time:%d",time);
        NSLog(@"expiresTime:%d",expiredTime);
        NSLog(@"time - oauthTime:%d",time - oauthTime);
        if(expiredTime - (time - oauthTime) <= 0){
            [DBOperate deleteData:T_WEIBO_USERINFO tableColumn:@"weiboType" columnValue:type];
            weiboArray = nil;
        }
    }
    
    if (weiboArray != nil && [weiboArray count] > 0) {
        array = [weiboArray objectAtIndex:0];
        NSString *accessToken = [array objectAtIndex:weibo_access_token];
        double expiresTime = [[array objectAtIndex:weibo_expires_time] doubleValue];
        NSString *weibo_uid = [array objectAtIndex:weibo_user_id];
        
        //微博分享采用新的接口，使用SinaWeibo类
        SinaWeibo *weibo = [[SinaWeibo alloc] initWithAppKey:SinaAppKey appSecret:SinaAppSecret appRedirectURI:redirectUrl andDelegate:nil];
        weibo.userID = weibo_uid;
        weibo.accessToken = accessToken;
        weibo.expirationDate = [NSDate dateWithTimeIntervalSince1970:expiresTime];
        
//        WBEngine *wbengine = [[WBEngine alloc] initWithAppKey:SinaAppKey appSecret:SinaAppSecret];
//        wbengine.accessToken = accessToken;
//        wbengine.userID = weibo_uid; 
//        wbengine.expireTime = expiresTime;
        //已经绑定了微博账号，调用新浪微博分享界面
        ShareToBlogViewController *share = [[ShareToBlogViewController alloc] init];
        share.defaultContent = [NSString stringWithFormat:@"%@ %@",[shareContentArray objectAtIndex:shareclientpromotion_shareContent],shareUrl];
        share.shareImage = [FileManager getPhoto:[shareContentArray objectAtIndex:shareclientpromotion_shareImg_name]];
        share.weiBoType = 0;
        [self.myNavigationController pushViewController:share animated:YES];
        [share release];
        
    }else {
        LoginViewController *login = [[LoginViewController alloc] init];
        login.delegate = self;
        [self.myNavigationController pushViewController:login animated:YES];
        [login release];
    }
}

- (void) onWechatButtonClick{
    NSArray *actionSheetMenu = [NSArray arrayWithObjects:@"分享到微信朋友圈",@"微信分享给好友",nil];
    manageActionSheet *actionsheet1 = [[manageActionSheet alloc]initActionSheetWithStrings:actionSheetMenu];
    actionsheet1.manageDeleage = self;
    self.actionsheet = actionsheet1;
    [actionsheet1 release];
    [actionsheet showActionSheet:self];
    
}

#pragma mark manageActionSheetDelegate
- (void) actionSheetAppear:(int)actionID actionSheet:(UIActionSheet *)actionSheet{
	
}

- (void)getChoosedIndex:(int)actionID chooseIndex:(int)index{       
    [self hide];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isShowPromotionAlert"];
    UIImage *image = [[FileManager getPhoto:[shareContentArray objectAtIndex:shareclientpromotion_shareImg_name]] fillSize:CGSizeMake(114, 114)];
    if (image == nil) {
        image = [[UIImage alloc]initWithContentsOfFile:
                 [[NSBundle mainBundle] pathForResource:@"微信分享默认图" ofType:@"png"]];
    }
    NSString *shareTitle = [shareContentArray objectAtIndex:shareclientpromotion_name];
    NSString *shareDesc = [shareContentArray objectAtIndex:shareclientpromotion_shareContent];
    SendMsgToWeChat *sendMsg = [[SendMsgToWeChat alloc] init];	
    
    NSString *link = [NSString stringWithFormat:@"www.yunlai.cn"];
    NSString *appLink = [link stringByAppendingFormat:@"/app"];
    NSString *shareUrl = [appLink stringByAppendingFormat:@"?isFromWeixin=1"];
    
    if (app_wechat_share_type == app_to_wechat) {
        [sendMsg sendNewsContent:shareTitle newsDescription:shareDesc newsImage:image newUrl:shareUrl shareType:index];
    }else if (app_wechat_share_type == wechat_to_app) {
        [sendMsg RespNewsContent:shareTitle newsDescription:shareDesc newsImage:image newUrl:shareUrl];
    }			
    [sendMsg release];
}

- (void) onQQButtonClick{
    [self hide];
    
    NSString *link = [NSString stringWithFormat:@"www.yunlai.cn"];
    NSString *appLink = [link stringByAppendingFormat:@"/app"];
    NSString *shareUrl = [appLink stringByAppendingFormat:@"?isFromWeixin=1"];
    
    NSArray *weiboArray = [DBOperate queryData:T_WEIBO_USERINFO theColumn:@"weiboType" theColumnValue:TENCENT withAll:NO];
    NSArray *array = nil;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isShowPromotionAlert"];
    if(weiboArray != nil && [weiboArray count] > 0){
        array = [weiboArray objectAtIndex:0];
        int expiredTime = [[array objectAtIndex:weibo_expires_time] intValue];
        NSDate *todayDate = [NSDate date]; 
        NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:expiredTime];
        NSLog(@"todayDate:%@",todayDate);
        NSLog(@"expirationDate:%@",expirationDate);
        if([todayDate compare:expirationDate] == NSOrderedSame){
            [DBOperate deleteData:T_WEIBO_USERINFO tableColumn:@"weiboType" columnValue:TENCENT];
            weiboArray = nil;
        }else {
            NSLog(@"not expired");
        }
    }
    
    if (weiboArray != nil && [weiboArray count] > 0) {
        array = [weiboArray objectAtIndex:0];
        NSString *accessToken = [array objectAtIndex:weibo_access_token];
        NSString *openid = [array objectAtIndex:weibo_open_id];
        NSString *username = [array objectAtIndex:weibo_user_name];
        
        ShareToBlogViewController *share = [[ShareToBlogViewController alloc] init];
        share.qAccessToken = accessToken;
        share.qOpenid = openid;
        share.qWeiboUserName = username;
        share.defaultContent = [NSString stringWithFormat:@"%@ %@",[shareContentArray objectAtIndex:shareclientpromotion_shareContent],shareUrl];
        share.shareImage = [FileManager getPhoto:[shareContentArray objectAtIndex:shareclientpromotion_shareImg_name]];
        share.weiBoType = 1;
        [self.myNavigationController pushViewController:share animated:YES];
        [share release];
    }else{	
        LoginViewController *login = [[LoginViewController alloc] init];
        login.delegate = self;
        [self.myNavigationController pushViewController:login animated:YES];
        [login release];
    }
}

#pragma mark -
#pragma mark LoginViewController delegate

-(void)loginSuccess:(NSString*)withLoginType{
    
    NSString *link = [NSString stringWithFormat:@"www.yunlai.cn"];
    NSString *appLink = [link stringByAppendingFormat:@"/app"];
    NSString *shareUrl = [appLink stringByAppendingFormat:@"?isFromWeixin=1"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isShowPromotionAlert"];
	if ([withLoginType isEqualToString:SINA]) {
		NSArray *weiboArray = [DBOperate queryData:T_WEIBO_USERINFO theColumn:@"weiboType" theColumnValue:SINA withAll:NO];
		NSArray *array = nil;
		if (weiboArray != nil && [weiboArray count] > 0) {
			array = [weiboArray objectAtIndex:0];
			NSString *accessToken = [array objectAtIndex:weibo_access_token];
			double expiresTime = [[array objectAtIndex:weibo_expires_time] doubleValue];
			NSString *weibo_uid = [array objectAtIndex:weibo_user_id];
            
            //微博分享采用新的接口，使用SinaWeibo类
            SinaWeibo *weibo = [[SinaWeibo alloc] initWithAppKey:SinaAppKey appSecret:SinaAppSecret appRedirectURI:redirectUrl andDelegate:nil];
            weibo.userID = weibo_uid;
            weibo.accessToken = accessToken;
            weibo.expirationDate = [NSDate dateWithTimeIntervalSince1970:expiresTime];
            
//			WBEngine *wbengine = [[WBEngine alloc] initWithAppKey:SinaAppKey appSecret:SinaAppSecret];
//			wbengine.accessToken = accessToken;
//			wbengine.userID = weibo_uid; 
//			wbengine.expireTime = expiresTime;
			//已经绑定了微博账号，调用新浪微博分享界面
			ShareToBlogViewController *share = [[ShareToBlogViewController alloc] init];
            
			share.shareImage = [FileManager getPhoto:[shareContentArray objectAtIndex:shareclientpromotion_shareImg_name]];

			share.checkBoxSelected =YES;
			share.defaultContent = [NSString stringWithFormat:@"%@ %@",[shareContentArray objectAtIndex:shareclientpromotion_shareContent],shareUrl];
//			share.engine = wbengine;
			share.weiBoType = 0;
			[self.myNavigationController pushViewController:share animated:YES];
			[share release];
            [weibo release];
		}
	}else if ([withLoginType isEqualToString:TENCENT]) {
		NSArray *weiboArray = [DBOperate queryData:T_WEIBO_USERINFO theColumn:@"weiboType" theColumnValue:TENCENT withAll:NO];
		NSArray *array = nil;
		if (weiboArray != nil && [weiboArray count] > 0) {
			array = [weiboArray objectAtIndex:0];
			NSString *accessToken = [array objectAtIndex:weibo_access_token];
			NSString *openid = [array objectAtIndex:weibo_open_id];
			NSString *username = [array objectAtIndex:weibo_user_name];
			
			ShareToBlogViewController *share = [[ShareToBlogViewController alloc] init];
            
			share.shareImage = [FileManager getPhoto:[shareContentArray objectAtIndex:shareclientpromotion_shareImg_name]];

			share.checkBoxSelected =YES;
			share.qAccessToken = accessToken;
			share.qOpenid = openid;
			share.qWeiboUserName = username;
            share.defaultContent = [NSString stringWithFormat:@"%@ %@",[shareContentArray objectAtIndex:shareclientpromotion_shareContent],shareUrl];
            share.shareImage = [FileManager getPhoto:[shareContentArray objectAtIndex:shareclientpromotion_shareImg_name]];
			share.weiBoType = 1;
			[self.myNavigationController pushViewController:share animated:YES];
			[share release];
		}
	}
}

@end
