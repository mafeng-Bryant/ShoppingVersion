//
//  MyAddressViewController.h
//  shopping
//
//  Created by 来 云 on 13-1-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "CommandOperation.h"
#import "ReservationInfo.h"
typedef enum
{
    FromTypeMy, //我的常用地址
    FromTypePrize,//奖品收货地址
    FromTypeReceive //收货人信息
}FromType;

@protocol GetMyAddressDelegate <NSObject>

- (void) getMyAddress;

@end

@interface MyAddressViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,CommandOperationDelegate,MBProgressHUDDelegate>
{
    UITableView *_myTableView;
    NSMutableArray *__listArray;
    UIActivityIndicatorView *indicatorView;
    UIActivityIndicatorView *spinner;
    MBProgressHUD *progressHUD;
    
    BOOL _isAllowLoadingMore;
    BOOL _loadingMore;
    
    BOOL _isHidden;
    FromType __fromType;
    
    NSNumber *_infoId;
    int rowValue;
    
    BOOL _isService;
    
    UILabel *noLabel;
    id<GetMyAddressDelegate> delegate;
    NSString *prizeInfoId;
}
@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) NSMutableArray *listArray;
@property (nonatomic, retain) CommandOperation *commandOper;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, assign) BOOL _isHidden;
@property (nonatomic, assign) id<GetMyAddressDelegate> delegate;
@property (nonatomic, assign) FromType fromType;
@property (nonatomic, assign) BOOL _isService;
@property (nonatomic, retain) ReservationInfo *info;
@property (nonatomic, retain) NSString *prizeInfoId;

@end
