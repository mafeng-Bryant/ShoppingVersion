//
//  ShareSuccessAlertView.h
//  information
//
//  Created by MC374 on 12-12-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UATitledModalPanel.h"
#import "MenberCenterMainViewController.h"
#import "CommandOperation.h"
#import "LoginViewController.h"

@class MBProgressHUD;

@interface ShareSuccessAlertView : UATitledModalPanel<MenberCenterMainViewControllerDelegate,CommandOperationDelegate,LoginViewDelegate>{
    UINavigationController *myNavigationController;
    NSArray *shareContentArray;
    MBProgressHUD *progressHUD;
    CommandOperation *commandOper;
}
@property (nonatomic,retain)  UINavigationController *myNavigationController;
@property (nonatomic,retain)  NSArray *shareContentArray;

- (id)initWithFrame:(CGRect)frame;
- (void) update:(NSArray*)resultArray;
@end
