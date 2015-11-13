//
//  CommentedViewController.h
//  shopping
//
//  Created by 来 云 on 13-1-28.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "CommandOperation.h"
#import "IconDownLoader.h"
@class MyCommentViewController;
@interface CommentedViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,CommandOperationDelegate,MBProgressHUDDelegate,IconDownloaderDelegate>
{
    UITableView *_myTableView;
    NSMutableArray *__listArray;
    UIActivityIndicatorView *indicatorView;
    UIActivityIndicatorView *spinner;
    MBProgressHUD *progressHUD;
    
    NSMutableDictionary *imageDownloadsInProgressDic;
	NSMutableArray *imageDownloadsInWaitingArray;
    CGFloat picWidth;
    CGFloat picHeight;

    int rowValue;
    
    BOOL _isAllowLoadingMore;
    BOOL _loadingMore;
    
    UILabel *noLabel;
}
@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) NSMutableArray *listArray;
@property (nonatomic, retain) CommandOperation *commandOper;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgressDic;
@property (nonatomic, retain) NSMutableArray *imageDownloadsInWaitingArray;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) MyCommentViewController *myCommentView;

- (void)addView;
- (void)startIconDownload:(NSString*)imageURL forIndex:(NSIndexPath*)index;

@end
