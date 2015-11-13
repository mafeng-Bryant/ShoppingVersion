//
//  ShareSuccessAlertView.m
//  information
//
//  Created by MC374 on 12-12-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShareSuccessAlertView.h"
#import "DBOperate.h"
#import "MenberCenterMainViewController.h"
#import "MBProgressHUD.h"
#import "shoppingAppDelegate.h"
#import "Common.h"
#import "GetPromotionCodeFailAlertView.h"
#import "FileManager.h"
#import "DataManager.h"
#import "LoginViewController.h"

#define MARGIN 20

@implementation ShareSuccessAlertView
@synthesize myNavigationController;
@synthesize shareContentArray;

- (id)initWithFrame:(CGRect)frame{
	if ((self = [super initWithFrame:frame])) {
        
		self.headerLabel.text = @"";
        
        // Margin between edge of container frame and panel. Default = 20.0
        self.outerMarginX = 10.0f;
        
        self.outerMarginY = 90.0f;
        
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
        
        NSArray *ay;
        ay = [DBOperate queryData:T_SHARE_PRODUCT_PROMOTION theColumn:nil theColumnValue:nil withAll:YES];
        
        if (ay != nil && [ay count] > 0) {
            self.shareContentArray = [ay objectAtIndex:0];
        }
        
        //添加图片
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, MARGIN, 64, 64)];
        UIImage *image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"表情成功" ofType:@"png"]];
        imageview.image = image;
        [image release],image = nil;
        [self.contentView addSubview:imageview];
        [imageview release],imageview = nil;
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(84, MARGIN,160,30)];
        label1.text = @"恭喜，分享成功。";
        label1.font = [UIFont systemFontOfSize:17.0f];
        label1.textAlignment = UITextAlignmentLeft;
        label1.textColor = [UIColor blackColor];
        label1.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:label1];
        [label1 release];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(84, MARGIN + 30,220,30)];
        if (_isLogin) {
            label2.text = @"快来领取优惠券！";
        }else {
            label2.text = @"登录会员,优惠劵等你来拿!";
        }
        
        label2.font = [UIFont systemFontOfSize:18.0f];
        label2.textAlignment = UITextAlignmentLeft;
        label2.textColor = [UIColor blackColor];
        label2.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:label2];
        [label2 release];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10,MARGIN*2+64,280,45);
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(onLoginButtonClick)
            forControlEvents:UIControlEventTouchUpInside];
        UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"领取优惠劵" ofType:@"png"]];
        [button setImage:img forState:UIControlStateNormal];
        [img release];
        
        //添加按钮文字描述
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(40, 7, 200, 30)];
        title.font = [UIFont boldSystemFontOfSize:20.0];
        title.textAlignment = UITextAlignmentCenter;
        title.backgroundColor = [UIColor clearColor];
        if (_isLogin) {
            title.text = @"领取优惠劵";
        }else {
            title.text = @"登录领取优惠劵";
        }
        
        title.textColor = [UIColor colorWithRed:0.56 green:0.56 blue:0.56 alpha:1.0];
        [button addSubview:title];
        [title release];
        
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter]; 
        
        [self.contentView addSubview:button];
//        [button release],button = nil;
        
        //添加优惠劵背景图片
        UIImageView *proImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-2, MARGIN*3 + 116, 304, 90)];
        UIImage *proImage;
        
        proImage = [FileManager getPhoto:[shareContentArray objectAtIndex:shareproductpromotion_image_name]];
        proImageView.image = proImage;
        [proImage release],proImage = nil;
        [self.contentView addSubview:proImageView];

        //添加优惠劵的文字描述
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 14,260,20)];
        nameLabel.text = [shareContentArray objectAtIndex:shareproductpromotion_name];
        
        nameLabel.font = [UIFont systemFontOfSize:14.0f];
        nameLabel.textAlignment = UITextAlignmentLeft;
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.backgroundColor = [UIColor clearColor];
        [proImageView addSubview:nameLabel];
        [nameLabel release];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30,260,50)];
        NSString *price;
        NSString *unitName;
        price = [shareContentArray objectAtIndex:shareproductpromotion_price];
        unitName = [shareContentArray objectAtIndex:shareproductpromotion_unitName];
        
        priceLabel.text = [NSString stringWithFormat:@"%@%@ %@",@"￥",price,unitName];
        priceLabel.font = [UIFont systemFontOfSize:28.0f];
        priceLabel.textAlignment = UITextAlignmentLeft;
        priceLabel.textColor = [UIColor whiteColor];
        priceLabel.backgroundColor = [UIColor clearColor];
        [proImageView addSubview:priceLabel];
        [priceLabel release];
        
        UILabel *youXiaoQiLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 18,80,20)];
        youXiaoQiLabel.text = @"有效期";
        youXiaoQiLabel.font = [UIFont systemFontOfSize:14.0f];
        youXiaoQiLabel.textAlignment = UITextAlignmentRight;
        youXiaoQiLabel.textColor = [UIColor whiteColor];
        youXiaoQiLabel.backgroundColor = [UIColor clearColor];
        [proImageView addSubview:youXiaoQiLabel];
        [youXiaoQiLabel release];
        
        int starttime;
        int endtime;
        starttime = [[shareContentArray objectAtIndex:shareproductpromotion_startTime] intValue];
        endtime = [[shareContentArray objectAtIndex:shareproductpromotion_endTime] intValue];
        
                 
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
        [proImageView addSubview:startLabel];
        [startLabel release];
        
        UILabel *endLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 60,80,20)];
        endLabel.text = endString;
        endLabel.font = [UIFont systemFontOfSize:14.0f];
        endLabel.textAlignment = UITextAlignmentRight;
        endLabel.textColor = [UIColor whiteColor];
        endLabel.backgroundColor = [UIColor clearColor];
        [proImageView addSubview:endLabel];
        [endLabel release];
        
        [proImageView release],proImageView = nil;
    }
    return self;
}

