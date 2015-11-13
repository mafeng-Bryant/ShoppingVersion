//
//  PayAndSendViewController.h
//  shopping
//
//  Created by 来 云 on 13-1-10.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ReservationInfo.h"
#import "MyAddressViewController.h"

@protocol PayAndSendViewControllerDelegate <NSObject>

- (void)payAndsendWithPay:(int)payWay withSend:(int)sendId withTime:(int)timeValue withSure:(int)isSureValue;

@end
@interface PayAndSendViewController : UITableViewController <UITextFieldDelegate,UIActionSheetDelegate>
{
    UITextField *_payTextField;
    UITextField *_sendTextField;
    UITextField *_timeTextField;
    UITextField *_isTelTextField;
    UITextField *_moneyTextField;
    id<PayAndSendViewControllerDelegate> _delegate;
    id<GetMyAddressDelegate> myDelegate;
    int rowCount;
}
@property (nonatomic, retain) UITextField *payTextField;
@property (nonatomic, retain) UITextField *sendTextField;
@property (nonatomic, retain) UITextField *timeTextField;
@property (nonatomic, retain) UITextField *isTelTextField;
@property (nonatomic, retain) UITextField *moneyTextField;
@property (nonatomic, assign) id<PayAndSendViewControllerDelegate> _delegate;
@property (nonatomic, assign) id<GetMyAddressDelegate> myDelegate;
@property (nonatomic, strong) ReservationInfo *info;
@end
