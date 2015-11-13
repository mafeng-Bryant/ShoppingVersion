//
//  LoginViewController.h
//  shopping
//
//  Created by 来 云 on 12-12-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "CommandOperation.h"
#import "MenberCenterMainViewController.h"
#import "EPUploader.h"
#import "RegisterViewController.h"

@protocol LoginViewDelegate <NSObject>

- (void)loginWithResult:(BOOL)isLoginSuccess;

@end

@interface LoginViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,MBProgressHUDDelegate,UIGestureRecognizerDelegate,CommandOperationDelegate,UIImagePickerControllerDelegate
,UINavigationControllerDelegate,MenberCenterMainViewControllerDelegate,UIAlertViewDelegate,EPUploaderDelegate,UITextFieldDelegate,registerViewDelegate>
{
    UITableView *loginTableView;
	UITextField *nameTextField;
    UITextField *passwordTextField;
	
	MBProgressHUD *mbProgressHUD;
	
	MBProgressHUD *progressHUD;	
	
    MenberCenterMainViewController *memberCenter;
	UIImageView *headImageView;
	UIImage *img;
	
	id <LoginViewDelegate> delegate;
	Byte *imageByte;
	NSString *imageString;
	
	EPUploader *upload;
	UIImage *scaleImage;
    
    UIBarButtonItem *barBtnItem;
    
    UIButton *showPwdButton;
    UIButton *rememberPwdButton;
    BOOL _isShow;
    BOOL _isRemember;
}

@property (nonatomic, retain) UITextField *nameTextField;
@property (nonatomic, retain) UITextField *passwordTextField;
@property (nonatomic, retain) MBProgressHUD *mbProgressHUD;

@property (nonatomic, retain) MBProgressHUD *progressHUD;

@property (nonatomic, retain) MenberCenterMainViewController *memberCenter;
@property (nonatomic, retain) UIImageView *headImageView;
@property (nonatomic, retain) UIImage *img;
@property (nonatomic, assign) id<LoginViewDelegate> delegate;
@property (nonatomic,retain )EPUploader *upload;
@property (nonatomic, retain) UIImage *scaleImage;
@end
