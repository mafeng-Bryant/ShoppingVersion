//
//  weiboSetViewController.h
//  Profession
//
//  Created by siphp on 12-8-24.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TencentViewController.h"
#import "SinaViewController.h"


@interface weiboSetViewController : UIViewController <OauthSinaWeiSuccessDelegate,OauthTencentWeiSuccessDelegate>{	
	UISwitch *sinaSwitch;
	UISwitch *tencentSwitch;
	
}

//sina微博设置
-(void)sinaSwitchChanged:(id)sender;

//tencent微博设置
-(void)tencentSwitchChanged:(id)sender;

@end
