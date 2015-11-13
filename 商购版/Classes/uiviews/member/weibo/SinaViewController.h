//
//  SinaViewController.h
//  Profession
//
//  Created by LuoHui on 12-9-5.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBEngine.h"
#import "MBProgressHUD.h"
#import "CommandOperation.h"
#import "LoginViewController.h"
#import "SinaWeibo.h"
#import "shoppingAppDelegate.h"

@protocol OauthSinaWeiSuccessDelegate <NSObject>
- (void) oauthSinaSuccess;
@end

@interface SinaViewController : UIViewController <WBEngineDelegate,CommandOperationDelegate,MBProgressHUDDelegate,UIAlertViewDelegate,SinaWeiboDelegate,APPlicationDelegate,SinaWeiboRequestDelegate>{
	WBEngine *weiBoEngine;
	int enpiresTime;
	NSString *sinaAccessToken;
	
	NSString *profile_image_url;
	
	MBProgressHUD *progressHUD;
	BOOL _isRequest;
	id<OauthSinaWeiSuccessDelegate> delegate;
	id<LoginViewDelegate> loginDelegate;
    SinaWeibo *sinaWeibo;
    BOOL hasOauth;
}
@property (nonatomic, retain) WBEngine *weiBoEngine;
@property (nonatomic) int expiresTime;
@property (nonatomic, retain) NSString *sinaAccessToken;
@property (nonatomic, retain) NSString *profile_image_url;
@property (nonatomic, retain) MBProgressHUD *progressHUD;
@property (nonatomic) BOOL isRequest;
@property (nonatomic,assign) id<OauthSinaWeiSuccessDelegate> delegate;
@property (nonatomic,assign) id<LoginViewDelegate> loginDelegate;
@end
