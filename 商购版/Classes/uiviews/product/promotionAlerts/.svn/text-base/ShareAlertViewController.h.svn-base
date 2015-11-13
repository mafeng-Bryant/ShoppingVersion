//
//  ShareAlertViewController.h
//  information
//
//  Created by MC374 on 12-12-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UATitledModalPanel.h"
#import "LoginViewController.h"
#import "manageActionSheet.h"

@class UpdateAppAlert;

@interface ShareAlertViewController : UATitledModalPanel<LoginViewDelegate,manageActionSheetDelegate>{
    NSArray *shareContentArray;
    UINavigationController *myNavigationController;
    manageActionSheet *actionsheet;
    UpdateAppAlert *weChatAlert;
}
@property (nonatomic,retain)  NSArray *shareContentArray;
@property (nonatomic,retain)  UINavigationController *myNavigationController;
@property (nonatomic,retain)  manageActionSheet *actionsheet;

- (id)initWithFrame:(CGRect)frame contentArray:(NSArray*)ay;
@end
