//
//  MenberCenterMainViewController.h
//  shopping
//
//  Created by 来 云 on 12-12-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconDownLoader.h"
@class LoginViewController;

@protocol MenberCenterMainViewControllerDelegate<NSObject>

- (void)actionButtonIndex:(int)index imageView:(UIImageView *)imgView;

@end

@interface MenberCenterMainViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,IconDownloaderDelegate,UINavigationControllerDelegate>
{
    UIImageView *memberHeaderView;
	NSString *memberName;
	NSString *memberLevel;
    UIView *topView;
    UITableView *_myTableView;
	
	IconDownLoader *iconDownLoad;
	NSMutableDictionary *imageDownloadsInProgress;
	NSMutableArray *imageDownloadsInWaiting;
	
	LoginViewController *_loginViewController;
	id <MenberCenterMainViewControllerDelegate> delegate;
}
@property (nonatomic, retain) UIImageView *memberHeaderView;
@property (nonatomic, retain) NSString *memberName;
@property (nonatomic, retain) NSString *memberLevel;
@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) IconDownLoader *iconDownLoad;
@property(nonatomic, retain) NSMutableArray *imageDownloadsInWaiting;
@property(nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

@property (nonatomic, retain) LoginViewController *loginViewController;
@property (nonatomic, assign) id <MenberCenterMainViewControllerDelegate> delegate;

- (void)startIconDownload:(NSString*)imageURL forIndex:(NSIndexPath*)index;
- (void)viewAppearAction;
@end
