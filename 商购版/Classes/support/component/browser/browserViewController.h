//
//  browserViewController.h
//  Profession
//
//  Created by siphp on 12-8-25.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "manageActionSheet.h"
#import "SinaViewController.h"
#import "TencentViewController.h"
@interface browserViewController : UIViewController<UIWebViewDelegate,manageActionSheetDelegate,OauthSinaWeiSuccessDelegate,OauthTencentWeiSuccessDelegate> {
	UIWebView *webView;
	NSString *url;
    NSString *webTitle;
    UIImage *shareImage;
	UIActivityIndicatorView *spinner;
    BOOL isShowTool;
    manageActionSheet *actionSheet;
}

@property(nonatomic,retain) UIWebView *webView;
@property(nonatomic,retain) NSString *url;
@property(nonatomic,retain) NSString *webTitle;
@property(nonatomic,retain) UIImage *shareImage;
@property(nonatomic,retain) UIActivityIndicatorView *spinner;
@property(nonatomic,assign) BOOL isShowTool;
@property(nonatomic,retain) manageActionSheet *actionSheet;

//工具栏
-(void)showToolBar;

//功能按钮
-(void)buttonClick:(id)sender;

//分享
-(void)share;

//刷新
-(void)reload;

@end
