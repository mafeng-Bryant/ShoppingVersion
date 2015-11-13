//
//  TencentViewController.h
//  Profession
//
//  Created by LuoHui on 12-8-23.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "OpenSdkOauth.h"
#import "OpenApi.h"
#import "CommandOperation.h"
#import "LoginViewController.h"

@protocol OauthTencentWeiSuccessDelegate <NSObject>
- (void) oauthTencentSuccess;
@end


@interface TencentViewController : UIViewController <UIWebViewDelegate,OpenAPiDelegate,
      CommandOperationDelegate,UIAlertViewDelegate>{
	MBProgressHUD *progressHUD;	
	
	OpenSdkOauth *_OpenSdkOauth;
	OpenApi *_OpenApi;
	UIWebView *_webView;
	int enpiresTime;
	
	NSString *headImageUrl;
	
	BOOL _isRequest;
	id<OauthTencentWeiSuccessDelegate> delegate;
	id<LoginViewDelegate> loginDelegate;
	
}
@property (nonatomic, retain)  UIWebView *_webView;
@property (nonatomic, retain) MBProgressHUD *progressHUD;
@property (nonatomic) int expiresTime;
@property (nonatomic, retain) NSString *headImageUrl;
@property (nonatomic) BOOL isRequest;
@property (nonatomic, assign) id<OauthTencentWeiSuccessDelegate> delegate;
@property (nonatomic, assign) id<LoginViewDelegate> loginDelegate;

- (void) getUserInfo;
- (void) getUserInfoSuccess:(NSString*)userInfo;
- (void)tencentLogin:(NSMutableArray*)resultArray;
@end
