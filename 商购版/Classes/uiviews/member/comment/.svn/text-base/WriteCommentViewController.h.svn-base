//
//  WriteCommentViewController.h
//  shopping
//
//  Created by 来 云 on 13-1-25.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "DataManager.h"
#import "MyOrderDetailViewController.h"

typedef enum
{
    CommentTypeMyCommentlist,
    CommentTypeOrderDetail
}CommentType;

@interface WriteCommentViewController : UIViewController <UITextViewDelegate,MBProgressHUDDelegate,CommandOperationDelegate> {
	UITextView *myTextView;
	MBProgressHUD *progressHUD;
    
    CommentType __commentType;
}

@property (nonatomic, retain) UITextView *myTextView;
@property (nonatomic, retain) MBProgressHUD *progressHUD;
@property (nonatomic, retain) NSString *infoIdStr;
@property (nonatomic, retain) NSString *orderIdStr;
@property (nonatomic, assign) CommentType commentType;

@end