#pragma mark -----MemberLoginViewDelegate method
- (void)loginWithResult:(BOOL)isLoginSuccess
{
    if(isLoginSuccess){
        NSLog(@"loginSuccess");
        shoppingAppDelegate *appDelegate = (shoppingAppDelegate*)[[UIApplication sharedApplication] delegate];
        progressHUD = [[MBProgressHUD alloc] initWithView:appDelegate.window];
        progressHUD.labelText = @"优惠劵领取中";
        [appDelegate.window addSubview:progressHUD];
        [progressHUD show:YES];
        
        [self accessService];
    }
}

-(void)accessService{
    NSArray *dbArray = [DBOperate queryData:T_MEMBER_INFO theColumn:nil theColumnValue:nil withAll:YES];
    int userid;
    NSString *userName = nil;
    if (dbArray != nil && [dbArray count] > 0) {
        NSArray *menberAy = [dbArray objectAtIndex:0];
        userid = [[menberAy objectAtIndex:member_info_memberId] intValue];
        userName = [menberAy objectAtIndex:member_info_name];
    }
    int tp = 1;
    
	NSMutableDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [Common getSecureString],@"keyvalue",
                                        [NSNumber numberWithInt: SITE_ID],@"site_id",
                                        [NSNumber numberWithInt: userid],@"user_id", 
                                        userName,@"username",
                                        [NSNumber numberWithInt: tp],@"type",
                                        nil];
	
    
    [[DataManager sharedManager] accessService:jsontestDic command:GET_PROMOTION_CODE accessAdress:@"book/addprivilege.do?param=%@" delegate:self withParam:jsontestDic];
}

- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver
{
    [self performSelectorOnMainThread:@selector(update:) withObject:(NSArray*)resultArray waitUntilDone:NO];
}

- (void) update:(NSArray*)resultArray
{
    if (progressHUD) {
        [progressHUD removeFromSuperview];
        progressHUD = nil;
    }
    NSArray *ay = (NSArray*)resultArray;
    int ret = [[ay objectAtIndex:0] intValue];
    shoppingAppDelegate *appDelegate = (shoppingAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (ret == 1) {
         [appDelegate showGetPromotionCodeSuccessAlert];
    }else if(ret == -1){
        [appDelegate showGetPromotionCodeFailedAlert:finished];
    }else if(ret == 2){
        [appDelegate showGetPromotionCodeFailedAlert:finished]; 
    }else if(ret == 3){
        [appDelegate showGetPromotionCodeFailedAlert:joined];
    }
}

- (void) onLoginButtonClick
{
    [self hide];
    if (_isLogin) {
        shoppingAppDelegate *appDelegate = (shoppingAppDelegate*)[[UIApplication sharedApplication] delegate];
        progressHUD = [[MBProgressHUD alloc] initWithView:appDelegate.window];
        progressHUD.labelText = @"优惠劵领取中";
        [appDelegate.window addSubview:progressHUD];
        [progressHUD show:YES];
        
        [self accessService];
    }else {
        LoginViewController *login = [[LoginViewController alloc] init];
        login.delegate = self;
        [self.myNavigationController pushViewController:login animated:YES];
        [login release];
    }
}

- (void) dealloc{
    [super dealloc];
    [myNavigationController release],myNavigationController = nil;
    [shareContentArray release],shareContentArray = nil;
    [progressHUD release],progressHUD = nil;
//    commandOper.delegate = nil;
//    [commandOper release],commandOper = nil;
}

@end
