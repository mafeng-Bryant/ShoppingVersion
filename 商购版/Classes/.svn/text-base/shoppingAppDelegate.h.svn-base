//
//  shoppingAppDelegate.h
//  shopping
//
//  Created by siphp on 12-12-20.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommandOperation.h"
#import "Common.h"
#import "WXApi.h"
#import "IconDownLoader.h"
#import "EPUploader.h"

@class showPushAlert;
@class ShareAlertViewController;
@class ShareSuccessAlertView;
@class MBProgressHUD;

#import "BMapKit.h" //baiduMap

@protocol APPlicationDelegate <NSObject>

- (void) handleCallBack:(NSDictionary*)info;

@end

@interface shoppingAppDelegate : NSObject <UIApplicationDelegate,CommandOperationDelegate,CLLocationManagerDelegate,UIScrollViewDelegate,WXApiDelegate,IconDownloaderDelegate,EPUploaderDelegate> {
    UIWindow *window;
	UINavigationController *navController;
    UIButton *loginBtn;
	UIImage *headerImage;
	NSString *myDeviceToken;
    NSString *province;
	NSString *city;
	NSString *LatitudeAndLongitude;
	showPushAlert *pushAlert;

    UIView *userGuideView;
    UIScrollView *guideScrollView;
    UIPageControl *pageControll;
    UIButton *closeBtn;
    
    ShareAlertViewController *shareAlertView;
    ShareSuccessAlertView *shareSuccessAlertView;
    
    BMKMapManager * _mapManager;
    
    NSMutableDictionary *imageDownloadsInProgress;
	NSMutableArray *imageDownloadsInWaiting;
	IconDownLoader *iconDownLoad;
    MBProgressHUD *mprogressHUD;
    id<APPlicationDelegate> delegate;
}
@property (nonatomic, retain) UIImage *headerImage;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, retain) UIButton *loginBtn;
@property (nonatomic, retain) NSString *myDeviceToken;
@property (nonatomic, retain) NSString *province;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *LatitudeAndLongitude;
@property (nonatomic, retain) showPushAlert *pushAlert;

@property (nonatomic, retain) UIView *userGuideView;
@property (nonatomic, retain) UIScrollView *guideScrollView;
@property (nonatomic, retain) UIPageControl *pageControll;

@property (nonatomic,retain) ShareAlertViewController *shareAlertView;
@property (nonatomic,retain) ShareSuccessAlertView *shareSuccessAlertView;
@property (nonatomic,retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic,retain) NSMutableArray *imageDownloadsInWaiting;
@property (nonatomic,retain) IconDownLoader *iconDownLoad;
@property (nonatomic, retain) NSString *alertType;
@property (nonatomic, retain) NSString *alertInfoId;
@property (nonatomic,assign) id<APPlicationDelegate> delegate;
//获取地理位置
- (void)getLocation;

- (void)isAutoLogin;
-(void)showString:(NSDictionary*)userInfo;
- (void) showShareSuccessAlert;
- (void) showGetPromotionCodeSuccessAlert;
- (void) showGetPromotionCodeFailedAlert:(int)showType;
@end
