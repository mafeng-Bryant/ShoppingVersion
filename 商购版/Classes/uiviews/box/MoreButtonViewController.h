//
//  MoreButtonViewController.h
//  xieHui
//
//  Created by 来 云 on 12-11-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommandOperation.h"
#import "PagedFlowView.h"
#import "IconDownLoader.h"

@interface MoreButtonViewController : UIViewController <CommandOperationDelegate,PagedFlowViewDelegate,PagedFlowViewDataSource,IconDownloaderDelegate>
{
    NSString *catStr;
    NSString *titleStr;
    NSMutableArray *__listArray;
    
    NSMutableDictionary *imageDownloadsInProgressDic;
	NSMutableArray *imageDownloadsInWaitingArray;
	IconDownLoader *iconDownLoad;
    
    UIActivityIndicatorView *spinner;
}
@property (nonatomic, retain) NSString *catStr;
@property (nonatomic, retain) NSString *titleStr;
@property (nonatomic, retain) NSMutableArray *listArray;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgressDic;
@property (nonatomic, retain) NSMutableArray *imageDownloadsInWaitingArray;
@property (nonatomic, retain) IconDownLoader *iconDownLoad;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;
@end
