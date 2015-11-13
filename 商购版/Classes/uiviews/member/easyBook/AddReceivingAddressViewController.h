//
//  AddReceivingAddressViewController.h
//  shopping
//
//  Created by 来 云 on 13-1-10.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ReservationInfo.h"
#import "CommandOperation.h"
#import "MyAddressViewController.h"
@protocol AddReceivingAddressViewControllerDelegate <NSObject>

- (void)addressWithName:(NSString *)name withTel:(NSString *)tel withPost:(NSString *)post withArea:(NSString *)area withAddress:(NSString *)addr;

@end

@interface AddReceivingAddressViewController : UITableViewController <UITextFieldDelegate,UIActionSheetDelegate,CommandOperationDelegate>
{
    UITextField *_nameTextField;
    UITextField *_telTextField;
    UITextField *_postTextField;
    UITextField *_areaTextField;
    UITextField *_addressTextField;
    id <AddReceivingAddressViewControllerDelegate> _delegate;
    BOOL _isEdit;
    
    MyAddressViewController *myAddress;
}
@property (nonatomic, retain) UITextField *nameTextField;
@property (nonatomic, retain) UITextField *telTextField;
@property (nonatomic, retain) UITextField *postTextField;
@property (nonatomic, retain) UITextField *areaTextField;
@property (nonatomic, retain) UITextField *addressTextField;
@property (nonatomic, assign) id <AddReceivingAddressViewControllerDelegate> _delegate;
@property (nonatomic, retain) ReservationInfo *info;
@property (nonatomic, retain) NSString *addrId;
@property (nonatomic, retain) MyAddressViewController *myAddress;
@property (nonatomic, assign) BOOL _fromPrize;
@end
