//
//  feedbackViewController.h
//  Profession
//
//  Created by siphp on 12-8-24.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "DataManager.h"

@interface feedbackViewController : UIViewController<UITextViewDelegate,MBProgressHUDDelegate,CommandOperationDelegate> {
	UITextView *myTextView;
	MBProgressHUD *progressHUD;
}

@property(nonatomic,retain)UITextView *myTextView;
@property(nonatomic,retain) MBProgressHUD *progressHUD;

//编辑中
-(void) doEditing;

//发表反馈
-(void)publishFeedback:(id)sender;

//评论成功
- (void)feedbackSuccess;

//网络请求回调函数
- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver;

@end
