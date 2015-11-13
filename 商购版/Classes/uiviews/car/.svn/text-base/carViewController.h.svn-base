//
//  carViewController.h
//  shopping
//
//  Created by lai yun on 12-12-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconDownLoader.h"
#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "PromotionAlertView.h"

@interface carViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,IconDownloaderDelegate,LoginViewDelegate,MBProgressHUDDelegate,PromotionAlertViewDelegate>
{
    UITableView *_carTableView;
    UIView *noProView;
    UIView *haveProView;
    NSMutableArray *__listArray;
    UILabel *strLabelTotal;
    UILabel *totalMoneyLabel;
    UILabel *saveMoneyLabel;
    UILabel *countLabel;
    NSMutableDictionary *imageDownloadsInProgressDic;
	NSMutableArray *imageDownloadsInWaitingArray;
    
    BOOL _isSelectAll;
    UIButton *topSelectButton;
    
    UIBarButtonItem *rightBarButton;
    double totalMoney;
    int fullSendID;
    double promotionMoney;
}
@property (nonatomic, retain) UITableView *carTableView;
@property (nonatomic, retain) NSMutableArray *listArray;
@property (nonatomic, retain) UILabel *totalMoneyLabel;
@property (nonatomic, retain) UILabel *saveMoneyLabel;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgressDic;
@property (nonatomic, retain) NSMutableArray *imageDownloadsInWaitingArray;

@property (nonatomic, retain) NSString *userId;
@end
