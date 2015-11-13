//
//  CustomTabBar.h
//  LeqiClient
//
//  Created by ui on 11-5-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tabEntranceViewController.h"

@class tabEntranceViewController;

@interface CustomTabBar : tabEntranceViewController {
	NSMutableArray *buttons;
	int currentSelectedIndex;
	UIImageView *slideBg;
    UIView *customTab;
    BOOL isHideToolbar;
}
@property (nonatomic, assign) int	currentSelectedIndex;
@property (nonatomic, assign) BOOL isHideToolbar;
@property (nonatomic,retain) NSMutableArray *buttons;
@property (nonatomic,retain) UIView *customTab;

- (void)hideRealTabBar;
- (void)customTabBar;
- (void)selectedTab:(UIButton *)button;
- (void) hideTabBarWithAnimation;
- (void) showTabBarWithAnimation;
@end

