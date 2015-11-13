//
//  WritingInvoiceViewController.h
//  shopping
//
//  Created by 来 云 on 13-1-10.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPicker.h"
#import "MBProgressHUD.h"
#import "ReservationInfo.h"
@protocol WritingInvoiceViewControllerDelegate <NSObject>

- (void)invoiceWithType:(int)typeValue withTitle:(int)titleValue withTitleName:(NSString *)name;

@end
@interface WritingInvoiceViewController : UITableViewController <UITextFieldDelegate,UIActionSheetDelegate>
{
    UITextField *_invoicetypeTextField;
    UITextField *_invoicetitleTextField;
    UITextField *_invoicetitlenameTextField;
    id <WritingInvoiceViewControllerDelegate> _delegate;
    
    BOOL _isPerson;
}
@property (nonatomic, retain) UITextField *invoicetypeTextField;
@property (nonatomic, retain) UITextField *invoicetitleTextField;
@property (nonatomic, retain) UITextField *invoicetitlenameTextField;
@property (nonatomic, assign) id <WritingInvoiceViewControllerDelegate> _delegate;
@property (nonatomic, strong) ReservationInfo *info;
@end
