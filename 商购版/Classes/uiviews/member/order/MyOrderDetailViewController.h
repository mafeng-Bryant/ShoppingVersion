//
//  MyOrderDetailViewController.h
//  shopping
//
//  Created by 来 云 on 13-1-21.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconDownLoader.h"
#import "CommandOperation.h"
#import "MBProgressHUD.h"
typedef enum
{
    OrderTypeSuccess,
    OrderTypeWaitReceive,
    OrderTypeNotSend,
    OrderTypeNotPay,
    OrderTypeCancel
}OrderType;

@interface MyOrderDetailViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,IconDownloaderDelegate,CommandOperationDelegate,MBProgressHUDDelegate>
{
    UITableView *_myTableView;
    
    NSMutableArray *__listArray;
    NSMutableArray *__productsArray;
    
    NSMutableDictionary *imageDownloadsInProgressDic;
	NSMutableArray *imageDownloadsInWaitingArray;
    CGFloat picWidth;
    CGFloat picHeight;
    
    OrderType __orderType;
    MBProgressHUD *progressHUD;
}
@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) NSString *orderIdStr;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSMutableArray *listArray;
@property (nonatomic, retain) NSMutableArray *productsArray;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgressDic;
@property (nonatomic, retain) NSMutableArray *imageDownloadsInWaitingArray;
@property (nonatomic, retain) CommandOperation *commandOper;
@property (nonatomic, retain) MBProgressHUD *progressHUD;
@property (nonatomic, assign) OrderType __orderType;

@end
