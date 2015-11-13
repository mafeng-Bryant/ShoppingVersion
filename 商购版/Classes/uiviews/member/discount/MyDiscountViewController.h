//
//  MyDiscountViewController.h
//  shopping
//
//  Created by 来 云 on 13-1-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommandOperation.h"
#import "IconDownLoader.h"
#import "MBProgressHUD.h"

@protocol getPromotionDetailDelegate
-(void)getPromotionArray:(NSArray*)promotionArray;
@end

@interface MyDiscountViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,CommandOperationDelegate,IconDownloaderDelegate,MBProgressHUDDelegate>
{
    UITableView *_myTableView;
    NSMutableArray *__listArray;
    
    UIActivityIndicatorView *indicatorView;
    UIActivityIndicatorView *spinner;
    
    NSString *userId;
    
    BOOL _isAllowLoadingMore;
    BOOL _loadingMore;
    
    BOOL isSelectPromotion; //是否是下单选择优惠券操作
    NSArray *promotionDataArray;
    id<getPromotionDetailDelegate> myDelegate;
    
    NSMutableDictionary *imageDownloadsInProgressDic;
	NSMutableArray *imageDownloadsInWaitingArray;
    CGFloat picWidth;
    CGFloat picHeight;
}
@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) NSMutableArray *listArray;
@property (nonatomic, retain) NSString *userId;
@property(nonatomic,retain) CommandOperation *commandOper;
@property(nonatomic,retain) UIActivityIndicatorView *spinner;
@property(nonatomic,assign) BOOL isSelectPromotion;
@property(nonatomic,assign) id<getPromotionDetailDelegate> myDelegate;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgressDic;
@property (nonatomic, retain) NSMutableArray *imageDownloadsInWaitingArray;

@end

