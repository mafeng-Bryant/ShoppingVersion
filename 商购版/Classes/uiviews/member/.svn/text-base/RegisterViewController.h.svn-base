//
//  RegisterViewController.h
//  shopping
//
//  Created by 来 云 on 12-12-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "CommandOperation.h"
@protocol registerViewDelegate <NSObject>

- (void)registerSuccess;

@end

@interface RegisterViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate, MBProgressHUDDelegate,CommandOperationDelegate>
{
    id <registerViewDelegate> delegate;
    UITableView *registTableView;
	UITextField *nameTextField;
    UITextField *passwordTextField;
	MBProgressHUD *progressHUD;
}
@property (nonatomic, assign) id<registerViewDelegate> delegate;
@property (nonatomic, retain) UITextField *nameTextField;
@property (nonatomic, retain) UITextField *passwordTextField;
@property (nonatomic, retain) MBProgressHUD *progressHUD;
- (void)accessService;
- (void)checkWeiboExpiredAction;
- (BOOL)validateRegexPassword:(NSString *)password;
@end
