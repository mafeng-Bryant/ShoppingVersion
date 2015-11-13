//
//  tabEntranceViewController.h
//
//  Created by MC374 on 12-7-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommandOperation.h"
#import "DDMenuController.h"

@class homeViewController;
@class productViewController;
@class carViewController;
@class LoginViewController;
@class boxViewController;

@interface tabEntranceViewController : UITabBarController<UITabBarControllerDelegate,CommandOperationDelegate,DDMenuControllerDelegate> {
    
	UIViewController *chooseVC;
	homeViewController *homeView;
	productViewController *productView;
	carViewController *carView;
	LoginViewController *loginView;
	boxViewController *boxView;
	UIImageView *logoview;
    DDMenuController *rootController;
    UINavigationController *navController;
}
@property(nonatomic,retain) UIViewController *chooseVC;
@property(nonatomic,retain) homeViewController *homeView;
@property(nonatomic,retain) productViewController *productView;
@property(nonatomic,retain) carViewController *carView;
@property(nonatomic,retain) LoginViewController *loginView;
@property(nonatomic,retain) boxViewController *boxView;
@property(nonatomic,retain) UIImageView *logoview;

- (void) hideTabBarWithAnimation;
@end
