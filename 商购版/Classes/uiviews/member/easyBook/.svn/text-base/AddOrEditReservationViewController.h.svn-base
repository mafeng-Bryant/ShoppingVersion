//
//  AddOrEditReservationViewController.h
//  shopping
//
//  Created by 来 云 on 13-1-15.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReservationInfo.h"
#import "CommandOperation.h"
#import "MBProgressHUD.h"

@protocol  AddOrEditReservationDelegate <NSObject>

- (void) finishEdit;

@end 

@interface AddOrEditReservationViewController : UITableViewController <CommandOperationDelegate,MBProgressHUDDelegate,UITextFieldDelegate>
{
    ReservationInfo *_info;
    NSMutableDictionary *_dict;
    
    MBProgressHUD *progressHUD;

    UITextField *_easyNameField;
    id<AddOrEditReservationDelegate> delegate;
}

@property (nonatomic, retain) ReservationInfo *info;
@property (nonatomic, retain) NSMutableDictionary *dict;
@property (nonatomic, retain) NSString *easyId;
@property (nonatomic, retain) UITextField *easyNameField;
@property (nonatomic, assign) id<AddOrEditReservationDelegate> delegate;
@end
