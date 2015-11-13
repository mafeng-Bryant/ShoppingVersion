//
//  MyPrizeViewController.h
//  shopping
//
//  Created by 来 云 on 13-1-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "CommandOperation.h"
#import "IconDownLoader.h"

@interface MyPrizeViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,CommandOperationDelegate,IconDownloaderDelegate>
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
    
    NSNumber *_infoId;
    int rowValue;
    
    BOOL _isAllowLoadingMore;
    BOOL _loadingMore;
}
@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) NSMutableArray *listArray;
@property(nonatomic,retain) CommandOperation *commandOper;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgressDic;
@property (nonatomic, retain) NSMutableArray *imageDownloadsInWaitingArray;
@property(nonatomic,retain) UIActivityIndicatorView *spinner;
@property (nonatomic, retain) NSString *userId;

@end
